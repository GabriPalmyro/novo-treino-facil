import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';

class ExercisesManager extends ChangeNotifier {
  ExercisesManager() {
    loadListExercises();
  }

  List<Exercise> listaExercicios = [];
  List<Exercise> listaMeusExercicios = [];
  List<Exercise> resultList = [];

// METHOD 1
  Future<void> loadListExercises() async {
    Map<String, dynamic> data = {};
    listaExercicios = [];
    log('LOADING LIST EXERCISES');
    try {
      var queryWorksheet = await FirebaseFirestore.instance.collection("musculos2").orderBy('title').get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        listaExercicios.add(Exercise.fromMap(data));
        resultList.add(Exercise.fromMap(data));
      });

      log('EXERCICE LIST LOAD SUCESS');
    } catch (e) {
      listaExercicios = [];
      log('ERROR LOADING: ' + e.toString());
    }
    notifyListeners();
  }

  List<Exercise> searchResultList({required String searchController, required String selectedType}) {
    List<Exercise> showResults = [];

    //se o controlador não estiver vazio
    if (searchController != "") {
      // parametro de busca
      //analisar todos os arquivos do banco de dados
      for (var tripSnapshot in listaExercicios) {
        var title = tripSnapshot.title!.toUpperCase();
        var homeExe = tripSnapshot.isHomeExercise;
        var muscleId = tripSnapshot.muscleId!.toUpperCase();
        //se o tipo for "home_exe"
        if (selectedType == "home_exe") {
          if (title.startsWith(searchController.toUpperCase()) && homeExe == true) {
            showResults.add(tripSnapshot); //adiciona apenas os procurados e home_exe na lista
          }
          //se o tipo for "muscleId"
        } else if (selectedType == "muscleId") {
          if (muscleId.startsWith(searchController.toUpperCase())) {
            log('adicionando ${tripSnapshot.toString()}');
            showResults.add(tripSnapshot);
          }
        } else if (selectedType == "title") {
          //se o tipo for title
          if (title.startsWith(searchController.toUpperCase())) {
            showResults.add(tripSnapshot); //adiciona apenas os procurados na lista
          }
        } else if (selectedType == "mines") {
          for (var meusExercicios in listaMeusExercicios) {
            if (meusExercicios.title!.startsWith(searchController.toUpperCase())) {
              showResults.add(meusExercicios); //adiciona apenas os procurados na lista
            }
          }
        } else {
          if (title.startsWith(searchController.toUpperCase()) && muscleId == selectedType.toUpperCase()) {
            showResults.add(tripSnapshot); //adiciona apenas os procurados na lista
          }
        }
      }
      //se o controlador estiver vazio de inicio e o tipo for "home_exe"
    } else if (selectedType == "mines") {
      showResults = listaMeusExercicios;
    } else if (selectedType == "home_exe") {
      //se o tipo for "home_exe"
      for (var tripSnapshot in listaExercicios) {
        var homeExe = tripSnapshot.isHomeExercise!;
        if (homeExe) {
          showResults.add(tripSnapshot);
        }
      }
    }
    //se for selecionado por titulo ou nome de agrupamentos
    else if (selectedType == "title" || selectedType == "muscleId") {
      showResults = List.from(listaExercicios);
    } else {
      //se for selecionado por grupamento
      for (var tripSnapshot in listaExercicios) {
        var muscle = tripSnapshot.muscleId;
        if (muscle == selectedType) {
          showResults.add(tripSnapshot);
        }
      }
    }
    resultList = showResults;
    notifyListeners();

    return showResults;
  }

  Future<void> loadMyListExercises({required String idUser}) async {
    Map<String, dynamic> data = {};
    listaMeusExercicios = [];
    try {
      var queryWorksheet = await FirebaseFirestore.instance.collection("users").doc(idUser).collection("exercicios").orderBy('title').get();

      queryWorksheet.docs.forEach((element) {
        log(element.data.toString());
        data = element.data();
        data['id'] = element.id;
        listaMeusExercicios.add(Exercise.fromMap(data));
      });

      log('MY LIST EXERCISE LOAD SUCESS');
    } catch (e) {
      listaMeusExercicios = [];
      log('ERROR LOADING: ' + e.toString());
    }
    notifyListeners();
  }

  Future<String?> deleteMyExercise({required int index, required String userId}) async {
    try {
      await FirebaseFirestore.instance.collection("users").doc(userId).collection("exercicios").doc(listaMeusExercicios[index].id).delete();
      listaMeusExercicios.removeAt(index);
      notifyListeners();
      return null;
    } catch (e) {
      log(e.toString());
      return e.toString();
    }
  }
}
