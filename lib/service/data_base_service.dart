import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DataBaseService{

  static final DataBaseService instance = DataBaseService.instance;


  final String _tasksTableName = "tasks";
  final String _tasksIdColumnName = "id";
  final String _tasksContentColumnName = "content";
  final String _tasksStatusColumnName = "status";



  DataBaseService._constructor();

  Future<Database>getDataBase() async{

    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
        databasePath,
      onCreate: (db, version){
          db.execute('''
          CREATE TABLE  $_tasksTableName(
            $_tasksIdColumnName INTEGER PRIMARY KEY
          )
          ''');
      }
    );



  }



}