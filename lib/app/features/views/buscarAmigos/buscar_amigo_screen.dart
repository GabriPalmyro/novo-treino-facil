import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/ads/ads_controller.dart';
import 'package:tabela_treino/app/features/controllers/amigosProcurados/amigos_procurados_controller.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/models/user/user.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/card_friend.dart';
import 'package:tabela_treino/app/features/views/buscarAmigos/components/search_bar_widget.dart';

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

  InterstitialAd? _interstitialAd;

  Future<void> _loadInterstitialAd() async {
    AdHelper.loadInterstitialAd((ad) {
      setState(() {
        _interstitialAd = ad;
      });
    });
  }

  @override
  void dispose() {
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Consumer2<UserManager, AmigosProcuradosManager>(builder: (_, userManager, amigosProcurados, __) {
      return Scaffold(
          appBar: AppBar(
            toolbarHeight: 60,
            // shadowColor: Colors.grey[850],
            elevation: 0,
            centerTitle: true,
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
            title: SearchBarWidget(
              onPressed: () {
                nicknameController.clear();
              },
              onSubmitted: (text) async {
                nicknameNode.unfocus();
                friends = await userManager.carregarAmigos(nickname: nicknameController.text);
              },
              focusNode: nicknameNode,
              controller: nicknameController,
            ),
            backgroundColor: AppColors.grey,
          ),
          backgroundColor: AppColors.grey,
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: width * 0.04, top: 18.0),
                  child: Text(
                    nicknameController.text.isEmpty
                        ? amigosProcurados.amigosProcurados.isEmpty
                            ? "Nenhum resultado encontrado"
                            : "Recentes"
                        : friends.isEmpty
                            ? userManager.loading || amigosProcurados.loading
                                ? ""
                                : "Nenhum resultado encontrado"
                            : "",
                    style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.white, fontSize: 22.0),
                  ),
                ),
                if (userManager.loading || amigosProcurados.loading) ...[
                  Container(
                    height: 100,
                    padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                        Text(
                          'Procurando "${nicknameController.text}"',
                          style: TextStyle(fontFamily: AppFonts.gotham, color: AppColors.white, fontSize: 14.0),
                        )
                      ],
                    ),
                  )
                ] else if (nicknameController.text.isEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Column(
                      children: [
                        ListView.builder(
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: amigosProcurados.amigosProcurados.length,
                            itemBuilder: (_, index) {
                              return CardFriend(
                                nickname: amigosProcurados.amigosProcurados[index].nickname!,
                                name: '${amigosProcurados.amigosProcurados[index].name} ${amigosProcurados.amigosProcurados[index].lastName}',
                                photoURL: amigosProcurados.amigosProcurados[index].photoURL!,
                                onTap: () async {
                                  await _loadInterstitialAd();
                                  if (_interstitialAd != null && !userManager.user.isPayApp) {
                                    //* VALIDAR ANÚNCIO INTERCALADO 3
                                    int adSeenTimes = await context.read<AdsManager>().getSeenTimesAmigosPerfil();
                                    if (adSeenTimes < 2) {
                                      context.read<AdsManager>().setSeenTimesAmigosPerfil(adSeenTimes + 1);
                                    } else {
                                      await _interstitialAd!.show();
                                      context.read<AdsManager>().setSeenTimesAmigosPerfil(0);
                                    }
                                  }

                                  Navigator.pushNamed(context, AppRoutes.perfilAmigo, arguments: amigosProcurados.amigosProcurados[index]);
                                },
                              );
                            }),
                        if (amigosProcurados.amigosProcurados.isNotEmpty) ...[
                          TextButton(
                            onPressed: () async {
                              await amigosProcurados.deleteHistorico();
                            },
                            child: Text(
                              "Apagar Histórico",
                              style: TextStyle(fontFamily: AppFonts.gothamLight, color: AppColors.white, fontSize: 14.0),
                            ),
                          )
                        ]
                      ],
                    ),
                  )
                ] else if (friends.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: friends.length,
                        itemBuilder: (_, index) {
                          return friends[index].mostrarPerfilPesquisa!
                              ? CardFriend(
                                  nickname: friends[index].nickname!,
                                  name: '${friends[index].name} ${friends[index].lastName}',
                                  photoURL: friends[index].photoURL!,
                                  onTap: () async {
                                    if (friends[index].id != userManager.user.id) {
                                      await amigosProcurados.inserirAmigoNaLista(user: friends[index]);
                                      Navigator.pushNamed(context, AppRoutes.perfilAmigo, arguments: friends[index]);
                                    } else {
                                      Navigator.pushNamed(context, AppRoutes.meuPerfil);
                                    }
                                  },
                                )
                              : SizedBox();
                        }),
                  )
                ]
              ],
            ),
          ));
    });
  }
}
