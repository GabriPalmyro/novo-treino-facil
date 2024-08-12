import 'dart:io';

class AdHelper {
  static const bannerAdIdAndroid = "ca-app-pub-7831186229252322/6549223566";
  static const intertstitialAdIdAndroid = "ca-app-pub-7831186229252322/7884973074";
  static const rewardedVideoAdIdAndroid = "ca-app-pub-7831186229252322/3632888368";
  static const nativeAdIdAndroid = "ca-app-pub-7831186229252322/8542072878";

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdIdAndroid;
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_BANNER_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return interstitialAdUnitId;
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_INTERSTITIAL_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return rewardedAdUnitId;
    } else if (Platform.isIOS) {
      return '<YOUR_IOS_REWARDED_AD_UNIT_ID>';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
