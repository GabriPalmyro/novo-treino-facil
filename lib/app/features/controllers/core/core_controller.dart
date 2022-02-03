import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/core/core.dart';

class CoreAppController extends ChangeNotifier {
  CoreApp coreInfos = CoreApp();

  Future<void> getAppCore() async {
    try {
      var querySnapshot =
          await FirebaseFirestore.instance.collection("appInfos").get();

      coreInfos = CoreApp.fromMap(querySnapshot.docs.first.data());

      log('Load App Core Sucess');
      notifyListeners();
    } catch (e) {
      log(e.toString());
      throw Exception(
          'Não foi possível comunicar-se com o Treino Fácil. Tente novamente mais tarde.');
    }
  }
}
