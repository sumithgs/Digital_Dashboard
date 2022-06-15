import 'package:flutter/material.dart';
import '../widget/change_theme_button.dart';
import '../widget/circular_gauge.dart';
import '../widget/speedgauge.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _channel = WebSocketChannel.connect(
    Uri.parse('ws://192.168.83.230:8000/ws3'),
  );
  @override
  void dispose() {
    _channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaquery = MediaQuery.of(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: Theme.of(context).iconTheme,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // leading: const Icon(
        //   Icons.arrow_back,
        //   color: Colors.green,
        //   size: 50,
        // ),
        // actions: const [
        //   Icon(
        //     Icons.arrow_forward,
        //     color: Colors.green,
        //     size: 50,
        //   ),
        //   // ChangeThemeButtonWidget(),
        // ],
      ),
      body: StreamBuilder(
          stream: _channel.stream,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              final response = jsonDecode(snapshot.data.toString());
              //print(response['SPEED'].toDouble());
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color:
                            response['mode'] == 1 ? Colors.green : Colors.grey,
                        size: 45,
                      ),
                      CircularGauge(
                        value: response['battery_percentage'] * 0.3,
                      ),
                      SizedBox(
                        width: (mediaquery.size.width) * 0.5,
                        height: (mediaquery.size.height) * 0.7,
                        child: SpeedometerView(
                          unitOfMeasurementTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.headline2?.color,
                            fontSize:
                                Theme.of(context).textTheme.headline2?.fontSize,
                          ),
                          minMaxTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1?.color,
                            fontSize:
                                Theme.of(context).textTheme.bodyText1?.fontSize,
                          ),
                          divisionCircleColors: Theme.of(context).primaryColor,
                          innerCirclePadding: 0,
                          speedTextStyle: TextStyle(
                            color: Theme.of(context).textTheme.headline1?.color,
                            fontSize:
                                Theme.of(context).textTheme.headline1?.fontSize,
                          ),
                          speed: (response['mode'] == 4)
                              ? response['mode'].toDouble()
                              : (response['speedometer'] * 0.4).toDouble(),
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
                                color: response['mode'] == 4
                                    ? Colors.red
                                    : Colors.grey,
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
                                color: response['mode'] == 8
                                    ? Colors.amber
                                    : Colors.grey,
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
                                color: (response['mode'] != 4 &&
                                        response['mode'] != 8)
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
                      Icon(
                        Icons.arrow_forward,
                        color:
                            response['mode'] == 2 ? Colors.green : Colors.grey,
                        size: 45,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.battery_alert_outlined,
                        color:
                            response['faults'] > 200 ? Colors.red : Colors.grey,
                        size: 40,
                      ),
                      Icon(
                        Icons.battery_2_bar,
                        color: response['battery_percentage'] < 20
                            ? Colors.red
                            : Colors.grey,
                        size: 40,
                      ),
                      Text(
                        'Estimated Range',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      Text(
                        response['battery_percentage'] < 20
                            ? '10 Km'
                            : response['battery_percentage'] < 40
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
                      ChangeThemeButtonWidget(),
                    ],
                  ),
                ],
              );
            }
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).iconTheme.color,
              ),
            );
          }),
    );
  }
}
