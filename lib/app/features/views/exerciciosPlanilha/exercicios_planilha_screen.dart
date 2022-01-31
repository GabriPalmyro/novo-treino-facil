import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/alunos/planilhasAlunos/planilhas_alunos.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/select_set_modal.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/uni_set_card.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

import 'components/bi_set_card.dart';
import 'components/planilha_vazia.dart';

class ExerciciosPlanilhaArguments {
  final String title;
  final String idPlanilha;
  final String idUser;
  final bool isPersonalAcess;
  final bool isFriendAcess;
  final String nomeAluno;

  ExerciciosPlanilhaArguments(
      {this.title,
      this.idPlanilha,
      this.idUser,
      this.isPersonalAcess = false,
      this.isFriendAcess = false,
      this.nomeAluno = ''});
}

class ExerciciosPlanilhaScreen extends StatefulWidget {
  final ExerciciosPlanilhaArguments arguments;

  ExerciciosPlanilhaScreen(this.arguments);

  @override
  _ExerciciosPlanilhaScreenState createState() =>
      _ExerciciosPlanilhaScreenState();
}

class _ExerciciosPlanilhaScreenState extends State<ExerciciosPlanilhaScreen> {
  List listaExercicios = List.empty(growable: true);
  List listaExerciciosTemp = List.empty(growable: true);

