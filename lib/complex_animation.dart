import 'package:flutter/material.dart';
import 'package:flutter_animation/widget/positioned_boom_menu.dart';
import 'package:flutter_animation/widget/circular_menu.dart';

import 'complex_animation/floating_action_bubble_demo.dart';

class ComplexAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Center(
      child: Wrap(
        children: <Widget>[
          PositionedBoomMenu(
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            onOpen: () => print("open"),
            onClose: () => print("close"),
            scrollVisible: true,
            overlayColor: Colors.black,
            overlayOpacity: 0.7,
            children: <BoomMenuItem>[
              BoomMenuItem(
//          child: Icon(Icons.accessibility, color: Colors.black, size: 40,),
                child: Icon(Icons.ac_unit),
                title: "Logout",
                titleColor: Colors.grey[850],
                subtitle: "Lorem ipsum dolor sit amet, consectetur",
                subTitleColor: Colors.grey[850],
                backgroundColor: Colors.grey[50],
                onTap: () => print('THIRD CHILD'),
              ),
              BoomMenuItem(
                child: Icon(Icons.ac_unit),
                title: "List",
                titleColor: Colors.white,
                subtitle: "Lorem ipsum dolor sit amet, consectetur",
                subTitleColor: Colors.white,
                backgroundColor: Colors.pinkAccent,
                onTap: () => print('FOURTH CHILD'),
              ),
              BoomMenuItem(
                child: Icon(Icons.ac_unit),
                title: "Team",
                titleColor: Colors.grey[850],
                subtitle: "Lorem ipsum dolor sit amet, consectetur",
                subTitleColor: Colors.grey[850],
                backgroundColor: Colors.grey[50],
                onTap: () => print('THIRD CHILD'),
              ),
              BoomMenuItem(
                child: Icon(Icons.ac_unit),
                title: "Profile",
                titleColor: Colors.white,
                subtitle: "Lorem ipsum dolor sit amet, consectetur",
                subTitleColor: Colors.white,
                backgroundColor: Colors.blue,
                onTap: () => print('FOURTH CHILD'),
              )
            ],
          ),
          FloatingActionBubbleDemo(),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
          Container(
            width: 200,
            height: 200,
            color: Colors.blue,
          ),
        ],
      ),
    ));
  }
}
