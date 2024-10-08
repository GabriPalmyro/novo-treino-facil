import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tabela_treino/app/features/models/aluno/aluno.dart';
import 'package:tabela_treino/app/features/models/seguidor/seguidor.dart';

import '/app/features/models/user/user.dart';

class UserManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User? firebaseUser;
  User user = User();
  String alunoNomeTemp = '';
  List<Aluno> alunos = [];
  List<User> friends = [];
  bool _loading = false;

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
    loadCurrentUser();
  }

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading => _loading;

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  String registerErrorType(String error) {
    switch (error) {
      case 'invalid-email':
        return 'E-mail inválido. Tente novamente.';
      case 'user-disabled':
        return 'Usuário desativado. Tente novamente.';
      case 'user-not-found':
        return 'Senha inválida. Tente novamente.';
      case 'wrong-password':
        return 'Senha inválida. Tente novamente.';
      default:
        return 'Ocorreu um erro. Verifique seu e-mail e senha e tente novamente.';
    }
  }

  Future<void> singUp(User user, String pass, VoidCallback onSucess, VoidCallback onFailed) async {
    loading = true;

    try {
      //await Future.delayed(Duration(seconds: 2));
      Auth.UserCredential authUser = await _auth.createUserWithEmailAndPassword(email: user.email!, password: pass);
      firebaseUser = authUser.user;
      Sentry.configureScope((scope) {
        scope.setUser(
          SentryUser(id: firebaseUser!.uid, email: user.email, username: user.nickname, name: user.name),
        );
      });
      onSucess();
      await saveUserData(user.toMap());
      loading = false;
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      log(e.toString());
      onFailed();
      loading = false;
    }
  }

  String loginErrorType(String error) {
    switch (error) {
      case 'invalid-email':
        return 'E-mail inválido. Tente novamente.';
      case 'user-disabled':
        return 'Usuário desativado. Tente novamente.';
      case 'user-not-found':
        return 'Usuário não encontrado. Tente novamente.';
      case 'wrong-password':
        return 'Senha inválida. Tente novamente.';
      default:
        return 'Ocorreu um erro. Verifique seu e-mail e senha e tente novamente.';
    }
  }

  Future<String?> signIn(String email, String pass) async {
    loading = true;

    try {
      // await Future.delayed(Duration(seconds: 1));
      Auth.UserCredential authUser = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      firebaseUser = authUser.user;
      await loadCurrentUser();
      loading = false;
      return null;
    } on Auth.FirebaseAuthException catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      loading = false;
      return loginErrorType(e.code);
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      log(e.toString());
      loading = false;
      return 'Ocorreu um erro. Verifique seu e-mail e senha e tente novamente.';
    }
  }

  Future<void> logout() async {
    loading = true;
    User userTemp = user;

    try {
      user = User();
      await Future.delayed(Duration(milliseconds: 500));
      await _auth.signOut();
      firebaseUser = null;
      loading = false;
      user = User();
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      user = userTemp;
      loading = false;
      log(e.toString());
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      this.user = User.fromMap(userData);
      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).set(userData);

      log('Usuário criado com sucesso!');
    } catch (e) {
      log(e.toString());
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<void> loadCurrentUser() async {
    loading = true;
    if (firebaseUser == null) firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (user.name == null) {
        try {
          DocumentSnapshot docUser = await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).get();
          Map<String, dynamic> _userData = docUser.data() as Map<String, dynamic>;
          _userData['id'] = docUser.id;
          await FirebaseAnalytics.instance.setUserId(id: _userData['id']);
          Sentry.configureScope((scope) {
            scope.setUser(
              SentryUser(id: _userData['id'], email: user.email, username: user.nickname, name: user.name),
            );
          });
          user = User.fromMap(_userData);
          notifyListeners();
        } catch (e) {
          log(e.toString());
        }
      }
    }

    loading = false;
    notifyListeners();
  }

  Future<void> updateUserPremiumStatus(bool status) async {
    user.isPayApp = status;
    await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update({
      'payApp': status,
    });
    notifyListeners();
  }

  Future<String?> changeUserInfos({
    required User newUser,
    required String password,
  }) async {
    // ignore: await_only_futures
    if (firebaseUser == null) firebaseUser = await _auth.currentUser;
    loading = true;
    try {
      Auth.UserCredential authResult =
          await firebaseUser!.reauthenticateWithCredential(Auth.EmailAuthProvider.credential(email: user.email!, password: password));
      authResult.user;

      if (user.email == newUser.email) {
        Map<String, dynamic> newUserInfos = {
          "nickname": newUser.nickname,
          "email": newUser.email,
          "name": newUser.name,
          "last_name": newUser.lastName,
          "payApp": user.isPayApp,
          "personal_type": user.isPersonal,
          "phone_number": newUser.phoneNumber,
          "photoURL": user.photoURL,
          "sexo": user.sex,
          "seguidores": user.seguidores,
          "seguindo": user.seguindo
        };
        await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(newUserInfos);
        log("PERFIL ATUALIZADO");
        user = User.fromMap(newUserInfos);
        loading = false;
        return null;
      } else {
        await firebaseUser?.verifyBeforeUpdateEmail(newUser.email!);

        Map<String, dynamic> newUserInfos = {
          "nickname": newUser.nickname,
          "email": newUser.email,
          "name": newUser.name,
          "last_name": newUser.lastName,
          "payApp": user.isPayApp,
          "personal_type": user.isPersonal,
          "phone_number": newUser.phoneNumber,
          "photoURL": user.photoURL,
          "sexo": user.sex,
          "seguidores": user.seguidores,
          "seguindo": user.seguindo
        };

        await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(newUserInfos);
        log("PERFIL ATUALIZADO");
        user = User.fromMap(newUserInfos);
        loading = false;
        return null;
      }
    } catch (e) {
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> changeUserPreferences({required bool mostrarPlanilhas, required bool mostrarExercicios, required bool mostrarPerfilPesquisa}) async {
    try {
      Map<String, dynamic> newUserInfos = {
        "mostrar_planilhas_perfil": mostrarPlanilhas,
        "mostrar_exercicios_perfil": mostrarExercicios,
        "mostrar_perfil_pesquisa": mostrarPerfilPesquisa
      };

      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(newUserInfos);

      user.mostrarPlanilhasPerfil = mostrarPlanilhas;
      user.mostrarExerciciosPerfil = mostrarExercicios;
      user.mostrarPerfilPesquisa = mostrarPerfilPesquisa;

      loading = false;
      return null;
    } catch (e) {
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }

  Future<List<User>> carregarAmigos({required String nickname}) async {
    Map<String, dynamic> data = {};
    friends = [];
    log('LOADING FRIENDS');
    try {
      loading = true;
      var queryWorksheet = await FirebaseFirestore.instance.collection("users").where('nickname', isEqualTo: nickname).get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        friends.add(User.fromMap(data));
      });

      log('AMIGOS LOAD SUCESS');
      loading = false;
      return friends;
    } catch (e) {
      loading = false;
      log(e.toString());
      return friends;
    }
  }

  Future<bool> checkIsFollowing({required String friendId}) async {
    try {
      var followers =
          await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).collection('seguindo').where('followerId', isEqualTo: friendId).get();

      loading = false;
      if (followers.docs.isEmpty) return false;
      return true;
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  Future<String?> adicionarSeguidor({required User friend}) async {
    try {
      var follower = Follower(
        followerId: firebaseUser!.uid,
        name: user.name! + ' ' + user.lastName!,
        email: user.email!,
        photoURL: user.photoURL!,
      );

      var following = Follower(followerId: friend.id!, name: friend.name! + ' ' + friend.lastName!, email: friend.email!, photoURL: friend.photoURL!);

      await FirebaseFirestore.instance.collection("users").doc(friend.id).collection('seguidores').add(follower.toMap());

      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).collection('seguindo').add(following.toMap());

      user.seguindo = user.seguindo! + 1;
      friend.seguidores = friend.seguidores! + 1;

      await FirebaseFirestore.instance.collection("users").doc(friend.id).update(friend.toMap());

      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(user.toMap());

      notifyListeners();

      return null;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> removerSeguidor({required User friend}) async {
    try {
      var queryFollower =
          await FirebaseFirestore.instance.collection("users").doc(friend.id).collection('seguidores').where('followerId', isEqualTo: firebaseUser!.uid).get();

      await FirebaseFirestore.instance.collection("users").doc(friend.id).collection('seguidores').doc(queryFollower.docs.first.id).delete();

      queryFollower =
          await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).collection('seguindo').where('followerId', isEqualTo: friend.id).get();

      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).collection('seguindo').doc(queryFollower.docs.first.id).delete();

      user.seguindo = user.seguindo! - 1;
      friend.seguidores = friend.seguidores! - 1;

      await FirebaseFirestore.instance.collection("users").doc(friend.id).update(friend.toMap());

      await FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(user.toMap());

      notifyListeners();

      return null;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> createNewExe({XFile? video, String? muscleText, String? title, int? level, bool? homeExe, VoidCallback? onSuccess}) async {
    loading = true;

    //! VERIFICAR QUANTOS EXERCÍCIOS POSSUI
    var listExe = await FirebaseFirestore.instance.collection("users").doc(user.id).collection("exercicios").get();

    if (listExe.docs.length > 10) {
      return "Limite máximo de exercícios personalizados atingido!";
    }

    File videoFile = File(video!.path);
    try {
      await FirebaseStorage.instance
          .refFromURL("gs://treino-facil-22856.appspot.com/exercicios_compartilhados/${user.id}/exercicios/$muscleText")
          .child("${title}_${DateTime.now().day}_${DateTime.now().month}")
          .putFile(videoFile)
          .then((value) async {
        if (value.state == TaskState.success) {
          await value.ref.getDownloadURL().then((value) {
            String downloadUrl = value.toString();

            var data = {"title": title, "muscleId": muscleText, "level": level, "home_exe": homeExe, "video": downloadUrl};

            FirebaseFirestore.instance.collection("users").doc(user.id).collection("exercicios").add(data).then((value) {
              print("Succesfuly Uploaded");
              onSuccess?.call();
              loading = false;
              return null;
            }).catchError((error) {
              print(error);
              loading = false;
              return;
            });
          });
        }

        loading = false;
      });
    } catch (error) {
      print(error);
      loading = false;
      return error.toString();
    }

    return 'Ocorreu um erro.';
  }

  //* PERSONAL AREA

  Future<String?> carregarAlunos() async {
    Map<String, dynamic> data = {};
    alunos = [];
    log('LOADING ALUNOS');
    try {
      var queryWorksheet = await FirebaseFirestore.instance.collection("users").doc(_auth.currentUser!.uid).collection("alunos").orderBy('client_name').get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        alunos.add(Aluno.fromMap(data));
      });

      log('ALUNOS LOAD SUCESS');
      notifyListeners();
      return null;
    } catch (e) {
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> sendAlunoRequest({required String emailAluno}) async {
    loading = true;
    try {
      var getResponse = await FirebaseFirestore.instance.collection("users").where("email", isEqualTo: emailAluno).get();

      if (getResponse.docs.isEmpty) {
        loading = false;
        return 'Não foi possível encontrar nenhum aluno com esse e-mail.';
      }

      String alunoId = getResponse.docs.first.id;

      var alreadyRequest =
          await FirebaseFirestore.instance.collection("users").doc(alunoId).collection("request_list").where("personal_email", isEqualTo: user.email).get();

      if (alreadyRequest.docs.isEmpty) {
        await FirebaseFirestore.instance.collection("users").doc(alunoId).collection("request_list").add({
          "personal_Id": user.id,
          "personal_name": user.name! + " " + user.lastName!,
          "personal_email": user.email,
          "personal_photo": user.photoURL,
          "personal_phoneNumber": user.phoneNumber
        });
      } else {
        loading = false;
        return 'Você já enviou um convite de conexão para esse e-mail.';
      }

      loading = false;
      return null;
    } catch (e) {
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> deletePersonalAlunoConnection({
    required String personalId,
    required String userId,
  }) async {
    loading = true;
    try {
      var personalSnapshot =
          await FirebaseFirestore.instance.collection("users").doc(userId).collection("personal").where("personal_Id", isEqualTo: personalId).get();

      for (var snapshot in personalSnapshot.docs) {
        await FirebaseFirestore.instance.collection("users").doc(userId).collection("personal").doc(snapshot.id).delete();
      }

      var alunoSnapshot = await FirebaseFirestore.instance.collection("users").doc(personalId).collection("alunos").where("client_Id", isEqualTo: userId).get();

      for (var snapshot in alunoSnapshot.docs) {
        await FirebaseFirestore.instance.collection("users").doc(personalId).collection("alunos").doc(snapshot.id).delete();
      }

      loading = false;
      return null;
    } catch (e) {
      log(e.toString());
      loading = false;
      return e.toString();
    }
  }

  Future<void> removeIAGenerationAvailable() async => FirebaseFirestore.instance.collection("users").doc(firebaseUser!.uid).update(
        {'ia_generations_available': user.availableIATrainingGenerations - 1},
      ).then((_) {
        user.availableIATrainingGenerations -= 1;
        notifyListeners();
      });

  removerPersonalAluno({required int index}) {
    alunos.removeAt(index);
    notifyListeners();
  }
}
