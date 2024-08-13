import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/personal/personal_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/shared/dialogs/show_dialog.dart';

import 'components/card_request.dart';

class RequestListPage extends StatefulWidget {
  @override
  _RequestListPageState createState() => _RequestListPageState();
}

class _RequestListPageState extends State<RequestListPage> {

  RewardedAd? _rewardedAd;

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
              log('Dismissed AD after rewarded');
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _loadRewardedAd();
    // listenerRewardedEvent();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Consumer2<UserManager, PersonalManager>(builder: (_, userManager, personalManager, __) {
      if (personalManager.loading)
        return Center(
          child: CircularProgressIndicator(),
        );
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            personalManager.personalRequestList.isEmpty
                ? Container(
                    height: height * 0.8,
                    width: width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sentiment_dissatisfied_rounded, size: 52, color: AppColors.mainColor),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Você não possui nenhum\npedido de conexão",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 22, fontFamily: AppFonts.gothamBook, color: Colors.white, height: 1.2),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    padding: EdgeInsets.all(7),
                    itemCount: personalManager.personalRequestList.length,
                    itemBuilder: (context, index) {
                      return CardRequest(
                        personal: personalManager.personalRequestList[index],
                        aceitarPedido: () async {
                          await showCustomDialogOpt(
                            context: context,
                            title: 'Aceitar Pedido?',
                            VoidCallBack: () async {
                              Navigator.pop(context);
                              final response =
                                  await personalManager.acceptPersonalRequest(personal: personalManager.personalRequestList[index], user: userManager.user);

                              if (response != null) {
                                mostrarSnackBar(response, AppColors.red);
                              } else {
                                if (_rewardedAd != null) {
                                  _rewardedAd?.show(
                                    onUserEarnedReward: (_, __) async {
                                      await context.read<PersonalManager>().loadMyPersonal(
                                            idUser: context.read<UserManager>().user.id!,
                                          );
                                    },
                                  );
                                } else {
                                  await context.read<PersonalManager>().loadMyPersonal(
                                        idUser: context.read<UserManager>().user.id!,
                                      );
                                }
                              }
                            },
                            message:
                                'Ao realizar essa ação seus pedidos de conexão serão apagados e ${personalManager.personalRequestList[index].personalName!.split(" ")[0]} será seu atual Personal.',
                          );
                        },
                        excluirPedido: () async {
                          await showCustomDialogOpt(
                              context: context,
                              title: 'Excluir Pedido?',
                              isDeleteMessage: true,
                              VoidCallBack: () async {
                                final response = await personalManager.deletePersonalRequest(
                                    requestId: personalManager.personalRequestList[index].id!, userId: userManager.user.id!);

                                if (response != null) {
                                  mostrarSnackBar(response, AppColors.red);
                                } else {
                                  Navigator.pop(context);
                                }
                              },
                              message:
                                  'Ao realizar essa ação o pedido de conexão de ${personalManager.personalRequestList[index].personalName} será excluído.');
                        },
                      );
                    })
          ],
        ),
      );
    });
  }

  void mostrarSnackBar(String message, Color color) {
    SnackBar snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
    );

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
