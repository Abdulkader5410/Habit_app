import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/core/utilities/pass_cubit.dart';
import 'package:untitled/bloc/signin/signin_cubit.dart';
import 'package:untitled/screen/home/home_screen.dart';
import 'package:untitled/screen/signup/signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  // Pass passCuibt = Pass();

  GlobalKey<FormState> loginForm = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();

  String? level;
  int? id;

  @override
  Widget build(BuildContext context) {
    Pass pass1 = Pass();

    return Scaffold(
      body: BlocConsumer<SigninCubit, SigninState>(
        listener: (context, state) {
          if (state is SigninSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged Successfully")));
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(userId: id),
                ));
          } else if (state is SigninError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.errMsg)));
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 200),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 10),

                  Text("Sign In",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 60,
                  ),

                  // const Text("First Name"),
                  SizedBox(
                      height: 55,
                      child: TextFormField(
                          cursorHeight: 25,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: const InputDecoration(
                              hintText: "Name",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              )),
                          controller:
                              context.read<SigninCubit>().nameController)),
                  const SizedBox(
                    height: 30,
                  ),

                  BlocBuilder<Pass, bool>(
                    bloc: pass1,
                    builder: (context, state) {
                      return SizedBox(
                        height: 55,
                        child: TextFormField(
                          obscureText: !state,
                          cursorHeight: 25,
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  pass1.togglePass();
                                },
                                child: Icon(
                                  state
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                              ),
                              hintText: "Password",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              )),
                          controller:
                              context.read<SigninCubit>().passController,
                        ),
                      );
                    },
                  ),

                  const SizedBox(
                    height: 30,
                  ),

                  const SizedBox(
                    height: 60,
                  ),
                  SizedBox(
                      height: 50,
                      width: MediaQuery.sizeOf(context).width,
                      child: ElevatedButton(
                        style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)))),
                            backgroundColor:
                                MaterialStatePropertyAll(primaryColor)),
                        onPressed: () async {
                          id = await context.read<SigninCubit>().signin();
                        },
                        child: BlocBuilder<SigninCubit, SigninState>(
                          builder: (context, state) {
                            if (state is SigninLoading) {
                              return const CircularProgressIndicator(
                                color: lightColor,
                                strokeWidth: 2,
                              );
                            }
                            return const Text(
                              "Sign In",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            );
                          },
                        ),
                      )),

                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "You have not an account ? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignUpScreen(),
                              ));
                        },
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
