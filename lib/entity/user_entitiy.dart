// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  int? id;
  String? pass;
  String? conPass;
  String? name;

  UserEntity({
    this.id,
    this.pass,
    this.conPass,
    this.name,
  });
  @override
  List<Object?> get props => [
        id,
        conPass,
        pass,
        name,
      ];
}
