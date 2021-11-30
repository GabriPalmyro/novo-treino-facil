import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/personal/personal.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;

class PersonalManager extends ChangeNotifier {
  Personal personal = Personal();

  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;

  bool _loading = false;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading => _loading;

  // METHOD 1
  Future<void> loadMyPersonal() async {
    Map<String, dynamic> data = {};
    debugPrint('LOADING PERSONAL');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("personal")
          .get();

      data = queryWorksheet.docs[0].data();
      data['id'] = queryWorksheet.docs[0].id;

      personal = Personal.fromMap(data);
      debugPrint('PERSONAL LOAD SUCESS');

      debugPrint(personal.toString());
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }
}
