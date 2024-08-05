import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart' as Auth;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/add_exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';

class CardExercicio extends StatefulWidget {
  final int index;
  final Exercise exercise;
  final String idPlanilha;
  final String titlePlanilha;
  final int tamPlan;
  final String idUser;
  final bool isBiSet;
  final bool showAddButton;

  const CardExercicio(
      {required this.index,
      required this.exercise,
      required this.idUser,
      required this.titlePlanilha,
      required this.idPlanilha,
      this.isBiSet = false,
      required this.tamPlan,
      this.showAddButton = true});

  @override
  _CardExercicioState createState() => _CardExercicioState();
}

class _CardExercicioState extends State<CardExercicio> with SingleTickerProviderStateMixin {
  Auth.FirebaseAuth _auth = Auth.FirebaseAuth.instance;

  bool onHover = false;
  bool isExpanded = false;

  late AnimationController expandController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.fastOutSlowIn,
    );
  }

  void _runExpandCheck() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    super.dispose();
  }

  String _calculateProgress(ImageChunkEvent loadingProgress) {
    return ((loadingProgress.cumulativeBytesLoaded * 100) / loadingProgress.expectedTotalBytes!).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          _runExpandCheck();
        });
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.symmetric(vertical: 14),
        width: width * 0.9,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15),
              child: AutoSizeText(
                widget.exercise.title!.toUpperCase(),
                maxLines: 2,
                style: TextStyle(fontSize: 22, height: 1.1, fontFamily: AppFonts.gotham),
                textAlign: TextAlign.center,
              ),
            ),
            Divider(
              thickness: 1,
            ),
            AutoSizeText(
              widget.exercise.muscleId!.toUpperCase(),
              maxLines: 2,
              style: TextStyle(fontSize: 14, height: 1.1, fontFamily: AppFonts.gothamBook),
              textAlign: TextAlign.center,
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: animation,
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
                child: Container(
                    height: 250,
                    color: AppColors.mainColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 180,
                          width: width,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 180,
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
                                      style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: "Gotham"),
                                    ),
                                    SizedBox(
                                      height: 25,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 40),
                                      child: Text(
                                        loadingProgress == null ? "0.00%" : "${_calculateProgress(loadingProgress)}%",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.amber, fontSize: 30, fontFamily: AppFonts.gothamBold),
                                      ),
                                    ),
                                  ],
                                )),
                                imageProvider: NetworkImage(widget.exercise.video!),
                                initialScale: PhotoViewComputedScale.contained,
                                minScale: PhotoViewComputedScale.covered * 0.5,
                              ),
                            ),
                          ),
                        ),
                        if (widget.showAddButton) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: CustomButton(
                              color: AppColors.grey,
                              onTap: () {
                                if (widget.isBiSet) {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    context: context,
                                    builder: (_) => ExercicioAddModal(
                                      idUser: widget.idUser,
                                      isPersonalManag: widget.idUser != _auth.currentUser!.uid ? true : false,
                                      isBiSet: true,
                                      isSecondExercise: true,
                                      titlePlanilha: widget.titlePlanilha,
                                      idPlanilha: widget.idPlanilha,
                                      tamPlan: widget.tamPlan,
                                      exercicio: widget.exercise,
                                    ),
                                  );
                                } else {
                                  showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    enableDrag: false,
                                    context: context,
                                    builder: (_) => ExercicioAddModal(
                                      idUser: widget.idUser,
                                      isPersonalManag: widget.idUser != _auth.currentUser!.uid ? true : false,
                                      titlePlanilha: widget.titlePlanilha,
                                      idPlanilha: widget.idPlanilha,
                                      tamPlan: widget.tamPlan,
                                      exercicio: widget.exercise,
                                    ),
                                  );
                                }
                              },
                              text: 'Selecionar exercício',
                              textColor: AppColors.white,
                              width: width * 0.5,
                            ),
                          )
                        ]
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
