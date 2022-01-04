import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_routes.dart';

import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
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
                                  AppRoutes.planilhas, (route) => false);
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.list_outlined,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Minha Planilha\nde Treino",
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
                              children: [
                                Icon(
                                  Icons.line_weight,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Biblioteca de\nExercícios",
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
                                      ? "Meus Alunos"
                                      : "Meu Personal\nTrainer",
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
                              children: [
                                Icon(
                                  Icons.person,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  "Meu Perfil",
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
                            isLoading = true;
                            await userManager.logout();

                            Navigator.pushNamedAndRemoveUntil(
                                context, AppRoutes.login, (route) => false);
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
