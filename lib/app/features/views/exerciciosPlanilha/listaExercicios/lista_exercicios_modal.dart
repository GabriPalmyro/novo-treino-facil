import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/listaExercicios/components/card_selecteds_exercices.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/components/filter_button.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

import 'components/card_exercicio.dart';

class ListaExerciciosModal extends StatefulWidget {
  final String idPlanilha;
  final String titlePlanilha;
  final int tamPlan;
  final String idUser;
  final bool isPersonalAcess;
  final bool isBiSet;

  ListaExerciciosModal(
      {@required this.idPlanilha,
      @required this.titlePlanilha,
      @required this.tamPlan,
      @required this.idUser,
      this.isPersonalAcess = false,
      this.isBiSet = false});

  @override
  _ListaExerciciosModalState createState() => _ListaExerciciosModalState();
}

class _ListaExerciciosModalState extends State<ListaExerciciosModal> {
  final _searchController = TextEditingController();

  String _selTypeSearch = "title";

  bool isHighletd = false;

  List filters = [
    "mines",
    "title",
    "home_exe",
    "abdomen",
    "biceps",
    "costas",
    "ombros",
    "peitoral",
    "pernas",
    "triceps",
  ];

  List titles = [
    "Meus Exercícios",
    "Título",
    "Fazer em casa",
    "Abdômen",
    "Bíceps",
    "Costas",
    "Ombros",
    "Peitoral",
    "Pernas",
    "Tríceps",
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer2<ExercisesManager, ExerciciosPlanilhaManager>(
        builder: (_, exercicios, exerciciosPlanilha, __) {
      return WillPopScope(
        onWillPop: () async {
          showCustomDialogOpt(
              context: context,
              function: () {
                exerciciosPlanilha.limparExercicioBiSetLista();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pop(context);
              },
              message:
                  'Essa ação irá resultar na perda dos exercício(s) adicionado(s) até agora.');
          return true;
        },
        child: Container(
          height: height * 0.95,
          child: Container(
            height: height * 0.95,
            decoration: new BoxDecoration(
                color: AppColors.grey,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(15.0),
                    topRight: const Radius.circular(15.0))),
            child: Padding(
              padding: EdgeInsets.only(
                top: 8.0,
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, bottom: 8, left: 12.0, right: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 10,
                              child: InkWell(
                                onTap: () {
                                  showCustomDialogOpt(
                                      context: context,
                                      function: () {
                                        exerciciosPlanilha
                                            .limparExercicioBiSetLista();
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      message:
                                          'Essa ação irá resultar na perda dos exercício(s) adicionado(s) até agora.');
                                },
                                child: Icon(
                                  Icons.cancel_rounded,
                                  color: AppColors.mainColor,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 90,
                              child: AutoSizeText(
                                widget.isBiSet
                                    ? exerciciosPlanilha
                                                .listaExerciciosBiSet.length ==
                                            2
                                        ? 'Clique em concluir para adicionar:'
                                        : exerciciosPlanilha
                                                .isFirstExerciseSelected
                                            ? 'Selecione o segundo exercício:'
                                            : 'Selecione o primeiro exercício:'
                                    : 'Selecione o exercício a ser adicionado:',
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontFamily: AppFonts.gothamBold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.only(
                            bottom: 10,
                          ),
                          height: 50,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Row(
                                children:
                                    List.generate(filters.length, (index) {
                                  return FilterButton(
                                    onTap: () {
                                      setState(() {
                                        _selTypeSearch = filters[index];
                                        exercicios.searchResultList(
                                            searchController:
                                                _searchController.text,
                                            selectedType: _selTypeSearch);
                                      });
                                    },
                                    filter: filters[index],
                                    selectedType: _selTypeSearch,
                                    title: titles[index],
                                  );
                                }),
                              ),
                            ),
                          )),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: exercicios.resultList.length,
                              itemBuilder: (_, index) {
                                return CardExercicio(
                                  index: index,
                                  idUser: widget.idUser,
                                  titlePlanilha: widget.titlePlanilha,
                                  idPlanilha: widget.idPlanilha,
                                  tamPlan: widget.tamPlan,
                                  exercise: exercicios.resultList[index],
                                  isBiSet: widget.isBiSet,
                                  showAddButton: exerciciosPlanilha
                                              .listaExerciciosBiSet.length >=
                                          2
                                      ? false
                                      : true,
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                  if (widget.isBiSet) ...[
                    Positioned(
                        bottom: 60,
                        child: Container(
                          width: width,
                          child: Align(
                              alignment: Alignment.center,
                              child: CardSelectedsExercices(
                                idPlanilha: widget.idPlanilha,
                                tamPlanilha: widget.tamPlan,
                                idUser: widget.idUser,
                                title: widget.titlePlanilha,
                                isPersonalAcess: widget.isPersonalAcess,
                              )),
                        )),
                  ]
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
