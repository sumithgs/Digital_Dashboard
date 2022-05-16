import 'package:flutter/material.dart';
import 'dart:math' as math;

class SpeedometerView extends StatefulWidget {
  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final TextStyle minMaxTextStyle;

  final double gaugeWidth;
  final Color baseGaugeColor;
  final Color inactiveGaugeColor;
  final Color activeGaugeColor;

  final List<double> alertSpeedArray;
  final List<Color> alertColorArray;
  final double innerCirclePadding;

  final Color subDivisionCircleColors;
  final Color divisionCircleColors;

  final Duration duration;
  final int fractionDigits;

  //final Widget child;
  const SpeedometerView(
      {this.speed = 0,
      this.speedTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 60,
        fontWeight: FontWeight.bold,
      ),
      this.unitOfMeasurement = 'Km/Hr',
      this.unitOfMeasurementTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
      this.alertSpeedArray = const [],
      this.alertColorArray = const [],
      this.minSpeed = 0,
      this.maxSpeed = 120,
      this.minMaxTextStyle = const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      this.gaugeWidth = 10,
      this.baseGaugeColor = Colors.transparent,
      this.inactiveGaugeColor = Colors.black87,
      this.activeGaugeColor = Colors.green,
      this.innerCirclePadding = 30,
      this.divisionCircleColors = Colors.black,
      this.subDivisionCircleColors = Colors.black,
      this.duration = const Duration(milliseconds: 400),
      this.fractionDigits = 0,
      Key? key})
      : super(key: key);

  @override
  _SpeedometerViewState createState() => _SpeedometerViewState();
}

class _SpeedometerViewState extends State<SpeedometerView> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeedometerPainter(
        widget.speed,
        widget.speedTextStyle,
        widget.unitOfMeasurement,
        widget.unitOfMeasurementTextStyle,
        widget.minSpeed,
        widget.maxSpeed,
        widget.minMaxTextStyle,
        widget.alertSpeedArray,
        widget.alertColorArray,
        widget.gaugeWidth,
        widget.baseGaugeColor,
        widget.inactiveGaugeColor,
        widget.activeGaugeColor,
        widget.innerCirclePadding,
        widget.divisionCircleColors,
        widget.subDivisionCircleColors,
        widget.fractionDigits,
      ),
    );
  }
}

class _SpeedometerPainter extends CustomPainter {
  //We are considering this start angle starting point for gauge view
  final double arcStartAngle = 135;
  final double arcSweepAngle = 270;

  final double speed;
  final TextStyle speedTextStyle;

  final String unitOfMeasurement;
  final TextStyle unitOfMeasurementTextStyle;

  final double minSpeed;
  final double maxSpeed;
  final TextStyle minMaxTextStyle;

  final List<double> alertSpeedArray;
  final List<Color> alertColorArray;

  final double gaugeWidth;
  final Color baseGaugeColor;
  final Color inactiveGaugeColor;
  final Color activeGaugeColor;

  final double innerCirclePadding;

  final Color subDivisionCircleColors;
  final Color divisionCircleColors;

  Offset center = const Offset(0, 0);
  double mRadius = 200;
  double mDottedCircleRadius = 0;

  final int fractionDigits;

