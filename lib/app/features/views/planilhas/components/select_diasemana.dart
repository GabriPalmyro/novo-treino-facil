import 'package:flutter/material.dart';

import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/planilha/dia_da_semana.dart';

import 'custom_button.dart';

class SelectDiaSemanaModal extends StatefulWidget {
  final List<DiaDaSemana> diasDaSemana;

  const SelectDiaSemanaModal({this.diasDaSemana});

  @override
  _SelectDiaSemanaModalState createState() => _SelectDiaSemanaModalState();
}

class _SelectDiaSemanaModalState extends State<SelectDiaSemanaModal> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: MediaQuery.of(context).viewInsets * 0.5,
      child: Container(
        height: height * 0.75,
        child: Container(
            height: height * 0.75,
            decoration: new BoxDecoration(
                color: AppColors.grey,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(25.0),
                    topRight: const Radius.circular(25.0))),
            child: Padding(
              padding: EdgeInsets.only(top: 18.0, right: 18, left: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selecione os dias da semana',
                    style: TextStyle(
                        fontFamily: AppFonts.gothamBold,
                        color: AppColors.white,
                        fontSize: 24.0),
                  ),
                  Divider(
                    color: AppColors.white,
                    thickness: 1,
                  ),
                  Column(
                    children:
                        List.generate(widget.diasDaSemana.length, (index) {
                      return InkWell(
                        enableFeedback: true,
                        focusColor: AppColors.mainColor,
                        onTap: () {
                          setState(() {
                            widget.diasDaSemana[index].isSelected =
                                !widget.diasDaSemana[index].isSelected;
                          });
                        },
                        child: Container(
                          height: 40,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            border: Border(
                              bottom: BorderSide(
                                  width: 0.8,
                                  color: AppColors.white.withOpacity(0.6)),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  flex: 80,
                                  child: Text(widget.diasDaSemana[index].dia,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: widget.diasDaSemana[index]
                                                  .isSelected
                                              ? AppColors.mainColor
                                              : AppColors.white,
                                          fontFamily: AppFonts.gothamBook))),
                              Expanded(
                                  flex: 20,
                                  child: widget.diasDaSemana[index].isSelected
                                      ? Icon(
                                          Icons.check,
                                          color: AppColors.mainColor,
                                        )
                                      : SizedBox())
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: CustomButton(
                      text: 'Confirmar',
                      color: AppColors.mainColor,
                      textColor: AppColors.black,
                      onTap: () async {
                        Navigator.pop(context);
                      },
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
