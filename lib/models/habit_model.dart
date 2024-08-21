import 'package:untitled/entity/habit_entity.dart';

class HabitModel extends HabitEntity {
  HabitModel({
    super.id,
    super.countNotifi,
    super.description,
    super.endDate,
    super.startDate,
    super.goal,
    super.idHt,
    super.idUser,
    super.priority,
    super.status,
    super.title,
  });

  factory HabitModel.fromjson(Map<String, dynamic> jsonDate) {
    return HabitModel(
      id: jsonDate['id_h'],
      title: jsonDate['title'],
      description: jsonDate['description'],
      countNotifi: jsonDate['count_notifi'],
      endDate: jsonDate['end_date'],
      goal: jsonDate['goal'],
      idHt: jsonDate['id_ht'],
      idUser: jsonDate['id_u'],
      priority: jsonDate['priority'],
      startDate: jsonDate['start_date'],
      status: jsonDate['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_h': id,
      'title': title,
      'description': description,
      'goal': goal,
      'priority': priority,
      'status': status,
      'start_date': startDate,
      'end_date': endDate,
      'count_notifi': countNotifi,
      'id_ht': idHt,
      'id_u': idUser
    };
  }
}
