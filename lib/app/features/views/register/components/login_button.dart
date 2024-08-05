import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/app_colors.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onTap;
  final bool isLoading;
  const LoginButton({required this.onTap, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 350),
        curve: Curves.ease,
        width: width * 0.85,
        height: 50,
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  color: AppColors.grey,
                )
              : Text(
                  "Registrar",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
        ),
        decoration: BoxDecoration(
            color: AppColors.mainColor,
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 2,
                  offset: Offset(0, 4))
            ]),
      ),
    );
  }
}
