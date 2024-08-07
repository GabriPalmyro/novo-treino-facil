import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';

class ProgressBarWidget extends StatelessWidget {
  const ProgressBarWidget({super.key, required this.actualStep, required this.totalSteps});
  final int actualStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    const kHeight = 8.0;
    return Stack(
      children: [
        Container(
          width: MediaQuery.sizeOf(context).width,
          height: kHeight,
          decoration: BoxDecoration(
            color: AppColors.grey340,
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: MediaQuery.sizeOf(context).width * ((actualStep + 0.5) / (totalSteps - 1)),
          height: kHeight,
          decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
      ],
    );
  }
}
