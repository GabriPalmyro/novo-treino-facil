import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/exercicio_modal.dart';

class BiSetCardWidget extends StatefulWidget {
  final int index;
  final String idPlanilha;
  final String idUser;
  final BiSetExercise exercicio;
  final String titlePlanilha;
  final int tamPlan;
  final VoidCallback refetchExercises;

  const BiSetCardWidget(
      {required this.index,
      required this.idPlanilha,
      required this.idUser,
      required this.exercicio,
      required this.refetchExercises,
      required this.tamPlan,
      required this.titlePlanilha});

  @override
  _BiSetCardWidgetState createState() => _BiSetCardWidgetState();
}

class _BiSetCardWidgetState extends State<BiSetCardWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      width: width,
      decoration: BoxDecoration(color: AppColors.mainColor, borderRadius: new BorderRadius.all(const Radius.circular(12.0)), boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          spreadRadius: 4,
          blurRadius: 4,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ]),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Text(
              (widget.index + 1).toString() + 'º',
              style: TextStyle(fontSize: 14, fontFamily: AppFonts.gothamBold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
              Row(
                children: [
                  Expanded(
                    flex: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(
                            'Exercício 1:',
                            style: TextStyle(color: Colors.black.withOpacity(0.6), fontFamily: AppFonts.gothamBook, fontSize: 14),
                          ),
                        ),
                        AutoSizeText(
                          widget.exercicio.exercicios![0].title.toString().toUpperCase(),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          style: TextStyle(color: Colors.black, fontFamily: "GothamBold", fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: IconButton(
                        icon: Icon(
                          Icons.remove_red_eye,
                          color: Colors.black.withOpacity(0.8),
                        ),
                        iconSize: 20,
                        onPressed: () async {
                          final firstExercise = widget.exercicio.exercicios![0];
                          try {
                            showModalBottomSheet(
                              backgroundColor: Colors.transparent,
                              isScrollControlled: true,
                              enableDrag: false,
                              context: context,
                              builder: (_) => ExercicioViewModal(
                                exercicio: firstExercise,
                                idPlanilha: widget.idPlanilha,
                                idUser: widget.idUser,
                                idExercicio: firstExercise.id,
                                isPersonalManag: false,
                                tamPlan: widget.tamPlan,
                                titlePlanilha: widget.titlePlanilha,
                                refetchExercises: widget.refetchExercises,
                                isBiSet: true,
                                isFriendAcess: false,
                                enableEditing: false,
                                idBiSet: '',
                                isSecondExercise: false,
                              ),
                            );
                          } catch (e) {
                            log(e.toString());
                          }
                        }),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Divider(
                  color: Colors.black.withOpacity(0.4),
                  thickness: 1,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 3.0),
                          child: Text(
                            'Exercício 2:',
                            style: TextStyle(color: Colors.black.withOpacity(0.6), fontFamily: AppFonts.gothamBook, fontSize: 14),
                          ),
                        ),
                        AutoSizeText(
                          widget.exercicio.exercicios![1].title.toString().toUpperCase(),
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          style: TextStyle(color: Colors.black, fontFamily: "GothamBold", fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 10,
                    child: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.black.withOpacity(0.8),
                      ),
                      iconSize: 20,
                      onPressed: () async {
                        final secondExercise = widget.exercicio.exercicios![1];
                        try {
                          showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            enableDrag: false,
                            context: context,
                            builder: (_) => ExercicioViewModal(
                              exercicio: secondExercise,
                              idPlanilha: widget.idPlanilha,
                              idUser: widget.idUser,
                              idExercicio: secondExercise.id,
                              isPersonalManag: false,
                              tamPlan: widget.tamPlan,
                              titlePlanilha: widget.titlePlanilha,
                              refetchExercises: widget.refetchExercises,
                              isBiSet: true,
                              isFriendAcess: false,
                              enableEditing: false,
                              idBiSet: '',
                              isSecondExercise: false,
                            ),
                          );
                        } catch (e) {
                          log(e.toString());
                        }
                      },
                    ),
                  ),
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
