import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/aluno/aluno.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';
import 'package:tabela_treino/app/shared/shimmer/skeleton.dart';

class CardAluno extends StatelessWidget {
  final Aluno aluno;
  final VoidCallback excluirAluno;
  final VoidCallback acessarPlanilhas;

  const CardAluno({required this.aluno, required this.excluirAluno, required this.acessarPlanilhas});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.black.withOpacity(0.3), width: 2))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 18.0),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        height: 60,
                        child: Image.network(
                          aluno.alunoPhoto!,
                          fit: BoxFit.cover,
                          loadingBuilder: (_, Widget child, ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            }
                            return Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Shimmer.fromColors(
                                  baseColor: AppColors.lightGrey,
                                  highlightColor: AppColors.grey300,
                                  child: Skeleton(
                                    height: 60,
                                    width: 60,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              aluno.alunoName ?? 'Nome do Aluno',
                              style: TextStyle(fontFamily: AppFonts.gotham, fontSize: 24, color: AppColors.black),
                            ),
                            Text(
                              aluno.alunoEmail ?? 'Email do Aluno',
                              style: TextStyle(fontFamily: AppFonts.gothamLight, fontSize: 14, color: AppColors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomButton(text: 'Excluir Aluno', color: Colors.red, textColor: AppColors.white, onTap: excluirAluno),
            CustomButton(width: 140, text: 'Acessar Planilhas', color: AppColors.grey, textColor: AppColors.white, onTap: acessarPlanilhas)
          ],
        )
      ]),
    );
  }
}
