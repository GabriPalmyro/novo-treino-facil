import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/iaTraining/ia_training_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/exercises/exercises.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/progress_bar_widget.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/health_infos_step.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/name_routine_step.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/select_groups_step.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

class GenerateTrainingScreen extends StatefulWidget {
  const GenerateTrainingScreen({super.key});

  @override
  State<GenerateTrainingScreen> createState() => _GenerateTrainingScreenState();
}

class _GenerateTrainingScreenState extends State<GenerateTrainingScreen> {
  late PageController _pageController;
  int page = 0;

  InterstitialAd? _interstitialAd;

  Future<void> _loadInterstitialAd() async {
    AdHelper.loadInterstitialAd((ad) {
      setState(() {
        _interstitialAd = ad;
      });
    });
  }

  @override
  void initState() {
    _loadInterstitialAd();
    _pageController = PageController(
      initialPage: 0,
    )..addListener(() {
        setState(() {
          page = _pageController.page!.toInt();
        });
      });
    super.initState();
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (page < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void onPop() {
    if (page > 0) {
      _pageController.previousPage(
        duration: Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (_) => onPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Gerar Treino com IA',
            style: TextStyle(
              color: AppColors.white,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(
            color: AppColors.mainColor,
          ),
          backgroundColor: AppColors.grey,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: onPop,
          ),
        ),
        backgroundColor: AppColors.grey,
        body: Column(
          children: [
            ProgressBarWidget(
              actualStep: page,
              totalSteps: 4,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  NameRoutineStep(
                    onContinue: goToNextPage,
                  ),
                  SelectGroupsStep(
                    onContinue: goToNextPage,
                  ),
                  HealthInfosStep(
                    onContinue: () async {
                      final selectedGroups = context.read<IATrainingController>().props.groups!..add('mines');
                      final gender = context.read<UserManager>().user.sex;

                      List<Exercise> exercises = [];

                      for (var group in selectedGroups) {
                        exercises.addAll(
                          context.read<ExercisesManager>().searchResultList(searchController: '', selectedType: group),
                        );
                      }

                      try {
                        await context.read<IATrainingController>().createIaTraining(
                              groupExercises: exercises,
                              sex: gender!,
                            );

                        await context.read<UserManager>().removeIAGenerationAvailable();

                        if (_interstitialAd != null && !context.read<UserManager>().user.isPayApp) {
                          await _interstitialAd!.show();
                        }

                        Navigator.of(context).pushReplacementNamed(AppRoutes.iaTrainingResult);
                      } catch (exception, stackTrace) {
                        await Sentry.captureException(
                          exception,
                          stackTrace: stackTrace,
                        );
                        mostrarSnackBar(message: 'Occorreu um erro ao gerar o seu treino. Tente novamente ou aguarde.', color: AppColors.red, context: context);
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
