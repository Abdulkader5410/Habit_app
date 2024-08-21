import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/delete%20habit/delete_habit_state.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/main.dart';

class DeleteHabitCubit extends Cubit<DeleteHabitState> {
  DeleteHabitCubit() : super(DeleteHabitInitial());

  deleteHabit(int userId, int habitId) async {
    try {
      emit(DeleteHabitLoading());

      print("habitId1 : $habitId");

      await DatabaseHelper.deleteNotifi(habitId);
      print("habitId2 : $habitId");

      await DatabaseHelper.deleteHabitStatus(habitId);
      print("habitId3 : $habitId");

      await DatabaseHelper.deleteHabit(userId, habitId);

      sp!.setBool("isNoti", false);

      print("habitId4 : $habitId");

      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          emit(const DeleteHabitSuccess(msg: "Deleted Successefully"));
        },
      );
    } on Exception catch (e) {
      emit(DeleteHabitError(errMsg: e.toString()));
    }
  }
}
