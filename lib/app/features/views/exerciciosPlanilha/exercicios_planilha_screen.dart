import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/select_set_modal.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/uni_set_card.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

import 'components/bi_set_card.dart';

class ExerciciosPlanilhaArguments {
  final String title;
  final String idPlanilha;
  final String idUser;
  final bool isPersonalAcess;
  final bool isFriendAcess;

  ExerciciosPlanilhaArguments(
      {this.title,
      this.idPlanilha,
      this.idUser,
      this.isPersonalAcess = false,
      this.isFriendAcess = false});
}

class ExerciciosPlanilhaScreen extends StatefulWidget {
  final ExerciciosPlanilhaArguments arguments;

  ExerciciosPlanilhaScreen(this.arguments);

  @override
  _ExerciciosPlanilhaScreenState createState() =>
      _ExerciciosPlanilhaScreenState();
}

class _ExerciciosPlanilhaScreenState extends State<ExerciciosPlanilhaScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  int tamPlan = 0;

  Future<List<ExerciciosPlanilha>> biSetExerciseList(
      String idSet, CollectionReference ref) async {
    Map<String, dynamic> data = {};
    List<ExerciciosPlanilha> biSets = [];

    try {
      var queryWorksheet = await ref.doc(idSet).collection('sets').get();

      queryWorksheet.docs.forEach((element) {
        data = element.data();
        data['id'] = element.id;
        biSets.add(ExerciciosPlanilha.fromMap(data));
      });
      return biSets;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<dynamic>> loadExerciciosPlanilha() async {
    Map<String, dynamic> data = {};
    List listaExercicios = List.empty(growable: true);
    try {
      CollectionReference ref = FirebaseFirestore.instance
          .collection("users")
          .doc(_auth.currentUser.uid)
          .collection("planilha")
          .doc(widget.arguments.idPlanilha)
          .collection('exercícios');

      var queryWorksheet = await ref.orderBy('pos').get();

      queryWorksheet.docs.forEach((element) async {
        data = element.data();
        data['id'] = element.id;

        if (data['set_type'] == "uniset") {
          listaExercicios.add(ExerciciosPlanilha.fromMap(data));
        } else if (data['set_type'] == "biset") {
          Map<String, dynamic> dataTemp = data;
          listaExercicios.add(BiSetExercise.fromMap(dataTemp));
        }
        data = {};
      });
      tamPlan = listaExercicios.length;
      return listaExercicios;
    } catch (e) {
      listaExercicios = [];
      debugPrint('Erro: ' + e.toString());
      return listaExercicios;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExerciciosPlanilhaManager>(builder: (_, exercicios, __) {
      return WillPopScope(
        onWillPop: () async {
          if (widget.arguments.isPersonalAcess ||
              widget.arguments.isFriendAcess) {
            Navigator.pop(context);
            return true;
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.planilhas, (route) => false);
            return true;
          }
        },
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            shadowColor: Colors.grey[850],
            elevation: 25,
            centerTitle: false,
            actions: [
              if (!widget.arguments.isFriendAcess) ...[
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 28,
                    ),
                    tooltip: 'Adicionar Novo Exercício',
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => SelectSetModal(
                              idUser: widget.arguments.idUser,
                              titlePlanilha: widget.arguments.title,
                              idPlanilha: widget.arguments.idPlanilha,
                              tamPlan: tamPlan));
                    },
                  ),
                ),
              ]
            ],
            title: Text(
              widget.arguments.title,
              style: TextStyle(
                  color: AppColors.black,
                  fontFamily: AppFonts.gothamBold,
                  fontSize: 30),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          backgroundColor: AppColors.grey,
          body: FutureBuilder<List>(
              future: loadExerciciosPlanilha(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return ExerciciosPlanilhaShimmer();
                } else {
                  return SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 70.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(snapshot.data.length, (index) {
                          return snapshot.data[index].setType == "uniset"
                              ? UniSetCard(
                                  index: index,
                                  isChanging: false,
                                  exercicio: snapshot.data[index],
                                  onTap: () {
                                    showModalBottomSheet(
                                        backgroundColor: Colors.transparent,
                                        isScrollControlled: true,
                                        enableDrag: false,
                                        context: context,
                                        builder: (_) => ExercicioViewModal(
                                              exercicio: snapshot.data[index],
                                              isFriendAcess: widget
                                                  .arguments.isFriendAcess,
                                            ));
                                  },
                                )
                              : BiSetCard(
                                  index: index,
                                  idPlanilha: widget.arguments.idPlanilha,
                                  exercicio: snapshot.data[index],
                                  isChanging: false,
                                  isFriendAcess:
                                      widget.arguments.isFriendAcess);
                        }),
                      ),
                    ),
                  );
                }
              }),
        ),
      );
    });
  }
}
