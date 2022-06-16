import 'package:flutter/material.dart';
import '../widget/change_theme_button.dart';
import '../widget/circular_gauge.dart';
import '../widget/speedgauge.dart';

class DashboardScreen extends StatefulWidget {
  final mode;
  final battery;
  final double speed;
  final faults;
  const DashboardScreen(
      {Key? key, this.mode, this.battery, this.speed = 0.0, this.faults})
      : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back,
          color: widget.mode == 1 ? Colors.green : Colors.grey,
          size: 50,
        ),
        actions: [
          Icon(
            Icons.arrow_forward,
            color: widget.mode == 2 ? Colors.green : Colors.grey,
            size: 50,
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularGauge(
                value: widget.battery * 0.3,
              ),
              SizedBox(
                width: (mediaquery.size.width) * 0.6,
                height: (mediaquery.size.height) * 0.7,
                child: SpeedometerView(
                  unitOfMeasurementTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline2?.color,
                    fontSize: Theme.of(context).textTheme.headline2?.fontSize,
                  ),
                  minMaxTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1?.color,
                    fontSize: Theme.of(context).textTheme.bodyText1?.fontSize,
                  ),
                  divisionCircleColors: Theme.of(context).primaryColor,
                  innerCirclePadding: 0,
                  speedTextStyle: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color,
                    fontSize: Theme.of(context).textTheme.headline1?.fontSize,
                  ),
                  speed: (widget.mode == 4)
                      ? widget.mode.toDouble()
                      : (widget.speed * 0.4),
                  minSpeed: 0,
                  maxSpeed: 120,
                  alertSpeedArray: const [
                    0.0,
                    20.0,
                    40.0,
                    60.0,
                    80.0,
                    100.0,
                    120.0,
                  ],
                  alertColorArray: const [
                    Colors.green,
                    Colors.green,
                    Colors.orange,
                    Colors.orange,
                    Colors.red,
                    Colors.red,
                    Colors.red,
                  ],
                ),
              ),
              Container(
                width: (mediaquery.size.width) * 0.1,
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        color: widget.mode == 4 ? Colors.red : Colors.grey,
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!),
                      ),
                      child: const Text(
                        'R',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      margin: const EdgeInsets.only(
                        bottom: 10,
                      ),
                      decoration: BoxDecoration(
                        color: widget.mode == 8 ? Colors.amber : Colors.grey,
                        border: Border.all(
                            color: Theme.of(context).iconTheme.color!),
                      ),
                      child: const Text(
                        'N',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: (widget.mode != 4 && widget.mode != 8)
                            ? Colors.green
                            : Colors.grey,
                        border: Border.all(
                          color: Theme.of(context).iconTheme.color!,
                        ),
                      ),
                      child: const Text(
                        'D',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.battery_alert_outlined,
                color: widget.faults > 200 ? Colors.red : Colors.grey,
                size: 40,
              ),
              Icon(
                Icons.battery_2_bar,
                color: widget.battery < 20 ? Colors.red : Colors.grey,
                size: 40,
              ),
              Text(
                'Estimated Range',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                widget.battery < 20
                    ? '10 Km'
                    : widget.battery < 40
                        ? '20 Km'
                        : '50 Km',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              Text(
                'Total Distance',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              Text(
                '100 Kms',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const ChangeThemeButtonWidget(),
            ],
          ),
        ],
      ),
    );
  }
}
