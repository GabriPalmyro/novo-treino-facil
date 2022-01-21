import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/listaExercicios/components/edit_biset_add.dart';

class ExercicioInfoCard extends StatelessWidget {
  final int index;
  final ExerciciosPlanilha exerciciosPlanilha;

  const ExercicioInfoCard({
    Key key,
    @required this.index,
    @required this.exerciciosPlanilha,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: Text(
                'Exercício ${index + 1}º',
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: AppFonts.gothamLight,
                  color: AppColors.grey,
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: AutoSizeText(
              exerciciosPlanilha.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontFamily: AppFonts.gothamBold,
                color: AppColors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      'Séries',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.gothamThin,
                        color: AppColors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AutoSizeText(
                        exerciciosPlanilha.series,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppFonts.gothamBook,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      'Repetições',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.gothamThin,
                        color: AppColors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AutoSizeText(
                        exerciciosPlanilha.reps,
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppFonts.gothamBook,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AutoSizeText(
                      'Carga',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: AppFonts.gothamThin,
                        color: AppColors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: AutoSizeText(
                        exerciciosPlanilha.carga.toString() + 'kg',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: AppFonts.gothamBook,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.grey,
                    size: 28,
                  ),
                  tooltip: 'Editar',
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        enableDrag: false,
                        context: context,
                        builder: (_) => EditBiSetAdd(
                            exerciciosPlanilha: exerciciosPlanilha,
                            index: index));
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: AppColors.red,
                    size: 28,
                  ),
                  tooltip: 'Remover Exercício',
                  onPressed: () {
                    context
                        .read<ExerciciosPlanilhaManager>()
                        .removerExercicioBiSetLista(index: index);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Divider(
              thickness: 0.6,
              color: Colors.black.withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}
