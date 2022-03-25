import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/alunos/components/aluno_card.dart';
import 'package:tabela_treino/app/features/views/alunos/components/novo_aluno_modal.dart';
import 'package:tabela_treino/app/features/views/alunos/planilhasAlunos/planilhas_alunos.dart';
import 'package:tabela_treino/app/shared/dialogs/customSnackbar.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

class AlunosScreen extends StatefulWidget {
  @override
  _AlunosScreenState createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen>
    with TickerProviderStateMixin {
  bool isExpanded = true;
  bool loading = true;

  AnimationController expandController;
  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    super.initState();
    carregarAlunosList();
    prepareAnimations();
    _runExpandCheck();
  }

  Future<void> carregarAlunosList() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<UserManager>().carregarAlunos();
      setState(() {
        loading = false;
      });
    });
  }

  ///Setting up the animation
  void prepareAnimations() {
    expandController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    animation = CurvedAnimation(
      parent: expandController,
      curve: Curves.easeInOutCubic,
    );
  }

  void _runExpandCheck() {
    if (isExpanded) {
      expandController.forward();
    } else {
      expandController.reverse();
    }
  }

  @override
  void dispose() {
    expandController.dispose();
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushNamedAndRemoveUntil(
            context, AppRoutes.home, (route) => false);
        return true;
      },
      child: Consumer<UserManager>(builder: (_, userManager, __) {
        return Scaffold(
          drawer: CustomDrawer(pageNow: 4),
          appBar: AppBar(
            toolbarHeight: 70,
            // shadowColor: Colors.grey[850],
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.add_circle_outline,
                    size: 28,
                  ),
                  tooltip: 'Adicionar Novo Aluno',
                  onPressed: () {
                    showModalBottomSheet(
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                        context: context,
                        builder: (_) => NovoAlunoModal());
                  },
                ),
              ),
            ],
            title: Text(
              "Meus Alunos",
              style: TextStyle(
                  color: AppColors.mainColor,
                  fontFamily: AppFonts.gothamBold,
                  fontSize: 30),
            ),
            backgroundColor: AppColors.grey,
          ),
          backgroundColor: AppColors.grey,
          body: loading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Buscando informações de seus alunos',
                          //textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.mainColor,
                              fontFamily: AppFonts.gothamBook,
                              fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )
              : SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 10.0),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.black.withOpacity(0.3),
                                  blurRadius: 5,
                                  offset: Offset(0, 5))
                            ]),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 80,
                                  child: Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: AutoSizeText('Ver Lista de Alunos',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: AppFonts.gothamBold,
                                            color: AppColors.black)),
                                  ),
                                ),
                                Expanded(
                                  flex: 20,
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          isExpanded = !isExpanded;
                                          isExpanded
                                              ? animationController.forward()
                                              : animationController.reverse();

                                          _runExpandCheck();
                                        });
                                      },
                                      child: Tooltip(
                                          message:
                                              isExpanded ? 'Fechar' : 'Abrir',
                                          child: AnimatedIcon(
                                              icon: AnimatedIcons.menu_close,
                                              progress: animationController)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizeTransition(
                              axisAlignment: 1.0,
                              sizeFactor: animation,
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, left: 5.0),
                                child: Container(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: List.generate(
                                        userManager.alunos.length, (index) {
                                      return CardAluno(
                                          acessarPlanilhas: () {
                                            Navigator.pushNamed(context,
                                                AppRoutes.planilhasAluno,
                                                arguments:
                                                    PlanilhaAlunoArguments(
                                                        nomeUser: userManager
                                                            .alunos[index]
                                                            .alunoName,
                                                        idUser: userManager
                                                            .alunos[index]
                                                            .alunoId));
                                          },
                                          excluirAluno: () async {
                                            await showCustomDialogOpt(
                                                context: context,
                                                function: () async {
                                                  String response =
                                                      await userManager
                                                          .deletePersonalAlunoConnection(
                                                              personalId:
                                                                  userManager
                                                                      .user.id,
                                                              userId:
                                                                  userManager
                                                                      .alunos[
                                                                          index]
                                                                      .alunoId);

                                                  if (response != null) {
                                                    Navigator.pop(context);
                                                    mostrarSnackBar(
                                                        context: context,
                                                        message: response,
                                                        color: AppColors.red);
                                                  } else {
                                                    userManager
                                                        .removerPersonalAluno(
                                                            index: index);

                                                    Navigator.pop(context);
                                                  }
                                                },
                                                isDeleteMessage: true,
                                                title: 'Excluir Aluno?',
                                                message:
                                                    'Essa ação irá excluir esse aluno permanentemente.');
                                          },
                                          aluno: userManager.alunos[index]);
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 80.0,
                      )
                    ],
                  ),
                ),
        );
      }),
    );
  }
}
