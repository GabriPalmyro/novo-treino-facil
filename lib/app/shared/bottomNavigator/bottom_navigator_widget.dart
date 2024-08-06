import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tabela_treino/app/core/core.dart';

class BottomNavigatorWidget extends StatelessWidget {
  const BottomNavigatorWidget({super.key, required this.selectedTab, required this.onItemTapped, this.isPersonal = false});

  final int selectedTab;
  final Function(int) onItemTapped;
  final bool isPersonal;

  static const kSpacer = const SizedBox(height: 6);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.grey600,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () {
                  onItemTapped(0);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.house,
                      color: selectedTab == 0 ? AppColors.mainColor : AppColors.lightGrey,
                    ),
                    kSpacer,
                    Text(
                      'Início',
                      style: TextStyle(
                        color: selectedTab == 0 ? AppColors.mainColor : AppColors.lightGrey,
                        fontFamily: AppFonts.gothamLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () {
                  onItemTapped(1);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.tableList,
                      color: selectedTab == 1 ? AppColors.mainColor : AppColors.lightGrey,
                    ),
                    kSpacer,
                    Text(
                      'Planilhas',
                      style: TextStyle(
                        color: selectedTab == 1 ? AppColors.mainColor : AppColors.lightGrey,
                        fontFamily: AppFonts.gothamLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: InkWell(
                onTap: () {
                  onItemTapped(2);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.dumbbell,
                      color: selectedTab == 2 ? AppColors.mainColor : AppColors.lightGrey,
                    ),
                    kSpacer,
                    Text(
                      'Exercícios',
                      style: TextStyle(
                        color: selectedTab == 2 ? AppColors.mainColor : AppColors.lightGrey,
                        fontFamily: AppFonts.gothamLight,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isPersonal) ...[
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    onItemTapped(3);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.users,
                        color: selectedTab == 3 ? AppColors.mainColor : AppColors.lightGrey,
                      ),
                      kSpacer,
                      Text(
                        'Alunos',
                        style: TextStyle(
                          color: selectedTab == 3 ? AppColors.mainColor : AppColors.lightGrey,
                          fontFamily: AppFonts.gothamLight,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: Center(
                child: InkWell(
                  onTap: () {
                    onItemTapped(4);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.userPen,
                        color: selectedTab == 3 ? AppColors.mainColor : AppColors.lightGrey,
                      ),
                      kSpacer,
                      Text(
                        'Personal',
                        style: TextStyle(
                          color: selectedTab == 3 ? AppColors.mainColor : AppColors.lightGrey,
                          fontFamily: AppFonts.gothamLight,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
