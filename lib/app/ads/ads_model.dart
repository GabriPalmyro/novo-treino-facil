import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class AdHelper {
  AdHelper._();

  static const bannerAdIdAndroid = "ca-app-pub-7831186229252322/6549223566";
  static const intertstitialAdIdAndroid = "ca-app-pub-7831186229252322/7884973074";
  static const rewardedVideoAdIdAndroid = "ca-app-pub-7831186229252322/3632888368";
  static const nativeAdIdAndroid = "ca-app-pub-7831186229252322/8542072878";

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdIdAndroid;
    } else if (Platform.isIOS) {
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return intertstitialAdIdAndroid;
    } else if (Platform.isIOS) {
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardedVideoAdIdAndroid;
    } else if (Platform.isIOS) {
      throw UnsupportedError('Unsupported platform');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static Future<void> loadInterstitialAd(Function(InterstitialAd ad) onLoadAd) async {
    await InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              log('Anuncio fechado: ${ad.responseInfo}');
            },
          );

          onLoadAd.call(ad);
        },
        onAdFailedToLoad: (err) {
          unawaited(Sentry.captureException(
            err,
            stackTrace: err.responseInfo,
          ));
          print('Failed to load an interstitial ad: ${err.message}');
        },
      ),
    );
  }
}