  _SpeedometerPainter(
    this.speed,
    this.speedTextStyle,
    this.unitOfMeasurement,
    this.unitOfMeasurementTextStyle,
    this.minSpeed,
    this.maxSpeed,
    this.minMaxTextStyle,
    this.alertSpeedArray,
    this.alertColorArray,
    this.gaugeWidth,
    this.baseGaugeColor,
    this.inactiveGaugeColor,
    this.activeGaugeColor,
    this.innerCirclePadding,
    this.subDivisionCircleColors,
    this.divisionCircleColors,
    this.fractionDigits,
  );
  @override
  void paint(Canvas canvas, Size size) {
    //get the center of the view
    center = size.center(const Offset(0, 0));

    double minDimension = size.width > size.height ? size.height : size.width;
    mRadius = minDimension / 2;

    mDottedCircleRadius = mRadius - innerCirclePadding;

    Paint paint = Paint();
    paint.color = Colors.red;
    paint.strokeWidth = gaugeWidth;
    paint.strokeCap = StrokeCap.round;
    paint.style = PaintingStyle.stroke;

    //Draw base gauge
    //canvas.drawCircle(center, mRadius, paint..color = baseGaugeColor);

    //Draw inactive gauge view
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: mRadius),
        (math.pi / 180.0) * arcStartAngle,
        (math.pi / 180.0) * arcSweepAngle,
        false,
        paint..color = Colors.grey.withOpacity(.4));

    //Draw active gauge view
    if (alertSpeedArray.isNotEmpty)
      for (int i = 0; alertSpeedArray.length > i; i++) {
        if (i == 0 && speed <= alertSpeedArray[i]) {
          paint.color = activeGaugeColor;
        } else if (i == alertSpeedArray.length - 1 &&
            speed >= alertSpeedArray[i]) {
          paint.color = alertColorArray[i];
        } else if (alertSpeedArray[i] <= speed &&
            speed <= alertSpeedArray[i + 1]) {
          paint.color = alertColorArray[i];
          break;
        } else {
          paint.color = activeGaugeColor;
        }
      }
    else {
      paint.color = activeGaugeColor;
    }
    canvas.drawArc(
        Rect.fromCircle(center: center, radius: mRadius),
        (math.pi / 180.0) * arcStartAngle,
        (math.pi / 180.0) * _getAngleOfSpeed(speed),
        false,
        paint);

    //Going to draw division, Subdivision and Alert Circle
    paint.style = PaintingStyle.fill;

    //draw division dots circle(big one)
    paint.color = divisionCircleColors;
    double j = 0;
    for (double i = 0; 270 >= i; i = i + 45) {
      canvas.drawCircle(
          _getDegreeOffsetOnCircle(mDottedCircleRadius, i + arcStartAngle),
          minDimension * .012,
          paint);
      _drawspeedText(
          canvas, size, (i == 0) ? minSpeed : j = j + maxSpeed / 6, i);
    }

    //draw subDivision dots circle(small one)
    paint.color = subDivisionCircleColors;

    for (double i = 0; 270 >= i; i = i + 5) {
      canvas.drawCircle(
          _getDegreeOffsetOnCircle(mDottedCircleRadius, i + arcStartAngle),
          minDimension * .005,
          paint);
    }

    //Draw alert indicator

    for (int i = 0; alertSpeedArray.length > i; i++) {
      paint.color = alertColorArray[i];
      canvas.drawCircle(
        _getDegreeOffsetOnCircle(mDottedCircleRadius,
            _getAngleOfSpeed(alertSpeedArray[i]) + arcStartAngle),
        minDimension * .015,
        paint,
      );
    }

    //Draw Unit of Measurement
    _drawUnitOfMeasurementText(canvas, size);

    //Draw Speed Text
    _drawSpeedText(canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return true;
  }

  Offset _getDegreeOffsetOnCircle(double radius, double angle) {
    double radian = (math.pi / 180.0) * angle;
    double dx = (center.dx + radius * math.cos(radian));
    double dy = (center.dy + radius * math.sin(radian));
    return Offset(dx, dy);
  }

  double _getAngleOfSpeed(double speed) {
    return speed / ((maxSpeed - minSpeed) / arcSweepAngle);
  }

  void _drawspeedText(
      Canvas canvas, Size size, double speedtxt, double angletogiv) {
    TextSpan span = TextSpan(
        style: minMaxTextStyle, text: speedtxt.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.rtl,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    //Get the end point of Gauge
    Offset offset = _getDegreeOffsetOnCircle(
        mDottedCircleRadius, arcStartAngle + angletogiv);
    //translate textPainter offset to bottom anchor the start point of the gauge
    if (angletogiv > 135) {
      offset =
          offset.translate(-textPainter.width - 10, -textPainter.height + 20);
    }
    if (angletogiv == 135) {
      offset = offset.translate(0 - 5, -textPainter.height + 25);
    } else {
      offset = offset.translate(0 + 5, -textPainter.height + 15);
    }
    textPainter.paint(canvas, offset);
  }

  void _drawUnitOfMeasurementText(Canvas canvas, Size size) {
    //Get the center point of the minSpeed and maxSpeed label
    //that would be center of the unit of measurement text
    Offset minTextOffset =
        _getDegreeOffsetOnCircle(mDottedCircleRadius, arcStartAngle);

    Offset unitOfMeasurementOffset = Offset(size.width / 2, minTextOffset.dy);

    TextSpan span =
        TextSpan(style: unitOfMeasurementTextStyle, text: unitOfMeasurement);
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset = unitOfMeasurementOffset.translate(
        -textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }

  void _drawSpeedText(Canvas canvas, Size size) {
    //We are going to draw this text in the center of the widget

    Offset unitOfMeasurementOffset = center;

    TextSpan span = TextSpan(
        style: speedTextStyle, text: speed.toStringAsFixed(fractionDigits));
    TextPainter textPainter = TextPainter(
      text: span,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: size.width,
    );

    unitOfMeasurementOffset =
        center.translate(-textPainter.width / 2, -textPainter.height / 2);
    textPainter.paint(canvas, unitOfMeasurementOffset);
  }
}
