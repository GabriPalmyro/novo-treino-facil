import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';

class ExercicioInfoModal extends StatefulWidget {
  final Exercise exercicio;

  ExercicioInfoModal({required this.exercicio});

  @override
  _ExercicioInfoModalState createState() => _ExercicioInfoModalState();
}

class _ExercicioInfoModalState extends State<ExercicioInfoModal> {
  String _calculateProgress(ImageChunkEvent loadingProgress) {
    return ((loadingProgress.cumulativeBytesLoaded * 100) /
            loadingProgress.expectedTotalBytes!)
        .toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      height: height * 0.7,
      child: Container(
          height: height * 0.6,
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
                        widget.exercicio.title!.toUpperCase(),
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
                  height: height * 0.45,
                  width: width * 8,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Container(
                      height: height * 0.45,
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
                        imageProvider: NetworkImage(widget.exercicio.video!),
                        initialScale: PhotoViewComputedScale.contained,
                        minScale: PhotoViewComputedScale.covered * 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
