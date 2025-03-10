import 'package:flutter/services.dart';

typedef InitSuccessCallback = void Function();
typedef InitFailCallback = void Function(String error);
typedef AdLoadCallback = void Function(bool success, {String? error});

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

  //! Load and Show Interstitial Ad
  static Future<void> loadAndShowAd({
    required String placementId,
    required String unitId,
    required AdLoadCallback adLoadCallback,
  }) async {
    try {
      final bool success = await _channel.invokeMethod('loadAndShowAd', {
        'placementId': placementId,
        'unitId': unitId,
      });

      adLoadCallback(success);
    } catch (e) {
      adLoadCallback(false, error: e.toString());
    }
  }
}
