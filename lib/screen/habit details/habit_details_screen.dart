import 'dart:async';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:untitled/main.dart';
import 'package:untitled/screen/home/home_screen.dart';

class HabitDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> habit;
  final DateTime? date;

  HabitDetailsScreen({
    super.key,
    required this.habit,
    required this.date,
  });

  @override
  State<HabitDetailsScreen> createState() => _HabitDetailsState();
}

class _HabitDetailsState extends State<HabitDetailsScreen> {
  void goToHomePage() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            userId: widget.habit['id_u'],
          ),
        ));
  }

  //start code of notifications

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        if (details.actionId == "1") {
          isClickOnDone = true;
          sp!.setBool("isNoti", true);

          goToHomePage();
        }
      },
    );
  }

  Future<void> showNotification(
      {required int id,
      required String title,
      required String body,
      String? payload}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your_channel_id', 'your_channel_name',
            channelDescription: 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            playSound: true,
            enableVibration: true,
            channelAction: AndroidNotificationChannelAction.createIfNotExists,
            actions: <AndroidNotificationAction>[
          AndroidNotificationAction("1", "Done",
              allowGeneratedReplies: true, showsUserInterface: true)
        ]);

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _notificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    //end code of notifications
  }

  DateTime? _foucsDate;
  List<Map<String, dynamic>>? hs;
  List<Map<String, dynamic>>? allStatus;
  int countP = 0;
  int countF = 0;
  int totalStatus = 0;

  /*Future<int> calcDays(String sDate, String eDate) async {
    DateTime startDate = DateTime.parse(sDate);
    DateTime endDate = DateTime.parse(eDate);

    final diff = endDate.difference(startDate).inDays;
    return diff + 1;
  }*/

  Future<List<Map<String, dynamic>>> getHabitTypesById(int idHt) async {
    return await DatabaseHelper.getHabitTypesById(idHt);
  }

  Future<void> getHS() async {
    List<Map<String, dynamic>> habitsStatus = await DatabaseHelper.getS(
            _foucsDate == null
                ? DateTime.now().toIso8601String().substring(0, 10)
                : _foucsDate!.toIso8601String().substring(0, 10),
            widget.habit['id_h'])
        .then((value) {
      hs = value;
      return hs!;
    });
    hs = habitsStatus;
  }

  Future<void> getStatusById() async {
    List<Map<String, dynamic>> allHabitsStatus =
        await DatabaseHelper.getStatusByHabitId(widget.habit['id_h'])
            .then((value) {
      totalStatus = value.length;

      for (int i = 0; i < value.length; i++) {
        if (value[i]['status'] == "F") {
          countF++;
        } else if (value[i]['status'] == "P") {
          countP++;
        }
      }

      allStatus = value;
      return allStatus!;
    });
    allStatus = allHabitsStatus;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    initialize();

    if (sp != null && sp!.getBool("isNoti") == null) {
      sp!.setBool("isNoti", false);
    }
  }

  Future<List<Map<String, dynamic>>> getNotifis() async {
    return await DatabaseHelper.getNotifi();
  }

  bool getIsNoti() {
    print("return sp!.getBool :  ${sp!.getBool("isNoti")}");
    return sp!.getBool("isNoti")!;
  }

  String? s;

  @override
  Widget build(BuildContext context) {
    getNotifis().then((value) => print(value));

    getHS();
    getStatusById();


    if (sp!.getBool("isNoti") == false) {
      sp!.setBool("isNoti", false);
    }

    return FutureBuilder(
        future: getHabitTypesById(widget.habit['id_ht']),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).brightness == Brightness.dark
                    ? Colors.black
                    : Colors.white,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(snapshot.data![0]['name'],
                        style: Theme.of(context).textTheme.displayLarge!),
                    const Icon(
                      size: 35,
                      Icons.health_and_safety_rounded,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
              body: FutureBuilder(
                  future: getNotifis(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final timeString =
                          snapshot.data![snapshot.data!.length - 1]['time'];

                      final parts = timeString.split(':');
                      var hour = int.parse(parts[0]);
                      final minute = int.parse(parts[1].split(' ')[0]);

                      final isPM = parts[1].split(' ')[1] == 'pm';

                      if (isPM && hour != 12) {
                        hour += 12;
                      } else if (!isPM && hour == 12) {
                        hour = 0;
                      }

                      final now = DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                          DateTime.now().hour <= 12
                              ? DateTime.now().hour
                              : DateTime.now().hour - 12,
                          DateTime.now().minute);

                      final time =
                          DateTime(now.year, now.month, now.day, hour, minute);

                      final diff = time.difference(now);

                      print('time : $time');
                      print('diff :  $diff');
                      print('now  : $now');

                      Future.delayed(Duration(seconds: diff.inSeconds - 10),
                          () {
                        bool isNotifiSend = getIsNoti();

                        print("isNotifiSend : $isNotifiSend");

                        if (!isNotifiSend) {
                          showNotification(
                              id: 1,
                              title: "Habitty",
                              body: widget.habit['title'],
                              payload: "Go to habits");
                          sp!.setBool("isNoti", true);
                        }
                      });
                    }

                    return ListView(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Card(
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? darkColor
                                    : lightColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Title :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            widget.habit['title'],
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge,
                                          ),
                                          Container(
                                            width: 100,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 12),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  widget.habit['priority'],
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .displayLarge!
                                                      .copyWith(
                                                          fontSize: 15,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                    size: 15,
                                                    Icons.flag_outlined,
                                                    color: widget.habit[
                                                                'priority'] ==
                                                            "high"
                                                        ? Colors.red
                                                        : widget.habit[
                                                                    'priority'] ==
                                                                "low"
                                                            ? Colors.blue
                                                            : Colors.orange),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Description :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.habit['description'],
                                          maxLines: 10,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            "Gaol :",
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayLarge!
                                                .copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w500),
                                          )),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          widget.habit['goal'],
                                          maxLines: 4,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Divider(
                                thickness: 8,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? darkColor
                                    : lightColor,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                children: [
                                  SizedBox(
                                    height: 90,
                                    width: 320,
                                    child: EasyInfiniteDateTimeLine(
                                      onDateChange: (selectedDate) {
                                        countF = 0;
                                        countP = 0;

                                        setState(() {
                                          _foucsDate = selectedDate;
                                        });

                                        DatabaseHelper.getS(
                                                selectedDate
                                                    .toIso8601String()
                                                    .substring(0, 10),
                                                widget.habit['id_h'])
                                            .then((value) =>
                                                s = value[0]['status']);
                                      },
                                      focusDate: _foucsDate,
                                      firstDate: DateTime.parse(
                                          widget.habit['start_date']),
                                      lastDate: DateTime.parse(
                                          widget.habit['end_date']),
                                      dayProps: EasyDayProps(
                                        todayStyle: DayStyle(
                                          dayStrStyle: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                          dayNumStyle: Theme.of(context)
                                              .textTheme
                                              .displaySmall,
                                          borderRadius: 12,
                                        ),
                                        inactiveDayStyle: DayStyle(
                                            dayStrStyle: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            dayNumStyle: Theme.of(context)
                                                .textTheme
                                                .displaySmall,
                                            borderRadius: 12,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? darkColor
                                                  : lightColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )),
                                        dayStructure: DayStructure.dayStrDayNum,
                                        height: 50,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                    height: 50,
                                    child: Text(s == "F"
                                        ? "This Habit is Copmlepted"
                                        : "This habit is Pending"),
                                  ),
                                ],
                              ),
                              Divider(
                                thickness: 8,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? darkColor
                                    : lightColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              SizedBox(
                                width: 200,
                                height: 160,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Total of Habits : $totalStatus",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                    ),
                                    SizedBox(
                                      width: 200,
                                      height: 120,
                                      child: PieChart(
                                          swapAnimationCurve: Curves.linear,
                                          swapAnimationDuration:
                                              const Duration(milliseconds: 500),
                                          PieChartData(
                                              borderData:
                                                  FlBorderData(show: true),
                                              sections: [
                                                PieChartSectionData(
                                                    value: countF.toDouble(),
                                                    title: "$countF",
                                                    color: Colors.green),
                                                PieChartSectionData(
                                                    value: countP.toDouble(),
                                                    title: "$countP",
                                                    color: Colors.orange)
                                              ])),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  const Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CircleAvatar(
                                        radius: 6,
                                        backgroundColor: Colors.greenAccent,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircleAvatar(
                                        radius: 6,
                                        backgroundColor: Colors.orangeAccent,
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Done",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium!),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text("Pending",
                                          style: Theme.of(context)
                                              .textTheme
                                              .displayMedium),
                                    ],
                                  )
                                ],
                              ),
                            ]),
                      ),
                    ]);
                  }),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
