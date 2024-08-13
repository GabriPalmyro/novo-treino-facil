import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';

class UniSetCardWidget extends StatefulWidget {
  final int index;
  final ExerciciosPlanilha exercicio;
  final String idUser;
  final VoidCallback onTap;

  const UniSetCardWidget({required this.index, required this.idUser, required this.exercicio, required this.onTap});

  @override
  _UniSetCardWidgetState createState() => _UniSetCardWidgetState();
}

class _UniSetCardWidgetState extends State<UniSetCardWidget> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: widget.onTap,
      splashColor: Colors.grey[900],
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      child: Container(
        constraints: BoxConstraints(minHeight: 120),
        margin: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
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
        child: Stack(
          children: [
            Positioned(
              left: 15,
              top: 15,
              child: Text(
                (widget.index + 1).toString() + 'º',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.gothamBold,
                ),
              ),
            ),
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
                      widget.exercicio.title!.toUpperCase(),
                      maxLines: 3,
                      style: TextStyle(fontSize: 20, fontFamily: AppFonts.gothamBold),
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
                          Text("Séries", style: TextStyle(fontSize: 20, fontFamily: AppFonts.gotham)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(widget.exercicio.series!, style: TextStyle(fontSize: 18, fontFamily: AppFonts.gothamBook)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Repetições", style: TextStyle(fontSize: 20, fontFamily: AppFonts.gotham)),
                          SizedBox(
                            height: 3,
                          ),
                          Text(widget.exercicio.reps!, style: TextStyle(fontSize: 18, fontFamily: AppFonts.gothamBook)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Carga", style: TextStyle(fontSize: 20, fontFamily: AppFonts.gotham)),
                          SizedBox(
                            height: 3,
                          ),
                          Text("${widget.exercicio.carga}kg", style: TextStyle(fontSize: 18, fontFamily: AppFonts.gothamBook)),
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
