import 'package:untitled/entity/notifi_entity.dart';
import 'package:untitled/entity/user_entitiy.dart';

class NotifiModel extends NotifiEntity {
  NotifiModel({
    super.id,
    super.timeNotifi,
    super.description,
    super.idH,
    super.idT,
    super.status,
    super.title,
  });

  factory NotifiModel.fromjson(Map<String, dynamic> jsonDate) {
    return NotifiModel(
      id: jsonDate['id_n'],
      title: jsonDate['title'],
      description: jsonDate['description'],
      status: jsonDate['status'],
      timeNotifi: jsonDate['time'],
      idH: jsonDate['id_h'],
      idT: jsonDate['id_t'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_n': id,
      'title': title,
      'description': description,
      'status': status,
      'time': timeNotifi,
      'id_h': idH,
      'id_t': idT,
    };
  }
}
