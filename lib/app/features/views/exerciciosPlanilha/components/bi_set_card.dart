import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

import 'exercicio_modal.dart';

class BiSetCard extends StatefulWidget {
  final int index;
  final String idPlanilha;
  final String idUser;
  final BiSetExercise exercicio;
  final bool isChanging;
  final bool isFriendAcess;
  final bool isEditing;
  final Function onDelete;
  final String titlePlanilha;
  final int tamPlan;

  const BiSetCard(
      {@required this.index,
      @required this.idPlanilha,
      @required this.idUser,
      @required this.exercicio,
      @required this.isChanging,
      this.isFriendAcess = false,
      this.onDelete,
      @required this.isEditing,
      @required this.tamPlan,
      @required this.titlePlanilha});

  @override
  _BiSetCardState createState() => _BiSetCardState();
}

class _BiSetCardState extends State<BiSetCard> {
  Future<void> showCustomDialogOpt({Function function, String message}) async {
    await showCustomAlertDialog(
        title: Text(
          'Deletar esse exercício?',
          style:
              TextStyle(fontFamily: AppFonts.gothamBold, color: AppColors.red),
        ),
        androidActions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: Colors.white))),
          TextButton(
              onPressed: function,
              child: Text('Ok',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
        ],
        iosActions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: Colors.white))),
          TextButton(
              onPressed: function,
              child: Text('Ok',
                  style: TextStyle(
                      fontFamily: AppFonts.gotham, color: AppColors.mainColor)))
        ],
        context: context,
        content: Text(
          message,
          style: TextStyle(
              height: 1.1, fontFamily: AppFonts.gotham, color: Colors.white),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        if (widget.isEditing) ...[
          Expanded(
              flex: 10,
              child: Container(
                padding: EdgeInsets.only(left: 8.0),
                child: Center(
                  child: Icon(
                    Icons.reorder,
                    color: AppColors.white,
                  ),
                ),
              )),
        ],
        Expanded(
          flex: widget.isEditing ? 90 : 100,
          child: Container(
            width: width * 0.8,
            decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: new BorderRadius.all(const Radius.circular(12.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    spreadRadius: 4,
                    blurRadius: 4,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ]),
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: widget.isChanging
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.grey[850]),
                    ),
                  )
                : Stack(
                    children: [
                      if (widget.isEditing) ...[
                        Positioned(
                          right: -15,
                          top: -15,
                          child: IconButton(
                              icon: Icon(
                                Icons.delete_forever_rounded,
                                color: Colors.red.withOpacity(0.9),
                              ),
                              iconSize: 20,
                              onPressed: () async {
                                await showCustomDialogOpt(
                                    message:
                                        'Essa ação não poderá ser desfeita após concluida.',
                                    function: () async {
                                      widget.onDelete();
                                    });
                              }),
                        )
                      ],
                      Positioned(
                          left: 0,
                          top: 0,
                          child: Text(
                            (widget.index + 1).toString() + 'º',
                            style: TextStyle(
                                fontSize: 14, fontFamily: AppFonts.gothamBold),
                          )),
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 12.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    flex: !widget.isEditing ? 90 : 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Exercício 1:',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontFamily: AppFonts.gothamBook,
                                                fontSize: 14),
                                          ),
                                        ),
                                        AutoSizeText(
                                          widget.exercicio.firstExercise
                                              .toString()
                                              .toUpperCase(),
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "GothamBold",
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!widget.isEditing) ...[
                                    Expanded(
                                      flex: 10,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          iconSize: 20,
                                          onPressed: () async {
                                            if (!widget.isEditing) {
                                              ExerciciosPlanilha exercicio;
                                              Map<String, dynamic> data = {};
                                              try {
                                                var snapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(widget.idUser)
                                                        .collection("planilha")
                                                        .doc(widget.idPlanilha)
                                                        .collection(
                                                            'exercícios')
                                                        .doc(
                                                            widget.exercicio.id)
                                                        .collection('sets')
                                                        .get();

                                                data = snapshot.docs[0].data();
                                                data['id'] =
                                                    snapshot.docs[0].id;
                                                exercicio =
                                                    ExerciciosPlanilha.fromMap(
                                                        data);

                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    isScrollControlled: true,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (_) =>
                                                        ExercicioViewModal(
                                                          exercicio: exercicio,
                                                          idPlanilha:
                                                              widget.idPlanilha,
                                                          idUser: widget.idUser,
                                                          idExercicio:
                                                              exercicio.id,
                                                          isPersonalManag:
                                                              false,
                                                          tamPlan:
                                                              widget.tamPlan,
                                                          titlePlanilha: widget
                                                              .titlePlanilha,
                                                          isBiSet: true,
                                                          isFriendAcess: widget
                                                              .isFriendAcess,
                                                          isSecondExercise:
                                                              false,
                                                        ));
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                            }
                                          }),
                                    )
                                  ]
                                ],
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: AutoSizeText(
                                  '+',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.4),
                                      fontFamily: "Gotham",
                                      fontSize: 20),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: !widget.isEditing ? 90 : 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 3.0),
                                          child: Text(
                                            'Exercício 2:',
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.6),
                                                fontFamily: AppFonts.gothamBook,
                                                fontSize: 14),
                                          ),
                                        ),
                                        AutoSizeText(
                                          widget.exercicio.secondExercise
                                              .toString()
                                              .toUpperCase(),
                                          textAlign: TextAlign.start,
                                          maxLines: 3,
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontFamily: "GothamBold",
                                              fontSize: 20),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (!widget.isEditing) ...[
                                    Expanded(
                                      flex: 10,
                                      child: IconButton(
                                          icon: Icon(
                                            Icons.remove_red_eye,
                                            color:
                                                Colors.black.withOpacity(0.8),
                                          ),
                                          iconSize: 20,
                                          onPressed: () async {
                                            if (!widget.isEditing) {
                                              ExerciciosPlanilha exercicio;
                                              Map<String, dynamic> data = {};
                                              try {
                                                var snapshot =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("users")
                                                        .doc(widget.idUser)
                                                        .collection("planilha")
                                                        .doc(widget.idPlanilha)
                                                        .collection(
                                                            'exercícios')
                                                        .doc(
                                                            widget.exercicio.id)
                                                        .collection('sets')
                                                        .get();

                                                data = snapshot.docs[1].data();
                                                data['id'] =
                                                    snapshot.docs[1].id;
                                                exercicio =
                                                    ExerciciosPlanilha.fromMap(
                                                        data);

                                                showModalBottomSheet(
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    isScrollControlled: true,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (_) =>
                                                        ExercicioViewModal(
                                                          exercicio: exercicio,
                                                          idPlanilha:
                                                              widget.idPlanilha,
                                                          idUser: widget.idUser,
                                                          idExercicio:
                                                              exercicio.id,
                                                          isPersonalManag:
                                                              false,
                                                          tamPlan:
                                                              widget.tamPlan,
                                                          titlePlanilha: widget
                                                              .titlePlanilha,
                                                          isBiSet: true,
                                                          isFriendAcess: widget
                                                              .isFriendAcess,
                                                          isSecondExercise:
                                                              false,
                                                        ));
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                            }
                                          }),
                                    )
                                  ]
                                ],
                              ),
                            ]),
                      )
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}
