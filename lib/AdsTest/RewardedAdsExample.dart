import 'package:flutter/material.dart';
import 'package:overlock/AdsTest/AdmobHelper.dart';

class RewardedAdsPage extends StatelessWidget {

  AdmobHelper admobHelper = new AdmobHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){admobHelper.loadRewardedAd();}, child: Text("Load Reward Ads")),
              ElevatedButton(onPressed: (){admobHelper.showRewaredAD();}, child: Text("Show Reward Ads"))
            ],
        ),
      )
    );
  }
}
