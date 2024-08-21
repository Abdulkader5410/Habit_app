// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class HabitEntity extends Equatable {
  int? id;
  String? priority;
  String? title;
  String? description;
  String? goal;
  String? status;
  String? startDate;
  String? endDate;
  int? countNotifi;
  int? idHt;
  int? idUser;

  HabitEntity({
    this.id,
    this.title,
    this.description,
    this.goal,
    this.startDate,
    this.endDate,
    this.status,
    this.idHt,
    this.idUser,
    this.countNotifi,
    this.priority,
  });
  @override
  List<Object?> get props => [
        id,
        title,
        description,
        goal,
        startDate,
        endDate,
        status,
        idHt,
        idUser,
        countNotifi,
        priority,
      ];
}
