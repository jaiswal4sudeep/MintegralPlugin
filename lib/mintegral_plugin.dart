import 'package:flutter/services.dart';

typedef InitSuccessCallback = void Function();
typedef InitFailCallback = void Function(String error);
typedef AdLoadCallback = void Function(InterstitialAd? ad, {String? error});

class MintegralPlugin {
  static const MethodChannel _channel = MethodChannel('mintegral_plugin');

  //! Initialize Mintegral SDK
  static Future<void> initialize({
    required String appId,
    required String appKey,
    InitSuccessCallback? onInitSuccess,
    InitFailCallback? onInitFail,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('initialize', {
        'appId': appId,
        'appKey': appKey,
      });
      if (result) {
        onInitSuccess?.call();
      } else {
        onInitFail?.call("Initialization failed");
      }
    } catch (e) {
      onInitFail?.call(e.toString());
    }
  }

  //! Load Ad (DOES NOT SHOW)
  static Future<void> loadAd({
    required String placementId,
    required String unitId,
    required AdLoadCallback adLoadCallback,
  }) async {
    try {
      final Map<dynamic, dynamic> response = await _channel.invokeMethod(
        'loadAd',
        {'placementId': placementId, 'unitId': unitId},
      );

      if (response['success'] == true) {
        adLoadCallback(InterstitialAd(response['adId']));
      } else {
        adLoadCallback(null, error: response['error']);
      }
    } catch (e) {
      adLoadCallback(null, error: e.toString());
    }
  }

  //! Show Ad
  static Future<void> showAd(InterstitialAd ad) async {
    await _channel.invokeMethod('showAd', {'adId': ad.adId});
  }
}

// Placeholder class for InterstitialAd
class InterstitialAd {
  final String adId;
  InterstitialAd(this.adId);

  Future<void> show() async {
    await MintegralPlugin.showAd(this);
  }
}
