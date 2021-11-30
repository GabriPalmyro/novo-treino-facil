import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';

class PlanilhaManager extends ChangeNotifier {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;
  Auth.User firebaseUser;

  List<Planilha> listaPlanilhas = [];

  // METHOD 1
  Future<void> loadWorksheetList() async {
    Map<String, dynamic> data = {};
    listaPlanilhas = [];
    debugPrint('LOADING LISTAS');
    try {
      var queryWorksheet = await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .orderBy('title')
          .get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        listaPlanilhas.add(Planilha.fromMap(data));
      });

      debugPrint('PLAN LIST LOAD SUCESS');
    } catch (e) {
      listaPlanilhas = [];
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  //METHOD 2
  Future<void> createNovaPlanilha(Planilha planilha) async {
    String id;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .add(planilha.toMap())
          .then((value) => id = value.id);
      planilha.id = id;
      listaPlanilhas.add(planilha);
      listaPlanilhas.sort((a, b) {
        return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  //METHOD 4
  Future<void> editPlanilha(Planilha planilha, int index) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .doc(planilha.id)
          .update(planilha.toMap());

      listaPlanilhas[index] = planilha;
    } catch (e) {
      debugPrint(e.toString());
    }
    notifyListeners();
  }

  //METHOD 5
  Future<String> changePlanilhaToFavorite(Planilha planilha, int index) async {
    planilha.favorito = !planilha.favorito;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .doc(planilha.id)
          .update(planilha.toMap());

      notifyListeners();
      return null;
    } catch (e) {
      debugPrint(e.toString());
      return e.toString();
    }
  }
}
