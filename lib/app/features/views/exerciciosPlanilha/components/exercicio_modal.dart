import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';

class ExercicioViewModal extends StatefulWidget {
  final ExerciciosPlanilha exercicio;

  ExercicioViewModal({this.exercicio});

  @override
  _ExercicioViewModalState createState() => _ExercicioViewModalState();
}

class _ExercicioViewModalState extends State<ExercicioViewModal> {
  TextEditingController _seriesController = TextEditingController();
  TextEditingController _repsController = TextEditingController();
  TextEditingController _cargaController = TextEditingController();
  TextEditingController _obsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _seriesController.text = widget.exercicio.series;
    _repsController.text = widget.exercicio.reps;
    _cargaController.text = widget.exercicio.carga.toString();
    _obsController.text = widget.exercicio.comments;
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
      padding: MediaQuery.of(context).viewInsets * 0.5,
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
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
                          imageProvider: NetworkImage(widget.exercicio.video),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text('Séries',
                                      style: TextStyle(
                                          fontFamily: AppFonts.gothamBook,
                                          color: AppColors.white,
                                          fontSize: 18)),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.lightGrey,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: TextFormField(
                                        enabled: _isEnable,
                                        controller: _seriesController,
                                        keyboardType: TextInputType.text,
                                        cursorColor: AppColors.mainColor,
                                        showCursor: true,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Repetições',
                                    style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                        fontSize: 18)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      enabled: _isEnable,
                                      controller: _repsController,
                                      keyboardType: TextInputType.text,
                                      cursorColor: AppColors.mainColor,
                                      showCursor: true,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Container(
                                child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Carga',
                                    style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                        fontSize: 18)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGrey,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: TextFormField(
                                      enabled: _isEnable,
                                      controller: _cargaController,
                                      keyboardType: TextInputType.text,
                                      cursorColor: AppColors.mainColor,
                                      showCursor: true,
                                      textAlign: TextAlign.center,
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
                        Text('Observações',
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              enabled: _isEnable,
                              controller: _obsController,
                              keyboardType: TextInputType.text,
                              cursorColor: AppColors.mainColor,
                              showCursor: true,
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
                    padding:
                        const EdgeInsets.only(top: 24.0, left: 8, right: 8),
                    child: Container(
                      width: width * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomButton(
                              text:
                                  _isEnable ? 'Confirmar' : 'Editar Exercício',
                              color: AppColors.mainColor,
                              textColor: AppColors.black,
                              onTap: () {
                                if (!_isEnable) {
                                  setState(() {
                                    _isEnable = true;
                                  });
                                } else {
                                  // confirmar edição
                                }
                              }),
                          if (_isEnable) ...[
                            CustomButton(
                              text: 'Cancelar',
                              color: _isEnable
                                  ? AppColors.black
                                  : AppColors.mainColor,
                              textColor:
                                  _isEnable ? AppColors.white : AppColors.black,
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
                ],
              ),
            )),
      ),
    );
  }
}
