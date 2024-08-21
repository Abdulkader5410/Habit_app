part of 'theme_bloc.dart';


sealed class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}


class GetCurrentThemeEvent extends ThemeEvent {}


class ChangeThemeEvent extends ThemeEvent {
  final MyThemes myThemes;

  const ChangeThemeEvent({required this.myThemes});

  @override
  List<Object> get props => [myThemes];
}