import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/alunos/alunos_screen.dart';
import 'package:tabela_treino/app/features/views/home/home_screen.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/lista_exercicios.dart';
import 'package:tabela_treino/app/features/views/personal/personal_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/planilha_screen.dart';
import 'package:tabela_treino/app/shared/bottomNavigator/bottom_navigator_widget.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int selectedTab = 0;

  final tabs = [
    HomeScreen(),
    PlanilhaScreen(),
    ListaExerciciosScreen(),
    AlunosScreen(),
    PersonalScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          IndexedStack(
            index: selectedTab,
            children: tabs,
          ),
          Positioned(
            bottom: MediaQuery.paddingOf(context).bottom,
            child: BottomNavigatorWidget(
              onItemTapped: (int) {
                setState(() {
                  selectedTab = int;
                });
              },
              selectedTab: selectedTab,
              isPersonal: context.read<UserManager>().user.isPersonal ?? false,
            ),
          )
        ],
      ),
    );
  }
}
