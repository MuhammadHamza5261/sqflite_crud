// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite/sqlite_api.dart';
// import 'package:sqflite_crud/models/task_model.dart';
//
//
// class DataBaseService{
//
//   static Database? _db;
//   static final DataBaseService instance = DataBaseService._constructor();
//
//   // Change the way to access the instance
//   factory DataBaseService() => instance;
//
//
//   final String _tasksTableName = "tasks";
//   final String _tasksIdColumnName = "id";
//   final String _tasksContentColumnName = "content";
//   final String _tasksStatusColumnName = "status";
//
//
//   DataBaseService._constructor();
//
//   Future<Database> get database async {
//     if(_db != null) return _db!;
//     _db = await getDataBase();
//     return _db!;
//   }
//
//
//
//   Future<Database>getDataBase() async{
//
//     final databaseDirPath = await getDatabasesPath();
//     final databasePath = join(databaseDirPath, "master_db.db");
//     final database = await openDatabase(
//         databasePath,
//       version: 1,
//       onCreate: (db, version){
//           db.execute('''
//           CREATE TABLE  $_tasksTableName(
//             $_tasksIdColumnName INTEGER PRIMARY KEY
//             $_tasksContentColumnName TEXT NOT NULL
//             $_tasksStatusColumnName INTEGER NOT NULL
//           )
//           ''');
//       }
//     );
//    return database;
//   }
//
//
//   void addTask(String content) async{
//
//     final db = await database;
//     await db.insert(_tasksTableName,
//         {
//          _tasksContentColumnName: content,
//           _tasksStatusColumnName: 0,
//     });
//
//   }
//
//   Future<List<TaskModel>?> getTask() async{
//
//     final db = await database;
//     final data = await db.query(_tasksTableName);
//     List<TaskModel> tasks = data.map((e) => TaskModel(
//         id: e["id"] as int,
//         status: e["status"] as int,
//         content: e["content"] as String,
//     )
//     ).toList();
//       return tasks;
//   }
//
//   void updateTask(int id, int status) async{
//     final db = await database;
//     await db.update(_tasksTableName, {
//       _tasksStatusColumnName: status,
//     },
//       where: 'id = ?',
//       whereArgs: [id]
//     );
//   }
//
//   void deleteTask(int id) async{
//     final db = await database;
//     await db.delete(
//         _tasksTableName,
//       where: 'id = ?',
//       whereArgs: [id],
//     );
//   }
//
//
// }
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_crud/models/task_model.dart';

class DataBaseService {
  static Database? _db;
  static final DataBaseService instance = DataBaseService._constructor();

  // Factory constructor to get the singleton instance
  factory DataBaseService() => instance;

  // Database table and column names
  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";

  // Private constructor for singleton
  DataBaseService._constructor();

  // Get the database instance
  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  // Initialize and open the database
  Future<Database> _initDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");

    // Open the database and create the table if it doesn't exist
    final database = await openDatabase(
      databasePath,
      version: 2, // Increment version to recreate the database
      onCreate: (db, version) async {
        print('Creating the tasks table...');
        await db.execute(''' 
          CREATE TABLE $_tasksTableName (
            $_tasksIdColumnName INTEGER PRIMARY KEY,
            $_tasksContentColumnName TEXT NOT NULL,
            $_tasksStatusColumnName INTEGER NOT NULL
          )
        ''');
        print('Table created successfully.');
      },
      onOpen: (db) async {
        // Optional: check if the table exists
        final tables = await db.rawQuery('SELECT name FROM sqlite_master WHERE type="table" AND name="$_tasksTableName"');
        if (tables.isEmpty) {
          print('Error: The "tasks" table does not exist.');
        } else {
          print('Success: The "tasks" table exists.');
        }
      },
    );
    return database;
  }

  // Add a new task to the database
  Future<void> addTask(String content) async {
    final db = await database;
    await db.insert(_tasksTableName, {
      _tasksContentColumnName: content,
      _tasksStatusColumnName: 0,
    });
  }

  // Get all tasks from the database
  Future<List<TaskModel>> getTask() async {
    final db = await database;
    final data = await db.query(_tasksTableName);
    if (data.isEmpty) return []; // Return an empty list if there are no tasks
    List<TaskModel> tasks = data.map((e) => TaskModel(
      id: e[_tasksIdColumnName] as int,
      status: e[_tasksStatusColumnName] as int,
      content: e[_tasksContentColumnName] as String,
    )).toList();
    return tasks;
  }

  // Update a task's status in the database
  Future<void> updateTask(int id, int status) async {
    final db = await database;
    await db.update(
      _tasksTableName,
      {
        _tasksStatusColumnName: status,
      },
      where: '$_tasksIdColumnName = ?',
      whereArgs: [id],
    );
  }

  // Delete a task from the database
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _tasksTableName,
      where: '$_tasksIdColumnName = ?',
      whereArgs: [id],
    );
  }
}

