import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/themes/themes.dart';
import 'package:untitled/core/utilities/pass_cubit.dart';
import 'package:untitled/screen/signin/signin_screen.dart';
import 'package:untitled/bloc/signup/signup_cubit.dart';
import 'package:untitled/bloc/signup/signup_state.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Pass passCuibt = Pass();

  GlobalKey<FormState> loginForm = GlobalKey();

  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController passConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Pass pass1 = Pass();
    Pass pass2 = Pass();

    return Scaffold(
      body: BlocConsumer<SignupCubit, SignupState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registered Successfully")));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignInScreen(),
                ));
          } else if (state is SignupFailure) {
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

                  Text("Sign Up",
                      style: Theme.of(context).textTheme.displayLarge),
                  const SizedBox(
                    height: 60,
                  ),
                  Form(
                      key: context.read<SignupCubit>().sigupForm,
                      child: Column(
                        children: [
                          SizedBox(
                              height: 55,
                              child: TextFormField(

                                  //support arabic and english not allowed never

                                  // inputFormatters: <TextInputFormatter>[
                                  //   FilteringTextInputFormatter.allow(
                                  //       RegExp(r'^[a-zA-Z\u0621-\u064A]+$'))
                                  // ],

                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 3) {
                                      return "The must be 3 letters or more!";
                                    }

                                    //support arabic and english in validate

                                    // if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                    //     .hasMatch(value)) {
                                    //   return "Enter Letters";
                                    // }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    context.read<SignupCubit>().name = newValue;
                                  },
                                  cursorHeight: 25,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: const InputDecoration(
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      )),
                                  controller: context
                                      .read<SignupCubit>()
                                      .nameController)),
                          const SizedBox(
                            height: 30,
                          ),
                          BlocBuilder<Pass, bool>(
                            bloc: pass1,
                            builder: (context, state) {
                              return SizedBox(
                                height: 55,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.isEmpty || value.length < 6) {
                                      return "The password must be 6 cahrs!";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    context.read<SignupCubit>().pass = newValue;
                                  },
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
                                  controller: context
                                      .read<SignupCubit>()
                                      .passController,
                                ),
                              );
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          BlocBuilder<Pass, bool>(
                            bloc: pass2,
                            builder: (context, state) {
                              return SizedBox(
                                height: 55,
                                child: TextFormField(
                                  validator: (value) {
                                    if (value !=
                                        context
                                            .read<SignupCubit>()
                                            .passController
                                            .text) {
                                      return "The password not match!";
                                    }
                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    context.read<SignupCubit>().conPass =
                                        newValue;
                                  },
                                  obscureText: !state,
                                  cursorHeight: 25,
                                  textAlignVertical: TextAlignVertical.center,
                                  decoration: InputDecoration(
                                      suffixIcon: GestureDetector(
                                        onTap: () async {
                                          pass2.togglePass();
                                        },
                                        child: Icon(
                                          state
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      hintText: "Confirm Password",
                                      hintStyle: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      )),
                                  controller: context
                                      .read<SignupCubit>()
                                      .conPassController,
                                ),
                              );
                            },
                          ),
                        ],
                      )),
                  // const Text("First Name"),
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
                          context.read<SignupCubit>().signup();
                        },
                        child: BlocBuilder<SignupCubit, SignupState>(
                          builder: (context, state) {
                            if (state is SignupLoading) {
                              return const CircularProgressIndicator(
                                color: lightColor,
                                strokeWidth: 2,
                              );
                            }
                            return const Text(
                              "Sign Up",
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
                        "Already have any account ? ",
                        style: TextStyle(fontSize: 12),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignInScreen(),
                              ));
                        },
                        child: const Text(
                          "Sign In",
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
