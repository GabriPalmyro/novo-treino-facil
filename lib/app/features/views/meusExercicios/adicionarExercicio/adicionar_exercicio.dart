import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/components/adicionar_video_page.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/components/exercicios_info_page.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

import '/app/core/app_colors.dart';
import '/app/core/core.dart';

class AdicionarExercicioModal extends StatefulWidget {
  @override
  _AdicionarExercicioModalState createState() =>
      _AdicionarExercicioModalState();
}

class _AdicionarExercicioModalState extends State<AdicionarExercicioModal> {
  TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String agrupamentoMusc = 'Abdômen';
  int dificuldade = 1;
  bool isHomeExe = false;

  //video
  File _video;
  final picker = ImagePicker();

  // This funcion will helps you to pick a Video File
  pickVideo() async {
    PickedFile pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _video = File(pickedFile.path);
    });
    int size = await _video.length();
    String isGifJpg =
        _video.path.substring(_video.path.length - 4, _video.path.length);
    log(_video.path.toString());

    if (size > 5000000 || (isGifJpg != '.jpg' && isGifJpg != '.gif')) {
      //! error aqui
      setState(() {
        _video = null;
      });
    }
  }

  changeDificuldade(int index) {
    setState(() {
      dificuldade = index + 1;
    });
  }

  changeIsHomeExe(bool isHome) {
    setState(() {
      isHomeExe = isHome;
    });
  }

  List<String> filters = [
    "abdomen",
    "biceps",
    "costas",
    "ombros",
    "peitoral",
    "pernas",
    "triceps",
  ];

  List<String> titles = [
    "Abdômen",
    "Bíceps",
    "Costas",
    "Ombros",
    "Peitoral",
    "Pernas",
    "Tríceps",
  ];

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Padding(
        padding: MediaQuery.of(context).viewInsets * 0.5,
        child: Container(
          height: height * 0.95,
          child: Container(
              height: height * 0.95,
              decoration: new BoxDecoration(
                  color: AppColors.grey,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(25.0),
                      topRight: const Radius.circular(25.0))),
              child: Container(
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _pageController,
                  children: [
                    ExerciciosInfoPage(
                      formKey: _formKey,
                      agrupamentoMusc: agrupamentoMusc,
                      titleController: _titleController,
                      titles: titles,
                      changeDificuldade: changeDificuldade,
                      dificuldade: dificuldade,
                      changeIsHomeExe: changeIsHomeExe,
                      isHomeExe: isHomeExe,
                      onChanged: (String newValue) {
                        setState(() {
                          agrupamentoMusc = newValue;
                        });
                      },
                      changePage: () {
                        _pageController.jumpToPage(1);
                      },
                    ),
                    ExercicioVideoPage(
                      pageController: _pageController,
                      video: _video,
                      pickVideo: pickVideo,
                      enviarExercicio: () {
                        if (_titleController.text.isNotEmpty &&
                            _video == null) {
                          userManager.createNewExe(
                              video: _video,
                              title: _titleController.text,
                              muscleText: agrupamentoMusc,
                              level: dificuldade,
                              homeExe: isHomeExe,
                              onSucess: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });
                        } else {
                          showCustomAlertDialog(
                              title: Text(
                                'Ocorreu um erro!',
                                style: TextStyle(
                                    fontFamily: AppFonts.gothamBold,
                                    color: Colors.red),
                              ),
                              androidActions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontFamily: AppFonts.gotham,
                                            color: Colors.white)))
                              ],
                              iosActions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Ok',
                                        style: TextStyle(
                                            fontFamily: AppFonts.gotham,
                                            color: Colors.white)))
                              ],
                              context: context,
                              content: Text(
                                'Verifique o título do seu exercício e se você selecionou um vídeo.\nTente novamente mais tarde.',
                                style: TextStyle(
                                    height: 1.1,
                                    fontFamily: AppFonts.gotham,
                                    color: Colors.white),
                              ));
                        }
                      },
                    )
                  ],
                ),
              )),
        ),
      );
    });
  }
}
