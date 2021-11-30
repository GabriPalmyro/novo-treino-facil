import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/home/components/home_button.dart';
import 'package:tabela_treino/app/features/views/home/components/planilha_widget.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';
import '/app/core/core.dart';
import '/app/features/controllers/user/user_controller.dart';
import '/app/features/views/home/components/loading_screen.dart';
import '/app/helpers/name_formats.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    filterDay();
  }

  ScrollController scrollController = ScrollController();

  List<Planilha> planilhas = [];
  bool dayHasTraining = false;
  int indexDay;

  List<String> daysOfTheWeek = [
    'Sunday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Monday',
  ];

  List<String> diasDaSemana = [
    'Segunda-Feira',
    'Terça-Feira',
    'Quarta-Feira',
    'Quinta-Feira',
    'Sexta-Feira',
    'Sábado',
    'Domingo'
  ];

  String homeMessage() {
    if (TimeOfDay.now().hour > 14) {
      return 'Já realizou seu treino de hoje?';
    } else {
      return 'Vamos treinar?';
    }
  }

  int dayOfTheWeek(String day) {
    switch (day) {
      case 'Sunday':
        return 0;
        break;
      case 'Tuesday':
        return 1;
        break;
      case 'Wednesday':
        return 2;
        break;
      case 'Thursday':
        return 3;
        break;
      case 'Friday':
        return 4;
        break;
      case 'Saturday':
        return 5;
        break;
      case 'Monday':
        return 6;
        break;
      default:
        return null;
    }
  }

  void filterDay() async {
    planilhas.clear();

    await context.read<PlanilhaManager>().loadWorksheetList();

    String todayDayOfWeek = DateFormat('EEEE').format(DateTime.now());

    indexDay = dayOfTheWeek(todayDayOfWeek);

    context.read<PlanilhaManager>().listaPlanilhas.forEach((element) {
      if (element.diasDaSemana[indexDay].isSelected &&
          element.diasDaSemana[indexDay].dia == diasDaSemana[indexDay]) {
        dayHasTraining = true;
        planilhas.add(element);
      }
    });

    if (planilhas.isEmpty)
      planilhas = context.read<PlanilhaManager>().listaPlanilhas;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(pageNow: 0),
      appBar: AppBar(
        toolbarHeight: 70,
        shadowColor: Colors.grey[850],
        elevation: 25,
        centerTitle: true,
        title: Text(
          "Início",
          style: TextStyle(
              color: Colors.grey[850],
              fontFamily: AppFonts.gothamBold,
              fontSize: 30),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(
                Icons.notifications,
                size: 28,
              ),
              tooltip: 'Notificações',
              onPressed: () {},
            ),
          ),
        ],
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: const Color(0xff313131),
      body: Consumer2<UserManager, PlanilhaManager>(
        builder: (_, userManager, planManager, __) {
          if (userManager.loading) {
            return HomeLoadingScreen();
          }
          return SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.only(top: 24),
                    margin: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Olá, ${capitalizeString(userManager.user.name)}",
                              style: TextStyle(
                                  fontFamily: AppFonts.gothamBold,
                                  fontSize: 33,
                                  color: AppColors.mainColor),
                            ),
                            Text(
                              !dayHasTraining
                                  ? homeMessage()
                                  : 'Seu treino de hoje é:',
                              style: TextStyle(
                                  fontFamily: AppFonts.gothamThin,
                                  fontSize: 20,
                                  color: AppColors.white),
                            ),
                          ],
                        ),
                      ],
                    )),
                if (!dayHasTraining) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, left: 22.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.planilhas);
                      },
                      child: Text(
                        'Acessar meus treinos',
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: AppFonts.gothamBold,
                            color: AppColors.mainColor),
                      ),
                    ),
                  ),
                ],
                SingleChildScrollView(
                  controller: scrollController,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: 5.0, top: dayHasTraining ? 12.0 : 0),
                    child: Row(
                      children: List.generate(planilhas.length, (index) {
                        return PlanilhaContainer(
                          onTap: () {
                            Navigator.pushNamed(
                                context, AppRoutes.exerciciosPlanilha,
                                arguments: ExerciciosPlanilhaArguments(
                                    planilhas[index].title,
                                    planilhas[index].id));
                          },
                          title: planilhas[index].title,
                          description: planilhas[index].description,
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 10.0),
                  child: Column(
                    children: [
                      HomeButton(
                        title: 'Biblioteca de Exercícios',
                        description:
                            'Uma lista com mais de 150 exercícios para você usar nos seus treinos e executá-los corretamente',
                        isMainColor: true,
                        onTap: () {
                          Navigator.pushNamed(
                              context, AppRoutes.listaExercicios);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: HomeButton(
                          title: 'Pesquisar Amigos',
                          description:
                              'Siga seus amigos e tenha acesso a suas listas de treinos disponíveis',
                          isMainColor: false,
                          onTap: () {
                            Navigator.pushNamed(context, AppRoutes.planilhas);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: HomeButton(
                          title: userManager.user.isPersonal
                              ? "Meus Alunos"
                              : "Meu Personal\nTrainer",
                          description: userManager.user.isPersonal
                              ? 'Controle a planilha de seus alunos ou adicione um aluno novo na sua área de Personal Trainer'
                              : 'Adicione seu Personal Trainer para que ter seus treinos montados remotamente',
                          isMainColor: true,
                          onTap: () {
                            if (userManager.user.isPersonal) {
                              Navigator.pushNamedAndRemoveUntil(
                                  context, AppRoutes.alunos, (route) => false);
                            } else {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  AppRoutes.personal, (route) => false);
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0, bottom: 8),
                        child: HomeButton(
                          title: 'Treinos Fáceis',
                          description:
                              'Lista de treinos prontos para você usar no seu dia a dia',
                          isMainColor: false,
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
