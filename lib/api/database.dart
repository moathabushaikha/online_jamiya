import 'dart:core';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:online_jamiya/models/models.dart';

class DataBaseConn {
  static final DataBaseConn instance = DataBaseConn.init();
  static Database? myDatabase;

  DataBaseConn.init();

  String databaseName = 'jamiya.db';

  Future<Database> get database async {
    if (myDatabase != null) return myDatabase!;
    myDatabase = await initDB(databaseName);
    return myDatabase!;
  }

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future createDB(Database database, int version) async {
    var sql = '''CREATE TABLE $userTableName 
    (
      ${UserTableCols.idCol} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      ${UserTableCols.firstNameCol} TEXT NOT NULL,
      ${UserTableCols.lastNameCol} TEXT NOT NULL,
      ${UserTableCols.userNameCol} TEXT NOT NULL,
      ${UserTableCols.passwordCol} TEXT NOT NULL,
      ${UserTableCols.darkModeCol}  TEXT NOT NULL,
      ${UserTableCols.registeredJamiyaID}  TEXT NOT NULL,
      ${UserTableCols.imgUrlCol}  TEXT NOT NULL 
    )     
    ''';
    await database.execute(sql);
    sql = '''CREATE TABLE $jamiyaTableName 
    (
      ${JamiyaTable.id} INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,      
      ${JamiyaTable.participantsId}  TEXT NOT NULL,
      ${JamiyaTable.name} TEXT NOT NULL,
      ${JamiyaTable.startingDate} TEXT NOT NULL,
      ${JamiyaTable.endingDate} TEXT NOT NULL,
      ${JamiyaTable.maxParticipants}  TEXT NOT NULL,
      ${JamiyaTable.creatorId}  TEXT NOT NULL, 
      ${JamiyaTable.shareAmount}  TEXT NOT NULL 
    )     
    ''';
    await database.execute(sql);
    sql = '''CREATE TABLE NOTIFICATIONS 
    (
      ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      CREATOR_ID TEXT NOT NULL,
      PARTICIPANT_ID TEXT NOT NULL,
      REQUEST_DATE TEXT NOT NULL,
      JAMIYA_ID TEXT NOT NULL,
      RESPONSE TEXT NOT NULL,
      NOTIFICATION_TYPE NOT NULL
    )     
    ''';
    await database.execute(sql);
  }

  Future<User?> authentication(String username, String password) async {
    var db = await instance.database;
    var res = await db.rawQuery(
        "SELECT * FROM $userTableName WHERE username = '$username' and password = '$password'");
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }

  Future<int> createUser(User user) async {
    final db = await instance.database;
    return await db.insert(userTableName, user.toMap());
  }

  Future<List<User>> allUsers() async {
    final db = await instance.database;
    final result = await db.query(userTableName);
    return result.map((json) => User.fromMap(json)).toList();
  }

  Future<User> readUser(int id) async {
    final db = await instance.database;
    final maps = await db.query(userTableName,
        columns: UserTableCols.values,
        where: '${UserTableCols.idCol} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return User.fromMap(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<int> updateUser(User user) async {
    final db = await instance.database;
    return db.update(userTableName, user.toMap(),
        where: '${UserTableCols.idCol} = ?', whereArgs: [user.id]);
  }

  Future<int> deleteUser() async {
    final db = await instance.database;
    return await db.delete(userTableName);
    // return await db.delete(userTableName,where: '${UserTableCols.idCol} = ?', whereArgs: [user.id]);
  }

  Future<int> createJamiya(Jamiya jamiya) async {
    final db = await instance.database;
    return await db.insert(jamiyaTableName, jamiya.toMap());
  }

  Future<List<Jamiya>> allJamiyas() async {
    final db = await instance.database;
    final result = await db.query(jamiyaTableName);
    return result.map((json) => Jamiya.fromMap(json)).toList();
  }

  Future<Jamiya> readJamiya(String id) async {
    final db = await instance.database;
    final maps = await db.query(jamiyaTableName,
        columns: JamiyaTable.values,
        where: '${JamiyaTable.id} = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return Jamiya.fromMap(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<int> updateJamiya(Jamiya jamiya) async {
    final db = await instance.database;
    int count = await db.update(jamiyaTableName, jamiya.toMap(),
        where: '${JamiyaTable.id} = ?', whereArgs: [jamiya.id]);
    return count;
  }

  Future<int> deleteJamiya(String id) async {
    final db = await instance.database;
    return await db.delete(jamiyaTableName,
        where: '${JamiyaTable.id} = ?', whereArgs: [id]);
  }

  Future<int> createNotification(MyNotification myNotification) async {
    final db = await instance.database;
    return await db.insert('NOTIFICATIONS', myNotification.toMap());
  }
  Future<MyNotification> getNotificationById(String id) async {
    final db = await instance.database;
    final maps = await db.query('NOTIFICATIONS',
        where: 'ID = ?',
        whereArgs: [id]);
    if (maps.isNotEmpty) {
      return MyNotification.fromMap(maps.first);
    } else {
      throw Exception('ID $id is not found');
    }
  }

  Future<List<MyNotification>> allNotifications() async {
    final db = await instance.database;
    final result = await db.query('NOTIFICATIONS');
    return result.map((json) => MyNotification.fromMap(json)).toList();
  }
  Future<int> deleteNotification(String id) async {
    final db = await instance.database;
    return await db.delete('NOTIFICATIONS',
        where: 'ID = ?', whereArgs: [id]);
  }
}