  int tamPlan = 0;
  bool _isEditing = false;
  bool isLoading = false;

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
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        isLoading = true;
      });
      Map<String, dynamic> data = {};
      listaExercicios = List.empty(growable: true);
      try {
        CollectionReference ref = FirebaseFirestore.instance
            .collection("users")
            .doc(widget.arguments.idUser)
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
        setState(() {
          isLoading = false;
        });
        return listaExercicios;
      } catch (e) {
        listaExercicios = [];
        setState(() {
          isLoading = false;
        });
        debugPrint('Erro: ' + e.toString());
        return listaExercicios;
      }
    });
    return null;
  }

  @override
  void initState() {
    super.initState();
    loadExerciciosPlanilha();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<UserManager, ExerciciosPlanilhaManager>(
        builder: (_, userManager, exercicios, __) {
      return WillPopScope(
        onWillPop: () async {
          if (widget.arguments.isPersonalAcess) {
            Navigator.pushNamed(context, AppRoutes.planilhasAluno,
                arguments: PlanilhaAlunoArguments(
                    nomeUser: userManager.alunoNomeTemp,
                    idUser: widget.arguments.idUser));
            return true;
          } else if (widget.arguments.isFriendAcess) {
            Navigator.pop(context);
            return true;
          } else {
            Navigator.pushNamedAndRemoveUntil(
                context, AppRoutes.planilhas, (route) => false,
                arguments: widget.arguments.idUser);
            return true;
          }
        },
        child: Scaffold(
            appBar: AppBar(
              toolbarHeight: 70,
              // shadowColor: Colors.grey[850],
              elevation: 0,
              iconTheme: IconThemeData(
                color: AppColors.mainColor,
              ),
              centerTitle: false,
              actions: [
                if (!widget.arguments.isFriendAcess && !_isEditing) ...[
                  IconButton(
                    icon: Icon(
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
                                tamPlan: tamPlan,
                                isPersonalAcess:
                                    widget.arguments.isPersonalAcess,
                              ));
                    },
                  ),
                ],
                if (!widget.arguments.isFriendAcess) ...[
                  Padding(
                    padding: EdgeInsets.only(right: _isEditing ? 0 : 8.0),
                    child: IconButton(
                      icon: Icon(
                        _isEditing ? Icons.save_outlined : Icons.edit_outlined,
                        size: 28,
                      ),
                      tooltip:
                          _isEditing ? 'Salvar edição' : 'Ordernar exercícios',
                      onPressed: () async {
                        if (_isEditing) {
                          if (exercicios.validarStringsIds(
                              planilhaId: widget.arguments.idPlanilha,
                              idUser: widget.arguments.idUser)) {
                            String response =
                                await exercicios.reorganizarListaExercicios(
                                    listaExercicios: listaExerciciosTemp,
                                    planilhaId: widget.arguments.idPlanilha,
                                    idUser: widget.arguments.idUser);

                            if (response != null) {
                              mostrarSnackBar(
                                  message:
                                      'Ocorreu um erro. Tente novamente mais tarde.',
                                  color: AppColors.red,
                                  context: context);
                            } else {
                              setState(() {
                                listaExercicios = listaExerciciosTemp;
                                listaExerciciosTemp =
                                    List.empty(growable: true);
                                _isEditing = false;
                              });
                            }
                          } else {
                            mostrarSnackBar(
                                message:
                                    'Ocorreu um erro. Tente novamente mais tarde.',
                                color: AppColors.red,
                                context: context);
                          }
                        } else {
                          setState(() {
                            listaExerciciosTemp.addAll(listaExercicios);
                            _isEditing = true;
                          });
                        }
                      },
                    ),
                  ),
                ],
                if (!widget.arguments.isFriendAcess && _isEditing) ...[
                  Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: 28,
                      ),
                      tooltip: 'Cancelar',
                      onPressed: () {
                        setState(() {
                          listaExerciciosTemp = List.empty(growable: true);
                          _isEditing = false;
                        });
                      },
                    ),
                  ),
                ]
              ],
              title: Text(
                widget.arguments.title,
                style: TextStyle(
                    color: AppColors.mainColor,
                    fontFamily: AppFonts.gothamBold,
                    fontSize: 26),
              ),
              backgroundColor: AppColors.grey,
            ),
            backgroundColor: AppColors.grey,
            body: exercicios.loading || isLoading
                ? ExerciciosPlanilhaShimmer()
                : listaExercicios.isEmpty
                    ? ExerciciosPlanilhaVazia()
                    : _isEditing
                        ? ReorderableListView.builder(
                            shrinkWrap: true,
                            itemCount: listaExerciciosTemp.length,
                            physics: BouncingScrollPhysics(),
                            onReorder: (oldIndex, newIndex) => setState(() {
                              final index =
                                  newIndex > oldIndex ? newIndex - 1 : newIndex;

                              final exercicio =
                                  listaExerciciosTemp.removeAt(oldIndex);
                              listaExerciciosTemp.insert(index, exercicio);
                            }),
                            itemBuilder: (_, index) {
                              return Container(
                                  key: ValueKey(listaExerciciosTemp[index]),
                                  decoration:
                                      BoxDecoration(color: AppColors.grey),
                                  child: listaExerciciosTemp[index].setType ==
                                          "uniset"
                                      ? UniSetCard(
                                          index: index,
                                          isChanging: false,
                                          isEditing: _isEditing,
                                          exercicio: listaExerciciosTemp[index],
                                          idUser: widget.arguments.idUser,
                                          isFriendAcess:
                                              widget.arguments.isFriendAcess,
                                          onTap: () {},
                                          onDelete: () async {
                                            debugPrint(
                                                'apagando uniset (${widget.arguments.idPlanilha} -> ${listaExerciciosTemp[index].id})...');
                                            Navigator.pop(context);
                                            String response = await exercicios
                                                .deleteExerciseUniSet(
                                                    listaExercicios:
                                                        listaExerciciosTemp,
                                                    planilhaId: widget
                                                        .arguments.idPlanilha,
                                                    idUser:
                                                        widget.arguments.idUser,
                                                    idExercise:
                                                        listaExerciciosTemp[
                                                                index]
                                                            .id,
                                                    index: index);

                                            if (response != null) {
                                              mostrarSnackBar(
                                                  message:
                                                      'Ocorreu um erro. Tente novamente mais tarde.',
                                                  color: AppColors.red,
                                                  context: context);
                                            } else {
                                              setState(() {
                                                listaExercicios =
                                                    listaExerciciosTemp;
                                                listaExerciciosTemp =
                                                    List.empty(growable: true);
                                                _isEditing = false;
                                              });
                                            }
                                          },
                                        )
                                      : BiSetCard(
                                          index: index,
                                          idPlanilha:
                                              widget.arguments.idPlanilha,
                                          exercicio: listaExerciciosTemp[index],
                                          isChanging: false,
                                          isEditing: _isEditing,
                                          idUser: widget.arguments.idUser,
                                          tamPlan: tamPlan,
                                          titlePlanilha: widget.arguments.title,
                                          isFriendAcess:
                                              widget.arguments.isFriendAcess,
                                          onDelete: () async {
                                            debugPrint(
                                                'apagando biset (${widget.arguments.idPlanilha} -> ${listaExerciciosTemp[index].id})...');
                                            Navigator.pop(context);
                                            String response = await exercicios
                                                .deleteExerciseBiSet(
                                                    planilhaId: widget
                                                        .arguments.idPlanilha,
                                                    idExercise:
                                                        listaExerciciosTemp[
                                                                index]
                                                            .id,
                                                    idUser:
                                                        widget.arguments.idUser,
                                                    listaExercicios:
                                                        listaExerciciosTemp,
                                                    index: index);

                                            if (response != null) {
                                              mostrarSnackBar(
                                                  message:
                                                      'Ocorreu um erro. Tente novamente mais tarde.',
                                                  color: AppColors.red,
                                                  context: context);
                                            } else {
                                              setState(() {
                                                listaExercicios =
                                                    listaExerciciosTemp;
                                                listaExerciciosTemp =
                                                    List.empty(growable: true);
                                                _isEditing = false;
                                              });
                                            }
                                          },
                                        ));
                            },
                          )
                        : SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 70.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(listaExercicios.length,
                                    (index) {
                                  return listaExercicios[index].setType ==
                                          "uniset"
                                      ? UniSetCard(
                                          index: index,
                                          isChanging: false,
                                          exercicio: listaExercicios[index],
                                          isEditing: _isEditing,
                                          idUser: widget.arguments.idUser,
                                          onTap: () {
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                enableDrag: false,
                                                context: context,
                                                builder: (_) =>
                                                    ExercicioViewModal(
                                                      exercicio:
                                                          listaExercicios[
                                                              index],
                                                      isFriendAcess: widget
                                                          .arguments
                                                          .isFriendAcess,
                                                      idPlanilha: widget
                                                          .arguments.idPlanilha,
                                                      idExercicio:
                                                          listaExercicios[index]
                                                              .id,
                                                      idUser: widget
                                                          .arguments.idUser,
                                                      isPersonalManag: widget
                                                          .arguments
                                                          .isPersonalAcess,
                                                      tamPlan: tamPlan,
                                                      titlePlanilha: widget
                                                          .arguments.title,
                                                      isBiSet: false,
                                                      isSecondExercise: false,
                                                    ));
                                          },
                                        )
                                      : BiSetCard(
                                          index: index,
                                          idPlanilha:
                                              widget.arguments.idPlanilha,
                                          exercicio: listaExercicios[index],
                                          isChanging: false,
                                          idUser: widget.arguments.idUser,
                                          isFriendAcess:
                                              widget.arguments.isFriendAcess,
                                          isEditing: _isEditing,
                                          tamPlan: tamPlan,
                                          titlePlanilha: widget.arguments.title,
                                        );
                                }),
                              ),
                            ),
                          )),
      );
    });
  }
}
