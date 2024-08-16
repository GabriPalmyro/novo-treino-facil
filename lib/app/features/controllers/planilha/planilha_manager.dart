import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';

class PlanilhaManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  late Auth.User firebaseUser;
  ExerciciosPlanilhaManager? exerciciosPlanilhaManager;

  List<Planilha> listaPlanilhas = [];

  bool _isLoading = false;

  bool get loading => _isLoading;

  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // METHOD 1
  Future<void> loadWorksheetList() async {
    Map<String, dynamic> data = {};
    listaPlanilhas = [];
    log('LOADING LISTAS');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("planilha")
          .orderBy('title')
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        listaPlanilhas.add(Planilha.fromMap(data));
      });

      log('PLAN LIST LOAD SUCESS');
    } catch (e) {
      listaPlanilhas = [];
      log(e.toString());
    }
    notifyListeners();
  }

  //METHOD 2
  Future<String?> createNovaPlanilha(
      {required Planilha planilha,
      required String idUser,
      required bool isPersonalAcess,
      bool adView = false}) async {
    loading = true;
    String? id;
    try {

      final lengthOfPlanilhas = listaPlanilhas.where((item) => !(item.isIaGenerated ?? false)).length;

      if (lengthOfPlanilhas < 7 || adView) {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(idUser)
            .collection("planilha")
            .add(planilha.toMap())
            .then((value) => id = value.id);
        planilha.id = id!;
        if (!isPersonalAcess) {
          listaPlanilhas.add(planilha);
          listaPlanilhas.sort((a, b) {
            return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
          });
        }
      } else {
        throw 'MAX';
      }
      loading = false;
      return null;
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }

  //METHOD 4
  Future<String?> editPlanilha(
      {required Planilha planilha,
      required String idUser,
      required int index,
      required bool isPersonalAcess}) async {
    loading = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilha.id)
          .update(planilha.toMap());

      if (!isPersonalAcess) listaPlanilhas[index] = planilha;

      loading = false;
      return null;
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      log(e.toString());
      loading = false;
      return e.toString();
    }
  }

  //METHOD 5
  Future<String?> changePlanilhaToFavorite(Planilha planilha, int index) async {
    planilha.favorito = !planilha.favorito!;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser!.uid)
          .collection("planilha")
          .doc(planilha.id)
          .update(planilha.toMap());

      notifyListeners();
      return null;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }

  Future<String?> deletarPlanilhaCompleta(
      {required String planilhaId,
      required String userId,
      required int index,
      required bool isPersonalAcess}) async {
    loading = false;
    try {
      var docWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("planilha")
          .doc(planilhaId)
          .get();

      if (docWorksheet.data()!.isEmpty) {
        //! PLANILHA VAZIA - APAGANDO
        log('PLANILHA VAZIA - APAGANDO');
        await FirebaseFirestore.instance
            .collection("users")
            .doc(userId)
            .collection("planilha")
            .doc(planilhaId)
            .delete();
        return null;
      }

      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .get();

      queryWorksheet.docs.forEach((element) async {
        if (element.data()["set_type"] == 'uniset') {
          //! APAGANDO EXERCICIO UNISET
          log('APAGANDO EXERCICIO UNI SET ${element.id}');
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("planilha")
              .doc(planilhaId)
              .collection("exercícios")
              .doc(element.id)
              .delete();
        } else {
          //* DELETANDO EXERCÍCIOS NISETSET
          //! BUSCANDO EXERCICIOS BISETS
          var queryBiSet = await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("planilha")
              .doc(planilhaId)
              .collection("exercícios")
              .doc(element.id)
              .collection("sets")
              .get();

          queryBiSet.docs.forEach((elementBiSet) async {
            log(
                'APAGANDO EXERCICIO BI SET ${element.id} - ${elementBiSet.id}');
            await FirebaseFirestore.instance
                .collection("users")
                .doc(userId)
                .collection("planilha")
                .doc(planilhaId)
                .collection("exercícios")
                .doc(element.id)
                .collection("sets")
                .doc(elementBiSet.id)
                .delete();
          });

          log('APAGANDO SET ${element.id}');
          //* DELETANDO SET
          await FirebaseFirestore.instance
              .collection("users")
              .doc(userId)
              .collection("planilha")
              .doc(planilhaId)
              .collection("exercícios")
              .doc(element.id)
              .delete();
        }
      });

      //! PLANILHA VAZIA - APAGANDO
      log('PLANILHA VAZIA - APAGANDO');
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("planilha")
          .doc(planilhaId)
          .delete();

      if (!isPersonalAcess) listaPlanilhas.removeAt(index);

      loading = false;

      return null;
    } catch (e, stack) {
      unawaited(Sentry.captureException(
        e,
        stackTrace: stack,
      ));
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }
}
