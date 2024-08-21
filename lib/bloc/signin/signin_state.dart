part of 'signin_cubit.dart';

sealed class SigninState extends Equatable {
  const SigninState();

  @override
  List<Object> get props => [];
}

final class SigninInitial extends SigninState {}

final class SigninLoading extends SigninState {}

final class SigninSuccess extends SigninState {}

final class SigninError extends SigninState {
  final String errMsg;

  const SigninError({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}

final class SigninFailure extends SigninState {
  final String errMsg;

  const SigninFailure({required this.errMsg});
  @override
  List<Object> get props => [errMsg];
}
