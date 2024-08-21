import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/bloc/add_habit/add_habit_cubit.dart';
import 'package:untitled/bloc/bottom_nav_habit/bottom_nav_habit_cubit.dart';
import 'package:untitled/bloc/habit/habit_cubit.dart';
import 'package:untitled/bloc/onboarding/onboarding_bloc.dart';
import 'package:untitled/bloc/signin/signin_cubit.dart';
import 'package:untitled/bloc/signup/signup_cubit.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/screen/add_habit/add_habit_screen.dart';
import 'package:untitled/screen/home/home_screen.dart';
import 'package:untitled/screen/signup/signup_screen.dart';
import 'package:untitled/screen/splash/splash_screen.dart';
import 'bloc/delete habit/delete_habit_cubit.dart';
import 'bloc/edit hab/edit_habit_cubit.dart';
import 'core/themes/theme bloc/theme_bloc.dart';

bool isClickOnDone = false;
SharedPreferences? sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.database;
  sp = await SharedPreferences.getInstance();


  runApp(const MyApp());
}

int userId = -1;

void getUser() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  int? u = sharedPreferences.getInt("idUser");
  if (u == null) {
    userId = -1;
  } else {
    userId = u;
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getUser();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc()..add(GetCurrentThemeEvent()),
        ),
        BlocProvider(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider(
          create: (context) => SignupCubit(),
        ),
        BlocProvider(
          create: (context) => SigninCubit(),
        ),
        BlocProvider(
          create: (context) => AddHabitCubit(),
        ),
        BlocProvider(
          create: (context) => HabitCubit(),
        ),
        BlocProvider(
          create: (context) => NavCubit(),
        ),
        BlocProvider(
          create: (context) => DeleteHabitCubit(),
        ),
        BlocProvider(
          create: (context) => EditHabitCubit(),
        )
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          if (state is LoadedThemeState) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: state.themeData,
              home: userId == -1
                  ? const SplashScreen()
                  : HomeScreen(
                      userId: userId,
                    ),

            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
