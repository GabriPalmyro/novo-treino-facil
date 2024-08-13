import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';

class LogoutButtonWidget extends StatefulWidget {
  const LogoutButtonWidget({super.key});

  @override
  State<LogoutButtonWidget> createState() => _LogoutButtonWidgetState();
}

class _LogoutButtonWidgetState extends State<LogoutButtonWidget> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
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
                  setState(() {
                    isLoading = true;
                  });
                  await context.read<UserManager>().logout();
                  Navigator.pop(context);
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
                  setState(() {
                    isLoading = true;
                  });
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
            padding: const EdgeInsets.symmetric(vertical: 18.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.grey300,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Desconectar",
                  style: TextStyle(
                    fontFamily: AppFonts.gotham,
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                isLoading
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.mainColor,
                          ),
                        ),
                      )
                    : FaIcon(
                        FontAwesomeIcons.arrowRightFromBracket,
                        color: Colors.red,
                        size: 15,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
