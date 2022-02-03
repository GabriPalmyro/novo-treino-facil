import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/meAjuda/me_ajuda.dart';

class MeAjudaController extends ChangeNotifier {
  bool _loading = false;
  List<MeAjuda> listaAjudas = [];

  set loading(bool value) => _loading;

  get loading => _loading;

  Future<void> getListaAjudas() async {
    loading = true;
    MeAjuda temp;
    listaAjudas = [];
    try {
      var queryAjudas =
          await FirebaseFirestore.instance.collection("ajudas").get();

      for (var item in queryAjudas.docs) {
        temp = MeAjuda.fromMap(item.data());
        temp.id = item.id;
        listaAjudas.add(temp);
      }
      loading = false;
    } catch (e) {
      loading = false;
      log(e.toString());
      return e.toString();
    }
  }
}
