import 'package:flutter/material.dart';
import 'package:overlock/router/ui_pages.dart';
import 'package:provider/provider.dart';
import 'package:stacked_card_carousel/stacked_card_carousel.dart';

import '../../app_state.dart';
import '../../constants.dart';
import 'pollPages.dart';

class stackedCardMain extends StatelessWidget {
  final List<Widget> fancyCards = [
    FancyCard(
      image: Image.asset("assets/images/6.jpg"),
      title: "부실급식 문제",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다",
      pollName: "투표1",
    ),
    FancyCard(
      image: Image.asset("assets/images/2.jpg"),
      title: "군 의료체계 문제",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다.",
      pollName: "투표2",
    ),
    FancyCard(
      image: Image.asset("assets/images/3.jpg"),
      title: "코로나 격리실태",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다. ",

      pollName: "투표3",
    ),
    FancyCard(
      image: Image.asset("assets/images/4.jpg"),
      title: "대대장 갑질",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다. ",
      pollName: "투표4",
    ),
    FancyCard(
      image: Image.asset("assets/images/5.jpg"),
      title: "부대시설 여건 미흡",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다. ",
      pollName: "투표5",
    ),
    FancyCard(
      image: Image.asset("assets/images/1.jpg"),
      title: "취사병 혹사 문제",
      contents: "저는 5월 31일에 x사단 xx 신병교육대대로 입영했던 한 훈련병입니다. ",
      pollName: "투표6",
    )
  ];

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemHeight = size.height;
    final appState = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("투표"),
            IconButton(
              icon: const Icon(Icons.settings, size: 18, color: Colors.white,),
              onPressed: () => appState.currentAction = PageAction(
                  state: PageState.addPage, page: SettingsPageConfig),
            ),
          ],
        ),
        backgroundColor: kPrimaryColor,
      ),
      body: StackedCardCarousel(
        initialOffset: 0,
        type: StackedCardCarouselType.fadeOutStack,
        spaceBetweenItems: itemHeight * 0.77,
        items: fancyCards,
      ),
    );
  }
}

class FancyCard extends StatelessWidget {
  const FancyCard(
      {Key key, this.image, this.title, this.pollName, this.contents})
      : super(key: key);

  final Image image;
  final String title;
  final String pollName;
  final String contents;

  @override
  Widget build(BuildContext context) {
    final query = MediaQuery.of(context);
    final size = query.size;
    final itemWidth = size.width;
    final itemHeight = size.height;

    return Card(
      elevation: 4.0,
      child: InkWell(
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => pollPages(pollName, contents),
              ))
        },
        child: Stack(
          children: <Widget>[
            Container(
              width: itemWidth,
              height: itemHeight * 0.74,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(900))),
              child: FittedBox(
                child: image,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 8, right: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title,
                      style: Theme.of(context).textTheme.headline5.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  Container(
                    height: itemHeight * 0.58,
                  ),
                  SizedBox(
                    height: 30,
                    child: FlatButton.icon(
                        icon: Icon(
                          Icons.account_circle_outlined,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text("참여: 10,000명",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white, fontSize: 16))),
                  ),
                  SizedBox(
                    height: 30,
                    child: FlatButton.icon(
                        icon: Icon(
                          Icons.how_to_vote,
                          size: 16,
                          color: Colors.white,
                        ),
                        label: Text("참여기간: 21.06.14~21.07.15",
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: Colors.white, fontSize: 16))),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
