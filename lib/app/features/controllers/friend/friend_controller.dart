import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';

class FriendManager extends ChangeNotifier {
  //Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  late Auth.User firebaseUser;

  List<Planilha> listaPlanilhasFriend = [];

  Future<void> loadFriendPlanList({required String idFriend}) async {
    Map<String, dynamic> data = {};
    listaPlanilhasFriend = [];
    log('LOADING LISTAS FRIEND');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(idFriend)
          .collection("planilha")
          .orderBy('title')
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        listaPlanilhasFriend.add(Planilha.fromMap(data));
      });

      log('PLAN LIST LOAD SUCESS');
    } catch (e) {
      listaPlanilhasFriend = [];
      log(e.toString());
    }
    notifyListeners();
  }
}
