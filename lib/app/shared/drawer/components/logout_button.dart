import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

class LogoutButtonWidget extends StatelessWidget {
  const LogoutButtonWidget({super.key, required this.isLoading, required this.changeLoading});

  final bool isLoading;
  final Function(bool) changeLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCustomAlertDialog(
          title: Text(
            'Aviso',
            style: TextStyle(
              fontFamily: AppFonts.gothamBold,
              color: Colors.red,
            ),
          ),
          androidActions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Não',
                style: TextStyle(
                  fontFamily: AppFonts.gotham,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                changeLoading(true);
                await context.read<UserManager>().logout();
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  AppColors.red,
                ),
              ),
              child: Text(
                'Sim',
                style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.white),
              ),
            )
          ],
          iosActions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'Não',
                style: TextStyle(
                  fontFamily: AppFonts.gotham,
                  color: Colors.white,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                changeLoading(true);
                await context.read<UserManager>().logout();
                await context.read<AmigosProcuradosManager>().deleteHistorico();

                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
              },
              child: Text(
                'Sim',
                style: TextStyle(
                  fontFamily: AppFonts.gotham,
                  color: AppColors.mainColor,
                ),
              ),
            )
          ],
          context: context,
          content: Text(
            'Você deseja mesmo desconectar da sua conta?',
            style: TextStyle(
              height: 1.1,
              fontFamily: AppFonts.gotham,
              color: Colors.white,
            ),
          ),
        );
      },
      child: Ink(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          margin: const EdgeInsets.only(right: 24.0),
          decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.grey300,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            "Desconectar",
            style: TextStyle(
              fontFamily: AppFonts.gotham,
              fontSize: 18,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }
}
