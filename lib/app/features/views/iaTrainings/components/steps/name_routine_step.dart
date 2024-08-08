import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/features/controllers/iaTraining/ia_training_controller.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/button_continue.dart';
import 'package:tabela_treino/app/shared/animation/page_animation.dart';
import 'package:tabela_treino/app/shared/input/custom_input_widget.dart';

class NameRoutineStep extends StatefulWidget {
  const NameRoutineStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<NameRoutineStep> createState() => _NameRoutineStepState();
}

class _NameRoutineStepState extends State<NameRoutineStep> with AutomaticKeepAliveClientMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  String? name;

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
            'Informe qual será o nome da planilha de treino',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ).enterAnimation(order: 1),
          const SizedBox(height: 12),
          CustomTextInputWidget(
            textController: nameController,
            textColor: AppColors.white,
            hintColor: AppColors.white.withOpacity(0.4),
            hintText: 'Titulo do treino',
            width: MediaQuery.of(context).size.width,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            onChanged: (value) {
              setState(() {
                name = value;
              });
            },
          ).enterAnimation(order: 2),
          const SizedBox(height: 24),
          Text(
            'Para qual objetivo você deseja criar esse treino?',
            style: TextStyle(color: Colors.white, fontSize: 24),
          ).enterAnimation(order: 3),
          const SizedBox(height: 12),
          CustomTextInputWidget(
            textController: goalController,
            textColor: AppColors.white,
            hintColor: AppColors.white.withOpacity(0.4),
            hintText: 'Objetivo do treino',
            width: MediaQuery.of(context).size.width,
            textInputType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ).enterAnimation(order: 4),
          const SizedBox(height: 16),
          Expanded(child: SizedBox()),
          ButtonContinue(
            title: 'Continuar',
            onTap: () {
              context.read<IATrainingController>().setName(nameController.text);
              context.read<IATrainingController>().setGoal(goalController.text);
              widget.onContinue();
            },
            isEnable: name != null && name!.isNotEmpty,
          ).enterAnimation(order: 5),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom + 24,
          )
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
