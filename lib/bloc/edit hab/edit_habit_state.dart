import 'package:equatable/equatable.dart';

sealed class EditHabitState extends Equatable {
  const EditHabitState();

  @override
  List<Object> get props => [];
}

final class EditHabitInitial extends EditHabitState {}

final class EditHabitLoading extends EditHabitState {}

final class EditHabitSuccess extends EditHabitState {}

final class EditHabitError extends EditHabitState {
  final String errMsg;

  const EditHabitError({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

final class EditHabitFailure extends EditHabitState {
  final String errMsg;

  const EditHabitFailure({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}
