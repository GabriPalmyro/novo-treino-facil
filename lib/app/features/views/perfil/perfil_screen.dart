import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_colors.dart';
import 'package:tabela_treino/app/core/app_routes.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/exercises/exercicios_manager.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/perfil/components/card_option.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';
import 'package:tabela_treino/app/shared/drawer/drawer.dart';

class MeuPerfiLScreen extends StatefulWidget {
  @override
  _MeuPerfiLScreenState createState() => _MeuPerfiLScreenState();
}

class _MeuPerfiLScreenState extends State<MeuPerfiLScreen> {
  @override
  void initState() {
    super.initState();
    carregarMeusExercicios();
  }

  Future<void> carregarMeusExercicios() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      String id = context.read<UserManager>().user.id;
      await context.read<ExercisesManager>().loadMyListExercises(idUser: id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Consumer2<UserManager, PlanilhaManager>(
        builder: (_, userManager, planilhas, __) {
      return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacementNamed(AppRoutes.home);
          return Future.value(true);
        },
        child: Scaffold(
          drawer: CustomDrawer(pageNow: 5),
          appBar: AppBar(
            toolbarHeight: 60,
            shadowColor: Colors.grey[850],
            elevation: 25,
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: const Icon(
                    Icons.settings,
                    size: 28,
                  ),
                  tooltip: 'Configurações',
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.preferencias);
                  },
                ),
              ),
            ],
            title: Text(
              "Perfil",
              style: TextStyle(
                  color: Colors.grey[850],
                  fontFamily: AppFonts.gothamBold,
                  fontSize: 30),
            ),
            backgroundColor: AppColors.mainColor,
          ),
          backgroundColor: const Color(0xff313131),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: width,
                  color: AppColors.grey600,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 24.0),
                        child:
                            UserPhotoWidget(photo: userManager.user.photoURL),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Text(
                          userManager.user.name +
                              ' ' +
                              userManager.user.lastName,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: AppFonts.gothamBook,
                              color: AppColors.white,
                              fontSize: 20,
                              letterSpacing: 1.2),
                        ),
                      ),
                      if (userManager.user.isPersonal) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Text(
                            'Personal Trainer',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontFamily: AppFonts.gothamThin,
                                color: AppColors.white,
                                fontSize: 14,
                                letterSpacing: 1.2),
                          ),
                        ),
                      ],
                      Padding(
                        padding: const EdgeInsets.only(top: 18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 33,
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      planilhas.listaPlanilhas.length
                                          .toString(),
                                      style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Planilhas',
                                        style: TextStyle(
                                          fontFamily: AppFonts.gothamBook,
                                          color: AppColors.mainColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 33,
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      userManager.user.seguindo.toString(),
                                      style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Seguindo',
                                        style: TextStyle(
                                          fontFamily: AppFonts.gothamBook,
                                          color: AppColors.mainColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 33,
                              child: Container(
                                child: Column(
                                  children: [
                                    Text(
                                      userManager.user.seguidores.toString(),
                                      style: TextStyle(
                                        fontFamily: AppFonts.gothamBook,
                                        color: AppColors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: Text(
                                        'Seguidores',
                                        style: TextStyle(
                                          fontFamily: AppFonts.gothamBook,
                                          color: AppColors.mainColor,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.35, vertical: 18.0),
                        child: CustomButton(
                            text: 'Editar Perfil',
                            color: AppColors.grey300,
                            textColor: AppColors.white,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRoutes.editarPerfil);
                            }),
                      )
                    ],
                  ),
                ),
                //CardOption(title: 'Minha Conta', onTap: () {}),
                CardOption(
                    title: 'Meus Exercícios',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.meusExercicios);
                    }),
                CardOption(
                    title: 'Alterar Senha',
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.preferencias);
                    }),
                CardOption(title: 'Alterar Foto de Perfil', onTap: () {}),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CardOption(
                      title: 'Preferências',
                      onTap: () {
                        Navigator.pushNamed(context, AppRoutes.preferencias);
                      }),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class UserPhotoWidget extends StatelessWidget {
  final String photo;

  const UserPhotoWidget({this.photo});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.circular(80),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(80),
        child: Container(
          height: 100,
          width: 100,
          decoration: new BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Image.network(photo, fit: BoxFit.fitWidth, loadingBuilder:
              (BuildContext context, Widget child,
                  ImageChunkEvent loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(child: CircularProgressIndicator());
          }),
        ),
      ),
    );
  }
}
