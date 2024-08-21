import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/habit/habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitInitial());


  getHabitsByDate(DateTime date, int userId) async {
    try {
      emit(HabitLoading());

      List<Map<String, dynamic>> habits =
          await DatabaseHelper.getHabitsByDate(date, userId);

      if (habits.isEmpty) {
        emit(const HabitError(errMsg: "No Habits yet !"));
      } else {
        log("$habits");
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            emit(HabitSuccess(habits: habits));
          },
        );
      }
    } on Exception catch (e) {
      emit(HabitFailure(errMsg: e.toString()));
    }
  }
}
