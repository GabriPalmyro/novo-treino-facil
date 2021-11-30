import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

class ExerciciosPlanilhaManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;

  List listaExercicios = [];

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
}
