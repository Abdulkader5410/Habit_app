import 'package:bcrypt/bcrypt.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/core/database/database_helper.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  SigninCubit() : super(SigninInitial());

  GlobalKey<FormState> siginForm = GlobalKey();
  TextEditingController passController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  int? idUser;

  Future<int> signin() async {
    try {
      emit(SigninLoading());

      List<Map<String, dynamic>> users =
          await DatabaseHelper.getUsers().then((value) => value);

      for (int i = 0; i < users.length; i++) {
        if (nameController.text == users[i]['name'] &&
            BCrypt.checkpw(passController.text, users[i]['pass']) == true) {
          idUser = users[i]['id'];

          SharedPreferences sharedPreferences =
              await SharedPreferences.getInstance();

          sharedPreferences.setInt("idUser", idUser!);

          emit(SigninSuccess());

          return idUser!;
        }
        if (i == users.length - 1) {
          emit(const SigninError(errMsg: "The name or password incorrect !"));
        }
      }
    } on Exception catch (e) {
      emit(SigninFailure(errMsg: e.toString()));
    }
    return -1;
  }
}
