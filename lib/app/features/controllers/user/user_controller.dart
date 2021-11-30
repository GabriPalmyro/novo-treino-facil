import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/aluno/aluno.dart';
import '/app/features/models/user/user.dart';

class UserManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;
  User user = User();
  List<Aluno> alunos;
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
          user = User.fromMap(_userData);
          debugPrint(user.toString());
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
}
