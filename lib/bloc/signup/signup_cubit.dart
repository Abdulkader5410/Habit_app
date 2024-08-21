import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/core/database/database_helper.dart';
import 'package:untitled/models/user_model.dart';
import 'package:untitled/bloc/signup/signup_state.dart';
import 'package:bcrypt/bcrypt.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupInitial());

  GlobalKey<FormState> sigupForm = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController conPassController = TextEditingController();

  UserModel? userModel;

  String? name;
  String? pass;
  String? conPass;

  signup() async {
    try {
      emit(SignupLoading());

      if (sigupForm.currentState!.validate()) {
        sigupForm.currentState!.save();

        String salt1 = BCrypt.gensalt();
        String hPass1 = BCrypt.hashpw(passController.text, salt1);

        String salt2 = BCrypt.gensalt();
        String hPass2 = BCrypt.hashpw(passController.text, salt2);

        print("Password is encrypt :  $hPass1");
        print("Confirm Password is encrypt :  $hPass2");

        await DatabaseHelper.addUser(
            UserModel(name: nameController.text, pass: hPass1, conPass: hPass2)
                .toJson());

        emit(SignupSuccess());
      } else {
        emit(const SignupFailure(errMsg: "There are empty fields !"));
      }
    } on Exception catch (e) {
      emit(SignupFailure(errMsg: e.toString()));
    }
  }
}
