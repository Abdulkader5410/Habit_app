
import 'package:equatable/equatable.dart';

sealed class BottomNavHabitState extends Equatable {
  const BottomNavHabitState();

  @override
  List<Object> get props => [];
}

final class BottomNavHabitInitial extends BottomNavHabitState {}
