import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/iaTraining/ia_training_controller.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/uni_set_card.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

class TrainingResultScreen extends StatelessWidget {
  const TrainingResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loading = context.watch<IATrainingController>().getIsLoading;

    if (loading) {
      return Scaffold(
        backgroundColor: AppColors.grey,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (context.read<IATrainingController>().result == null) {
      return Scaffold(
        backgroundColor: AppColors.grey,
        body: Center(
          child: Text(
            'Erro ao gerar treino',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
              fontFamily: AppFonts.gothamBold,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(context.read<IATrainingController>().result!.title),
        actions: [
          IconButton(
            icon: Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(
                  text: context.read<IATrainingController>().result!.toJson().toString(),
                ),
              );
              mostrarSnackBar(message: 'Resultado copiado', color: AppColors.grey300, context: context);
            },
          ),
        ],
      ),
      backgroundColor: AppColors.grey,
      body: CustomScrollView(
        // mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.start,
        slivers: [
          // SliverToBoxAdapter(child: const SizedBox(height: 18)),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   sliver: Text(
          //     'Descrição',
          //     style: TextStyle(
          //       fontSize: 24,
          //       color: AppColors.mainColor,
          //       fontFamily: AppFonts.gothamBold,
          //     ),
          //   ),
          // ),
          // SliverToBoxAdapter(child: const SizedBox(height: 4)),
          // SliverPadding(
          //   padding: const EdgeInsets.symmetric(horizontal: 12),
          //   sliver: Text(
          //     context.read<IATrainingController>().result!.description,
          //     style: TextStyle(fontSize: 14, color: AppColors.white, fontFamily: AppFonts.gothamLight),
          //   ),
          // ),
          // SliverToBoxAdapter(child: const SizedBox(width: 12)),
          SliverList.builder(
            itemCount: context.read<IATrainingController>().result!.exercises.length,
            itemBuilder: (_, index) {
              final item = context.read<IATrainingController>().result!.exercises[index];
              return item.set_type == "uniset"
                  ? UniSetCard(
                      index: index,
                      isChanging: false,
                      exercicio: ExerciciosPlanilha(
                        id: '',
                        title: item.title,
                        muscleId: item.muscleId,
                        setType: item.set_type,
                        reps: item.reps,
                        carga: item.peso,
                        comments: item.obs,
                        video: item.video,
                        series: item.series,
                      ),
                      isEditing: false,
                      idUser: '',
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          enableDrag: false,
                          context: context,
                          builder: (_) => ExercicioViewModal(
                            exercicio: ExerciciosPlanilha(
                              id: '',
                              title: item.title,
                              muscleId: item.muscleId,
                              setType: item.set_type,
                              reps: item.reps,
                              carga: item.peso,
                              comments: item.obs,
                              video: item.video,
                              series: item.series,
                            ),
                            isFriendAcess: false,
                            idPlanilha: '',
                            idExercicio: '',
                            idUser: '',
                            isPersonalManag: false,
                            tamPlan: 0,
                            titlePlanilha: '',
                            refetchExercises: () {},
                            isBiSet: false,
                            isSecondExercise: false,
                          ),
                        );
                      },
                    )

                  // TODO - Implementar BiSetCard
                  // : BiSetCard(
                  //     index: index,
                  //     idPlanilha: '',
                  //     exercicio: BiSetExercise(
                  //       setType: item.set_type!,
                  //       firstExercise: item.title1!,
                  //       secondExercise: item.title2!,
                  //       exercicios:
                  //       // List<ExerciciosPlanilha>.from(
                  //       //   item.sets!.map(
                  //       //     (item) => ExerciciosPlanilha(
                  //       //       id: '',
                  //       //       title: item.title,
                  //       //       muscleId: item.muscleId,
                  //       //       setType: item.set_type,
                  //       //       reps: item.reps,
                  //       //       carga: item.peso,
                  //       //       comments: item.obs,
                  //       //       video: item.video,
                  //       //       series: item.series,
                  //       //     ),
                  //       //   ),
                  //       // ),
                  //       [
                  //         ExerciciosPlanilha(
                  //           id: '',
                  //           title: item.sets![0].title,
                  //           muscleId: item.sets![0].muscleId,
                  //           setType: item.sets![0].set_type,
                  //           reps: item.sets![0].reps,
                  //           carga: item.sets![0].peso,
                  //           comments: item.sets![0].obs,
                  //           video: item.sets![0].video,
                  //           series: item.sets![0].series,
                  //         ),
                  //         ExerciciosPlanilha(
                  //           id: '',
                  //           title: item.sets![1].title,
                  //           muscleId: item.sets![1].muscleId,
                  //           setType: item.sets![1].set_type,
                  //           reps: item.sets![1].reps,
                  //           carga: item.sets![1].peso,
                  //           comments: item.sets![1].obs,
                  //           video: item.sets![1].video,
                  //           series: item.sets![1].series,
                  //         ),
                  //       ],
                  //       position: 0,
                  //     ),
                  //     isChanging: false,
                  //     idUser: '',
                  //     isEditing: false,
                  //     tamPlan: 0,
                  //     titlePlanilha: '',
                  //     refetchExercises: () {},
                  //   );
                  : SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
