import 'package:flutter/material.dart';

class AnimatedPageWidget extends StatefulWidget {
  final Widget child;
  final bool visible;
  final bool animationReversed;
  final Animation<double> animation;

  const AnimatedPageWidget(
      {Key key,
      this.visible,
      this.child,
      this.animation,
      this.animationReversed})
      : super(key: key);
  @override
  _AnimatedPageWidgetState createState() => _AnimatedPageWidgetState();
}

class _AnimatedPageWidgetState extends State<AnimatedPageWidget> {
  @override
  Widget build(BuildContext context) {
    double animationValue = (widget.visible)
        ? (!widget.animationReversed)
            ? widget.animation.value
            : 1.0 - widget.animation.value
        : 0.0;
    double opacity = animationValue.clamp(0.0, 1.0);

    return Opacity(
      opacity: opacity,
      child: Transform(
        transform: new Matrix4.translationValues(
            0.0, 50.0 * (1.0 - animationValue), 0.0),
        child: widget.child,
      ),
    );
  }
}
