import 'dart:async';
import 'package:flutter/material.dart';
import 'package:untitled/core/themes/themes.dart';

class TimerScreen extends StatefulWidget {
  @override
  _TimerScreenState createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  Timer? _timer;
  int _secondsRemaining = 0;
  bool isStart = false;

  @override
  void initState() {
    super.initState();
    _secondsRemaining =
        0; // Set your initial seconds here (0 for demonstration)
    isStart = false;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _secondsRemaining++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Stack(
              children: [
                Positioned(
                  child: Center(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        color: isStart
                            ? primaryColor
                            : primaryColor.withOpacity(0.3),
                        value: 10,
                        strokeWidth: 14,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 120,
                  right: 120,
                  child: Center(
                    child: Text(
                      _formatTime(_secondsRemaining),
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(fontSize: 40),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _startTimer();
                        setState(() {
                          isStart = true;
                        });
                      },
                      child: Text("Start",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? darkColor
                                      : lightColor))),
                  ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                      },
                      child: Text("Stop",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? darkColor
                                      : lightColor))),
                  ElevatedButton(
                      onPressed: () {
                        _timer?.cancel();
                        setState(() {
                          _secondsRemaining = 0;
                          isStart = false;
                        });
                      },
                      child: Text("Clear",
                          style: Theme.of(context)
                              .textTheme
                              .displayMedium!
                              .copyWith(
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? darkColor
                                      : lightColor)))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
