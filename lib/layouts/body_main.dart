import 'package:flutter/material.dart';
import 'package:flutter_anime_app/pages/home_page.dart';
import 'package:flutter_anime_app/pages/favorite_page.dart';

class BodyMain extends StatelessWidget {

  List<Widget> topTabs;
  int currentTopTabIndex;
  Function(int) onPageChanged;
  Function(int) onScreenChanged;
  Function(int) onTopTabChanged;
  TabController topController;
  PageController bottomController;
  FutureBuilder futureBuilderList;

  BodyMain({
    Key key,
    this.topTabs,
    this.onPageChanged,
    this.onScreenChanged,
    this.onTopTabChanged,
    this.topController,
    this.bottomController,
    this.currentTopTabIndex,
    this.futureBuilderList
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        HomePage(
          topTabs: topTabs,
          topController: topController,
          onScreenChanged: onScreenChanged,
          onTopTabChanged: onTopTabChanged,
          currentTopTabIndex: currentTopTabIndex,
          futureBuilderList: futureBuilderList,
        ),
        FavoritePage(
          topTabs: topTabs,
          topController: topController,
          onScreenChanged: onScreenChanged,
          onTopTabChanged: onTopTabChanged,
          currentTopTabIndex: currentTopTabIndex,
          futureBuilderList: futureBuilderList,
        )
      ],
      controller: bottomController,
      onPageChanged: onPageChanged,
    );
  }
}