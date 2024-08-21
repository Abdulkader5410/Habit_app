import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/edit%20hab/edit_habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/models/habit_model.dart';
import 'package:untitled/models/notifi_model.dart';


class EditHabitCubit extends Cubit<EditHabitState> {

  

  EditHabitCubit() : super(EditHabitInitial());

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

  editHabit(int idUser, int idHabit) async {
    try {
      emit(EditHabitLoading());

      log("$priority  $idHt  $startDate  $endDate  ${addHabitForm.currentState!.validate()}");

      if (!(priority == null &&
              idHt == null &&
              startDate == null &&
              endDate == null) &&
          addHabitForm.currentState!.validate()) {
        if (endDate!.isBefore(startDate!)) {
          emit(const EditHabitError(
              errMsg: "EndDate must be larger than from StartDate"));
          return;
        }

        await DatabaseHelper.updateHabit(HabitModel(
                id: idHabit,
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

        if (countNotifi == 1) {
          await DatabaseHelper.updateNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifi!,
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
        } else if (countNotifi == 2) {
          await DatabaseHelper.updateNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifiList[0],
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
          await DatabaseHelper.updateNotifi(NotifiModel(
                  title: 'Habit',
                  description: 'Notification for habit',
                  timeNotifi: timeNotifiList[1],
                  status: 'waitng',
                  idH: habits[habits.length - 1]['id_h'])
              .toJson());
        } else if (countNotifi == 3) {
          await DatabaseHelper.updateNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[0],
            status: 'waitng',
          ).toJson());
          await DatabaseHelper.updateNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[1],
            status: 'waitng',
          ).toJson());
          await DatabaseHelper.updateNotifi(NotifiModel(
            title: 'Habit',
            description: 'Notification for habit',
            timeNotifi: timeNotifiList[2],
            status: 'waitng',
          ).toJson());
        }

        emit(EditHabitSuccess());
      } else {
        log("message else");

        emit(const EditHabitError(errMsg: 'There are fields are empty!'));
      }
    } on Exception catch (e) {
      emit(EditHabitFailure(errMsg: e.toString()));
    }
  }
}
