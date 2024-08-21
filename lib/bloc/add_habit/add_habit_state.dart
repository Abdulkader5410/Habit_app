import 'package:equatable/equatable.dart';

sealed class AddHabitState extends Equatable {
  const AddHabitState();

  @override
  List<Object> get props => [];
}

final class AddHabitInitial extends AddHabitState {}

final class AddHabitLoading extends AddHabitState {}

final class AddHabitSuccess extends AddHabitState {}

final class AddHabitError extends AddHabitState {
  final String errMsg;

  const AddHabitError({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

final class AddHabitFailure extends AddHabitState {
  final String errMsg;

  const AddHabitFailure({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}
