import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/progress_bar_widget.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/health_infos_step.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/name_routine_step.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/steps/select_groups_step.dart';

class GenerateTrainingScreen extends StatefulWidget {
  const GenerateTrainingScreen({super.key});

  @override
  State<GenerateTrainingScreen> createState() => _GenerateTrainingScreenState();
}

class _GenerateTrainingScreenState extends State<GenerateTrainingScreen> {
  late PageController _pageController;
  int page = 0;

  @override
  void initState() {
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
    _pageController.dispose();
    super.dispose();
  }

  void goToNextPage() {
    if (page < 4) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) async {
        if (page > 0) {
          _pageController.previousPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        } else {
          Navigator.of(context).pop();
        }
      },
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
                    onContinue: goToNextPage,
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
