import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/listaExercicios/lista_exercicios_modal.dart';
import '/app/core/app_colors.dart';
import '/app/core/core.dart';
import 'package:provider/provider.dart';

class SelectSetModal extends StatelessWidget {
  final String idPlanilha;
  final String titlePlanilha;
  final int tamPlan;
  final String idUser;

  SelectSetModal(
      {@required this.idPlanilha,
      @required this.titlePlanilha,
      @required this.tamPlan,
      @required this.idUser});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: MediaQuery.of(context).viewInsets * 0.5,
      child: Container(
        height: height * 0.3,
        child: Container(
            height: height * 0.3,
            decoration: new BoxDecoration(
                color: AppColors.grey,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: Padding(
              padding: EdgeInsets.only(top: 18.0, left: 15, right: 8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      await context
                          .read<ExercisesManager>()
                          .loadMyListExercises(
                              idUser: context.read<UserManager>().user.id);
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => ListaExerciciosModal(
                                titlePlanilha: titlePlanilha,
                                idPlanilha: idPlanilha,
                                tamPlan: tamPlan,
                                idUser: idUser,
                              ));
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 20,
                            child: Icon(
                              Icons.looks_one,
                              color: AppColors.mainColor,
                              size: 42,
                            ),
                          ),
                          Expanded(
                            flex: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: AutoSizeText(
                                'Adicionar Novo Exercício',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: AppFonts.gothamBold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    color: AppColors.black.withOpacity(0.2),
                    thickness: 2,
                  ),
                  InkWell(
                    onTap: () async {
                      await context
                          .read<ExercisesManager>()
                          .loadMyListExercises(
                              idUser: context.read<UserManager>().user.id);
                    },
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 20,
                            child: Icon(
                              Icons.looks_two,
                              color: AppColors.mainColor,
                              size: 42,
                            ),
                          ),
                          Expanded(
                            flex: 80,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: AutoSizeText(
                                'Adicionar Novo Bi-Set',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: AppFonts.gothamBold,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
