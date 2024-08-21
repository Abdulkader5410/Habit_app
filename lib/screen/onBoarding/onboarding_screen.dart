import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/onboarding/onboarding_bloc.dart';
import 'package:untitled/bloc/onboarding/onboarding_event.dart';
import 'package:untitled/bloc/onboarding/onboarding_state.dart';
import 'package:untitled/notifi.dart';
import 'package:untitled/screen/onBoarding/dot_widget.dart';
import 'package:untitled/screen/onBoarding/onboarding_widget.dart';
import 'package:untitled/screen/signup/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  PageController pageController = PageController();

  List<String> images = [
    "assets/images/img1.png",
    "assets/images/img3.png",
    "assets/images/img2.png",
    "assets/images/img4.png",
  ];
  List<String> titles = [
    "Welcome to the habit app !",
    "Create a new habit and task",
    "Tracke your progress",
    "Let's GO"
  ];
  List<String> subtitles = [
    "Discover the power of shaping new habits to imporve your life",
    "Define the habits and tasks to develop and track them daily",
    "Monitor your progress in developing your habits and tasks",
    "Begin your journey to develop new habits and enjoy improving your life",
  ];

  int currIndex = 0;

  @override
  Widget build(BuildContext context) {
   

    return Scaffold(
      body: BlocBuilder<OnboardingBloc, ChangedPageState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.75,
                    child: PageView.builder(
                      itemCount: 4,
                      onPageChanged: (index) {
                        currIndex = index;
                        state.index = index;
                        BlocProvider.of<OnboardingBloc>(context)
                            .add(NextPageEvent());
                      },
                      controller: pageController,
                      itemBuilder: (context, index) {
                        return OnboardingWidget(
                            title: titles[index],
                            subtitle: subtitles[index],
                            imagePath: images[index]);
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DotWidget(
                        currIndex: 0,
                        pageController: pageController,
                        state: state),
                    DotWidget(
                        currIndex: 1,
                        pageController: pageController,
                        state: state),
                    DotWidget(
                        currIndex: 2,
                        pageController: pageController,
                        state: state),
                    DotWidget(
                        currIndex: 3,
                        pageController: pageController,
                        state: state),
                  ],
                )
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: BlocBuilder<OnboardingBloc, ChangedPageState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.only(bottom: 8, right: 8, left: 8),
            width: MediaQuery.sizeOf(context).width * 0.90,
            height: MediaQuery.sizeOf(context).height * 0.08,
            child: ElevatedButton(
              onPressed: () {
                if (currIndex < 3) {
                  pageController.animateToPage(currIndex + 1,
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.fastOutSlowIn);
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUpScreen(),
                      ));
                }
              },
              child: Text(
                state.index == 3 ? "Let's GO" : "next",
                style: Theme.of(context)
                    .textTheme
                    .displayMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
