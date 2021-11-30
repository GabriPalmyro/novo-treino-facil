import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

import 'components/card_exercicio.dart';
import 'components/filter_button.dart';
import 'components/info_exercicio_modal.dart';

class ListaExerciciosScreen extends StatefulWidget {
  @override
  _ListaExerciciosScreenState createState() => _ListaExerciciosScreenState();
}

class _ListaExerciciosScreenState extends State<ListaExerciciosScreen> {
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
    return Consumer<ExercisesManager>(builder: (_, exercicios, __) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          return Future.value(true);
        },
        child: Scaffold(
          drawer: CustomDrawer(pageNow: 2),
          appBar: AppBar(
            title: _isSearching
                ? _buildSearchField()
                : Text(
                    "Exercícios",
                    style: TextStyle(
                        fontFamily: AppFonts.gothamBold, fontSize: 30),
                    maxLines: 2,
                  ),
            actions: _buildActions(),
            //leading: (addMode && exeId != null) ? Container() : null,
            centerTitle: true,
          ),
          backgroundColor: AppColors.grey,
          body: Column(
            children: [
              Container(
                  margin: EdgeInsets.only(top: 20, bottom: 10),
                  height: 60,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
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
                child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: exercicios.resultList.length,
                    itemBuilder: (_, index) {
                      return CardExercicio(
                        index: index,
                        onTap: () {
                          showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              enableDrag: false,
                              context: context,
                              builder: (_) => ExercicioInfoModal(
                                  exercicio: exercicios.resultList[index]));
                        },
                        exercise: exercicios.resultList[index],
                      );
                    }),
              )
            ],
          ),
        ),
      );
    });
  }
}
