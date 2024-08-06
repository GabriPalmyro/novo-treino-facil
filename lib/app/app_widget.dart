
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/ads/ads_controller.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/friend/friend_controller.dart';
import 'package:tabela_treino/app/features/controllers/meAjuda/ajudas_controller.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/routes.dart';

import '/app/core/core.dart';
import '/app/features/controllers/user/user_controller.dart';
import 'features/controllers/planilha/planilha_manager.dart';

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => FriendManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => ExercisesManager(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => PlanilhaManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => ExerciciosPlanilhaManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => PersonalManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => AmigosProcuradosManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => AdsManager(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => CoreAppController(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => MeAjudaController(),
          lazy: false,
        ),
      ],
      child: MaterialApp(
        title: 'Treino Fácil',
        theme: ThemeData(
          primarySwatch: Colors.amber,
          primaryColor: AppColors.mainColor,
          useMaterial3: false,
        ),
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return MediaQuery(
            child: child!,
            data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(1.0)),
          );
        },
        initialRoute: AppRoutes.splash,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
