import 'package:equatable/equatable.dart';

sealed class HabitState extends Equatable {
  const HabitState();

  @override
  List<Object> get props => [];
}

final class HabitInitial extends HabitState {}

final class HabitLoading extends HabitState {}

final class HabitSuccess extends HabitState {
  final List<Map<String, dynamic>> habits;
  const HabitSuccess({required this.habits});
  @override
  List<Object> get props => [habits];
}

final class HabitError extends HabitState {
  final String errMsg;

  const HabitError({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

final class HabitFailure extends HabitState {
  final String errMsg;

  const HabitFailure({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}
