library styled_widget;

import 'dart:math';

import 'package:flutter/material.dart';

class StyleWidget extends StatefulWidget {
  const StyleWidget({
    super.key,
    required this.style,
    required this.child,
  });

  final void Function(StyleContext s) style;

  final Widget child;

  @override
  State<StyleWidget> createState() => _StyleWidgetState();
}

class _StyleWidgetState extends State<StyleWidget> {
  @override
  Widget build(BuildContext context) {
    final s = StyleContext();
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

class StyleContext {
  Duration _duration = Duration.zero;
  Curve _curve = Curves.easeInOut;

  StyleContext animated({
    final Duration delay = Duration.zero,
    final Duration duration = const Duration(milliseconds: 500),
    final Curve curve = Curves.easeInOut,
  }) {
    _assertUseOnce(_duration == Duration.zero, "animated()");
    final (d, c) = _delayedCurve(delay, duration, curve);
    _duration = d;
    _curve = c;
    return this;
  }

  double _opacity = 1;
  StyleContext opacity(double x) {
    _opacity = x;
    return this;
  }

  Offset _translation = Offset.zero;

  StyleContext translate({double x = 0, double y = 0}) {
    _translation = _translation + Offset(x, y);
    return this;
  }

  double _rotate = 0;

  StyleContext rotate(double degrees) {
    _rotate = degrees * pi / 180;
    return this;
  }

  StyleContext rotateRadians(double radians) {
    _rotate = radians;
    return this;
  }

  bool _collapseY = false;
  StyleContext collapseY(bool value) {
    _collapseY = value;
    return this;
  }

  bool _collapseX = false;
  StyleContext collapseX(bool value) {
    _collapseX = value;
    return this;
  }

  AlignmentGeometry _rotateAlignment = Alignment.center;

  @visibleForTesting
  // isn't behaving the way I'd expect it to
  StyleContext rotateAlignment(AlignmentGeometry x) {
    _rotateAlignment = x;
    return this;
  }

  EdgeInsetsGeometry _padding = EdgeInsets.zero;

  StyleContext paddingAll([double value = 10]) {
    _padding = _padding.add(EdgeInsetsDirectional.all(value));
    return this;
  }

  StyleContext padding({double s = 0, double t = 0, double e = 0, double b = 0}) {
    _padding = _padding.add(EdgeInsetsDirectional.fromSTEB(s, t, e, b));
    return this;
  }

  StyleContext paddingLTRB({double l = 0, double t = 0, double r = 0, double b = 0}) {
    _padding = _padding.add(EdgeInsets.fromLTRB(l, t, r, b));
    return this;
  }

  StyleContext paddingXY({double x = 0, double y = 0}) {
    _padding = _padding
        .add(EdgeInsetsDirectional.symmetric(horizontal: x, vertical: y));
        return this;
  }

  EdgeInsetsGeometry _margin = EdgeInsets.zero;

  StyleContext marginAll([double value = 10]) {
    _margin = _margin.add(EdgeInsetsDirectional.all(value));
    return this;
  }

  StyleContext margin({double s = 0, double t = 0, double e = 0, double b = 0}) {
    _margin = _margin.add(EdgeInsetsDirectional.fromSTEB(s, t, e, b));
    return this;
  }

  StyleContext marginLTRB({double l = 0, double t = 0, double r = 0, double b = 0}) {
    _margin = _margin.add(EdgeInsets.fromLTRB(l, t, r, b));
    return this;
  }

  StyleContext marginXY({double x = 0, double y = 0}) {
    _margin = _margin
        .add(EdgeInsetsDirectional.symmetric(horizontal: x, vertical: y));
        return this;
  }

  Color _backgroundColor = Colors.transparent;
  StyleContext backgroundColor(Color color) {
    _assertUseOnce(_backgroundColor == Colors.transparent, "backgroundColor()");
    _backgroundColor = color;
    return this;
  }

  Color? _foregroundColor;
  StyleContext foregroundColor(Color color) {
    _assertUseOnce(_foregroundColor == null, "foregroundColor()");
    _foregroundColor = color;
    return this;
  }

  double? _iconSize;
  StyleContext iconSize(double size) {
    _assertUseOnce(_iconSize == null, "iconSize()");
    _iconSize = size;
    return this;
  }

  double? _borderRadius;

  StyleContext borderRadius(double radius) {
    _assertUseOnce(_borderRadius == null, "borderRadius()");
    _borderRadius = radius;
    return this;
  }

  final List<BoxShadow> _boxShadows = [];
  StyleContext boxShadow(BoxShadow shadow) {
    _boxShadows.add(shadow);
    return this;
  }

  TextStyle _textStyle = const TextStyle();
  StyleContext textStyle(TextStyle style) {
    _textStyle = _textStyle.merge(style);
    return this;
  }

  StyleContext fontSize(double size) {
    textStyle(TextStyle(fontSize: size));
    return this;
  }

  StyleContext fontWeight(FontWeight weight) {
    textStyle(
      TextStyle(
        fontWeight: weight,
        fontVariations: [
          FontVariation.weight(weight.value.toDouble()),
        ],
      ),
    );
    return this;
  }

  StyleContext fontFamily(String family) {
    textStyle(TextStyle(fontFamily: family));
    return this;
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
