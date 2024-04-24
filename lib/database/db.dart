import 'package:sqflite/sqflite.dart';
import 'package:pbb_sqflite/database/db_service.dart';
import 'package:pbb_sqflite/model/db_model.dart';

class Db {
  final tableName = 'movie';

  // Create Table
  Future<void> createTable(Database database) async{
    await database.execute("""
    CREATE TABLE IF NOT EXISTS $tableName (
     "id" INTEGER NOT NULL,
     "title" TEXT NOT NULL,
     "image" TEXT NOT NULL,
     "description" TEXT NOT NULL,
     "created_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s', 'now') as int)),
     "updated_at" INTEGER,
     PRIMARY KEY("id" AUTOINCREMENT)
    );
    """);
  }

  Future<int> create({required String title, required String image, required String description}) async {
    final database = await DatabaseService().database;
    // Returns the latest inserted row
    return await database.rawInsert(
      '''INSERT INTO $tableName (title, image, description, created_at) VALUES (?,?,?,?)''',
      [title, image, description, DateTime.now().millisecondsSinceEpoch],
    );
  }

  Future<List<Model>> fetchAll() async {
    final database = await DatabaseService().database;
    final movies = await database.rawQuery(
        '''SELECT * from $tableName ORDER BY COALESCE(updated_at, created_at)''');
    return movies.map((movie) => Model.fromSqfliteDatabase(movie)).toList();
  }

  Future<Model> fetchById(int id) async {
    final database = await DatabaseService().database;
    final movie = await database.rawQuery('''SELECT * from $tableName WHERE id = ?''', [id]);
    return Model.fromSqfliteDatabase(movie.first);
  }

  Future<int> update({required int id, String? title, String? image, String? description}) async {
    final database = await DatabaseService().database;
    return await database.update(
      tableName,
      {
        if (title != null) 'title':title,
        if (image != null) 'image':image,
        if (description != null) 'description':description,
        'updated_at' : DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      conflictAlgorithm: ConflictAlgorithm.rollback,
      whereArgs: [id],
    );
  }

  Future<void> delete(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''DELETE FROM $tableName WHERE id = ?''', [id]);
  }
}