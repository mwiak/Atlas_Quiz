import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;
  bool isDatabaseCreated = false;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await intialDb();
      return _db;
    } else {
      return _db;
    }
  }

  intialDb() async {
    String databasepath = await getDatabasesPath();
    String path = join(databasepath, 'archive.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newversion) {
    print("onUpgrade =====================================");
  }

  _onCreate(Database db, int version) async {
    await db.execute('''
  CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    question_id INTEGER,
    question_body TEXT,
    choices TEXT
       
     )
   ''');

    await db.execute('''
  CREATE TABLE guessed_questions (
    id INTEGER PRIMARY KEY,
    question_id INTEGER,
    question_body TEXT,
    choices TEXT
       
     )
   ''');

    await db.execute('''
  CREATE TABLE user (
    id INTEGER PRIMARY KEY,
    nickname TEXT,
    high_score INTEGER
       
     )
   ''');
    isDatabaseCreated = true;
    //print(" onCreate =====================================");
  }

  readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
  }

  insertData(String sql, [List<dynamic>? arguments]) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }

  Future<void> moveQuestionToGuessed(int questionId) async {
    Database? mydb = await db;

    // Start a transaction
    await mydb!.transaction((txn) async {
      // Insert the entry into the new table
      await txn.rawInsert(
        '''
        INSERT INTO guessed_questions (question_id, question_body, choices)
        SELECT question_id, question_body, choices
        FROM questions
        WHERE question_id = $questionId
      ''',
      );

      // Delete the entry from the old table
      await txn.rawDelete('''
        DELETE FROM questions
        WHERE question_id = $questionId
      ''');
    });
  }
}
