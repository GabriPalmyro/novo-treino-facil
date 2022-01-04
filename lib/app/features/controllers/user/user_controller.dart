import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/aluno/aluno.dart';
import 'package:tabela_treino/app/features/models/seguidor/seguidor.dart';
import '/app/features/models/user/user.dart';

class UserManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;
  User user = User();
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

  Future<void> singUp(User user, String pass, VoidCallback onSucess,
      VoidCallback onFailed) async {
    loading = true;

    try {
      //await Future.delayed(Duration(seconds: 2));
      Auth.UserCredential authUser = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: pass);
      firebaseUser = authUser.user;
      onSucess();
      await saveUserData(user.toMap());
      loading = false;
    } catch (e) {
      debugPrint(e.toString());
      onFailed();
      loading = false;
    }
  }

  Future<void> signIn(String email, String pass, VoidCallback onSucess,
      VoidCallback onFailed) async {
    loading = true;

    try {
      await Future.delayed(Duration(seconds: 1));
      Auth.UserCredential authUser =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      firebaseUser = authUser.user;
      await loadCurrentUser();
      onSucess();
      loading = false;
    } catch (e) {
      debugPrint(e.toString());
      onFailed();
      loading = false;
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
    } catch (e) {
      user = userTemp;
      loading = false;
      debugPrint(e.toString());
    }
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      this.user = User.fromMap(userData);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .set(userData);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("planilha")
          .add({"title": "Treino Demo", "description": "Descrição Demo"});

      debugPrint('Usuário criado com sucesso!');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> loadCurrentUser() async {
    loading = true;
    if (firebaseUser == null) firebaseUser = _auth.currentUser;
    if (firebaseUser != null) {
      if (user.name == null) {
        try {
          DocumentSnapshot docUser = await FirebaseFirestore.instance
              .collection("users")
              .doc(firebaseUser.uid)
              .get();
          Map<String, dynamic> _userData = docUser.data();
          _userData['id'] = docUser.id;
          user = User.fromMap(_userData);
        } catch (e) {
          debugPrint(e.toString());
        }
      }
    }

    loading = false;
    notifyListeners();
  }

  Future<String> carregarAlunos() async {
    await Future.delayed(Duration(seconds: 1));
    Map<String, dynamic> data = {};
    alunos = [];
    debugPrint('LOADING ALUNOS');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("alunos")
          .orderBy('client_name')
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        alunos.add(Aluno.fromMap(data));
      });

      debugPrint('ALUNOS LOAD SUCESS');
      notifyListeners();
      return null;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String> changeUserInfos(
      {@required User newUser,
      @required String password,
      VoidCallback onSucess,
      VoidCallback onFailed}) async {
    // ignore: await_only_futures
    if (firebaseUser == null) firebaseUser = await _auth.currentUser;
    loading = true;
    try {
      Auth.UserCredential authResult = await firebaseUser
          .reauthenticateWithCredential(Auth.EmailAuthProvider.credential(
              email: user.email, password: password));
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
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .update(newUserInfos);
        log("PERFIL ATUALIZADO");
        user = User.fromMap(newUserInfos);
        loading = false;
        return null;
      } else {
        await firebaseUser.updateEmail(newUser.email);

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

        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .update(newUserInfos);
        log("PERFIL ATUALIZADO");
        user = User.fromMap(newUserInfos);
        loading = false;
        return null;
      }
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String> changeUserPreferences(
      {bool mostrarPlanilhas,
      bool mostrarExercicios,
      bool mostrarPerfilPesquisa}) async {
    try {
      Map<String, dynamic> newUserInfos = {
        "mostrar_planilhas_perfil": mostrarPlanilhas,
        "mostrar_exercicios_perfil": mostrarExercicios,
        "mostrar_perfil_pesquisa": mostrarPerfilPesquisa
      };

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .update(newUserInfos);

      user.mostrarPlanilhasPerfil = mostrarPlanilhas;
      user.mostrarExerciciosPerfil = mostrarExercicios;
      user.mostrarPerfilPesquisa = mostrarPerfilPesquisa;

      loading = false;
      return null;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String> carregarAmigos({String nickname}) async {
    Map<String, dynamic> data = {};
    friends = [];
    debugPrint('LOADING FRIENDS');
    try {
      loading = true;
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .where('nickname', isEqualTo: nickname)
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        friends.add(User.fromMap(data));
      });

      debugPrint('AMIGOS LOAD SUCESS');
      loading = false;
      return null;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<bool> checkIsFollowing({String friendId}) async {
    try {
      var followers = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection('seguindo')
          .where('followerId', isEqualTo: friendId)
          .get();

      loading = false;
      if (followers.docs.isEmpty) return false;
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<String> adicionarSeguidor({User friend}) async {
    try {
      var follower = Follower(
          followerId: firebaseUser.uid,
          name: user.name + ' ' + user.lastName,
          email: user.email,
          photoURL: user.photoURL);

      var following = Follower(
          followerId: friend.id,
          name: friend.name + ' ' + friend.lastName,
          email: friend.email,
          photoURL: friend.photoURL);

      await FirebaseFirestore.instance
          .collection("users")
          .doc(friend.id)
          .collection('seguidores')
          .add(follower.toMap());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection('seguindo')
          .add(following.toMap());

      user.seguindo = user.seguindo + 1;
      friend.seguidores = friend.seguidores + 1;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(friend.id)
          .update(friend.toMap());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .update(user.toMap());

      notifyListeners();

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String> removerSeguidor({User friend}) async {
    try {
      var queryFollower = await FirebaseFirestore.instance
          .collection("users")
          .doc(friend.id)
          .collection('seguidores')
          .where('followerId', isEqualTo: firebaseUser.uid)
          .get();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(friend.id)
          .collection('seguidores')
          .doc(queryFollower.docs.first.id)
          .delete();

      queryFollower = await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection('seguindo')
          .where('followerId', isEqualTo: friend.id)
          .get();

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .collection('seguindo')
          .doc(queryFollower.docs.first.id)
          .delete();

      user.seguindo = user.seguindo - 1;
      friend.seguidores = friend.seguidores - 1;

      await FirebaseFirestore.instance
          .collection("users")
          .doc(friend.id)
          .update(friend.toMap());

      await FirebaseFirestore.instance
          .collection("users")
          .doc(firebaseUser.uid)
          .update(user.toMap());

      notifyListeners();

      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<void> createNewExe(
      {File video,
      String muscleText,
      String title,
      int level,
      bool homeExe,
      Function onSucess}) async {
    log('Enviando!');
    await FirebaseStorage.instance
        .refFromURL(
            "gs://treino-facil-22856.appspot.com/exercicios_compartilhados/${user.id}/exercicios/$muscleText")
        .child("${title}_${DateTime.now().day}_${DateTime.now().month}")
        .putFile(video)
        .then((value) async {
      if (value.state == TaskState.success) {
        await value.ref.getDownloadURL().then((value) {
          String downloadUrl = value.toString();

          var data = {
            "title": title,
            "muscleId": muscleText,
            "level": level,
            "home_exe": homeExe,
            "video": downloadUrl
          };

          FirebaseFirestore.instance
              .collection("users")
              .doc(user.id)
              .collection("exercicios")
              .add(data)
              .then((value) {
            print("Succesfuly Uploaded");
            onSucess();
            return null;
          }).catchError((error) {
            print(error);
            return error.toString();
          });
        });
      }
    }).catchError((error) {
      print(error);
      return error.toString();
    });
  }
}
