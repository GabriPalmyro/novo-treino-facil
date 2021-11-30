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

  ListaExerciciosModal(
      {@required this.idPlanilha,
      @required this.titlePlanilha,
      @required this.tamPlan});

  @override
  _ListaExerciciosModalState createState() => _ListaExerciciosModalState();
}

class _ListaExerciciosModalState extends State<ListaExerciciosModal> {
  bool _isSearching = false;
  final _searchController = TextEditingController();

  String _selTypeSearch = "title";

  Widget _buildSearchField() {
    return TextField(
      keyboardType: TextInputType.text,
      controller: _searchController,
      style: TextStyle(
        color: Colors.grey[900],
        fontSize: 20,
        height: 1.3,
        fontFamily: AppFonts.gothamBook,
      ),
      enableInteractiveSelection: true,
      decoration: InputDecoration(
          hintText: _selTypeSearch == "title"
              ? "Procure um exercício"
              : _selTypeSearch == "home_exe"
                  ? "Fazer em casa"
                  : _selTypeSearch == "muscleId"
                      ? "Procure um músculo"
                      : "Procure em $_selTypeSearch",
          border: InputBorder.none,
          hintStyle: TextStyle(
              fontSize: 18, color: Colors.grey[900].withOpacity(0.9))),
    );
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null || _searchController.text.isEmpty) {
              setState(() {
                _isSearching = false;
              });
              return;
            }
            setState(() {
              _searchController.clear();
            });
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        padding: EdgeInsets.only(right: 30),
        icon: const Icon(
          Icons.search,
          size: 30,
        ),
        onPressed: () {
          setState(() {
            _isSearching = true;
          });
        },
      ),
    ];
  }

  List filters = [
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
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Text(
                    'Selecione o exercício a ser adicionado:',
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
                                      _searchController.text, _selTypeSearch);
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
