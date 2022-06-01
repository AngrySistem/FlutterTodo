import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:two/model/note.dart';

class DbProvider {

  DbProvider._();
  static final DbProvider db = DbProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  initDB() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, 'note_db1.db');

    return await openDatabase(path, version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE note1 (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            body TEXT,
            creation_date DATE,
            isDone INTEGER,
            notifyId INTEGER
          )
        ''');
      },
    );
  }

  addNewNote(Note note) async {
    final db = await database;
    db.insert('note1', note.toMap());
  }

  Future<dynamic> getNotes() async {
    final db = await database;
    var res = await db.query("note1");

    if (res.isEmpty) {
      return null;
    } else {
      var resultMap = res.toList();
      return resultMap.isNotEmpty ? resultMap : null;
    }
  }

  Future<int> deleteNote(int id) async {
    final db = await database;
    int count = await db.rawDelete("DELETE FROM note1 where id = ?", [id]);
    return count;
  }

  Future<int> editNote(Note note) async {
    final db = await database;
    int count = await db.rawUpdate(
        "UPDATE note1 SET title = ?, body = ?, creation_date = ?, isDone = ?, notifyId = ? WHERE id = ?",
        [note.title, note.body, note.creation_date.toString(), note.isDone, note.notifyId, note.id]);
    return count;
  }

  // Future<int> del() async {
  //   final db = await database;
  //   int count = await(db.rawDelete('DELETE FROM note'));
  //   return count;
  // }
}