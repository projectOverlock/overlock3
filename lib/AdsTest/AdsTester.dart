import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String androidTestUnitId = 'ca-app-pub-3940256099942544/6300978111';

  BannerAd banner;

  List items = [];

  @override
  void initState() {
    super.initState();
    // banner = BannerAd(
    //     listener: BannerAdListener(),
    //     size: AdSize.banner,
    //     adUnitId: androidTestUnitId,
    //     request: AdRequest())
    //   ..load();

    items = List.generate(100, (index) => index);

    for (int i = items.length; i >= 1; i -= 4) {
      items.insert(
          i,
          BannerAd(
              listener: BannerAdListener(),
              size: AdSize.banner,
              adUnitId: androidTestUnitId,
              request: AdRequest())
            ..load());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
                itemBuilder: (_, index) {
                  final item = this.items[index];
                  if (item is int) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Center(
                          child: Text(index.toString()),
                        ),
                      ),
                    );
                  } else {
                    return Container(
                      height: 50.0,
                      child: this.banner == null
                          ? Container()
                          : AdWidget(
                              ad: this.banner,
                            ),
                    );
                  }
                },
                separatorBuilder: (_, index) {
                  return Divider();
                },
                itemCount: this.items.length),
          ),
          // Container(
          //   height: 50.0,
          //   child: this.banner == null
          //       ? Container()
          //       : AdWidget(
          //     ad: this.banner,
          //   ),
          // )
        ],
      ),
    );
  }
}
