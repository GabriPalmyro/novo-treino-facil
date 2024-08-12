import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/controllers/planilha/planilha_manager.dart';
import 'package:tabela_treino/app/features/controllers/user/user_controller.dart';
import 'package:tabela_treino/app/features/views/exerciciosPlanilha/exercicios_planilha_screen.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/card_planilha.dart';
import 'package:tabela_treino/app/shared/shimmer/exerciciosPlanilha/exercicios_planilhas_shimmer.dart';

import 'components/info_dialog.dart';
import 'components/lista_planilha_vazia.dart';
import 'components/nova_planilha_modal.dart';

class PlanilhaScreen extends StatefulWidget {
  final bool isPersonalAcess;
  PlanilhaScreen({this.isPersonalAcess = false});
  @override
  _PlanilhaScreenState createState() => _PlanilhaScreenState();
}

class _PlanilhaScreenState extends State<PlanilhaScreen> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    _initAdUnit();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  void _initAdUnit() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          log('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlanilhaManager>(
      builder: (_, planilhas, __) {
        return Scaffold(
          appBar: AppBar(
            toolbarHeight: 70,
            iconTheme: IconThemeData(
              color: AppColors.mainColor,
            ),
            elevation: 0,
            centerTitle: false,
            actions: [
              IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.circleInfo,
                  size: 25,
                ),
                tooltip: 'Info',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return InfoDialog();
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: IconButton(
                  icon: FaIcon(
                    FontAwesomeIcons.circlePlus,
                    size: 25,
                  ),
                  tooltip: 'Adicionar Nova Planiha',
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (_) => NovaPlanilhaModal(
                        idUser: context.read<UserManager>().user.id!,
                        isPersonalAcess: widget.isPersonalAcess,
                      ),
                    );
                  },
                ),
              ),
            ],
            title: Text(
              "Planilhas",
              style: TextStyle(color: AppColors.mainColor, fontFamily: AppFonts.gothamBold, fontSize: 30),
            ),
            backgroundColor: AppColors.grey,
          ),
          backgroundColor: AppColors.grey,
          body: planilhas.loading
              ? ExerciciosPlanilhaShimmer()
              : planilhas.listaPlanilhas.isEmpty
                  ? PlanilhasVazia(
                      onTap: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => NovaPlanilhaModal(
                            idUser: context.read<UserManager>().user.id!,
                            isPersonalAcess: widget.isPersonalAcess,
                          ),
                        );
                      },
                    )
                  : SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 70.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            if (_bannerAd != null) ...[
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                child: AdWidget(
                                  ad: _bannerAd!,
                                ),
                              ),
                            ],
                            ...List.generate(
                              planilhas.listaPlanilhas.length,
                              (index) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 24),
                                  child: Column(
                                    children: [
                                      CardPlanilha(
                                        onTap: () {
                                          Navigator.pushNamed(context, AppRoutes.exerciciosPlanilha,
                                              arguments: ExerciciosPlanilhaArguments(
                                                  title: planilhas.listaPlanilhas[index].title!,
                                                  idPlanilha: planilhas.listaPlanilhas[index].id!,
                                                  idUser: context.read<UserManager>().user.id!,
                                                  isFriendAcess: false,
                                                  isPersonalAcess: widget.isPersonalAcess));
                                        },
                                        userId: context.read<UserManager>().user.id!,
                                        planilha: planilhas.listaPlanilhas[index],
                                        index: index,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12.0),
                          ],
                        ),
                      ),
                    ),
        );
      },
    );
  }
}
