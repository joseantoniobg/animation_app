import 'package:flutter/material.dart';
import 'dart:math' as math;

class BasicAnimation extends StatefulWidget {
  BasicAnimation({Key key}) : super(key: key);

  @override
  _BasicAnimationState createState() => _BasicAnimationState();
}

class _BasicAnimationState extends State<BasicAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;

  ///tweens are like modifiers for an animation,
  ///they can change in range and
  ///even output type

  @override
  void initState() {
    super.initState();
    animController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    final curvedAnimation = CurvedAnimation(
      parent: animController,
      curve: Curves.bounceIn,
      reverseCurve: Curves.easeOut,
    );

    //will permits the default range of values in animationController (from 0 to 1) be replaced the range specified
    animation = Tween<double>(begin: 0, end: 2 * math.pi)
        //its possible to chain a curve animation
        //.chain(CurveTween(curve: Curves.bounceIn))
        .animate(
            //animController <- linear animation directly from the controller itself
            curvedAnimation)
          //adds a listener witch calls a function everytime this value in range gets updated, (60 times per second in this case, vsync = 60)
          //so, it can be called simply to update the state of widget, refreshing the page
          ..addListener(() {
            setState(() {});
          })
          //listener to get whenever the status of animation changes
          /*
        Available status:
        - Dismissed - when animation is at the beginnig (valueRange: 0)
        - Forward
        - Completed
        - Reverse
      */
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              animController.reverse();
            } else if (status == AnimationStatus.dismissed) {
              animController.forward();
            }
          });

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Transform.rotate(
        angle: animation.value,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          child: Image(image: AssetImage('assets/lion.jpg')),
        ),
      ),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}
