// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class NotifiEntity extends Equatable {
  int? id;
  String? title;
  String? description;
  String? status;
  String? timeNotifi;
  int? idH;
  int? idT;

  NotifiEntity({
    this.id,
    this.title,
    this.timeNotifi,
    this.description,
    this.status,
    this.idH,
    this.idT,
  });
  @override
  List<Object?> get props =>
      [id, description, timeNotifi, status, idH, idT, title];
}
