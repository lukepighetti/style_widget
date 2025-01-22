library styled_widget;

import 'dart:math';

import 'package:flutter/material.dart';

class StyledWidget extends StatefulWidget {
  const StyledWidget({
    super.key,
    required this.style,
    required this.child,
  });

  final void Function(StyledContext s) style;

  final Widget child;

  @override
  State<StyledWidget> createState() => _StyledWidgetState();
}

class _StyledWidgetState extends State<StyledWidget> {
  @override
  Widget build(BuildContext context) {
    final s = StyledContext();
    widget.style(s);

    return TweenAnimationBuilder(
      duration: s._duration,
      curve: s._curve,
      tween: Tween(end: s._rotate),
      builder: (_, t, child) {
        return Transform.rotate(
          angle: t,
          alignment: s._rotateAlignment,
          child: child,
        );
      },
      child: TweenAnimationBuilder(
        tween: Tween(end: s._translation),
        duration: s._duration,
        curve: s._curve,
        builder: (_, t, child) {
          return Transform.translate(offset: t, child: child);
        },
        child: AnimatedOpacity(
          opacity: s._opacity,
          duration: s._duration,
          curve: s._curve,
          child: ClipRect(
            child: AnimatedAlign(
              alignment: Alignment.center,
              widthFactor: s._collapseY ? 0 : 1,
              heightFactor: s._collapseX ? 0 : 1,
              duration: s._duration,
              curve: s._curve,
              child: ClipRect(
                child: AnimatedContainer(
                  padding: s._padding,
                  margin: s._margin,
                  duration: s._duration,
                  curve: s._curve,
                  decoration: BoxDecoration(
                    color: s._backgroundColor,
                    borderRadius: BorderRadius.circular(s._borderRadius ?? 0),
                    boxShadow: s._boxShadows,
                  ),
                  child: IgnorePointer(
                    ignoring: s._opacity <= 0.01,
                    child: DefaultTextStyle(
                      style: DefaultTextStyle.of(context)
                          .style
                          .merge(s._textStyle)
                          .copyWith(
                            color: s._foregroundColor,
                          ),
                      child: IconTheme(
                        data: IconTheme.of(context).copyWith(
                          color: s._foregroundColor,
                          size: s._iconSize,
                        ),
                        child: widget.child,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class StyledContext {
  Duration _duration = Duration.zero;
  Curve _curve = Curves.easeInOut;

  void animated({
    final Duration delay = Duration.zero,
    final Duration duration = const Duration(milliseconds: 500),
    final Curve curve = Curves.easeInOut,
  }) {
    _assertUseOnce(_duration == Duration.zero, "animated()");
    final (d, c) = _delayedCurve(delay, duration, curve);
    _duration = d;
    _curve = c;
  }

  double _opacity = 1;
  void opacity(double x) {
    _opacity = x;
  }

  Offset _translation = Offset.zero;

  void translate({double x = 0, double y = 0}) {
    _translation = _translation + Offset(x, y);
  }

  double _rotate = 0;

  void rotate(double degrees) {
    _rotate = degrees * pi / 180;
  }

  void rotateRadians(double radians) {
    _rotate = radians;
  }

  bool _collapseY = false;
  void collapseY(bool value) {
    _collapseY = value;
  }

  bool _collapseX = false;
  void collapseX(bool value) {
    _collapseX = value;
  }

  AlignmentGeometry _rotateAlignment = Alignment.center;

  @visibleForTesting
  // isn't behaving the way I'd expect it to
  void rotateAlignment(AlignmentGeometry x) {
    _rotateAlignment = x;
  }

  EdgeInsetsGeometry _padding = EdgeInsets.zero;

  void paddingAll([double value = 10]) {
    _padding = _padding.add(EdgeInsetsDirectional.all(value));
  }

  void padding({double s = 0, double t = 0, double e = 0, double b = 0}) {
    _padding = _padding.add(EdgeInsetsDirectional.fromSTEB(s, t, e, b));
  }

  void paddingLTRB({double l = 0, double t = 0, double r = 0, double b = 0}) {
    _padding = _padding.add(EdgeInsets.fromLTRB(l, t, r, b));
  }

  void paddingXY({double x = 0, double y = 0}) {
    _padding = _padding
        .add(EdgeInsetsDirectional.symmetric(horizontal: x, vertical: y));
  }

  EdgeInsetsGeometry _margin = EdgeInsets.zero;

  void marginAll([double value = 10]) {
    _margin = _margin.add(EdgeInsetsDirectional.all(value));
  }

  void margin({double s = 0, double t = 0, double e = 0, double b = 0}) {
    _margin = _margin.add(EdgeInsetsDirectional.fromSTEB(s, t, e, b));
  }

  void marginLTRB({double l = 0, double t = 0, double r = 0, double b = 0}) {
    _margin = _margin.add(EdgeInsets.fromLTRB(l, t, r, b));
  }

  void marginXY({double x = 0, double y = 0}) {
    _margin = _margin
        .add(EdgeInsetsDirectional.symmetric(horizontal: x, vertical: y));
  }

  Color _backgroundColor = Colors.transparent;
  void backgroundColor(Color color) {
    _assertUseOnce(_backgroundColor == Colors.transparent, "backgroundColor()");
    _backgroundColor = color;
  }

  Color? _foregroundColor;
  void foregroundColor(Color color) {
    _assertUseOnce(_foregroundColor == null, "foregroundColor()");
    _foregroundColor = color;
  }

  double? _iconSize;
  void iconSize(double size) {
    _assertUseOnce(_iconSize == null, "iconSize()");
    _iconSize = size;
  }

  double? _borderRadius;

  void borderRadius(double radius) {
    _assertUseOnce(_borderRadius == null, "borderRadius()");
    _borderRadius = radius;
  }

  final List<BoxShadow> _boxShadows = [];
  void boxShadow(BoxShadow shadow) {
    _boxShadows.add(shadow);
  }

  TextStyle _textStyle = const TextStyle();
  void textStyle(TextStyle style) {
    _textStyle = _textStyle.merge(style);
  }

  void fontSize(double size) {
    textStyle(TextStyle(fontSize: size));
  }

  void fontWeight(FontWeight weight) {
    textStyle(
      TextStyle(
        fontWeight: weight,
        fontVariations: [
          FontVariation.weight(weight.value.toDouble()),
        ],
      ),
    );
  }

  void fontFamily(String family) {
    textStyle(TextStyle(fontFamily: family));
  }
}

void _assertUseOnce(bool test, String tag) {
  assert(test, "You can only use $tag once");
}

(Duration, Curve) _delayedCurve(
    Duration delay, Duration duration, Curve curve) {
  final total = delay + duration;
  final tStart = delay.inMicroseconds / total.inMicroseconds;
  return (total, Interval(tStart, 1, curve: curve));
}
