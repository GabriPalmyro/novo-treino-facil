import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';

import '../exercicios_planilha_screen.dart';

class ExercicioViewModal extends StatefulWidget {
  final ExerciciosPlanilha exercicio;
  final bool isFriendAcess;
  final idExercicio;
  final String idPlanilha;
  final String titlePlanilha;
  final int tamPlan;
  final String idUser;
  final bool isBiSet;
  final bool isSecondExercise;
  final bool isPersonalManag;

  ExercicioViewModal(
      {@required this.exercicio,
      this.isFriendAcess = false,
      @required this.idExercicio,
      @required this.idPlanilha,
      @required this.titlePlanilha,
      @required this.tamPlan,
      @required this.idUser,
      this.isBiSet = false,
      this.isSecondExercise = false,
      @required this.isPersonalManag});

  @override
  _ExercicioViewModalState createState() => _ExercicioViewModalState();
}

class _ExercicioViewModalState extends State<ExercicioViewModal> {
  TextEditingController _seriesController = TextEditingController();
  TextEditingController _repsController = TextEditingController();
  TextEditingController _cargaController = TextEditingController();
  TextEditingController _obsController = TextEditingController();

  FocusNode _repsFocus = FocusNode();
  FocusNode _cargaFocus = FocusNode();
  FocusNode _obsFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _seriesController.text = widget.exercicio.series;
    _repsController.text = widget.exercicio.reps;
    _cargaController.text = widget.exercicio.carga.toString();
    _obsController.text = widget.exercicio.comments;
    debugPrint(widget.exercicio.id + ' ' + widget.idExercicio);
  }

  void resetFields() {
    setState(() {
      _seriesController.text = widget.exercicio.series;
      _repsController.text = widget.exercicio.reps;
      _cargaController.text = widget.exercicio.carga.toString();
      _obsController.text = widget.exercicio.comments;
    });
  }

  String _calculateProgress(ImageChunkEvent loadingProgress) {
    return ((loadingProgress.cumulativeBytesLoaded * 100) /
            loadingProgress.expectedTotalBytes)
        .toStringAsFixed(2);
  }

  bool _isEnable = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: MediaQuery.of(context).viewInsets * 0.8,
      child: Container(
        height: height * 0.95,
        child: Container(
            height: height * 0.75,
            decoration: new BoxDecoration(
                color: AppColors.grey,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: Padding(
              padding: EdgeInsets.only(top: 18.0, right: 18, left: 18),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 80,
                            child: AutoSizeText(
                              widget.exercicio.title.toUpperCase(),
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: AppFonts.gothamBold,
                                  color: AppColors.white,
                                  fontSize: 22.0),
                            ),
                          ),
                          Expanded(
                            flex: 20,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close,
                                color: AppColors.white,
                                size: 28,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: AppColors.white,
                        thickness: 1,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 5.0),
                        child: Container(
                          child: Center(
                            child: AutoSizeText(
                              'Use o dedo como uma pinça para ampliar e reduzir a imagem',
                              maxLines: 1,
                              minFontSize: 8,
                              maxFontSize: 10,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.gothamBook,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: height * 0.35,
                        width: width * 8,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            height: height * 0.35,
                            width: width * 8,
                            color: AppColors.grey300.withOpacity(0.7),
                            child: PhotoView(
                              //controller: photoViewcontroller,
                              backgroundDecoration: const BoxDecoration(
                                color: Colors.transparent,
                              ),
                              loadingBuilder: (_, loadingProgress) => Center(
                                  child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Carregando exercício: ",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontFamily: "Gotham"),
                                  ),
                                  SizedBox(
                                    height: 25,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 40),
                                    child: Text(
                                      loadingProgress == null
                                          ? "0.00%"
                                          : "${_calculateProgress(loadingProgress)}%",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.amber,
                                          fontSize: 30,
                                          fontFamily: AppFonts.gothamBold),
                                    ),
                                  ),
                                ],
                              )),
                              imageProvider:
                                  NetworkImage(widget.exercicio.video),
                              initialScale: PhotoViewComputedScale.contained,
                              minScale: PhotoViewComputedScale.covered * 0.5,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Container(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Séries',
                                          style: TextStyle(
                                              fontFamily: AppFonts.gothamBook,
                                              color: AppColors.white,
                                              fontSize: 18)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: AppColors.lightGrey,
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: TextFormField(
                                            enabled: _isEnable,
                                            controller: _seriesController,
                                            keyboardType: TextInputType.text,
                                            cursorColor: AppColors.mainColor,
                                            showCursor: true,
                                            maxLines: null,
                                            onFieldSubmitted: (text) {
                                              _repsFocus.requestFocus();
                                            },
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontFamily: AppFonts.gothamBook,
                                                color: AppColors.white),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AutoSizeText('Repetições',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: AppFonts.gothamBook,
                                            color: AppColors.white,
                                            fontSize: 18)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          enabled: _isEnable,
                                          controller: _repsController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: AppColors.mainColor,
                                          showCursor: true,
                                          maxLines: null,
                                          focusNode: _repsFocus,
                                          onFieldSubmitted: (text) {
                                            _repsFocus.unfocus();
                                            _cargaFocus.requestFocus();
                                          },
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontFamily: AppFonts.gothamBook,
                                              color: AppColors.white),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              )),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Container(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    AutoSizeText('Carga',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontFamily: AppFonts.gothamBook,
                                            color: AppColors.white,
                                            fontSize: 18)),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.lightGrey,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0),
                                        child: TextFormField(
                                          enabled: _isEnable,
                                          controller: _cargaController,
                                          keyboardType: TextInputType.text,
                                          cursorColor: AppColors.mainColor,
                                          showCursor: true,
                                          maxLines: null,
                                          textAlign: TextAlign.center,
                                          onFieldSubmitted: (text) {
                                            _cargaFocus.unfocus();
                                            _obsFocus.requestFocus();
                                          },
                                          style: TextStyle(
                                              fontFamily: AppFonts.gothamBook,
                                              color: AppColors.white),
                                          decoration: InputDecoration(
                                            suffixText: 'kg',
                                            suffixStyle: TextStyle(
                                                fontFamily: AppFonts.gothamBook,
                                                color: AppColors.white),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )),
                              ))
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 24, 8, 0),
                        child: Container(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText('Observações',
                                maxLines: 1,
                                style: TextStyle(
                                    fontFamily: AppFonts.gothamBook,
                                    color: AppColors.white,
                                    fontSize: 18)),
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: TextFormField(
                                  enabled: _isEnable,
                                  controller: _obsController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: AppColors.mainColor,
                                  showCursor: true,
                                  maxLines: null,
                                  style: TextStyle(
                                      fontFamily: AppFonts.gothamBook,
                                      color: AppColors.white),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            )
                          ],
                        )),
                      ),
                      if (!widget.isFriendAcess) ...[
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 8, right: 8, bottom: 12.0),
                          child: Container(
                            width: width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                    text: _isEnable
                                        ? 'Confirmar'
                                        : 'Editar Exercício',
                                    color: AppColors.mainColor,
                                    textColor: AppColors.black,
                                    onTap: () async {
                                      if (!_isEnable) {
                                        setState(() {
                                          _isEnable = true;
                                        });
                                      } else {
                                        // confirmar edição
                                        if (_formKey.currentState.validate()) {
                                          if (widget.isBiSet) {
                                            ExerciciosPlanilha exercicio =
                                                ExerciciosPlanilha(
                                                    title:
                                                        widget.exercicio.title,
                                                    series:
                                                        _seriesController.text,
                                                    reps: _repsController.text,
                                                    carga: int.tryParse(
                                                        _cargaController.text),
                                                    setType: 'uniset',
                                                    comments:
                                                        _obsController.text,
                                                    muscleId: widget
                                                        .exercicio.muscleId,
                                                    video:
                                                        widget.exercicio.video,
                                                    position:
                                                        widget.tamPlan + 1);
                                            //TODO EDITAR EXERCICIO BISET
                                            Navigator.pop(context);
                                          } else {
                                            ExerciciosPlanilha exercicio =
                                                ExerciciosPlanilha(
                                              series: _seriesController.text,
                                              reps: _repsController.text,
                                              carga: int.tryParse(
                                                  _cargaController.text),
                                              comments: _obsController.text,
                                            );

                                            String response = await context
                                                .read<
                                                    ExerciciosPlanilhaManager>()
                                                .editExerciseUniSet(
                                                    planilhaId:
                                                        widget.idPlanilha,
                                                    idUser: widget.idUser,
                                                    idExercicio:
                                                        widget.idExercicio,
                                                    exercicio: exercicio);
                                            if (response == null) {
                                              Navigator.pushReplacementNamed(
                                                  context,
                                                  AppRoutes.exerciciosPlanilha,
                                                  arguments:
                                                      ExerciciosPlanilhaArguments(
                                                    title: widget.titlePlanilha,
                                                    idPlanilha:
                                                        widget.idPlanilha,
                                                    idUser: widget.idUser,
                                                    isFriendAcess:
                                                        widget.isFriendAcess,
                                                    isPersonalAcess:
                                                        widget.isPersonalManag,
                                                  ));
                                            } else {
                                              debugPrint('Erro $response');
                                            }
                                          }
                                        }
                                      }
                                    }),
                                if (_isEnable) ...[
                                  CustomButton(
                                    text: 'Cancelar',
                                    color: _isEnable
                                        ? AppColors.black
                                        : AppColors.mainColor,
                                    textColor: _isEnable
                                        ? AppColors.white
                                        : AppColors.black,
                                    onTap: () async {
                                      setState(() {
                                        _isEnable = false;
                                      });
                                      resetFields();
                                    },
                                  )
                                ]
                              ],
                            ),
                          ),
                        )
                      ]
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
