import 'dart:developer';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  static Future<Database> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'habit.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {

    }
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE user(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      pass text,
      con_pass text
    )
    ''');

    await db.execute('''
    CREATE TABLE habit (
      id_h INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description text,
      goal text,
      priority text,
      status text,
      start_date date,
      end_date date,
      count_notifi int,
      id_ht int,
      id_u int,
      FOREIGN KEY (id_ht) REFERENCES habit_type(id_ht) ON DELETE CASCADE ON UPDATE CASCADE
      FOREIGN KEY (id_u) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE habit_status (
      id_hs INTEGER PRIMARY KEY AUTOINCREMENT,
      id_h INTEGER ,
      status text,
      status_date date,
      FOREIGN KEY (id_h) REFERENCES habit(id_h) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE habit_type (
      id_ht INTEGER PRIMARY KEY AUTOINCREMENT,
      color int,
      icon int,
      name text
          )
    ''');

    await db.execute('''
    CREATE TABLE task (
      id_t INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description text,
      priority int,
      status text,
      date_t date,
      count_notifi,
      id_u int,
      FOREIGN KEY (id_u) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE notifi (
      id_n INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description text,
      status text,
      time text,
      id_h int, 
      id_t int,
      FOREIGN KEY (id_h) REFERENCES habit(id_h) ON DELETE CASCADE ON UPDATE CASCADE,
      FOREIGN KEY (id_t) REFERENCES task(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');

    await db.execute('''
    CREATE TABLE report (
      id_r INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT,
      description text,
      date_r date,
      task_com int,
      task_uncom int,
      habit_com int,
      habit_uncom int,
      rate double,
      FOREIGN KEY (id_r) REFERENCES user(id) ON DELETE CASCADE ON UPDATE CASCADE
    )
    ''');

    log("CREATED DATABSE");

    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFba55d3 , 0xefc0 , "Sport")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFff4500 , 0xf114 , "Home")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFffd700 , 0xf072b , "Work")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFF008000 , 0xf0f2 , "Health")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFF48d1cc , 0xf1c2 , "Study")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFF808000 , 0xf22b , "Stop")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFF443cc , 0xf428 , "Task")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFff1493 , 0xf1e7 , "Other")');
    await db.rawInsert(
        'insert into habit_type (color , icon , name) values (0xFFff8712 , 0xf111 , "Time")');

  }

  //insert

  static Future<int> addUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('user', user);
  }

  static Future<int> addHabit(Map<String, dynamic> habit) async {
    final db = await database;
    return await db.insert('habit', habit);
  }

  static Future<int> addNotifi(Map<String, dynamic> notifi) async {
    final db = await database;
    return await db.insert('notifi', notifi);
  }

  static Future<int> addHabitStatus(Map<String, dynamic> hs) async {
    final db = await database;
    return await db.insert('habit_status', hs);
  }

  //udapte

  static Future<int> updateUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db
        .update('user', user, where: 'id = ?', whereArgs: [user['id']]);
  }

  static Future<int> updateHabit(Map<String, dynamic> habit) async {
    final db = await database;
    return await db
        .update('habit', habit, where: 'id_h = ?', whereArgs: [habit['id_h']]);
  }

  static Future<int> updateNotifi(Map<String, dynamic> notifi) async {
    final db = await database;
    return await db.update('notifi', notifi,
        where: 'id_n = ?', whereArgs: [notifi['id_n']]);
  }

  static Future<void> updateHabitStatus(
      int idHs, int idH, String status, String date) async {
    final db = await database;
    await db.update('habit_status', {'status': status},
        where: 'id_hs =? and id_h = ? and status_date = ?',
        whereArgs: [
          idHs,
          idH,
          date,
        ]);
  }

  //delelte

  static Future<int> deleteUser(int idUser) async {
    final db = await database;
    return await db.delete('user', where: 'id = ?', whereArgs: [idUser]);
  }

  static Future<int> deleteHabit(int idUser, int idHabit) async {
    final db = await database;
    return await db.delete('habit',
        where: 'id_h = ? and id_u =?', whereArgs: [idHabit, idUser]);
  }

  static Future<int> deleteNotifi(int idHabit) async {
    final db = await database;
    return await db.delete('notifi',
        where: 'id_h = ?', whereArgs: [idHabit]);
  }

  static Future<int> deleteHabitStatus(int idHabit) async {
    final db = await database;
    return await db
        .delete('habit_status', where: 'id_h = ?', whereArgs: [idHabit]);
  }

  //get

  static Future<List<Map<String, dynamic>>> getNotifi() async {
    final db = await database;
    return await db.query('notifi');
  }

  static Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    return await db.query('user');
  }

  static Future<List<Map<String, dynamic>>> getHabits(int idUser) async {
    final db = await database;
    return await db.query('habit', where: 'id_u = ?', whereArgs: [idUser]);
  }

  static Future<List<Map<String, dynamic>>> getNotifis() async {
    final db = await database;
    return await db.query('notifi');
  }

  static Future<List<Map<String, dynamic>>> getHabitTypes() async {
    final db = await database;
    return await db.query('habit_type');
  }

  static Future<List<Map<String, dynamic>>> getHabitTypesById(int idHt) async {
    final db = await database;
    return await db.query('habit_type', where: 'id_ht = ?', whereArgs: [idHt]);
  }

  static Future<List<Map<String, dynamic>>> getHabitsByDate(
      DateTime date, int userId) async {
    String sDate = date.toIso8601String().substring(0, 10);
    final db = await database;
    return await db.rawQuery('''select * from habit 
        where '$sDate' between start_date and end_date 
        and id_u = $userId ''');
  }

  static Future<String> getStatus(int idH, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> res = await db.query('habit_status',
        columns: ['status'],
        where: 'id_h =? and status_date = ?',
        whereArgs: [idH, date]);

    if (res.isNotEmpty) {
      return res.first['status'];
    } else {
      return "Empty";
    }
  }

  static Future<List<Map<String, dynamic>>> getS(String date, int idH) async {
    final db = await database;
    return await db.query('habit_status',
        where: 'id_h = ? and status_date = ?', whereArgs: [idH, date]);
  }


  static Future<List<Map<String, dynamic>>> getStatusByHabitId(int idH) async {
    final db = await database;
    return await db.query('habit_status',
        where: 'id_h = ? ', whereArgs: [idH]);
  }


}