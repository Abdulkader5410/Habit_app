import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/main.dart';
import 'package:untitled/screen/home/home_screen.dart';
import 'package:untitled/screen/timer/timer_home_screen.dart';
import 'package:untitled/screen/timer/timer_screen.dart';

class CountdownTimerSetupScreen extends StatefulWidget {
  @override
  _CountdownTimerSetupScreenState createState() =>
      _CountdownTimerSetupScreenState();
}

class _CountdownTimerSetupScreenState extends State<CountdownTimerSetupScreen> {
  int _selectedHours = 0;
  int _selectedMinutes = 0;
  int _selectedSeconds = 0;

  bool isStart = true;

  @override
  void initState() {
    // TODO: implement initState
    isStart = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Select Time',
                style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildTimePicker(24, (value) {
                  setState(() {
                    _selectedHours = value;
                  });
                }, "Hours"),
                Text(':',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 30)),
                _buildTimePicker(60, (value) {
                  setState(() {
                    _selectedMinutes = value;
                  });
                }, "Minutes"),
                Text(':',
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 30)),
                _buildTimePicker(60, (value) {
                  setState(() {
                    _selectedSeconds = value;
                  });
                }, "Seconds"),
              ],
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                String countdownTime =
                    '$_selectedHours:$_selectedMinutes:$_selectedSeconds';
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CountdownTimerScreen(countdownTime: countdownTime),
                  ),
                );

                setState(() {
                  isStart = true;
                });
              },
              child: Text('Start Countdown Timer',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      fontSize: 18,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? darkColor
                          : lightColor)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
      int maxValue, ValueChanged<int> onChanged, String text) {
    return Column(
      children: [
        Text(text, style: Theme.of(context).textTheme.displayMedium),
        Container(
          width: 80,
          height: 100,
          child: ListWheelScrollView.useDelegate(
            itemExtent: 40,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: onChanged,
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                return Text(index.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium!
                        .copyWith(fontSize: 30));
              },
              childCount: maxValue,
            ),
          ),
        ),
      ],
    );
  }
}

class CountdownTimerScreen extends StatefulWidget {
  final String countdownTime;

  CountdownTimerScreen({required this.countdownTime});

  @override
  _CountdownTimerScreenState createState() =>
      _CountdownTimerScreenState(countdownTime: countdownTime);
}

class _CountdownTimerScreenState extends State<CountdownTimerScreen> {
  Timer? _timer;
  Duration _duration = Duration.zero;
  double _percntage = 1.0;

  _CountdownTimerScreenState({required String countdownTime}) {
    List<String> timeParts = countdownTime.split(':');
    _duration = Duration(
      hours: int.parse(timeParts[0]),
      minutes: int.parse(timeParts[1]),
      seconds: int.parse(timeParts[2]),
    );
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration -= const Duration(seconds: 1);
          int totalTime = int.parse(widget.countdownTime.split(':')[0]) * 3600 +
              int.parse(widget.countdownTime.split(':')[1]) * 60 +
              int.parse(widget.countdownTime.split(':')[2]);

          if (totalTime > 0) {
            _percntage = _duration.inSeconds / totalTime;
          } else {
            _percntage = 0;
          }
        } else {
          _timer!.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String hours = twoDigits(duration.inHours);
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {

    Future.delayed(_duration, () {
      Navigator.maybePop(context);
    });

    return Scaffold(
      body: Center(
          child: Stack(
        children: [
          Positioned(
              child: Center(
            child: SizedBox(
              width: 250,
              height: 250,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 14,
                value: _percntage,
              ),
            ),
          )),
          Positioned(
              top: MediaQuery.sizeOf(context).height / 2.1,
              left: 110,
              right: 110,
              child: Center(
                child: Text(
                  _formatDuration(_duration),
                  style: Theme.of(context)
                      .textTheme
                      .displayMedium!
                      .copyWith(fontSize: 30),
                ),
              )),
        ],
      )),
    );
  }
}
