import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/listaExercicios/components/exercicio_infos_card.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

import '../../exercicios_planilha_screen.dart';

class CardSelectedsExercices extends StatefulWidget {
  final String idPlanilha;
  final int tamPlanilha;
  final String title;
  final String idUser;
  final bool isPersonalAcess;

  const CardSelectedsExercices({
    required this.idPlanilha,
    required this.tamPlanilha,
    required this.title,
    required this.idUser,
    this.isPersonalAcess = false,
  });
  @override
  _CardSelectedsExercicesState createState() => _CardSelectedsExercicesState();
}

class _CardSelectedsExercicesState extends State<CardSelectedsExercices> with SingleTickerProviderStateMixin {
  bool isExpanded = false;
  bool loading = true;

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
      curve: Curves.easeInOutCubic,
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<ExerciciosPlanilhaManager>(builder: (_, exerciciosPlanilhaManager, __) {
      return InkWell(
        onTap: () {},
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.03,
          ),
          decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.4),
              blurRadius: 5,
              offset: Offset(0, 2),
            )
          ]),
          width: width * 0.85,
          child: Column(
            children: [
              SizeTransition(
                axisAlignment: 1.0,
                sizeFactor: animation,
                child: Container(
                  padding: EdgeInsets.only(top: 8.0),
                  child: exerciciosPlanilhaManager.listaExerciciosBiSet.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: AutoSizeText(
                              'Você ainda não adicionou nenhum exercício.',
                              maxLines: 1,
                              maxFontSize: 20,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: AppFonts.gothamBook,
                                color: AppColors.grey,
                              ),
                            ),
                          ),
                        )
                      : Column(
                          children: [
                            Column(
                              children: List.generate(exerciciosPlanilhaManager.listaExerciciosBiSet.length, (index) {
                                return ExercicioInfoCard(
                                  index: index,
                                  exerciciosPlanilha: exerciciosPlanilhaManager.listaExerciciosBiSet[index],
                                );
                              }),
                            ),
                            if (exerciciosPlanilhaManager.listaExerciciosBiSet.length == 2) ...[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: CustomButton(
                                  text: 'Concluir',
                                  color: Colors.green,
                                  textColor: AppColors.white,
                                  onTap: () async {
                                    final response = await exerciciosPlanilhaManager.addNewExerciseBiSet(
                                        planilhaId: widget.idPlanilha, idUser: widget.idUser, pos: widget.tamPlanilha + 1);
                                    if (response != null) {
                                      mostrarSnackBar(message: response, color: AppColors.red, context: context);
                                    } else {
                                      Navigator.pushReplacementNamed(context, AppRoutes.exerciciosPlanilha,
                                          arguments: ExerciciosPlanilhaArguments(
                                              idPlanilha: widget.idPlanilha,
                                              idUser: widget.idUser,
                                              isFriendAcess: false,
                                              isPersonalAcess: widget.isPersonalAcess,
                                              title: widget.title));
                                    }
                                  },
                                ),
                              )
                            ]
                          ],
                        ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                    _runExpandCheck();
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  width: width * 0.85,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 2,
                        child: AutoSizeText(
                          exerciciosPlanilhaManager.listaExerciciosBiSet.length == 2 ? 'Concluir Exercícios' : 'Exercícios Selecionados'.toUpperCase(),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: AppFonts.gothamBold,
                            color: AppColors.grey,
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                              _runExpandCheck();
                            });
                          },
                          icon: Icon(
                            exerciciosPlanilhaManager.listaExerciciosBiSet.length == 2
                                ? Icons.play_arrow_rounded
                                : isExpanded
                                    ? Icons.arrow_downward_rounded
                                    : Icons.arrow_upward_rounded,
                            color: exerciciosPlanilhaManager.listaExerciciosBiSet.length == 2
                                ? Colors.green
                                : isExpanded
                                    ? AppColors.grey300
                                    : AppColors.grey,
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
