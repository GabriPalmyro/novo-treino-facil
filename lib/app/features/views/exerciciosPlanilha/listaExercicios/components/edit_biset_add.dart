import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';

class EditBiSetAdd extends StatefulWidget {
  final int index;
  final ExerciciosPlanilha exerciciosPlanilha;

  const EditBiSetAdd({
    Key key,
    @required this.exerciciosPlanilha,
    @required this.index,
  }) : super(key: key);

  @override
  _EditBiSetAddState createState() => _EditBiSetAddState();
}

class _EditBiSetAddState extends State<EditBiSetAdd> {
  TextEditingController _seriesController = TextEditingController();
  TextEditingController _repsController = TextEditingController();
  TextEditingController _cargaController = TextEditingController();
  TextEditingController _obsController = TextEditingController();

  FocusNode _seriesFocus = FocusNode();
  FocusNode _repsFocus = FocusNode();
  FocusNode _cargaFocus = FocusNode();
  FocusNode _obsFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _seriesController.text = widget.exerciciosPlanilha.series;
    _repsController.text = widget.exerciciosPlanilha.reps;
    _cargaController.text = widget.exerciciosPlanilha.carga.toString();
    _obsController.text = widget.exerciciosPlanilha.comments;
  }

  void resetFields() {
    setState(() {
      _seriesController.text = '';
      _repsController.text = '';
      _cargaController.text = '';
      _obsController.text = '';
    });
  }

  String _calculateProgress(ImageChunkEvent loadingProgress) {
    return ((loadingProgress.cumulativeBytesLoaded * 100) /
            loadingProgress.expectedTotalBytes)
        .toStringAsFixed(2);
  }

  bool _isEnable = true;
  String errorMessage = '';
  String responseMessage = '';

  void mostrarSnackBar(String message, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Consumer<ExerciciosPlanilhaManager>(
        builder: (_, exerciseManager, __) {
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
                                exerciseManager
                                    .listaExerciciosBiSet[widget.index].title
                                    .toUpperCase(),
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
                                            fontFamily: "GothamBold"),
                                      ),
                                    ),
                                  ],
                                )),
                                imageProvider: NetworkImage(exerciseManager
                                    .listaExerciciosBiSet[widget.index].video),
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: FormField<String>(
                                        initialValue: '',
                                        validator: (text) {
                                          if (_seriesController.text.isEmpty) {
                                            setState(() {
                                              errorMessage =
                                                  'Séries não pode ser vazia';
                                            });
                                            return 'Séries não pode ser vazia';
                                          }
                                          return null;
                                        },
                                        builder: (state) {
                                          return Container(
                                              child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text('Séries',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.gothamBook,
                                                      color: state.hasError
                                                          ? Colors.red
                                                          : AppColors.white,
                                                      fontSize: 18)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 8.0),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: AppColors.lightGrey,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10.0),
                                                  child: TextFormField(
                                                    enabled: _isEnable,
                                                    controller:
                                                        _seriesController,
                                                    keyboardType:
                                                        TextInputType.text,
                                                    cursorColor:
                                                        AppColors.mainColor,
                                                    showCursor: true,
                                                    textAlign: TextAlign.center,
                                                    focusNode: _seriesFocus,
                                                    onFieldSubmitted: (text) {
                                                      _repsFocus.requestFocus();
                                                    },
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            AppFonts.gothamBook,
                                                        color: state.hasError
                                                            ? Colors.red
                                                            : AppColors.white),
                                                    decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ));
                                        }),
                                  ),
                                ),
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: FormField<String>(
                                      initialValue: '',
                                      validator: (text) {
                                        if (_repsController.text.isEmpty) {
                                          setState(() {
                                            errorMessage =
                                                'Repetições não pode ser vazia';
                                          });
                                          return 'Repetições não pode ser vazia';
                                        }
                                        return null;
                                      },
                                      builder: (state) {
                                        return Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AutoSizeText('Repetições',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.gothamBook,
                                                    color: state.hasError
                                                        ? Colors.red
                                                        : AppColors.white,
                                                    fontSize: 18)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: TextFormField(
                                                  enabled: _isEnable,
                                                  controller: _repsController,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  cursorColor:
                                                      AppColors.mainColor,
                                                  showCursor: true,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  focusNode: _repsFocus,
                                                  onFieldSubmitted: (text) {
                                                    _repsFocus.unfocus();
                                                    _cargaFocus.requestFocus();
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.gothamBook,
                                                      color: state.hasError
                                                          ? Colors.red
                                                          : AppColors.white),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                      }),
                                )),
                                Expanded(
                                    child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: FormField<String>(
                                      initialValue: '',
                                      validator: (text) {
                                        RegExp regExp =
                                            new RegExp(r'(^[0-9]*$)');
                                        if (_cargaController.text.isEmpty) {
                                          setState(() {
                                            errorMessage =
                                                'Carga não pode ser vazia';
                                          });
                                          return 'Carga não pode ser vazia';
                                        } else if (!regExp
                                            .hasMatch(_cargaController.text)) {
                                          setState(() {
                                            errorMessage =
                                                'Carga não pode contar letras ou símbolos';
                                          });
                                          return 'Carga não pode contar letras ou símbolos';
                                        }
                                        return null;
                                      },
                                      builder: (state) {
                                        return Container(
                                            child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            AutoSizeText('Carga',
                                                maxLines: 1,
                                                style: TextStyle(
                                                    fontFamily:
                                                        AppFonts.gothamBook,
                                                    color: state.hasError
                                                        ? Colors.red
                                                        : AppColors.white,
                                                    fontSize: 18)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: AppColors.lightGrey,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0),
                                                child: TextFormField(
                                                  enabled: _isEnable,
                                                  controller: _cargaController,
                                                  keyboardType:
                                                      TextInputType.number,
                                                  cursorColor:
                                                      AppColors.mainColor,
                                                  showCursor: true,
                                                  maxLines: null,
                                                  textAlign: TextAlign.center,
                                                  focusNode: _cargaFocus,
                                                  onFieldSubmitted: (text) {
                                                    _cargaFocus.unfocus();
                                                    _obsFocus.requestFocus();
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppFonts.gothamBook,
                                                      color: state.hasError
                                                          ? Colors.red
                                                          : AppColors.white),
                                                  decoration: InputDecoration(
                                                    suffixText: 'kg',
                                                    suffixStyle: TextStyle(
                                                        fontFamily:
                                                            AppFonts.gothamBook,
                                                        color: AppColors.white),
                                                    border: InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ));
                                      }),
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
                                    focusNode: _obsFocus,
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
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 12.0, left: 8, right: 8, bottom: 12.0),
                          child: Container(
                            width: width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CustomButton(
                                    text: 'Confirmar',
                                    color: AppColors.mainColor,
                                    textColor: AppColors.black,
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        ExerciciosPlanilha exercicio =
                                            ExerciciosPlanilha(
                                                title: exerciseManager
                                                    .listaExerciciosBiSet[
                                                        widget.index]
                                                    .title,
                                                series: _seriesController.text,
                                                reps: _repsController.text,
                                                carga: int.tryParse(
                                                    _cargaController.text),
                                                setType: 'uniset',
                                                comments: _obsController.text,
                                                muscleId: exerciseManager
                                                    .listaExerciciosBiSet[
                                                        widget.index]
                                                    .muscleId,
                                                video: exerciseManager
                                                    .listaExerciciosBiSet[
                                                        widget.index]
                                                    .video,
                                                position: 0);

                                        exerciseManager.substituirExercicio(
                                            index: widget.index,
                                            exerciciosPlanilha: exercicio);
                                        Navigator.pop(context);
                                      }
                                    }),
                                CustomButton(
                                  text: 'Limpar Campos',
                                  color: AppColors.black,
                                  textColor: AppColors.white,
                                  onTap: () async {
                                    resetFields();
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        if (errorMessage.isNotEmpty) ...[
                          Padding(
                            padding: EdgeInsets.only(
                              top: 12.0,
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: AppColors.lightGrey,
                                  borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.red,
                                  ),
                                  Text(
                                    errorMessage,
                                    style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: Colors.red),
                                  ),
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
    });
  }
}
