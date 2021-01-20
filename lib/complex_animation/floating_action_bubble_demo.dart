import 'package:flutter/material.dart';
import 'package:flutter_animation/widget/FloatingAnimatedMenu.dart';

class FloatingActionBubbleDemo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _FloatingActionBubbleDemoState();
  }
}

class _FloatingActionBubbleDemoState extends State<FloatingActionBubbleDemo> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  List<Bubble> items;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 260),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(curve: Curves.easeInOut, parent: controller));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
      animation: animation,
      onPress: () => controller.isCompleted ? controller.reverse() : controller.forward(),
      iconColor: Colors.blue,
      iconData: Icons.home,
      backGroundColor: Colors.white,
      items: <Bubble>[
        Bubble(
          title: "Setting",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.settings,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            controller.reverse();
          },
        ),
        // Floating action menu item
        Bubble(
          title: "Profile",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.people,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            controller.reverse();
          },
        ),
        //Floating action menu item
        Bubble(
          title: "Home",
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.home,
          titleStyle: TextStyle(fontSize: 16, color: Colors.white),
          onPress: () {
            controller.reverse();
            setState(() {});
          },
        )
      ],
    );
    // return FloatingActionBubble(
    //   animation: animation,
    //   onPress: () => controller.isCompleted ? controller.reverse() : controller.forward(),
    //   iconColor: Colors.blue,
    //   iconData: Icons.home,
    //   backGroundColor: Colors.white,
    //   items: <Bubble>[
    //     // Floating action menu item
    //     Bubble(
    //       title: "Settings",
    //       iconColor: Colors.white,
    //       bubbleColor: Colors.blue,
    //       icon: Icons.settings,
    //       titleStyle: TextStyle(fontSize: 16, color: Colors.white),
    //       onPress: () {
    //         controller.reverse();
    //       },
    //     ),
    //     // Floating action menu item
    //     Bubble(
    //       title: "Profile",
    //       iconColor: Colors.white,
    //       bubbleColor: Colors.blue,
    //       icon: Icons.people,
    //       titleStyle: TextStyle(fontSize: 16, color: Colors.white),
    //       onPress: () {
    //         controller.reverse();
    //       },
    //     ),
    //     //Floating action menu item
    //     Bubble(
    //       title: "Home",
    //       iconColor: Colors.white,
    //       bubbleColor: Colors.blue,
    //       icon: Icons.home,
    //       titleStyle: TextStyle(fontSize: 16, color: Colors.white),
    //       onPress: () {
    //         controller.reverse();
    //       },
    //     ),
    //   ],
    // );
  }
}
