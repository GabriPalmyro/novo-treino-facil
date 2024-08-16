import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
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
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      log(e.toString());
      throw Exception('Não foi possível comunicar-se com o Treino Fácil. Tente novamente mais tarde.');
    }
  }

  Future<void> loadIaTraining() async {
    try {
      await _remoteConfig.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(minutes: 5),
      ));
      await _remoteConfig.fetchAndActivate();
      final iaTraining = await _remoteConfig.getBool('is_ia_training_available');
      coreInfos = coreInfos.copyWith(mostrarIaTraining: iaTraining);
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      log(e.toString());
    }
  }
}
