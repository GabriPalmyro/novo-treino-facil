import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_routes.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/card_friend.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/search_bar.dart';

class BuscarAmigosScreen extends StatefulWidget {
  @override
  _BuscarAmigosScreenState createState() => _BuscarAmigosScreenState();
}

class _BuscarAmigosScreenState extends State<BuscarAmigosScreen> {
  bool changing = false;

  TextEditingController nicknameController = TextEditingController();
  FocusNode nicknameNode = FocusNode();

  List<User> friends = [];

  @override
  void initState() {
    super.initState();
    carregarProcurados();
  }

  Future<void> carregarProcurados() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AmigosProcuradosManager>().getAmigosProcurados();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        shadowColor: Colors.grey[850],
        elevation: 25,
        centerTitle: true,
        title: Text(
          nicknameController.text.isEmpty ? "Procurados" : "Encontrados",
          style: TextStyle(
              color: Colors.grey[850],
              fontFamily: AppFonts.gothamBold,
              fontSize: 24),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      backgroundColor: const Color(0xff313131),
      body: Consumer2<UserManager, AmigosProcuradosManager>(
          builder: (_, userManager, amigosProcurados, __) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 24.0, right: 12.0, left: 12.0),
                      child: SearchBar(
                        onPressed: () async {
                          nicknameNode.unfocus();
                          friends = await userManager.carregarAmigos(
                              nickname: nicknameController.text);
                        },
                        onSubmitted: (text) async {
                          nicknameNode.unfocus();
                          friends = await userManager.carregarAmigos(
                              nickname: nicknameController.text);
                        },
                        node: nicknameNode,
                        controller: nicknameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.05, top: 18.0),
                      child: Text(
                        'Procurar',
                        style: TextStyle(
                            fontFamily: AppFonts.gothamBold,
                            color: AppColors.white,
                            fontSize: 26.0),
                      ),
                    ),
                    if (nicknameController.text.isEmpty) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: amigosProcurados.amigosProcurados.length,
                            itemBuilder: (_, index) {
                              return CardFriend(
                                nickname: amigosProcurados
                                    .amigosProcurados[index].nickname,
                                name:
                                    '${amigosProcurados.amigosProcurados[index].name} ${amigosProcurados.amigosProcurados[index].lastName}',
                                photoURL: amigosProcurados
                                    .amigosProcurados[index].photoURL,
                                onTap: () async {
                                  Navigator.pushNamed(
                                      context, AppRoutes.perfilAmigo,
                                      arguments: amigosProcurados
                                          .amigosProcurados[index]);
                                },
                              );
                            }),
                      )
                    ] else ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: friends.length,
                            itemBuilder: (_, index) {
                              return userManager
                                      .friends[index].mostrarPerfilPesquisa
                                  ? CardFriend(
                                      nickname: friends[index].nickname,
                                      name:
                                          '${friends[index].name} ${friends[index].lastName}',
                                      photoURL: friends[index].photoURL,
                                      onTap: () async {
                                        await amigosProcurados
                                            .inserirAmigoNaLista(
                                                user: friends[index]);
                                        if (friends[index].id !=
                                            userManager.user.id) {
                                          Navigator.pushNamed(
                                              context, AppRoutes.perfilAmigo,
                                              arguments: friends[index]);
                                        } else {
                                          Navigator.pushNamed(
                                              context, AppRoutes.meuPerfil);
                                        }
                                      },
                                    )
                                  : SizedBox();
                            }),
                      )
                    ]
                  ],
                ),
              ),
            ),
            if (userManager.loading || amigosProcurados.loading) ...[
              LinearProgressIndicator(
                color: AppColors.mainColor,
              )
            ]
          ],
        );
      }),
    );
  }
}
