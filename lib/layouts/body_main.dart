import 'package:flutter/material.dart';
import 'package:flutter_anime_app/screens/home.dart';
import 'package:flutter_anime_app/screens/favorite.dart';

class BodyMain extends StatelessWidget {

  List<Widget> topTabs;
  Function(int) onPageChanged;
  TabController topController;
  PageController bottomController;

  BodyMain({
    Key key,
    this.topTabs,
    this.onPageChanged,
    this.topController,
    this.bottomController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: [
        Home(
          topTabs: topTabs,
          topController: topController,
        ),
        Favorite()
      ],
      controller: bottomController,
      onPageChanged: onPageChanged,
    );
  }
}