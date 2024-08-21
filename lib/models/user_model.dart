import 'package:untitled/entity/user_entitiy.dart';

class UserModel extends UserEntity {
  UserModel({
    super.id,
    super.pass,
    super.conPass,
    super.name,
  });

  factory UserModel.fromjson(Map<String, dynamic> jsonDate) {
    return UserModel(
      id: jsonDate['id'],
      name: jsonDate['name'],
      // password: jsonDate[ApiKey.password],
      pass: jsonDate['pass'],
      conPass: jsonDate['con_pass'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pass': pass,
      'con_pass': conPass,
    };
  }
}
