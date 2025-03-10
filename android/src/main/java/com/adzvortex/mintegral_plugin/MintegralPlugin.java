package com.adzvortex.mintegral_plugin;

import android.app.Activity;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;

import com.mbridge.msdk.MBridgeSDK;
import com.mbridge.msdk.newinterstitial.out.MBNewInterstitialHandler;
import com.mbridge.msdk.newinterstitial.out.NewInterstitialListener;
import com.mbridge.msdk.out.MBridgeSDKFactory;
import com.mbridge.msdk.out.MBridgeIds;
import com.mbridge.msdk.out.RewardInfo;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;

public class MintegralPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Activity activity;
  private Context context;
  private MBNewInterstitialHandler interstitialHandler;
  private static final String TAG = "MintegralPlugin";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "mintegral_plugin");
    channel.setMethodCallHandler(this);
    context = flutterPluginBinding.getApplicationContext();
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("initialize")) {
      String appId = call.argument("appId");
      String appKey = call.argument("appKey");

      if (appId != null && appKey != null) {
        MBridgeSDK sdk = MBridgeSDKFactory.getMBridgeSDK();
        Map<String, String> map = sdk.getMBConfigurationMap(appId, appKey);
        sdk.init(map, context.getApplicationContext());
        result.success(true);
      } else {
        result.error("INIT_ERROR", "App ID or App Key is missing", null);
      }
    }
    else if (call.method.equals("loadAd")) {
      String placementId = call.argument("placementId");
      String unitId = call.argument("unitId");

      if (placementId != null && unitId != null) {
        interstitialHandler = new MBNewInterstitialHandler(activity, placementId, unitId);
        interstitialHandler.setInterstitialVideoListener(new NewInterstitialListener() {
          @Override
          public void onLoadCampaignSuccess(MBridgeIds ids) {
            Log.i(TAG, "Ad Loaded: " + ids.toString());

            Map<String, Object> response = new HashMap<>();
            response.put("success", true);
            response.put("adId", ids.getUnitId());

            result.success(response);
          }

          @Override
          public void onResourceLoadSuccess(MBridgeIds ids) {
            Log.i(TAG, "Ad Resources Loaded: " + ids.toString());
          }

          @Override
          public void onResourceLoadFail(MBridgeIds ids, String errorMsg) {
            Map<String, Object> response = new HashMap<>();
            response.put("success", false);
            response.put("error", errorMsg);
            result.success(response);
          }

          @Override
          public void onShowFail(MBridgeIds ids, String errorMsg) {
            Log.e(TAG, "Show Fail: " + errorMsg);
          }

          @Override
          public void onAdShow(MBridgeIds ids) {
            Log.i(TAG, "Ad Displayed");
          }

          @Override
          public void onAdClose(MBridgeIds ids, RewardInfo info) {
            Log.i(TAG, "Ad Closed");
          }

          @Override
          public void onAdClicked(MBridgeIds ids) {
            Log.i(TAG, "Ad Clicked");
          }

          @Override
          public void onVideoComplete(MBridgeIds ids) {
            Log.i(TAG, "Video Completed");
          }

          @Override
          public void onAdCloseWithNIReward(MBridgeIds ids, RewardInfo info) {
            Log.i(TAG, "Reward Ad Closed");
          }

          @Override
          public void onEndcardShow(MBridgeIds ids) {
            Log.i(TAG, "End card Displayed");
          }
        });

        interstitialHandler.load();
      } else {
        result.error("LOAD_ERROR", "Placement ID or Unit ID is missing", null);
      }
    }
    else if (call.method.equals("showAd")) {
      if (interstitialHandler != null && interstitialHandler.isReady()) {
        interstitialHandler.show();
        result.success(true);
      } else {
        result.error("SHOW_ERROR", "Ad is not ready or handler is null", null);
      }
    }
    else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {}

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    activity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {
    activity = null;
  }
}
