import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

class ExerciciosPlanilhaManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;

  List listaExercicios = [];
  List listaExerciciosTemp = [];

  bool _isLoading = false;

  bool get loading => _isLoading;

  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String> addNewExerciseUniSet(
      {String planilhaId, ExerciciosPlanilha exercicio}) async {
    String id;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .add(exercicio.toMap())
          .then((value) => id = value.id);
      exercicio.id = id;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }

  bool validarStringsIds({String planilhaId, String idUser}) {
    if ((idUser != null && idUser.isNotEmpty) &&
        (planilhaId != null && planilhaId.isNotEmpty))
      return true;
    else
      return false;
  }

  Future<String> reorganizarListaExercicios(
      {List<dynamic> listaExercicios, String planilhaId, String idUser}) async {
    loading = true;

    CollectionReference ref = FirebaseFirestore.instance
        .collection("users")
        .doc(idUser)
        .collection("planilha")
        .doc(planilhaId)
        .collection("exercícios");

    try {
      for (var i = 0; i < listaExercicios.length; i++) {
        if (listaExercicios[i].position != (i + 1)) {
          await ref.doc(listaExercicios[i].id).update({'pos': (i + 1)});
        }
      }

      loading = false;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
      return e.toString();
    }
  }
}
