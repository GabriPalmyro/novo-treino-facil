import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/ads/ads_controller.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';
import 'package:tabela_treino/app/features/controllers/exerciciosPlanilha/exercicios_planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/friend/friend_controller.dart';
import 'package:tabela_treino/app/features/controllers/meAjuda/ajudas_controller.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/models/user/user.dart' as User;
import 'package:tabela_treino/app/features/views/alunos/alunos_screen.dart';
import 'package:tabela_treino/app/features/views/alunos/planilhasAlunos/planilhas_alunos.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/buscar_amigo_screen.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/home/home_screen.dart';
import 'package:tabela_treino/app/features/views/listaExercicios/lista_exercicios.dart';
import 'package:tabela_treino/app/features/views/meAjuda/meajuda_screen.dart';
import 'package:tabela_treino/app/features/views/meusExercicios/meus_exercicios_screen.dart';
import 'package:tabela_treino/app/features/views/perfil/editarPerfil/editar_perfil.dart';
import 'package:tabela_treino/app/features/views/perfil/perfil_screen.dart';
import 'package:tabela_treino/app/features/views/perfilAmigo/perfil_amigo_screen.dart';
import 'package:tabela_treino/app/features/views/personal/personal_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/planilha_screen.dart';
import 'package:tabela_treino/app/features/views/preferencias/preferencias_screen.dart';
import 'package:tabela_treino/app/features/views/register/register_screen.dart';
import 'package:tabela_treino/app/shared/splash/splash.dart';
import '/app/core/core.dart';
import '/app/features/controllers/user/user_controller.dart';

import 'features/controllers/planilha/planilha_manager.dart';
import 'features/views/login/login_screen.dart';
import 'shared/services/pushNotifications/push_notification_service.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'ads/ads_model.dart';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

class _MyAppState extends State<MyApp> {
  void displayBanner() async {
    try {
      startBanner();
      myBanner
        ..load()
        ..show(
          anchorOffset: -2,
          anchorType: AnchorType.bottom,
        );
    } catch (e) {
      log("ERRO AO MOSTRAR ANUNCIO BANNER: $e");
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    myBanner?.dispose();
    myInterstitial?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-7831186229252322~9095625736");
    displayBanner();
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
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          final arguments = settings.arguments;
          switch (settings.name) {
            case AppRoutes.splash:
              return MaterialPageRoute(builder: (_) => SplashScreen());
            case AppRoutes.login:
              return MaterialPageRoute(builder: (_) => LoginScreen());
            case AppRoutes.register:
              return MaterialPageRoute(builder: (_) => RegisterScreen());
            case AppRoutes.home:
              return MaterialPageRoute(builder: (_) => HomeScreen());
            case AppRoutes.meuPerfil:
              return MaterialPageRoute(builder: (_) => MeuPerfiLScreen());
            case AppRoutes.preferencias:
              return MaterialPageRoute(builder: (_) => PreferenciasScreen());
            case AppRoutes.editarPerfil:
              return MaterialPageRoute(builder: (_) => EditarPerfilScreen());
            case AppRoutes.listaExercicios:
              return MaterialPageRoute(builder: (_) => ListaExerciciosScreen());
            case AppRoutes.planilhas:
              return MaterialPageRoute(
                  builder: (_) => PlanilhaScreen(
                        idUser: settings.arguments as String,
                      ));
            case AppRoutes.planilhasAluno:
              return MaterialPageRoute(
                  builder: (_) => PlanilhaAlunoScreen(arguments));
            case AppRoutes.exerciciosPlanilha:
              return MaterialPageRoute(
                  builder: (_) => ExerciciosPlanilhaScreen(arguments));
            case AppRoutes.alunos:
              return MaterialPageRoute(builder: (_) => AlunosScreen());
            case AppRoutes.personal:
              return MaterialPageRoute(builder: (_) => PersonalScreen());
            case AppRoutes.buscarAmigos:
              return MaterialPageRoute(builder: (_) => BuscarAmigosScreen());
            case AppRoutes.perfilAmigo:
              return MaterialPageRoute(
                  builder: (_) => PerfilAmigoScreen(
                      friend: settings.arguments as User.User));
            case AppRoutes.meusExercicios:
              return MaterialPageRoute(builder: (_) => MeusExerciciosScreen());
            case AppRoutes.meAjuda:
              return MaterialPageRoute(builder: (_) => MeAjudaScreen());
            default:
              return null;
          }
        },
      ),
    );
  }
}
