import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/iaTraining/ia_training_controller.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/biset_exercicio.dart';
import 'package:tabela_treino/app/features/models/exerciciosPlanilha/exercicios_planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/components/exercicio_modal.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/button_continue.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/cards/bi_set_card_widget.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/cards/uni_set_card_widget.dart';
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
      backgroundColor: AppColors.grey,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).padding.top + 18.0,
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                context.read<IATrainingController>().result!.title,
                style: TextStyle(
                  fontSize: 28,
                  color: AppColors.mainColor,
                  fontFamily: AppFonts.gothamBold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 8)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Descrição',
                style: TextStyle(
                  fontSize: 20,
                  color: AppColors.white,
                  fontFamily: AppFonts.gotham,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(child: const SizedBox(height: 4)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                context.read<IATrainingController>().result!.description,
                style: TextStyle(fontSize: 14, color: AppColors.white.withOpacity(0.8), fontFamily: AppFonts.gothamLight),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: const SizedBox(width: 24.0),
          ),
          SliverList.builder(
            itemCount: context.read<IATrainingController>().result!.exercises.length,
            itemBuilder: (_, index) {
              final item = context.read<IATrainingController>().result!.exercises[index];
              return item.set_type == "uniset"
                  ? UniSetCardWidget(
                      index: index,
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
                            enableEditing: false,
                            isPersonalManag: false,
                            tamPlan: 0,
                            titlePlanilha: context.read<IATrainingController>().result!.title,
                            refetchExercises: () {},
                            isBiSet: false,
                            isSecondExercise: false,
                          ),
                        );
                      },
                    )
                  : BiSetCardWidget(
                      index: index,
                      idPlanilha: '',
                      exercicio: BiSetExercise(
                        setType: item.set_type!,
                        firstExercise: item.title1!,
                        secondExercise: item.title2!,
                        exercicios: [
                          ExerciciosPlanilha(
                            id: '',
                            title: item.sets![0].title,
                            muscleId: item.sets![0].muscleId,
                            setType: item.sets![0].set_type,
                            reps: item.sets![0].reps,
                            carga: item.sets![0].peso,
                            comments: item.sets![0].obs,
                            video: item.sets![0].video,
                            series: item.sets![0].series,
                          ),
                          ExerciciosPlanilha(
                            id: '',
                            title: item.sets![1].title,
                            muscleId: item.sets![1].muscleId,
                            setType: item.sets![1].set_type,
                            reps: item.sets![1].reps,
                            carga: item.sets![1].peso,
                            comments: item.sets![1].obs,
                            video: item.sets![1].video,
                            series: item.sets![1].series,
                          ),
                        ],
                        position: 0,
                      ),
                      idUser: context.read<UserManager>().user.id!,
                      tamPlan: 0,
                      titlePlanilha: context.read<IATrainingController>().result!.title,
                      refetchExercises: () {},
                    );
              // : SizedBox();
            },
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              child: ButtonContinue(
                title: 'Adicionar Treino',
                onTap: () {
                  context.read<IATrainingController>().createWorksheetFromIATraining(
                        idUser: context.read<UserManager>().user.id!,
                        onError: () {
                          mostrarSnackBar(
                            message: 'Occorreu um erro ao gerar o seu treino. Tente novamente ou aguarde alguns instantes,',
                            color: AppColors.red,
                            context: context,
                          );
                        },
                        onSuccess: () async {
                          await context.read<PlanilhaManager>().loadWorksheetList();
                          Navigator.of(context).pushReplacementNamed(AppRoutes.planilhas);
                        },
                      );
                },
                isEnable: true,
                isLoading: context.watch<IATrainingController>().getIsLoading,
              ),
            ),
          )
        ],
      ),
    );
  }
}
