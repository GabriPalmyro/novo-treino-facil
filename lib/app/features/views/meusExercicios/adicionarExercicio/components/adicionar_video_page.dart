import 'dart:io';

import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';

class ExercicioVideoPage extends StatefulWidget {
  final File video;
  final Function pickVideo;
  final Function enviarExercicio;
  final PageController pageController;

  const ExercicioVideoPage(
      {@required this.video,
      @required this.pickVideo,
      @required this.enviarExercicio,
      @required this.pageController});

  @override
  _ExercicioVideoPageState createState() => _ExercicioVideoPageState();
}

class _ExercicioVideoPageState extends State<ExercicioVideoPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 18, left: 18),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                  onPressed: () {
                    widget.pageController.jumpToPage(0);
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.mainColor,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Text(
                'Adicionar Vídeo: ',
                style: TextStyle(
                    fontFamily: AppFonts.gothamBold,
                    color: AppColors.white,
                    fontSize: 24.0),
              ),
            ),
            Divider(
              color: AppColors.white,
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: CustomButton(
                  text: 'Selecionar Mídia',
                  color: AppColors.mainColor,
                  textColor: AppColors.black,
                  verticalPad: 16,
                  onTap: () {
                    widget.pickVideo();
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Formatos disponíveis: ',
                    style: TextStyle(
                        fontFamily: AppFonts.gothamThin,
                        color: AppColors.white,
                        fontSize: 18.0),
                  ),
                  Text(
                    'GIF e JPEG',
                    style: TextStyle(
                        fontFamily: AppFonts.gothamBook,
                        color: AppColors.white,
                        fontSize: 18.0),
                  ),
                ],
              ),
            ),
            widget.video != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Container(
                      height: height * 0.4,
                      width: width,
                      child: Image.file(
                        widget.video,
                        fit: BoxFit.contain,
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Container(
                        height: height * 0.4,
                        width: width,
                        child: Center(
                          child: Text(
                            'Nenhuma mídia selecionada',
                            style: TextStyle(
                                fontFamily: AppFonts.gothamBook,
                                color: AppColors.white,
                                fontSize: 14.0),
                          ),
                        )),
                  ),
            Padding(
              padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomButton(
                  text: 'Enviar Exercício',
                  color: AppColors.mainColor,
                  textColor: AppColors.black,
                  verticalPad: 16,
                  onTap: widget.enviarExercicio,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
