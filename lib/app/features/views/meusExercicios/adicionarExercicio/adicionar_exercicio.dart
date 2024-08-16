import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/components/adicionar_video_page.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/adicionarExercicio/components/exercicios_info_page.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

import '/app/core/core.dart';

class AdicionarExercicioModal extends StatefulWidget {
  @override
  _AdicionarExercicioModalState createState() => _AdicionarExercicioModalState();
}

class _AdicionarExercicioModalState extends State<AdicionarExercicioModal> {
  TextEditingController _titleController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String agrupamentoMusc = 'Abdômen';
  int dificuldade = 1;
  bool isHomeExe = false;

  //video
  XFile? _video = null;
  final picker = ImagePicker();

  // This funcion will helps you to pick a Video File
  pickVideo() async {
    XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _video = pickedFile;
    });
    int size = await _video!.length();
    String isGifJpg = _video!.path.substring(_video!.path.length - 4, _video!.path.length);
    log(_video!.path.toString());

    if (size > 5000000) {
      showCustomDialogOpt(
          title: 'Arquivo inválido.',
          isOnlyOption: true,
          VoidCallBack: () {
            Navigator.pop(context);
          },
          message: 'O arquivo excede o tamanho máximo de 5MB.',
          context: context);
    } else if ((isGifJpg != '.jpg' && isGifJpg != '.gif')) {
      showCustomDialogOpt(
          title: 'Arquivo inválido.',
          isOnlyOption: true,
          VoidCallBack: () {
            Navigator.pop(context);
          },
          message: 'O arquivo não é de formato suportado (.GIF, .JPEG ou .JPG)',
          context: context);
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

  Future<void> adicionarNovoExercicio() async {
    final response = await context.read<UserManager>().createNewExe(
        video: _video,
        title: _titleController.text,
        muscleText: agrupamentoMusc,
        level: dificuldade,
        homeExe: isHomeExe,
        onSuccess: () {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.meusExercicios, (route) => false);
        });

    if (response != null) {
      showCustomDialogOpt(
          title: 'Erro!',
          VoidCallBack: () {
            Navigator.pop(context);
          },
          message: response,
          context: context,
          isDeleteMessage: true);
    }
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

  late PageController _pageController;

  InterstitialAd? _interstitialAd;

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              log('Anuncio fechado: ${ad.responseInfo}');
            },
          );

          setState(() {
            _interstitialAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }

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
    _interstitialAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Consumer<UserManager>(builder: (_, userManager, __) {
      return Container(
        height: height * 0.95,
        child: Container(
            height: height * 0.95,
            decoration: new BoxDecoration(
                color: AppColors.grey, borderRadius: new BorderRadius.only(topLeft: const Radius.circular(25.0), topRight: const Radius.circular(25.0))),
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
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          agrupamentoMusc = newValue;
                        });
                      }
                    },
                    changePage: () {
                      _pageController.jumpToPage(1);
                    },
                  ),
                  ExercicioVideoPage(
                    pageController: _pageController,
                    video: _video,
                    pickVideo: pickVideo,
                    enviarExercicio: () async {
                      if (_titleController.text.isNotEmpty && _video != null) {
                        _loadInterstitialAd();
                        if (_interstitialAd != null  && !userManager.user.isPayApp) {
                          await _interstitialAd?.show();
                        }
                        adicionarNovoExercicio();
                      } else {
                        showCustomDialogOpt(
                            title: 'Ocorreu um erro!',
                            isOnlyOption: true,
                            isDeleteMessage: true,
                            VoidCallBack: () {
                              Navigator.pop(context);
                            },
                            message: 'Verifique o título do seu exercício e se você selecionou um vídeo.\nTente novamente mais tarde.',
                            context: context);
                      }
                    },
                  )
                ],
              ),
            )),
      );
    });
  }
}
