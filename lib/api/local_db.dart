import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseConn {
  static final DataBaseConn instance = DataBaseConn.init();
  static Database? myDatabase;

  DataBaseConn.init();

  Future<Database> initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final String path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: createDB);
  }

  Future<Database> get database async {
    if (myDatabase != null) return myDatabase!;
    myDatabase = await initDB('userEncKeys.db');
    return myDatabase!;
  }

  Future createDB(Database database, int version) async => await database.execute('''
          CREATE TABLE userEncKeys (
          user_id TEXT NOT NULL,
          passwordKey TEXT NOT NULL,
          passwordIV Text Not Null
        )''');

  Future<int> addKey(String userId, String? passwordKey, String? passwordIV) async {
    final db = await instance.database;
    return await db.insert(
        'userEncKeys', {'user_id': userId, 'passwordKey': passwordKey, 'passwordIV': passwordIV});
  }

  Future<List<Map<String, Object?>>> getKeys(String? userId) async {
    final db = await instance.database;
    return await db.query('userEncKeys', where: 'user_id = ?',whereArgs: [userId]);
  }
  Future<void> getToken() async{

  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
