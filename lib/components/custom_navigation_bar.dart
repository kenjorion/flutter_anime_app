import 'package:flutter/material.dart';

class CustomNavigationBar extends StatelessWidget {

  int currentIndex;
  PageController bottomController;

  CustomNavigationBar({
    Key key, this.currentIndex, this.bottomController
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => {
          this.bottomController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut)
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            title: Text('Favorite'),
          )
        ]
    );
  }
}