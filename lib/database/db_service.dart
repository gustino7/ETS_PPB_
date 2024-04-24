import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:pbb_sqflite/database/db.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async{
    if (_database != null){
      return _database!;
    }

    _database = await _initialize();
    return _database!;
  }

  Future<String> get fullPath async {
    const name = 'movie.db';
    final path = await getDatabasesPath();

    return join(path, name);
  }

  Future<Database> _initialize() async {
    final path = await fullPath;
    var database = await openDatabase(
      path,
      // Version of the dataset
      version: 1,
      // Create database using this function if it does not exist yet
      onCreate: create,
      singleInstance: true,
    );
    return database;
  }

  Future<void> create(Database database, int version) async => await Db().createTable(database);
}

