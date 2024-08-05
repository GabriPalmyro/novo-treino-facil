import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

class CardMeuExercicio extends StatelessWidget {
  final int index;
  final Exercise exercise;
  final VoidCallback onTap;
  final VoidCallback deleteExercise;
  const CardMeuExercicio(
      {required this.index,
      required this.exercise,
      required this.onTap,
      required this.deleteExercise});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.all(10),
          width: width * 0.9,
          height: 130,
          decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(5.0)),
            color: AppColors.mainColor,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withOpacity(0.4),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(2, 5), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 5,
                bottom: 0,
                child: IconButton(
                    icon: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.red.withOpacity(0.9),
                    ),
                    iconSize: 24,
                    onPressed: () async {
                      await showCustomDialogOpt(
                          context: context,
                          title: 'Excluir esses exercício?',
                          isDeleteMessage: true,
                          message:
                              'Essa ação não poderá ser desfeita após concluida.',
                          VoidCallBack: deleteExercise);
                    }),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 15, right: 15),
                    child: AutoSizeText(
                      exercise.title!.toUpperCase(),
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 25,
                          height: 1.1,
                          fontFamily: AppFonts.gotham),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  AutoSizeText(
                    exercise.muscleId!.toUpperCase(),
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 15,
                        height: 1.1,
                        fontFamily: AppFonts.gothamBook),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
