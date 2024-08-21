import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/bloc/add_habit/add_habit_cubit.dart';
import 'package:untitled/core/themes/themes.dart';

class TextFormWidget extends StatelessWidget {
  final String name;
  String? text;
  final TextEditingController controller;
  TextFormWidget(
      {super.key, required this.name, required this.controller, this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          validator: (value) {
            if (value!.isEmpty) {
              return "The filed is empty !!";
            }
            return null;
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onSaved: (newValue) {
            name == 'Title of habit'
                ? context.read<AddHabitCubit>().title = newValue
                : name == 'Goal of habit'
                    ? context.read<AddHabitCubit>().goal = newValue
                    : context.read<AddHabitCubit>().desc = newValue;
          },
          
          controller: controller,
          cursorColor: primaryColor,
          cursorHeight: 20,
          minLines: 1,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          style: Theme.of(context).textTheme.displayMedium,
          decoration: InputDecoration(labelText: text, hintText: name),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
