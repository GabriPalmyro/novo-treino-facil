import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

import 'exercicio_modal.dart';

class BiSetCard extends StatefulWidget {
  final int index;
  final String idPlanilha;
  final BiSetExercise exercicio;
  final bool isChanging;
  final Function onTap;
  final bool isFriendAcess;

  const BiSetCard(
      {this.index,
      this.idPlanilha,
      this.exercicio,
      this.isChanging,
      this.onTap,
      this.isFriendAcess = false});

  @override
  _BiSetCardState createState() => _BiSetCardState();
}

class _BiSetCardState extends State<BiSetCard> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[850]),
              ),
            )
          : Stack(
              children: [
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
                              flex: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'Exercício 1:',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
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
                            Expanded(
                              flex: 10,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  iconSize: 20,
                                  onPressed: () async {
                                    ExerciciosPlanilha exercicio;
                                    Map<String, dynamic> data = {};
                                    try {
                                      var snapshot = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(_auth.currentUser.uid)
                                          .collection("planilha")
                                          .doc(widget.idPlanilha)
                                          .collection('exercícios')
                                          .doc(widget.exercicio.id)
                                          .collection('sets')
                                          .get();

                                      data = snapshot.docs[0].data();
                                      data['id'] = snapshot.docs[0].id;
                                      exercicio =
                                          ExerciciosPlanilha.fromMap(data);

                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          enableDrag: false,
                                          context: context,
                                          builder: (_) => ExercicioViewModal(
                                                exercicio: exercicio,
                                                isFriendAcess:
                                                    widget.isFriendAcess,
                                              ));
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  }),
                            )
                          ],
                        ),
                        AutoSizeText(
                          '+',
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.4),
                              fontFamily: "Gotham",
                              fontSize: 20),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 90,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Text(
                                      'Exercício 2:',
                                      style: TextStyle(
                                          color: Colors.black.withOpacity(0.6),
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
                            Expanded(
                              flex: 10,
                              child: IconButton(
                                  icon: Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                  iconSize: 20,
                                  onPressed: () async {
                                    ExerciciosPlanilha exercicio;
                                    Map<String, dynamic> data = {};
                                    try {
                                      var snapshot = await FirebaseFirestore
                                          .instance
                                          .collection("users")
                                          .doc(_auth.currentUser.uid)
                                          .collection("planilha")
                                          .doc(widget.idPlanilha)
                                          .collection('exercícios')
                                          .doc(widget.exercicio.id)
                                          .collection('sets')
                                          .get();

                                      data = snapshot.docs[0].data();
                                      data['id'] = snapshot.docs[0].id;
                                      exercicio =
                                          ExerciciosPlanilha.fromMap(data);

                                      showModalBottomSheet(
                                          backgroundColor: Colors.transparent,
                                          isScrollControlled: true,
                                          enableDrag: false,
                                          context: context,
                                          builder: (_) => ExercicioViewModal(
                                              exercicio: exercicio));
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  }),
                            )
                          ],
                        ),
                      ]),
                )
              ],
            ),
    );
  }
}
