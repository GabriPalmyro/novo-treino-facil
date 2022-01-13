import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/personal/personal.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:tabela_treino/app/features/models/user/user.dart';

class PersonalManager extends ChangeNotifier {
  Personal personal = Personal();
  List<Personal> personalRequestList = [];

  Auth.User firebaseUser;

  bool _loading = false;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  bool get loading => _loading;

  // METHOD 1
  Future<void> loadMyPersonal({String idUser}) async {
    loading = true;
    Map<String, dynamic> data = {};
    debugPrint('LOADING PERSONAL');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("personal")
          .get();

      data = queryWorksheet.docs[0].data();
      debugPrint(data.toString());
      data['id'] = queryWorksheet.docs[0].id;

      personal = Personal.fromMap(data);
      debugPrint('PERSONAL LOAD SUCESS');

      loading = false;
      return null;
    } catch (e) {
      personal = Personal();
      debugPrint(e.toString());
      loading = false;
    }
    notifyListeners();
  }

  Future<String> loadMyPersonalRequestList({String idUser}) async {
    loading = true;
    Map<String, dynamic> data = {};
    personalRequestList = [];
    debugPrint('LOADING PERSONAL REQUEST LIST');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("request_list")
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        personalRequestList.add(Personal.fromMap(data));
      });

      debugPrint('PERSONAL REQUEST LIST LOAD SUCESS');
      loading = false;
      return null;
    } catch (e) {
      personalRequestList = [];
      debugPrint(e.toString());
      loading = false;
      return e.toString();
    }
  }

  Future<String> acceptPersonalRequest({Personal personal, User user}) async {
    loading = true;

    try {
      var hasPersonal = await FirebaseFirestore.instance
          .collection("users")
          .doc(user.id)
          .collection("personal")
          .get();
      if (hasPersonal.docs.isNotEmpty) {
        loading = false;
        return 'Você já possui um Personal atualmente. Cancele a conexão para realizar essa ação.';
      } else {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.id)
            .collection("personal")
            .add({
          "personal_name": personal.personalName,
          "personal_email": personal.personalEmail,
          "personal_phoneNumber": personal.personalPhone,
          "personal_photo": personal.personalPhoto,
          "personal_Id": personal.personalId,
          "connection_date": DateTime.now().toString()
        });
        //adiciona o aluno ao personal
        await FirebaseFirestore.instance
            .collection("users")
            .doc(personal.personalId)
            .collection("alunos")
            .add({
          "client_Id": user.id,
          "client_name": user.name + " " + user.lastName,
          "client_email": user.email,
          "client_phoneNumber": user.phoneNumber,
          "client_photo": user.photoURL,
        });

        var requestList = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.id)
            .collection("request_list")
            .get();

        for (var personal in requestList.docs) {
          await FirebaseFirestore.instance
              .collection("users")
              .doc(user.id)
              .collection("request_list")
              .doc(personal.id)
              .delete();
        }
        personalRequestList.clear();
        loading = false;
        return null;
      }
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String> deletePersonalRequest(
      {String requestId, String userId}) async {
    loading = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("request_list")
          .doc(requestId)
          .delete();

      personalRequestList.removeWhere((element) => element.id == requestId);
      loading = false;
      return null;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }
}
