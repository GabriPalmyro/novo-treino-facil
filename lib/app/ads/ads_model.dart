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
}
