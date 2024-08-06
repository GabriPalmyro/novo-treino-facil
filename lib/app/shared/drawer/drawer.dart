import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/drawer/components/logout_button.dart';
import 'package:tabela_treino/app/shared/shimmer/drawer/drawer_shimmer.dart';

import 'components/header_drawer.dart';

class CustomDrawer extends StatefulWidget {
  final int pageNow;
  CustomDrawer({required this.pageNow});

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<UserManager>(
      builder: (_, userManager, __) {
        if (isLoading) {
          return DrawerLoading();
        }

        return Drawer(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColors.grey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderDrawer(
                  fullName: userManager.user.fullName(),
                  photoURL: userManager.user.photoURL!,
                  isPersonal: userManager.user.isPersonal!,
                  onTap: () {
                    if (widget.pageNow != 5) {
                      Navigator.pushNamed(context, AppRoutes.meuPerfil);
                    }
                  },
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 0) {
                              Navigator.pushNamed(context, AppRoutes.home);
                            } else {
                              Navigator.pop(context);
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
                                    fontFamily: AppFonts.gothamLight,
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
                              Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.planilhas, arguments: userManager.user.id);
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
                                  "Planilhas",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamLight,
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
                              Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.listaExercicios);
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
                                    fontFamily: AppFonts.gothamLight,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        if (context.read<CoreAppController>().coreInfos.mostrarTreinosFaceis!) ...[
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
                                      fontFamily: AppFonts.gothamLight,
                                      fontSize: 20,
                                      color: AppColors.mainColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        InkWell(
                          onTap: () {
                            if (widget.pageNow != 4) {
                              Navigator.pop(context);
                              if (userManager.user.isPersonal!) {
                                Navigator.pushNamed(context, AppRoutes.alunos);
                              } else {
                                Navigator.pushNamed(context, AppRoutes.personal);
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
                                  userManager.user.isPersonal! ? Icons.people_rounded : Icons.live_help,
                                  size: 30,
                                  color: AppColors.mainColor,
                                ),
                                SizedBox(width: 32),
                                Text(
                                  userManager.user.isPersonal! ? "Alunos" : "Personal\nTrainer",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontFamily: AppFonts.gothamLight,
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
                              Navigator.pop(context);
                              Navigator.pushNamed(context, AppRoutes.meuPerfil);
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
                                    fontFamily: AppFonts.gothamLight,
                                    fontSize: 20,
                                    color: AppColors.mainColor,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(child: SizedBox()),
                        LogoutButtonWidget(
                          isLoading: isLoading,
                          changeLoading: (value) {
                            setState(() {
                              isLoading = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
