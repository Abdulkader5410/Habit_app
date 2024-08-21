import 'package:flutter/material.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/habit/habit_cubit.dart';
import 'package:untitled/bloc/habit/habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/notifi.dart';
import 'package:untitled/screen/add_habit/add_habit_screen.dart';
import 'package:untitled/screen/habit/habit_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'package:jiffy/jiffy.dart';

class HabitScreen extends StatefulWidget {
  int? idUser;
  HabitScreen({super.key, this.idUser});

  @override
  State<HabitScreen> createState() => _HabitScreenState();
}

class _HabitScreenState extends State<HabitScreen> {
  DateTime? dateOfStatus;

  @override
  Widget build(BuildContext context) {
    context.read<HabitCubit>().getHabitsByDate(DateTime.now(), widget.idUser!);

    return Scaffold(
      floatingActionButton: SizedBox(
        width: 55,
        height: 55,
        child: FloatingActionButton(
          heroTag: 1,
          backgroundColor: primaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddHabitScreen(
                    idUser: widget.idUser!,
                    isUpdate: false,
                  ),
                ));
          },
          child: Icon(
            Icons.add,
            color: Theme.of(context).brightness == Brightness.dark
                ? darkColor
                : lightColor,
          ),
        ),
      ),
      body: Container(
          margin: const EdgeInsets.only(top: 30),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(9),
                  child: EasyDateTimeLine(
                    initialDate: DateTime.now(),
                    headerProps: EasyHeaderProps(
                        selectedDateStyle:
                            Theme.of(context).textTheme.displayMedium,
                        monthPickerType: MonthPickerType.switcher),
                    dayProps: EasyDayProps(
                      todayStyle: DayStyle(
                        dayStrStyle: Theme.of(context).textTheme.displaySmall,
                        dayNumStyle: Theme.of(context).textTheme.displaySmall,
                        borderRadius: 12,
                      ),
                      inactiveDayStyle: DayStyle(
                          dayStrStyle: Theme.of(context).textTheme.displaySmall,
                          dayNumStyle: Theme.of(context).textTheme.displaySmall,
                          borderRadius: 12,
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? darkColor
                                    : lightColor,
                            borderRadius: BorderRadius.circular(12),
                          )),
                      dayStructure: DayStructure.dayStrDayNum,
                      height: 60,
                      width: 50,
                    ),
                    onDateChange: (selectedDate) {
                      context
                          .read<HabitCubit>()
                          .getHabitsByDate(selectedDate, widget.idUser!);
                      dateOfStatus = selectedDate;
                    },
                  ),
                ),
                BlocBuilder<HabitCubit, HabitState>(
                  builder: (context, state) {
                    
                    if (state is HabitLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                          strokeWidth: 2,
                        ),
                      );
                    } else if (state is HabitError) {
                      return Expanded(
                        child: Center(child: Text(state.errMsg)),
                      );
                    } else if (state is HabitSuccess) {
                      return Expanded(
                        child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: state.habits.length,
                          itemBuilder: (context, index) {
                            return HabitWidget(
                                date: dateOfStatus == null
                                    ? DateTime.now()
                                    : dateOfStatus!,
                                habit: state.habits[index]);
                          },
                        ),
                      );
                    } else {
                      return Container(
                        color: Colors.red,
                      );
                    }
                  },
                )
              ])),
    );
  }
}
