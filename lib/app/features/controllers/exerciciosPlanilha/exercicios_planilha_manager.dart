import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

class ExerciciosPlanilhaManager extends ChangeNotifier {
  late Auth.User firebaseUser;

  //! BI SET EXERCICES
  List<ExerciciosPlanilha> listaExerciciosBiSet = [];
  bool isFirstExerciseSelected = false;

  bool _isLoading = false;

  bool get loading => _isLoading;

  set loading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> addNewExerciseUniSet(
      {required String planilhaId,
      required String idUser,
      required ExerciciosPlanilha exercicio}) async {
    String id = '';
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
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

  bool validarStringsIds({String? planilhaId, String? idUser}) {
    if ((idUser != null && idUser.isNotEmpty) &&
        (planilhaId != null && planilhaId.isNotEmpty))
      return true;
    else
      return false;
  }

  Future<String?> reorganizarListaExercicios(
      {required List<dynamic> listaExercicios,
      required String planilhaId,
      required String idUser}) async {
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

  void adicionarExercicioBiSetLista({required ExerciciosPlanilha exercise}) {
    listaExerciciosBiSet.add(exercise);
    isFirstExerciseSelected = true;
    notifyListeners();
  }

  void removerExercicioBiSetLista({required int index}) {
    listaExerciciosBiSet.removeAt(index);
    isFirstExerciseSelected = false;
    notifyListeners();
  }

  void limparExercicioBiSetLista() {
    listaExerciciosBiSet.clear();
    isFirstExerciseSelected = false;
    notifyListeners();
  }

  void substituirExercicio({required int index, required ExerciciosPlanilha exerciciosPlanilha}) {
    listaExerciciosBiSet[index] = exerciciosPlanilha;
    notifyListeners();
  }

  Future<String?> editExerciseUniSet(
      {required String planilhaId,
      required String idUser,
      required String idExercicio,
      required ExerciciosPlanilha exercicio}) async {
    loading = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(idExercicio)
          .update({
        "obs": exercicio.comments,
        "peso": exercicio.carga,
        "reps": exercicio.reps,
        "series": exercicio.series
      });
      loading = false;
      return null;
    } catch (e) {
      debugPrint(e.toString());

      loading = false;
      return e.toString();
    }
  }

  Future<void> editExerciseBiSet(
      {required String planilhaId,
      required String idUser,
      required String idExercicio,
      required String idBiSet,
      required ExerciciosPlanilha exercicio}) async {
    loading = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(idBiSet)
          .collection("sets")
          .doc(idExercicio)
          .update({
        "obs": exercicio.comments,
        "peso": exercicio.carga,
        "reps": exercicio.reps,
        "series": exercicio.series
      });
      loading = false;
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
    }
  }

  Future<String?> addNewExerciseBiSet(
      {required String planilhaId,
      required String idUser,
      required int pos}) async {
    loading = true;
    String? id;

    try {
      listaExerciciosBiSet[0].position = 0;
      listaExerciciosBiSet[1].position = 1;

      BiSetExercise biSetExercise = BiSetExercise(
          firstExercise: listaExerciciosBiSet[0].title!,
          secondExercise: listaExerciciosBiSet[1].title!,
          setType: 'biset',
          position: pos,
          exercicios: listaExerciciosBiSet);

      //* ADICIONANDO BI SET
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .add(biSetExercise.toMap())
          .then((value) => id = value.id);
      biSetExercise.id = id;

      //* PRIMEIRO EXERCICIO BI SET
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(biSetExercise.id)
          .collection("sets")
          .add(listaExerciciosBiSet[0].toMap())
          .then((value) => id = value.id);
      biSetExercise.exercicios![0].id = id!;

      //* SEGUNDO EXERCICIO BI SET
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(biSetExercise.id)
          .collection("sets")
          .add(listaExerciciosBiSet[1].toMap())
          .then((value) => id = value.id);
      biSetExercise.exercicios![1].id = id!;
      listaExerciciosBiSet.clear();
      isFirstExerciseSelected = false;
      loading = false;
      return null;
    } catch (e) {
      loading = false;
      debugPrint(e.toString());
      return e.toString();
    }
  }

  Future<String?> deleteExerciseUniSet(
      {required List<dynamic> listaExercicios,
      required String planilhaId,
      required String idExercise,
      required String idUser,
      required int index}) async {
    loading = true;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(listaExercicios[index].id)
          .delete();

      listaExercicios.removeAt(index);

      await reorganizarListaExercicios(
          listaExercicios: listaExercicios,
          planilhaId: planilhaId,
          idUser: idUser);

      loading = false;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
      return e.toString();
    }
  }

  Future<String?> deleteExerciseBiSet({
    required String planilhaId,
    required String idExercise,
    required String idUser,
    required int index,
    required List<dynamic> listaExercicios,
  }) async {
    loading = true;

    var queryBiSet = await FirebaseFirestore.instance
        .collection("users")
        .doc(idUser)
        .collection("planilha")
        .doc(planilhaId)
        .collection("exercícios")
        .doc(idExercise)
        .collection("sets")
        .orderBy("pos")
        .get();

    try {
      //* DELETANDO EXERCÍCIOS SET
      queryBiSet.docs.forEach((element) async {
        debugPrint('deletando ' + element.id);
        await FirebaseFirestore.instance
            .collection("users")
            .doc(idUser)
            .collection("planilha")
            .doc(planilhaId)
            .collection("exercícios")
            .doc(idExercise)
            .collection("sets")
            .doc(element.id)
            .delete();
      });

      //* DELETANDO SET

      debugPrint('deletando ' + idExercise);
      await FirebaseFirestore.instance
          .collection("users")
          .doc(idUser)
          .collection("planilha")
          .doc(planilhaId)
          .collection("exercícios")
          .doc(idExercise)
          .delete();

      listaExercicios.removeAt(index);

      await reorganizarListaExercicios(
          listaExercicios: listaExercicios,
          planilhaId: planilhaId,
          idUser: idUser);

      loading = false;
      return null;
    } catch (e) {
      debugPrint(e.toString());
      loading = false;
      return e.toString();
    }
  }
}
