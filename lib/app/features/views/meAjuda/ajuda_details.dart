import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:tabela_treino/app/ads/ads_model.dart';
import 'package:tabela_treino/app/core/core.dart';
import 'package:tabela_treino/app/features/views/planilhas/components/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AjudaDetailsScreen extends StatefulWidget {
  final String title;
  final String description;
  final String link;

  const AjudaDetailsScreen({
    @required this.title,
    @required this.description,
    @required this.link,
  });

  @override
  _AjudaDetailsScreenState createState() => _AjudaDetailsScreenState();
}

class _AjudaDetailsScreenState extends State<AjudaDetailsScreen> {
  //* ADS
  InterstitialAd interstitialAdMuscle;
  bool isInterstitialReady = false;

  void _loadInterstitialAd() {
    interstitialAdMuscle.load();
  }

  void _onInterstitialAdEvent(MobileAdEvent event) {
    switch (event) {
      case MobileAdEvent.loaded:
        isInterstitialReady = true;
        break;
      case MobileAdEvent.failedToLoad:
        log('Failed to load an interstitial ad. Error: $event'.toUpperCase());
        isInterstitialReady = false;
        break;
      default:
      // do nothing
    }
  }

  @override
  void initState() {
    super.initState();

    interstitialAdMuscle = InterstitialAd(
      adUnitId: interstitialAdUnitId(),
      listener: _onInterstitialAdEvent,
    );
    _loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Padding(
        padding: MediaQuery.of(context).viewInsets * 0.5,
        child: Container(
            height: height * 0.95,
            child: Container(
                height: height * 0.95,
                decoration: new BoxDecoration(
                    color: AppColors.grey,
                    borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(25.0),
                        topRight: const Radius.circular(25.0))),
                child: Padding(
                  padding: EdgeInsets.only(top: 18.0, right: 18, left: 18),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () async {
                                String message =
                                    '*${widget.title}*\n\n${widget.description.replaceAll("\\n", "\n")}\n\nBaixe de graça o aplicativo Treino Fácil e comece a montar seus treinos ainda hoje: https://bityli.com/UAxpM!';
                                await Share.share(message);

                                if (isInterstitialReady) {
                                  await interstitialAdMuscle.show();
                                }
                              },
                              icon: Icon(
                                Icons.share,
                                color: AppColors.mainColor,
                                size: 28,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.close_rounded,
                                color: AppColors.mainColor,
                                size: 28,
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: AutoSizeText(
                            widget.title,
                            style: TextStyle(
                                fontFamily: AppFonts.gothamBold,
                                color: AppColors.white,
                                fontSize: 28.0),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: AutoSizeText(
                            widget.description.replaceAll("\\n", "\n"),
                            style: TextStyle(
                                height: 1.1,
                                fontFamily: AppFonts.gothamLight,
                                color: AppColors.white,
                                fontSize: 18.0),
                          ),
                        ),
                        if (widget.link.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: Center(
                              child: CustomButton(
                                height: 40,
                                width: width * 0.95,
                                text: 'Acessar Post com Ilustrações'
                                    .toUpperCase(),
                                color: AppColors.mainColor,
                                textColor: AppColors.grey,
                                onTap: () {
                                  launch(widget.link);
                                },
                              ),
                            ),
                          )
                        ]
                      ],
                    ),
                  ),
                ))));
  }
}
