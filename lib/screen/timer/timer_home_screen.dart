import 'package:flutter/material.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/screen/timer/countdown_screen.dart';
import 'package:untitled/screen/timer/timer_screen.dart';

class TimerHomeScreen extends StatefulWidget {
  const TimerHomeScreen({super.key});

  @override
  State<TimerHomeScreen> createState() => _TimerHomeScreenState();
}

class _TimerHomeScreenState extends State<TimerHomeScreen> {
  PageController pc = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: PageView.builder(
              controller: pc,
              itemCount: 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return TimerScreen();
                } else if (index == 1) {
                  return CountdownTimerSetupScreen();
                }
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    pc.animateToPage(0,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear);
                  },
                  child: Text("Timer",
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
                    pc.animateToPage(1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.linear);
                  },
                  child: Text("CountDown Timer",
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
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
