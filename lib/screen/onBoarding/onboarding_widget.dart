import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String title, subtitle, imagePath;

  const OnboardingWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imagePath,
            width: MediaQuery.sizeOf(context).width * 1,
            height: MediaQuery.sizeOf(context).height * 0.35,
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
              //  style: styleTitles
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
              width: 200,
              child: Text(
                subtitle,

                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,

                //  style: styleSubtites
              )),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
