import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';

class CardPlanilhaFriend extends StatefulWidget {
  final Planilha planilha;
  final int index;
  final Function onTap;

  const CardPlanilhaFriend(
      {@required this.planilha, @required this.index, @required this.onTap});

  @override
  _CardPlanilhaFriendState createState() => _CardPlanilhaFriendState();
}

class _CardPlanilhaFriendState extends State<CardPlanilhaFriend> {
  void mostrarSnackBar(String message, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer<PlanilhaManager>(builder: (_, planilhaManager, __) {
      return Padding(
        padding: EdgeInsets.only(top: 24.0),
        child: InkWell(
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
              // Positioned(
              //     top: 0,
              //     left: 20,
              //     child: IconButton(
              //         onPressed: () async {
              //           var response =
              //               await planilhaManager.changePlanilhaToFavorite(
              //                   widget.planilha, widget.index);
              //           if (response != null) {
              //             mostrarSnackBar(
              //                 'Não foi possível favoritar esse treino.',
              //                 Colors.red);
              //           }
              //         },
              //         icon: Icon(
              //           widget.planilha.favorito
              //               ? Icons.favorite
              //               : Icons.favorite_border_rounded,
              //           color: widget.planilha.favorito
              //               ? Colors.red
              //               : AppColors.black,
              //         ))),
            ],
          ),
        ),
      );
    });
  }
}
