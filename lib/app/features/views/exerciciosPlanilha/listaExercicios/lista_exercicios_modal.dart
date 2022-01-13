import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/components/filter_button.dart';

import 'components/card_exercicio.dart';

class ListaExerciciosModal extends StatefulWidget {
  final String idPlanilha;
  final String titlePlanilha;
  final int tamPlan;
  final String idUser;

  ListaExerciciosModal(
      {@required this.idPlanilha,
      @required this.titlePlanilha,
      @required this.tamPlan,
      @required this.idUser});

  @override
  _ListaExerciciosModalState createState() => _ListaExerciciosModalState();
}

class _ListaExerciciosModalState extends State<ListaExerciciosModal> {
  final _searchController = TextEditingController();

  String _selTypeSearch = "title";

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
    double height = MediaQuery.of(context).size.height;
    return Consumer<ExercisesManager>(builder: (_, exercicios, __) {
      return Container(
        height: height * 0.95,
        child: Container(
          height: height * 0.95,
          decoration: new BoxDecoration(
              color: AppColors.grey,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(25.0),
                  topRight: const Radius.circular(25.0))),
          child: Padding(
            padding: EdgeInsets.only(
              top: 8.0,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 8,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                          color: AppColors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 12, bottom: 8, left: 12.0, right: 12.0),
                  child: AutoSizeText(
                    'Selecione o exercício a ser adicionado:',
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: AppFonts.gothamBold,
                      color: AppColors.white,
                    ),
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
                          children: List.generate(filters.length, (index) {
                            return FilterButton(
                              onTap: () {
                                setState(() {
                                  _selTypeSearch = filters[index];
                                  exercicios.searchResultList(
                                      searchController: _searchController.text,
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
                            onTap: () {},
                            idUser: widget.idUser,
                            titlePlanilha: widget.titlePlanilha,
                            idPlanilha: widget.idPlanilha,
                            tamPlan: widget.tamPlan,
                            exercise: exercicios.resultList[index],
                          );
                        }),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
