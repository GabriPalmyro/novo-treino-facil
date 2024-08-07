import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/button_continue.dart';
import 'package:tabela_treino/app/shared/animation/page_animation.dart';
import 'package:tabela_treino/app/shared/input/custom_input_widget.dart';

class HealthInfosStep extends StatefulWidget {
  const HealthInfosStep({super.key, required this.onContinue});

  final VoidCallback onContinue;

  @override
  State<HealthInfosStep> createState() => _HealthInfosStepState();
}

class _HealthInfosStepState extends State<HealthInfosStep> with AutomaticKeepAliveClientMixin {
  static List<String> condicaoFisica = [
    "Sedentário",
    "Iniciante",
    "Intermediário",
    "Avançado",
    "Atleta",
  ];

  String? condicaoFisicaSelecionada;

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
            'Informações de saúde',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 24,
            ),
          ).enterAnimation(order: 1),
          const SizedBox(height: 6),
          Text(
            'Isso ajuda a criar um treino mais personalizado, essas informações não serão salvas.',
            style: TextStyle(
              color: AppColors.lightGrey,
              fontSize: 14,
            ),
          ).enterAnimation(order: 2),
          const SizedBox(height: 18),
          Text(
            'Qual o seu peso? (kg)',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
            ),
          ).enterAnimation(order: 3),
          const SizedBox(height: 6),
          CustomTextInputWidget(
            textColor: AppColors.white,
            hintColor: AppColors.white.withOpacity(0.4),
            hintText: 'Peso (kg)',
            suffixText: 'KG',
            width: MediaQuery.of(context).size.width,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ).enterAnimation(order: 4),
          const SizedBox(height: 12),
          Text(
            'Qual sua altura? (cm)',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
            ),
          ).enterAnimation(order: 5),
          const SizedBox(height: 6),
          CustomTextInputWidget(
            textColor: AppColors.white,
            hintColor: AppColors.white.withOpacity(0.4),
            hintText: 'Altura (cm)',
            suffixText: 'CM',
            width: MediaQuery.of(context).size.width,
            textInputType: TextInputType.number,
            textInputAction: TextInputAction.next,
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
          ).enterAnimation(order: 6),
          const SizedBox(height: 12),
          // Nivel de condicionament
          Text(
            'Qual seu nível de condicionamento físico?',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 20,
            ),
          ).enterAnimation(order: 7),
          const SizedBox(height: 6),
          Wrap(
            children: [
              for (int i = 0; i < condicaoFisica.length; i++)
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    backgroundColor: AppColors.grey300,
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    label: Text(
                      condicaoFisica[i],
                      style: TextStyle(
                        color: condicaoFisicaSelecionada == condicaoFisica[i] ? AppColors.black : AppColors.mainColor,
                      ),
                    ),
                    selected: condicaoFisicaSelecionada == condicaoFisica[i],
                    onSelected: (value) {
                      setState(() {
                        if (value) {
                          condicaoFisicaSelecionada = condicaoFisica[i];
                        }
                      });
                    },
                    selectedColor: AppColors.mainColor,
                    checkmarkColor: AppColors.black,
                  ).enterAnimation(
                    order: 8 + i,
                  ),
                ),
            ],
          ),
          Expanded(child: SizedBox()),
          ButtonContinue(
            title: 'Continuar',
            onTap: widget.onContinue,
          ).enterAnimation(order: 6),
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
