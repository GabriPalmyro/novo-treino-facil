import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/views/alunos/alunos_screen.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/home/home_screen.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/lista_exercicios.dart';
import 'package:tabela_treino/app/features/views/perfil/perfil_screen.dart';
import 'package:tabela_treino/app/features/views/personal/personal_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/planilha_screen.dart';
import 'package:tabela_treino/app/features/views/register/register_screen.dart';
import '/app/core/core.dart';
import '/app/features/controllers/user/user_controller.dart';

import 'features/controllers/planilha/planilha_manager.dart';
import 'features/views/login/login_screen.dart';
import 'shared/services/pushNotifications/push_notification_service.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

FirebaseAuth _auth = FirebaseAuth.instance;
final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class _MyAppState extends State<MyApp> {
  // void displayBanner() {
  //   myBanner
  //     ..load()
  //     ..show(
  //       anchorOffset: -2,
  //       anchorType: AnchorType.bottom,
  //     ).then((value) {
  //       print("anuncio mostrado");
  //       padding = 0;
  //       print(padding);
  //     }).catchError((_) {
  //       print("ERRO $_");
  //       padding = 0;
  //       print(padding);
  //     });
  // }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    // myBanner?.dispose();
    // myInterstitial?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // FirebaseAdMob.instance
    //     .initialize(appId: "ca-app-pub-7831186229252322~9095625736");
  }

  @override
  Widget build(BuildContext context) {
    final pushNotificationService = PushNotificationService(_firebaseMessaging);
    pushNotificationService.initialise();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserManager(),
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
      ],
      child: MaterialApp(
        title: 'Treino Fácil',
        theme: ThemeData(
          primarySwatch: Colors.amber, //descobrir cor boa
          primaryColor: AppColors.mainColor,
        ),
        debugShowCheckedModeBanner: false,
        // supportedLocales: const [
        //   Locale('pt', 'BR'),
        //   Locale('en', ''),
        // ],
        builder: (context, child) {
          return MediaQuery(
            child: child,
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          );
        },
        //home: LoginScreen(),
        initialRoute:
            _auth.currentUser == null ? AppRoutes.login : AppRoutes.home,
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          switch (settings.name) {
            case AppRoutes.login:
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case AppRoutes.register:
              return MaterialPageRoute(builder: (_) => RegisterScreen());
            case AppRoutes.home:
              return MaterialPageRoute(builder: (_) => HomeScreen());
            case AppRoutes.meuPerfil:
              return MaterialPageRoute(builder: (_) => MeuPerfiLScreen());
            case AppRoutes.listaExercicios:
              return MaterialPageRoute(builder: (_) => ListaExerciciosScreen());
            case AppRoutes.planilhas:
              return MaterialPageRoute(builder: (_) => PlanilhaScreen());
            case AppRoutes.exerciciosPlanilha:
              return MaterialPageRoute(
                  builder: (_) => ExerciciosPlanilhaScreen(arguments));
            case AppRoutes.alunos:
              return MaterialPageRoute(builder: (_) => AlunosScreen());
            case AppRoutes.personal:
              return MaterialPageRoute(builder: (_) => PersonalScreen());
            default:
              return null;
          }
        },
        /*_auth.currentUser == null
            ? LoginScreen(padding)
            : HomeTab(padding),*/
      ),
    );
  }
}
