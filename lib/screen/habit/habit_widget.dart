import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/delete%20habit/delete_habit_cubit.dart';
import 'package:untitled/bloc/delete%20habit/delete_habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/main.dart';
import 'package:untitled/screen/add_habit/add_habit_screen.dart';
import 'package:untitled/screen/habit%20details/habit_details_screen.dart';
import 'package:untitled/screen/home/home_screen.dart';

class HabitWidget extends StatefulWidget {
  final Map<String, dynamic> habit;
  final DateTime date;

  HabitWidget({
    required this.habit,
    required this.date,
    super.key,
  });

  @override
  State<HabitWidget> createState() => _HabitWidgetState();
}

class _HabitWidgetState extends State<HabitWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getHS();
  }

  Future<List<Map<String, dynamic>>> getHabitTypesById(int idHt) async {
    return await DatabaseHelper.getHabitTypesById(idHt);
  }

  List<Map<String, dynamic>>? habitS;

  String? status;

  Future<void> getHS() async {
    List<Map<String, dynamic>> habitsStatus = await DatabaseHelper.getS(
            widget.date.toIso8601String().substring(0, 10),
            widget.habit['id_h'])
        .then((value) => habitS = value);
    Future.delayed(const Duration(milliseconds: 500), () {
      habitS = habitsStatus;
    });
    habitS = habitsStatus;
  }

  void checkStatus() async {
    if (isClickOnDone) {
      getHS();
      Future.delayed(const Duration(milliseconds: 200), () async {
        await DatabaseHelper.updateHabitStatus(habitS![0]['id_hs'],
            habitS![0]['id_h'], "F", habitS![0]['status_date']);
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        status = habitS![0]['status'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    checkStatus();

    getHS();

    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return FutureBuilder(
              future: getHabitTypesById(widget.habit['id_ht']),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Future.delayed(const Duration(milliseconds: 900), () {
                    print("x");
                  });

                  return Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? darkColor
                            : lightColor,
                        borderRadius: BorderRadius.circular(25)),
                    height: 120,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            height: 120,
                            width: 80,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25)),
                            child: Icon(
                              size: 40,
                              IconData(snapshot.data![0]['icon'],
                                  fontFamily: 'MaterialIcons'),
                              color: Color(snapshot.data![0]['color']),
                            )),
                        const SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          height: 120,
                          width: MediaQuery.sizeOf(context).width - 144,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data![0]['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
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
                                          "${widget.habit['priority']}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                            size: 15,
                                            Icons.flag_outlined,
                                            color: widget.habit['priority'] ==
                                                    "high"
                                                ? Colors.red
                                                : widget.habit['priority'] ==
                                                        "low"
                                                    ? Colors.blue
                                                    : Colors.orange),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                "${widget.habit['title']}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const Divider(
                                color: Colors.black,
                                thickness: 1,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  FutureBuilder(
                                      future: getHS(),
                                      builder: (context, snapshot) {
                                        print("habitS :  $habitS");
                                        return Text(
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,

                                          habitS![0]['status'] == 'F'
                                              ? "Completed"
                                              : "Pending",
                                          // style: styleSubtites.copyWith(
                                          //   fontWeight: FontWeight.w400,
                                          // ),
                                        );
                                      }),
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HabitDetailsScreen(
                                                        habit: widget.habit,
                                                        date: widget.date),
                                              ));
                                        },
                                        child: const Icon(
                                            size: 20,
                                            Icons.stacked_bar_chart_rounded),
                                      ),
                                      const SizedBox(width: 15),
                                      GestureDetector(
                                          onTap: () {
                                            options(context, userId,
                                                widget.habit['id_h']);
                                          },
                                          child: const Icon(
                                              size: 20, Icons.more_vert_sharp)),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 10),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              });
        });
  }

  void options(BuildContext context, int userId, int habitId) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BlocConsumer<DeleteHabitCubit, DeleteHabitState>(
          listener: (context, state) {
            if (state is DeleteHabitSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.msg)));
              Navigator.pop(context);
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeScreen(
                            userId: userId,
                          )));
            }
          },
          builder: (context, state) {
            return Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? darkColor
                        : lightColor,
                    borderRadius: BorderRadius.circular(25)),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddHabitScreen(
                                idHabit: widget.habit['id_h'],
                                desc: widget.habit['description'],
                                goal: widget.habit['goal'],
                                habitType: widget.habit['id_ht'],
                                idUser: widget.habit['id_u'],
                                isUpdate: true,
                                priority: widget.habit['priority'],
                                title: widget.habit['title'],
                              ),
                            ));
                      },
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 90,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.edit,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Edit",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                    GestureDetector(
                      onTap: () {
                        context
                            .read<DeleteHabitCubit>()
                            .deleteHabit(userId, habitId);
                      },
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width,
                        height: 90,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                "Delete",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(color: Colors.red, fontSize: 24),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ));
          },
        );
      },
    );
  }
}
