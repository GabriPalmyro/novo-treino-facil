import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tabela_treino/app/features/controllers/core/core_controller.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/home/components/home_button.dart';
import 'package:tabela_treino/app/features/views/home/components/planilha_widget.dart';
import 'package:tabela_treino/app/features/views/home/components/update_to_premium_dialog.dart';
import 'package:tabela_treino/app/features/views/perfil/perfil_screen.dart';
import 'package:tabela_treino/app/shared/shimmer/skeleton.dart';

import '/app/core/core.dart';
import '/app/features/controllers/user/user_controller.dart';
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

  bool _isLoading = false;

  ScrollController scrollController = ScrollController();

  List<Planilha> planilhas = [];
  bool dayHasTraining = false;
  int? indexDay;

  List<String> daysOfTheWeek = [
    'Sunday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Monday',
  ];

  List<String> diasDaSemana = ['Segunda-Feira', 'Terça-Feira', 'Quarta-Feira', 'Quinta-Feira', 'Sexta-Feira', 'Sábado', 'Domingo'];

  String homeMessage() {
    if (TimeOfDay.now().hour > 14) {
      return 'Já realizou seu treino de hoje?';
    } else {
      return 'Vamos treinar?';
    }
  }

  int dayOfTheWeek(String day) {
    switch (day) {
      case 'Monday':
        return 0;
      case 'Tuesday':
        return 1;
      case 'Wednesday':
        return 2;
      case 'Thursday':
        return 3;
      case 'Friday':
        return 4;
      case 'Saturday':
        return 5;
      case 'Sunday':
        return 6;
      default:
        return 0;
    }
  }

  void filterDay() async {
    planilhas.clear();

    await context.read<PlanilhaManager>().loadWorksheetList();

    String todayDayOfWeek = DateFormat('EEEE').format(DateTime.now());

    indexDay = dayOfTheWeek(todayDayOfWeek);

    context.read<PlanilhaManager>().listaPlanilhas.forEach((element) {
      if (element.diasDaSemana![indexDay!].isSelected && element.diasDaSemana![indexDay!].dia == diasDaSemana[indexDay!]) {
        dayHasTraining = true;
        planilhas.add(element);
      }
    });

    if (planilhas.isEmpty) planilhas = context.read<PlanilhaManager>().listaPlanilhas;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.grey,
      body: Consumer2<UserManager, PlanilhaManager>(
        builder: (_, userManager, planManager, __) {
          final isPayUser = userManager.user.isPayApp;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _isLoading = true;
              });
              await userManager.loadCurrentUser();
              await planManager.loadWorksheetList();
              filterDay();
              setState(() {
                _isLoading = false;
              });
            },
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: MediaQuery.of(context).padding.top),
                  if (userManager.loading || _isLoading) ...[
                    Shimmer.fromColors(
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.lightGrey.withOpacity(0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 12.0, top: 18.0),
                            child: Skeleton(
                              height: 50,
                              width: width * 0.5,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12.0,
                            ),
                            child: Skeleton(
                              height: 40,
                              width: width * 0.75,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      padding: const EdgeInsets.only(top: 24),
                      margin: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Olá, ${capitalizeString(userManager.user.name ?? '')}",
                                style: TextStyle(fontFamily: AppFonts.gothamBold, fontSize: 33, color: AppColors.mainColor),
                              ),
                              Text(
                                !dayHasTraining ? homeMessage() : 'Como você está hoje?',
                                style: TextStyle(fontFamily: AppFonts.gothamLight, fontSize: 18, color: AppColors.white),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.meuPerfil);
                              },
                              child: Hero(
                                tag: 'userPhoto',
                                child: UserPhotoWidget(
                                  photo: userManager.user.photoURL,
                                  size: Size(50, 50),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  if (userManager.loading || _isLoading) ...[
                    Shimmer.fromColors(
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.lightGrey.withOpacity(0.6),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Skeleton(
                                  height: 90,
                                  width: width * 0.43,
                                ),
                                SizedBox(
                                  width: 14.0,
                                ),
                                Skeleton(
                                  height: 90,
                                  width: width * 0.43,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 12.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Skeleton(
                                  height: 80,
                                  width: (width / 2) * 0.83,
                                  // (width / 3) * 0.8,
                                ),
                                Skeleton(
                                  height: 80,
                                  width: (width / 2) * 0.83,
                                  // (width / 3) * 0.8,
                                ),
                                if (context.read<CoreAppController>().coreInfos.mostrarTreinosFaceis!) ...[
                                  Skeleton(
                                    height: 80,
                                    width: (width / 3) * 0.82,
                                  )
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 24, 12, 12),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              HomeButton(
                                width: width * 0.43,
                                title: 'Exercícios',
                                icon: Icons.line_weight,
                                iconePath: AppImages.listaExercicios,
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.listaExercicios);
                                },
                              ),
                              SizedBox(
                                width: 14.0,
                              ),
                              HomeButton(
                                width: width * 0.43,
                                title: 'Amigos',
                                icon: Icons.people_alt_outlined,
                                iconePath: AppImages.amigos,
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.buscarAmigos);
                                },
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 14.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HomeButtonMin(
                                width: (width / 2) * 0.85,
                                // (width / 3) * 0.8,
                                title: 'Exercícios Personalizados',
                                iconePath: AppImages.meusExercicios,
                                onTap: () {
                                  Navigator.pushNamed(context, AppRoutes.meusExercicios);
                                },
                              ),
                              HomeButtonMin(
                                width: (width / 2) * 0.85,
                                // (width / 3) * 0.8,
                                title: userManager.user.isPersonal ?? false ? "Alunos" : "Personal\nTrainer",
                                iconePath: AppImages.personal,
                                onTap: () {
                                  if (userManager.user.isPersonal ?? false) {
                                    Navigator.pushNamed(context, AppRoutes.alunos);
                                  } else {
                                    Navigator.pushNamed(context, AppRoutes.personal);
                                  }
                                },
                              ),
                              if (context.read<CoreAppController>().coreInfos.mostrarTreinosFaceis ?? false) ...[
                                HomeButtonMin(
                                  width: (width / 3) * 0.8,
                                  title: 'Treinos Fáceis - Crie treinos com IA',
                                  iconePath: AppImages.treinosFaceis,
                                  onTap: () {},
                                )
                              ],
                            ],
                          ),
                          if (context.read<CoreAppController>().coreInfos.mostrarIaTraining ?? false) ...[
                            SizedBox(height: 14.0),
                            HomeButtonMin(
                              width: width * 0.9,
                              title: 'Crie treinos com IA',
                              iconePath: AppImages.treinosFaceis,
                              isAvailable: isPayUser || userManager.user.availableIATrainingGenerations > 0,
                              valueLabel: isPayUser ? null : userManager.user.availableIATrainingGenerations.toString(),
                              valueTitle: 'Treinos Restantes',
                              onTap: () {
                                if (!isPayUser && userManager.user.availableIATrainingGenerations <= 0) {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
                                    builder: (_) => const UpdateToPremiumBottomSheet(),
                                  );
                                  return;
                                }

                                Navigator.pushNamed(context, AppRoutes.generateIaTraining);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                  if (userManager.loading || _isLoading) ...[
                    Shimmer.fromColors(
                      baseColor: AppColors.lightGrey,
                      highlightColor: AppColors.lightGrey.withOpacity(0.6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 24.0,
                              left: 12.0,
                            ),
                            child: Skeleton(
                              height: 40,
                              width: width * 0.65,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6.0, bottom: 12.0),
                            child: Row(
                              children: List.generate(
                                  2,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Skeleton(height: 100, width: width * 0.4),
                                      )),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 18.0, right: 18.0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, AppRoutes.planilhas, arguments: userManager.user.id);
                        },
                        highlightColor: AppColors.mainColor.withOpacity(0.3),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            planilhas.isNotEmpty ? 'Acessar meus treinos' : 'Clique aqui para criar o seu primeiro treino',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20, fontFamily: AppFonts.gothamBold, color: AppColors.mainColor),
                          ),
                        ),
                      ),
                    ),
                    if (dayHasTraining) ...[
                      Padding(
                        padding: const EdgeInsets.only(left: 22.0),
                        child: Text(
                          'Seu treino de hoje é:',
                          style: TextStyle(fontFamily: AppFonts.gothamLight, fontSize: 18, color: AppColors.white),
                        ),
                      ),
                    ],
                    SingleChildScrollView(
                      controller: scrollController,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.only(left: 8.0, top: dayHasTraining ? 5.0 : 0),
                        child: Row(
                          children: List.generate(planilhas.length, (index) {
                            return PlanilhaContainer(
                              onTap: () {
                                Navigator.pushNamed(context, AppRoutes.exerciciosPlanilha,
                                    arguments: ExerciciosPlanilhaArguments(
                                      title: planilhas[index].title!,
                                      idPlanilha: planilhas[index].id!,
                                      idUser: userManager.user.id!,
                                    ));
                              },
                              title: planilhas[index].title ?? '',
                              description: planilhas[index].description ?? '',
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                  if ((context.read<CoreAppController>().coreInfos.showPremium ?? false) && !isPayUser) ...[
                    SizedBox(height: 14.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: HomeButtonMin(
                        width: width,
                        title: 'Atualizar para o Plano Premium',
                        iconePath: AppImages.premium,
                        isAvailable: true,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (_) => const UpdateToPremiumBottomSheet(),
                          );
                        },
                      ),
                    ),
                  ],
                  if (context.read<CoreAppController>().coreInfos.mostrarAjudas!) ...[
                    if (userManager.loading || _isLoading) ...[
                      Shimmer.fromColors(
                        baseColor: AppColors.lightGrey,
                        highlightColor: AppColors.lightGrey.withOpacity(0.6),
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 12.0,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Skeleton(
                              height: 100,
                              width: width * 0.9,
                            ),
                          ),
                        ),
                      )
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 12, 12, 65),
                        child: Align(
                          alignment: Alignment.center,
                          child: HomeButton(
                            width: width * 0.9,
                            title: 'Me Ajuda',
                            description: 'sdasdasdasdasdasd',
                            fontSize: 28,
                            icon: Icons.help,
                            iconePath: AppImages.ajudas,
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.meAjuda);
                            },
                          ),
                        ),
                      ),
                    ]
                  ],
                  const SizedBox(height: 50),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
