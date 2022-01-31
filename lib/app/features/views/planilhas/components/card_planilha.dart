import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/edit_planilha_modal.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';

class CardPlanilha extends StatefulWidget {
  final Planilha planilha;
  final String userId;
  final int index;
  final Function onTap;
  final bool isPersonalAcess;

  const CardPlanilha(
      {@required this.planilha,
      @required this.userId,
      @required this.index,
      @required this.onTap,
      this.isPersonalAcess = false});

  @override
  _CardPlanilhaState createState() => _CardPlanilhaState();
}

class _CardPlanilhaState extends State<CardPlanilha> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<PlanilhaManager>(builder: (_, planilhaManager, __) {
      return InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Container(
              height: 120,
              width: width * 0.9,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.mainColor,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: AppColors.black.withOpacity(0.4),
                      blurRadius: 6,
                      offset: Offset(0, 6))
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AutoSizeText(
                    widget.planilha.title.toUpperCase(),
                    style: TextStyle(
                        fontSize: 24, fontFamily: AppFonts.gothamBold),
                    textAlign: TextAlign.center,
                  ),
                  Divider(
                    color: AppColors.black.withOpacity(0.4),
                    thickness: 0.5,
                  ),
                  AutoSizeText(
                    widget.planilha.description,
                    maxLines: 2,
                    style: TextStyle(
                        fontSize: 18, fontFamily: AppFonts.gothamBook),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (!widget.isPersonalAcess) ...[
              Positioned(
                  top: 0,
                  left: 20,
                  child: IconButton(
                      onPressed: () async {
                        var response =
                            await planilhaManager.changePlanilhaToFavorite(
                                widget.planilha, widget.index);
                        if (response != null) {
                          mostrarSnackBar(
                              context: context,
                              message:
                                  'Não foi possível favoritar esse treino.',
                              color: AppColors.red);
                        }
                      },
                      icon: Icon(
                        widget.planilha.favorito
                            ? Icons.star
                            : Icons.star_border,
                        color: widget.planilha.favorito
                            ? AppColors.black
                            : AppColors.black,
                      ))),
            ],
            Positioned(
                top: 0,
                right: 20,
                child: IconButton(
                    onPressed: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => EditPlanilhaModal(
                                planilha: widget.planilha,
                                userId: widget.userId,
                                index: widget.index,
                                isPersonalAcess: widget.isPersonalAcess,
                              ));
                    },
                    icon: Icon(
                      Icons.edit_outlined,
                      color: AppColors.black,
                    ))),
          ],
        ),
      );
    });
  }
}
