import 'package:flutter/material.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/bloc/onboarding/onboarding_state.dart';

class DotWidget extends StatelessWidget {
  final int currIndex;
  final PageController pageController;
  final ChangedPageState state;

  const DotWidget(
      {super.key,
      required this.currIndex,
      required this.pageController,
      required this.state});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () {
            pageController.animateToPage(currIndex,
                duration: const Duration(milliseconds: 900),
                curve: Curves.linear);
          },
          child: AnimatedContainer(
            curve: Curves.linear,
            duration: const Duration(milliseconds: 400),
            width: state.index == currIndex ? 30: 10,
            height: 10,
            decoration: BoxDecoration(
                color: state.index == currIndex ? primaryColor : Colors.grey,
                borderRadius: BorderRadius.circular(1000)),
          ),
        ),
        const SizedBox(
          width: 20,
        )
      ],
    );
  }
}
