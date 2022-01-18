import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/core/app_routes.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/card_friend.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/search_bar.dart';

class BuscarAmigosScreen extends StatefulWidget {
  @override
  _BuscarAmigosScreenState createState() => _BuscarAmigosScreenState();
}

class _BuscarAmigosScreenState extends State<BuscarAmigosScreen> {
  TextEditingController nicknameController = TextEditingController();
  FocusNode nicknameNode = FocusNode();

  List<User> friends = [];

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
          "Procurar",
          style: TextStyle(
              color: Colors.grey[850],
              fontFamily: AppFonts.gothamBold,
              fontSize: 24),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      backgroundColor: const Color(0xff313131),
      body: Consumer<UserManager>(builder: (_, userManager, __) {
        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                        node: nicknameNode,
                        controller: nicknameController,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width * 0.05, top: 18.0),
                      child: Text(
                        'Pessoas',
                        style: TextStyle(
                            fontFamily: AppFonts.gothamBold,
                            color: AppColors.white,
                            fontSize: 26.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: ListView.builder(
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
                                    onTap: () {
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
                  ],
                ),
              ),
            ),
            if (userManager.loading) ...[
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
