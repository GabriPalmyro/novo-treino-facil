import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

class UniSetCard extends StatelessWidget {
  final int index;
  final bool isChanging;
  final ExerciciosPlanilha exercicio;
  final Function onTap;
  final bool isFriendAcess;

  const UniSetCard(
      {this.index,
      this.isChanging,
      this.exercicio,
      this.onTap,
      this.isFriendAcess = false});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey[900],
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        height: 150,
        width: width * 0.8,
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(12.0)),
          color: AppColors.mainColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              spreadRadius: 4,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: isChanging
            ? Center(
                child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(Colors.grey[850]),
                ),
              )
            : Stack(
                children: [
                  Positioned(
                      right: -5,
                      child: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.black.withOpacity(0.8),
                            // Icons.delete,
                            // color: Colors.red.withOpacity(0.6),
                          ),
                          iconSize: 20,
                          onPressed: onTap)),
                  Positioned(
                      left: 15,
                      top: 15,
                      child: Text(
                        (index + 1).toString() + 'º',
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "GothamBold",
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: AutoSizeText(
                            exercicio.title.toUpperCase(),
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 20, fontFamily: AppFonts.gothamBold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text("Séries",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gotham)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(exercicio.series,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFonts.gothamBook)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Repetições",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gotham)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(exercicio.reps,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFonts.gothamBook)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Carga",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: AppFonts.gotham)),
                                SizedBox(
                                  height: 3,
                                ),
                                Text("${exercicio.carga}kg",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontFamily: AppFonts.gothamBook)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
