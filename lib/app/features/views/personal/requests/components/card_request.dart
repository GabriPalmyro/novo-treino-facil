import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/personal/personal.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';
import 'package:tabela_treino/app/shared/shimmer/skeleton.dart';

class CardRequest extends StatefulWidget {
  final Personal personal;
  final VoidCallback excluirPedido;
  final VoidCallback aceitarPedido;

  const CardRequest({required this.personal, required this.excluirPedido, required this.aceitarPedido});

  @override
  _CardRequestState createState() => _CardRequestState();
}

class _CardRequestState extends State<CardRequest> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: AppColors.white.withOpacity(0.5),
          width: 2,
        ),
      )),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Padding(
            padding: EdgeInsets.symmetric(vertical: 5.0),
            child: Container(
              child: Row(
                children: [
                  Expanded(
                      child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 60,
                      child: Image.network(widget.personal.personalPhoto!,
                          fit: BoxFit.cover, loadingBuilder:
                              (_, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Center(
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Shimmer.fromColors(
                                    baseColor: AppColors.lightGrey,
                                    highlightColor: AppColors.grey300,
                                    child: Skeleton(height: 60, width: 60))));
                      }),
                    ),
                  )),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.personal.personalName!,
                              style: TextStyle(
                                  fontFamily: AppFonts.gotham,
                                  fontSize: 24,
                                  color: AppColors.white),
                            ),
                            Text(
                              widget.personal.personalEmail!,
                              style: TextStyle(
                                  fontFamily: AppFonts.gothamLight,
                                  fontSize: 14,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomButton(
                  text: 'Excluir Pedido',
                  color: Colors.red,
                  textColor: AppColors.white,
                  onTap: widget.excluirPedido),
              CustomButton(
                  width: 140,
                  text: 'Aceitar Personal',
                  color: Colors.green,
                  textColor: AppColors.white,
                  onTap: widget.aceitarPedido)
            ],
          ),
        )
      ]),
    );
  }
}
