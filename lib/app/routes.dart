import 'package:flutter/material.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/models/user/user.dart' as User;
import 'package:tabela_treino/app/features/views/alunos/alunos_screen.dart';
import 'package:tabela_treino/app/features/views/alunos/planilhasAlunos/planilhas_alunos.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/buscar_amigo_screen.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/components/training_result_screen.dart';
import 'package:tabela_treino/app/features/views/iaTrainings/generate_training_screen.dart';
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
import 'package:tabela_treino/app/features/views/tabs/tabs_screen.dart';
import 'package:tabela_treino/app/shared/splash/splash.dart';

import 'features/views/login/login_screen.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final arguments = settings.arguments;
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      // case AppRoutes.home:
      //   return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRoutes.tabs:
        return MaterialPageRoute(builder: (_) => TabsScreen());
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
            // idUser: settings.arguments as String,
          ),
        );
      case AppRoutes.planilhasAluno:
        return MaterialPageRoute(
          builder: (_) => PlanilhaAlunoScreen(
            arguments as PlanilhaAlunoArguments,
          ),
        );
      case AppRoutes.exerciciosPlanilha:
        return MaterialPageRoute(
          builder: (_) => ExerciciosPlanilhaScreen(
            arguments as ExerciciosPlanilhaArguments,
          ),
        );
      case AppRoutes.alunos:
        return MaterialPageRoute(builder: (_) => AlunosScreen());
      case AppRoutes.personal:
        return MaterialPageRoute(builder: (_) => PersonalScreen());
      case AppRoutes.buscarAmigos:
        return MaterialPageRoute(builder: (_) => BuscarAmigosScreen());
      case AppRoutes.perfilAmigo:
        return MaterialPageRoute(
          builder: (_) => PerfilAmigoScreen(
            friend: settings.arguments as User.User,
          ),
        );
      case AppRoutes.meusExercicios:
        return MaterialPageRoute(builder: (_) => MeusExerciciosScreen());
      case AppRoutes.meAjuda:
        return MaterialPageRoute(builder: (_) => MeAjudaScreen());
      case AppRoutes.generateIaTraining:
        return MaterialPageRoute(builder: (_) => GenerateTrainingScreen());
      case AppRoutes.iaTrainingResult:
        return MaterialPageRoute(builder: (_) => TrainingResultScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text(
                'No route defined for ${settings.name}',
              ),
            ),
          ),
        );
    }
  }
}
