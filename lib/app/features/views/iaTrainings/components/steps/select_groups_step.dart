import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/iaTraining/ia_training_controller.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/button_continue.dart';
import 'package:tabela_treino/app/shared/animation/page_animation.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

class SelectGroupsStep extends StatefulWidget {
  const SelectGroupsStep({super.key, required this.onContinue});
  final VoidCallback onContinue;

  @override
  State<SelectGroupsStep> createState() => _SelectGroupsStepState();
}

class _SelectGroupsStepState extends State<SelectGroupsStep> with AutomaticKeepAliveClientMixin {
  static List<String> filters = [
    "mines",
    "home_exe",
    "abdomen",
    "biceps",
    "costas",
    "ombros",
    "peitoral",
    "pernas",
    "triceps",
  ];

  static List<String> titles = [
    "Meus Exercícios",
    "Fazer em casa",
    "Abdômen",
    "Bíceps",
    "Costas",
    "Ombros",
    "Peitoral",
    "Pernas",
    "Tríceps",
  ];

  final List<String> exercisesTimes = [
    "30 minutos",
    "45 minutos",
    "60 minutos",
    "75 minutos",
    "90 minutos",
  ];

  String? selectedTime;
  List<String> selectedFilters = [];

  static int kDefaultMaxFilters = 2;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          Text(
            'Quais grupos musculares você deseja trabalhar?',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ).enterAnimation(order: 1),
          const SizedBox(height: 12),
          Wrap(
            children: [
              for (int i = 0; i < filters.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    backgroundColor: AppColors.grey300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    label: Text(
                      titles[i],
                      style: TextStyle(
                        color: selectedFilters.contains(filters[i]) ? AppColors.black : AppColors.mainColor,
                      ),
                    ),
                    selected: selectedFilters.contains(filters[i]),
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          if (selectedFilters.length == kDefaultMaxFilters) {
                            mostrarSnackBar(message: 'Selecione no máximo $kDefaultMaxFilters grupamentos', color: AppColors.red, context: context);
                            return;
                          }

                          selectedFilters.add(filters[i]);
                        } else {
                          selectedFilters.remove(filters[i]);
                        }
                      });
                    },
                    selectedColor: AppColors.mainColor,
                    checkmarkColor: AppColors.black,
                  ).enterAnimation(
                    order: 2 + i,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Quanto tempo você tem disponível para treinar?',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
            ),
          ).enterAnimation(order: 1, duration: 200),
          const SizedBox(height: 6),
          Wrap(
            children: [
              for (int i = 0; i < exercisesTimes.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    backgroundColor: AppColors.grey300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    label: Text(
                      exercisesTimes[i],
                      style: TextStyle(
                        color: selectedTime == exercisesTimes[i] ? AppColors.black : AppColors.mainColor,
                      ),
                    ),
                    selected: selectedTime == exercisesTimes[i],
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          selectedTime = exercisesTimes[i];
                        } else {
                          selectedTime = null;
                        }
                      });
                    },
                    selectedColor: AppColors.mainColor,
                    checkmarkColor: AppColors.black,
                  ).enterAnimation(
                    order: 2 + i,
                    duration: 200,
                  ),
                ),
            ],
          ),
          Expanded(child: SizedBox()),
          ButtonContinue(
            title: 'Continuar',
            onTap: () {
              context.read<IATrainingController>().setGroups(selectedFilters);
              context.read<IATrainingController>().setTime(selectedTime!);
              widget.onContinue.call();
            },
            isEnable: selectedFilters.isNotEmpty && selectedTime != null,
          ).enterAnimation(order: 2),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 24,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
