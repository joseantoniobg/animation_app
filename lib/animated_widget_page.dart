import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:math' as math;

class AnimatedWidgetPage extends StatefulWidget {
  AnimatedWidgetPage({Key key}) : super(key: key);

  @override
  _AnimatedWidgetPageState createState() => _AnimatedWidgetPageState();
}

class _AnimatedWidgetPageState extends State<AnimatedWidgetPage>
    with SingleTickerProviderStateMixin {
  AnimationController animController;
  Animation<double> animation;
  Animation<double> fadingAnimation;

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
          //when using an animatedwidget, its not necessary to refresh the page
          // ..addListener(() {
          //   setState(() {});
          // })
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

    fadingAnimation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadingTransition(
          angle: fadingAnimation,
          child: RotatingTransition(angle: animation, child: LionImage())),
    );
  }

  @override
  void dispose() {
    animController.dispose();
    super.dispose();
  }
}

class RotatingTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> angle;

  const RotatingTransition(
      {Key key, @required this.angle, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      child: child,
      builder: (ctx, child) {
        //FadeTranstion
        //RotationTransition
        //SizeTransition
        return Transform.rotate(
          angle: angle.value,
          child: child,
        );
      },
    );
  }
}

class FadingTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> angle;

  const FadingTransition({Key key, @required this.angle, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: angle,
      child: child,
      builder: (ctx, child) {
        //FadeTranstion
        //RotationTransition
        //SizeTransition
        return FadeTransition(
          opacity: angle,
          child: child,
        );
      },
    );
  }
}

class LionImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Image(image: AssetImage('assets/lion.jpg')),
      ),
    );
  }
}
