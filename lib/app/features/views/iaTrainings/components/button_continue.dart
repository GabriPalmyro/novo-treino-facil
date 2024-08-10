import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';

class ButtonContinue extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool isEnable;
  final bool isLoading;

  const ButtonContinue({
    required this.title,
    required this.onTap,
    this.isEnable = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: isEnable && !isLoading ? onTap : () {},
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: width,
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isEnable ? AppColors.mainColor : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: AppFonts.gotham,
                color: AppColors.black,
                fontSize: 16,
              ),
            ),
            if (isLoading) ...[
              SizedBox(
                width: 18,
              ),
              ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                  width: 18,
                  height: 18,
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.black,
                  ),
                  strokeWidth: 2,
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
