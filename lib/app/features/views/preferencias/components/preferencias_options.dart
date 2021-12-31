import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class PreferenciasOptions extends StatelessWidget {
  final String labelText;
  final bool isActive;
  final Function onTap;

  const PreferenciasOptions(
      {@required this.labelText,
      @required this.isActive,
      @required this.onTap});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
            flex: 65,
            child: Text(
              labelText,
              style: TextStyle(
                  fontFamily: AppFonts.gothamBook,
                  color: AppColors.white,
                  fontSize: 16),
            )),
        Expanded(
            flex: 35,
            child: Row(
              children: [
                InkWell(
                  onTap: onTap,
                  child: Container(
                    width: width * 0.13,
                    height: 30,
                    decoration: BoxDecoration(
                        color: !isActive
                            ? AppColors.mainColor
                            : Colors.transparent,
                        border: Border.all(
                            color: isActive
                                ? AppColors.mainColor
                                : Colors.transparent,
                            width: 2),
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Center(
                      child: Text(
                        'Não',
                        style: TextStyle(
                            fontFamily: AppFonts.gothamBook,
                            color: !isActive
                                ? AppColors.grey
                                : AppColors.mainColor,
                            fontSize: 12.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12.0),
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      width: width * 0.13,
                      height: 30,
                      decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.mainColor
                              : Colors.transparent,
                          border: Border.all(
                              color: !isActive
                                  ? AppColors.mainColor
                                  : Colors.transparent,
                              width: 2),
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Center(
                        child: Text(
                          'Sim',
                          style: TextStyle(
                              fontFamily: AppFonts.gothamBook,
                              color: isActive
                                  ? AppColors.grey
                                  : AppColors.mainColor,
                              fontSize: 12.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }
}
