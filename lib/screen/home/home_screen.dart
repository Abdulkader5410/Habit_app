import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/bottom_nav_habit/bottom_nav_habit_cubit.dart';
import 'package:untitled/core/themes/theme%20bloc/theme_bloc.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/notifi.dart';
import 'package:untitled/screen/habit/habit_screen.dart';
import 'package:untitled/screen/timer/timer_home_screen.dart';

class HomeScreen extends StatefulWidget {

  int? userId;

  HomeScreen({super.key, this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavCubit, int>(
      builder: (context, index) {
        return Scaffold(
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 70, right: 9),
            child: Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                    width: 35,
                    height: 35,
                    child: FloatingActionButton(
                        heroTag: 2,
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.dark
                                ? darkColor
                                : lightColor,
                        child: Icon(
                          Theme.of(context).brightness == Brightness.dark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? lightColor
                              : darkColor,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Center(
                                  child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? darkColor
                                              : lightColor,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      width: 100,
                                      height: 100,
                                      child: const CircularProgressIndicator(
                                        color: primaryColor,
                                      )));
                            },
                          );

                          if (Theme.of(context).brightness == Brightness.dark) {
                            context.read<ThemeBloc>().add(
                                ChangeThemeEvent(myThemes: MyThemes.values[0]));
                          } else if (Theme.of(context).brightness ==
                              Brightness.light) {
                            context.read<ThemeBloc>().add(
                                ChangeThemeEvent(myThemes: MyThemes.values[1]));
                          }
                          Future.delayed(
                            const Duration(seconds: 2),
                            () {
                              Navigator.pop(context);
                            },
                          );
                        }))),
          ),
          body: _getPage(index, widget.userId, context),
          bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                  ? darkColor
                  : lightColor,
              unselectedLabelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  fontFamily: "jozoor"),
              selectedLabelStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: "jozoor"),
              fixedColor: primaryColor,
              currentIndex: index,
              onTap: (val) {
                context.read<NavCubit>().changePage(val);
              },
              items: const [
                BottomNavigationBarItem(
                  label: "Habits",
                  icon: Icon(Icons.local_activity_outlined),
                ),
                BottomNavigationBarItem(
                    label: "Timer", icon: Icon(Icons.timer_outlined)),

              ]),
        );
      },
    );
  }
}

Widget _getPage(int index, int? userId, BuildContext context) {
  switch (index) {
    case 0:
      return HabitScreen(idUser: userId);

    case 1:
      return const TimerHomeScreen();
    default:
      return HabitScreen(
        idUser: userId,
      );
  }
}