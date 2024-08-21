import 'package:flutter/material.dart';
import 'package:untitled/screen/onBoarding/onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double op = 0;

  @override
  void initState() {
    super.initState();
    _fadeOp();

    Future.delayed(
      const Duration(seconds: 3),
      () {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const OnboardingScreen(),
            ));
      },
    );
  }

  void _fadeOp() {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        setState(() {
          op = 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    

    return Scaffold(
      body: AnimatedOpacity(
        duration: const Duration(seconds: 1),
        opacity: op,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: MediaQuery.sizeOf(context).width / 4,
                  height: MediaQuery.sizeOf(context).height / 4,
                  child: const Icon(size: 100, Icons.check_circle_sharp)),
              Text(
                "Habit App",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
      ),
    );

    
  }
}
