import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/friend/friend_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/planilha/planilha.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/perfil/perfil_screen.dart';
import 'package:tabela_treino/app/shared/buttons/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

import 'components/card_planilha_friend.dart';

class PerfilAmigoScreen extends StatefulWidget {
  final User friend;

  const PerfilAmigoScreen({
    required this.friend,
  });

  @override
  _PerfilAmigoScreenState createState() => _PerfilAmigoScreenState();
}

class _PerfilAmigoScreenState extends State<PerfilAmigoScreen> {
  bool isLoading = true;
  List<Planilha> planilhas = [];
  bool isFollower = false;

  carregarInformacoes() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isFollower = await context.read<UserManager>().checkIsFollowing(friendId: widget.friend.id!);
      await context.read<FriendManager>().loadFriendPlanList(idFriend: widget.friend.id!);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    carregarInformacoes();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 60,
          shadowColor: Colors.grey[850],
          elevation: 25,
          centerTitle: true,
          title: Text(
            "Perfil",
            style: TextStyle(color: Colors.grey[850], fontFamily: AppFonts.gothamBold, fontSize: 24),
          ),
          backgroundColor: AppColors.mainColor,
        ),
        backgroundColor: const Color(0xff313131),
        body: Consumer2<UserManager, FriendManager>(builder: (_, userManager, friendManager, __) {
          return isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Align(alignment: Alignment.center, child: CircularProgressIndicator()),
                    Padding(
                      padding: const EdgeInsets.only(top: 24.0),
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          'Buscando informações de @${widget.friend.nickname}',
                          //textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gothamBook, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )
              : SingleChildScrollView(
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
                              child: UserPhotoWidget(photo: widget.friend.photoURL!),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                widget.friend.fullName(),
                                textAlign: TextAlign.center,
                                style: TextStyle(fontFamily: AppFonts.gothamBook, color: AppColors.white.withOpacity(0.6), fontSize: 20, letterSpacing: 1),
                              ),
                            ),
                            if (widget.friend.isPersonal ?? false) ...[
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: Text(
                                  'Personal Trainer',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontFamily: AppFonts.gothamThin, color: AppColors.white, fontSize: 14, letterSpacing: 1.2),
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
                                            friendManager.listaPlanilhasFriend.length.toString(),
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
                                            widget.friend.seguindo.toString(),
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
                                            widget.friend.seguidores.toString(),
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
                              padding: EdgeInsets.symmetric(horizontal: width * 0.02, vertical: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  CustomButton(
                                      text: isFollower ? 'Seguindo' : 'Seguir',
                                      verticalPad: 10.0,
                                      horizontalPad: 35.0,
                                      color: isFollower ? AppColors.mainColor : AppColors.grey300,
                                      textColor: isFollower ? AppColors.grey600 : AppColors.white,
                                      onTap: () async {
                                        if (!isFollower) {
                                          var response = await userManager.adicionarSeguidor(friend: widget.friend);
                                          if (response == null) {
                                            setState(() {
                                              isFollower = true;
                                            });
                                          }
                                        } else {
                                          var response = await userManager.removerSeguidor(friend: widget.friend);
                                          if (response == null) {
                                            setState(() {
                                              isFollower = false;
                                            });
                                          }
                                        }
                                      }),
                                  CustomButton(
                                      text: 'Contato',
                                      verticalPad: 10.0,
                                      horizontalPad: 40.0,
                                      color: AppColors.grey300,
                                      textColor: AppColors.white,
                                      onTap: () {
                                        String encodeQueryParameters(Map<String, String> params) {
                                          return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
                                        }

                                        final Uri emailLaunchUri = Uri(
                                          scheme: 'mailto',
                                          path: widget.friend.email,
                                          query: encodeQueryParameters(<String, String>{'subject': 'Olá, tudo bem com você?'}),
                                        );

                                        launchUrl(emailLaunchUri);
                                      }),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      if (widget.friend.mostrarPlanilhasPerfil ?? false) ...[
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Container(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: List.generate(friendManager.listaPlanilhasFriend.length, (index) {
                                  final planilha = friendManager.listaPlanilhasFriend[index];
                                  return CardPlanilhaFriend(
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.exerciciosPlanilha,
                                        arguments: ExerciciosPlanilhaArguments(
                                          title: planilha.title!,
                                          idPlanilha: planilha.id!,
                                          idUser: widget.friend.id!,
                                          isFriendAcess: true,
                                        ),
                                      );
                                    },
                                    planilha: friendManager.listaPlanilhasFriend[index],
                                    index: index,
                                  );
                                }),
                              ),
                            ),
                          ),
                        )
                      ] else ...[
                        Container(
                          height: height * 0.3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.do_not_disturb_alt_outlined,
                                color: AppColors.white.withOpacity(0.7),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 12.0,
                                  left: width * 0.02,
                                  right: width * 0.02,
                                ),
                                child: Text(
                                  'Essa pessoa não disponibiliza suas planilhas publicamente',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    height: 1.1,
                                    fontFamily: AppFonts.gothamBook,
                                    color: AppColors.white.withOpacity(0.7),
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ]
                    ],
                  ),
                );
        }));
  }
}
