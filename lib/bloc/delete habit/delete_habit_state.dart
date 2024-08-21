
import 'package:equatable/equatable.dart';

sealed class DeleteHabitState extends Equatable {
  const DeleteHabitState();

  @override
  List<Object> get props => [];
}

final class DeleteHabitInitial extends DeleteHabitState {}



final class DeleteHabitLoading extends DeleteHabitState {}

final class DeleteHabitSuccess extends DeleteHabitState {
  final String msg;

  const DeleteHabitSuccess({required this.msg});
  @override
  List<Object> get props => [msg];

}

final class DeleteHabitError extends DeleteHabitState {
  final String errMsg;

  const DeleteHabitError({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

