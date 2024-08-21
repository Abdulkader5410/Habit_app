import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/add_habit/add_habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/models/habit_model.dart';
import 'package:untitled/models/notifi_model.dart';

class AddHabitCubit extends Cubit<AddHabitState> {
  AddHabitCubit() : super(AddHabitInitial());

  GlobalKey<FormState> addHabitForm = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  TextEditingController goalController = TextEditingController();

  String? title;
  String? goal;
  String? desc;

  DateTime? startDate;
  DateTime? endDate;
  int? countNotifi;
  String? priority;
  HabitModel? habitModel;
  DateTime? notifiDate;
  String? timeNotifi;
  List<String> timeNotifiList = [];
  int? idHt;

  addHabit(int idUser) async {
    try {
      emit(AddHabitLoading());

      if (!(priority == null &&
              idHt == null &&
              startDate == null &&
              endDate == null) &&
          addHabitForm.currentState!.validate()) {
        if (endDate!.isBefore(startDate!)) {
          emit(const AddHabitError(
              errMsg: "EndDate must be larger than from StartDate"));
          return;
        }

        await DatabaseHelper.addHabit(HabitModel(
                countNotifi: countNotifi,
                description: descController.text,
                endDate: endDate!.toIso8601String().substring(0, 10),
                goal: goalController.text,
                priority: priority,
                startDate: startDate!.toIso8601String().substring(0, 10),
                status: 'Pending',
                idHt: idHt!,
                idUser: idUser,
                title: titleController.text)
            .toJson());

        List<Map<String, dynamic>> habits =
            await DatabaseHelper.getHabits(idUser).then((value) => value);

        DateTime sDate =
            DateTime.parse(habits[habits.length - 1]['start_date']);
        DateTime eDate = DateTime.parse(habits[habits.length - 1]['end_date']);

        for (DateTime date = sDate;
            date.isBefore(eDate.add(Duration(days: 1)));
            date = date.add(Duration(days: 1))) {
          await DatabaseHelper.addHabitStatus({
            'id_h': habits[habits.length - 1]['id_h'],
            'status': 'P',
            'status_date': date.toIso8601String().substring(0, 10),
          });

          
        }

        if (countNotifi == 1) {
          await DatabaseHelper.addNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifi!,
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
        } else if (countNotifi == 2) {
          await DatabaseHelper.addNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifiList[0],
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
          await DatabaseHelper.addNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifiList[1],
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
        } else if (countNotifi == 3) {
          await DatabaseHelper.addNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[0],
            status: 'waitng',
          ).toJson());
          await DatabaseHelper.addNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[1],
            status: 'waitng',
          ).toJson());
          await DatabaseHelper.addNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[2],
            status: 'waitng',
          ).toJson());
        }

        emit(AddHabitSuccess());
      } else {
        emit(const AddHabitError(errMsg: 'There are fields are empty!'));
      }
    } on Exception catch (e) {
      log("ABD");
      emit(AddHabitFailure(errMsg: e.toString()));
    }
  }
}
