import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/onboarding/onboarding_event.dart';
import 'package:untitled/bloc/onboarding/onboarding_state.dart';

class OnboardingBloc extends Bloc<NextPageEvent, ChangedPageState> {
  OnboardingBloc() : super(ChangedPageState()) {
    on<NextPageEvent>((event, emit) {
      emit(ChangedPageState(index: state.index));
    });
  }
}
