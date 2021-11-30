import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    //final height = MediaQuery.of(context).size.height;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 10,
      backgroundColor: Colors.black,
      child: Container(
        height: 250,
        width: width * 0.9,
        decoration: BoxDecoration(
            color: AppColors.grey,
            border: Border.all(color: AppColors.white, width: 5),
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: AppColors.white,
                    ))),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 0, 24),
              child: Container(
                height: 300,
                width: width * 0.9,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.favorite_outline_rounded,
                          color: AppColors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 10),
                          child: Container(
                            width: width * 0.6,
                            child: AutoSizeText(
                              'Esse ícone significa quais são seus treinos favoritos. Você pode selecionar para que eles apareçam na sua tela inicial (Meu Perfil - Configurações).',
                              style: TextStyle(
                                  height: 1.1,
                                  fontFamily: AppFonts.gotham,
                                  color: AppColors.white,
                                  fontSize: 14),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            color: AppColors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 10),
                            child: Container(
                              width: width * 0.6,
                              child: AutoSizeText(
                                'Você pode editar as planilhas que já tenha criado, caso seja necessário.',
                                style: TextStyle(
                                    height: 1.1,
                                    fontFamily: AppFonts.gotham,
                                    color: AppColors.white,
                                    fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 14.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            color: AppColors.white,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 10),
                            child: Container(
                              width: width * 0.6,
                              child: AutoSizeText(
                                'Adicione novas planilhas e as personalize da forma que desejar!',
                                style: TextStyle(
                                    height: 1.1,
                                    fontFamily: AppFonts.gotham,
                                    color: AppColors.white,
                                    fontSize: 14),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
