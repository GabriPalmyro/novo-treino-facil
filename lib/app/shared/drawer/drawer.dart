import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_routes.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/show_custom_alert_dialog.dart';
import 'package:tabela_treino/app/shared/shimmer/drawer/drawer_shimmer.dart';

import 'components/header_drawer.dart';

class CustomDrawer extends StatefulWidget {
  final int pageNow;
  CustomDrawer({this.pageNow});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(builder: (_, userManager, __) {
      if (isLoading) {
        return DrawerLoading();
      } else {
        return Drawer(
          child: Container(
            color: AppColors.grey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HeaderDrawer(
                    fullName: (userManager.user.name.toUpperCase() +
                        ' ' +
                        userManager.user.lastName.toUpperCase()),
                    photoURL: userManager.user.photoURL,
                    isPersonal: userManager.user.isPersonal,
                    onTap: () {
                      if (widget.pageNow != 5) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AppRoutes.meuPerfil, (route) => false);
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 0) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AppRoutes.home, (route) => false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Página inicial",
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 1) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.planilhas, (route) => false,
                                  arguments: userManager.user.id);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.list_outlined,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Treinos",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 2) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.listaExercicios, (route) => false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.line_weight,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Exercícios",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 3) {}
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.fitness_center,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Treinos Fáceis",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 4) {
                              if (userManager.user.isPersonal) {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.alunos, (route) => false);
                              } else {
                                Navigator.pushNamedAndRemoveUntil(context,
                                    AppRoutes.personal, (route) => false);
                              }
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  userManager.user.isPersonal ?? false
                                      ? Icons.people_rounded
                                      : Icons.live_help,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  userManager.user.isPersonal ?? false
                                      ? "Alunos"
                                      : "Personal\nTrainer",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 5) {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.meuPerfil, (route) => false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Perfil",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamThin,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            await showCustomAlertDialog(
                                title: Text(
                                  'Aviso',
                                  style: TextStyle(
                                      fontFamily: AppFonts.gothamBold,
                                      color: Colors.red),
                                ),
                                androidActions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Não',
                                          style: TextStyle(
                                              fontFamily: AppFonts.gotham,
                                              color: Colors.white))),
                                  TextButton(
                                      onPressed: () async {
                                        isLoading = true;
                                        await userManager.logout();

                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            AppRoutes.login,
                                            (route) => false);
                                      },
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  AppColors.red)),
                                      child: Text('Sim',
                                          style: TextStyle(
                                              fontFamily: AppFonts.gotham,
                                              color: AppColors.white)))
                                ],
                                iosActions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('Não',
                                          style: TextStyle(
                                              fontFamily: AppFonts.gotham,
                                              color: Colors.white))),
                                  TextButton(
                                      onPressed: () async {
                                        isLoading = true;
                                        await userManager.logout();

                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            AppRoutes.login,
                                            (route) => false);
                                      },
                                      child: Text('Sim',
                                          style: TextStyle(
                                              fontFamily: AppFonts.gotham,
                                              color: AppColors.mainColor)))
                                ],
                                context: context,
                                content: Text(
                                  'Você deseja mesmo desconectar da sua conta?',
                                  style: TextStyle(
                                      height: 1.1,
                                      fontFamily: AppFonts.gotham,
                                      color: Colors.white),
                                ));
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.only(top: 24.0, bottom: 24.0),
                            child: Text(
                              "Sair",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontFamily: AppFonts.gotham,
                                fontSize: 20,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
