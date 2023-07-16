import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMobService {
  static String? get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2282149611905342/7620421133';
    }
    return null;
  }

  static String? get interstatitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-2282149611905342/2904502264';
    }
    return null;
  }

  static String? get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return '';
    }
    return null;
  }

  static final BannerAdListener bannerListener = BannerAdListener(
    onAdLoaded: (ad) => debugPrint('Ad Loaded. fort'),
    onAdFailedToLoad: (ad, error) {
      ad.dispose();
      debugPrint('Ad Failed to Load. Mkawda : $error');
    },
    onAdOpened: (ad) => debugPrint('Ad Opened. Nhell'),
    onAdClosed: (ad) => debugPrint('Ad Closes. tbala3'),
  );
}
