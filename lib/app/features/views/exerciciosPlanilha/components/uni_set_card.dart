import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

class UniSetCard extends StatefulWidget {
  final int index;
  final bool isChanging;
  final ExerciciosPlanilha exercicio;
  final String idUser;
  final VoidCallback onTap;
  final bool isFriendAcess;
  final bool isEditing;
  final VoidCallback? onDelete;

  const UniSetCard(
      {required this.index,
      required this.isChanging,
      required this.idUser,
      required this.exercicio,
      required this.onTap,
      this.isFriendAcess = false,
      required this.isEditing,
      this.onDelete});

  @override
  _UniSetCardState createState() => _UniSetCardState();
}

class _UniSetCardState extends State<UniSetCard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: !widget.isEditing ? widget.onTap : () {},
      splashColor: Colors.grey[900],
      borderRadius: const BorderRadius.all(const Radius.circular(10.0)),
      child: Row(
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
              ),
            ),
          ],
          Expanded(
            flex: widget.isEditing ? 90 : 100,
            child: Container(
              constraints: BoxConstraints(minHeight: 120),
              margin: EdgeInsets.fromLTRB(widget.isEditing ? 8.0 : 20.0, 12.0, 20.0, 12.0),
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
              child: widget.isChanging
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.grey[850]!),
                      ),
                    )
                  : Stack(
                      children: [
                        if (!widget.isEditing) ...[
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
                                  onPressed: widget.onTap)),
                        ] else ...[
                          Positioned(
                            right: 5,
                            top: -2,
                            child: IconButton(
                                icon: Icon(
                                  Icons.delete_forever_rounded,
                                  color: Colors.red.withOpacity(0.9),
                                ),
                                iconSize: 20,
                                onPressed: () async {
                                  await showCustomDialogOpt(
                                    context: context,
                                    title: 'Excluir exercício?',
                                    isDeleteMessage: true,
                                    message: 'Essa ação não poderá ser desfeita após concluida.',
                                    VoidCallBack: widget.onDelete!,
                                  );
                                }),
                          )
                        ],
                        Positioned(
                            left: 15,
                            top: 15,
                            child: Text(
                              (widget.index + 1).toString() + 'º',
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
          ),
        ],
      ),
    );
  }
}
