import 'package:flutter/material.dart';

import 'basic_animation/AnimatedBuilderDemo.dart';
import 'basic_animation/AnimatedContainerDemo.dart';
import 'basic_animation/AnimatedCrossFadeDemo.dart';
import 'basic_animation/AnimatedDefaultTextStyleDemo.dart';
import 'basic_animation/AnimatedIconDemo.dart';
import 'basic_animation/AnimatedListDemo.dart';
import 'basic_animation/AnimatedModalBarrierDemo.dart';
import 'basic_animation/AnimatedOpacityDemo.dart';
import 'basic_animation/AnimatedPhysicalModelDemo.dart';
import 'basic_animation/AnimatedPositionedDemo.dart';
import 'basic_animation/AnimatedSizeDemo.dart';
import 'basic_animation/AnimatedSwitcherDemo.dart';
import 'basic_animation/DecoratedBoxTransitionDemo.dart';
import 'basic_animation/FadeTransitionDemo.dart';
import 'basic_animation/PositionedTransitionDemo.dart';
import 'basic_animation/RotationTransitionDemo.dart';
import 'basic_animation/ScaleTransitionDemo.dart';
import 'basic_animation/SizeTransitionDemo.dart';
import 'basic_animation/SlideTransitionDemo.dart';

class BasicAnimation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Wrap(
          children: <Widget>[
            SlideTransitionDemo(),
            AnimatedContainerDemo(),
            AnimatedCrossFadeDemo(),
            AnimatedBuilderDemo(),
            DecoratedBoxTransitionDemo(),
            FadeTransitionDemo(),
            PositionedTransitionDemo(),
            RotationTransitionDemo(),
            ScaleTransitionDemo(),
            SizeTransitionDemo(),
            AnimatedDefaultTextStyleDemo(),
            AnimatedListDemo(),
            AnimatedModalBarrierDemo(),
            AnimatedOpacityDemo(),
            AnimatedPhysicalModelDemo(),
            AnimatedPositionedDemo(),
            AnimatedSizeDemo(),
            AnimatedSwitcherDemo(),
            AnimatedIconDemo(),
          ],
        ),
      ),
    );
  }
}
