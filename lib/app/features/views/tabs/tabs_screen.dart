import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
                HapticFeedback.lightImpact();
                if (selectedTab == int) return;
                setState(() {
                  selectedTab = int;
                });
              },
              selectedTab: selectedTab,
            ),
          )
        ],
      ),
    );
  }
}
