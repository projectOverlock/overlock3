import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:overlock/ui/userInfo/nickNameChange.dart';
import 'package:provider/provider.dart';

import '../app_state.dart';

class AdmobHelper{

  static String get bannerUnit => 'ca-app-pub-2229504227701789/1378091589';



  InterstitialAd _interstitialAd;
  RewardedAd _rewardedAd;

  int num_of_attemtp_load =0;

  static inintailization(){
    if(MobileAds.instance == null)
      {
        MobileAds.instance.initialize();
      }

  }

  void loadRewardedAd(){
    RewardedAd.load(
      adUnitId: 'ca-app-pub-2229504227701789/5787754663',
      request: AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad){
              print("ad loaded");
              this._rewardedAd =ad;
              showRewaredAD();
            },
            onAdFailedToLoad: (LoadAdError error){
              //loadRewaredAD();
            }
        )
    );
  }

  void showRewaredAD() {
    _rewardedAd.show(onUserEarnedReward: (RewardedAd ad, RewardItem rpoint){

      print("Reward Earned is ${rpoint.amount}");


    });
  _rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (RewardedAd ad){

    },
    onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error){
      ad.dispose();
    },
    onAdDismissedFullScreenContent: (RewardedAd ad){
      ad.dispose();
    },
    onAdImpression: (RewardedAd ad) => print('$ad impression occured.')
  );
  }


}