import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/core/core.dart';

class CoreAppController extends ChangeNotifier {
  CoreApp coreInfos = CoreApp();

  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> getAppCore() async {
    try {
      var querySnapshot = await FirebaseFirestore.instance.collection("appInfos").get();

      coreInfos = CoreApp.fromMap(querySnapshot.docs.first.data());
      await loadIaTraining();
      log('Load App Core Sucess');
      notifyListeners();
    } catch (e) {
      log(e.toString());
      throw Exception('Não foi possível comunicar-se com o Treino Fácil. Tente novamente mais tarde.');
    }
  }

  Future<void> loadIaTraining() async {
    try {
      final iaTraining = await _remoteConfig.getBool('is_ia_training_available');
      coreInfos.copyWith(mostrarIaTraining: iaTraining);
    } catch (e) {
      log(e.toString());
    }
  }
}
