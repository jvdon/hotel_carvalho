import 'dart:io';

import 'package:hotel_carvalho/models/quarto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class QuartoDB {
  Future<Database> _getDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "hotel_carvalho.db");
    print(path);
    String sql = """
      CREATE TABLE IF NOT EXISTS quartos (
          id INTEGER PRIMARY KEY,
          number INTEGER UNIQUE,
          occupancy INTEGER,
          status TEXT DEFAULT "LIVRE"
      );
    """;

    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          sql,
        );
      },
      onConfigure: (db) {
        return db.execute(
          sql,
        );
      },
      version: 1,
    );
  }

  Future<List<Quarto>> quartos() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('quartos');

    return List.generate(
      maps.length,
      (i) {
        return Quarto.fromMap(maps[i]);
      },
    );
  }

  Future<void> insertQuarto(Map<String, Object?> quarto) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    // carro.toMap().forEach((key, value) { print(value.runtimeType);});

    await db.insert(
      'quartos',
      quarto,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateQuarto(Quarto quarto, int id) async {
    final db = await _getDatabase();
    await db.update('quartos', quarto.toMap(), where: 'id = $id');
  }

  Future<void> limparQuarto(int id, QuartoStatus status) async {
    final db = await _getDatabase();

    await db.update('quartos', {"status": status.name}, where: "id = $id");
  }

  Future<void> deleteQuarto(Quarto quarto) async {
    final db = await _getDatabase();
    await db.delete('quartos', where: 'id = ${quarto.id}');
  }
}
