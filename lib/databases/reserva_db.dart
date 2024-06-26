import 'dart:io';

import 'package:hotel_carvalho/models/quarto.dart';
import 'package:hotel_carvalho/models/reserva.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ReservaDB {
  Future<Database> _getDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "hotel_carvalho.db");
    String sql = """
      CREATE TABLE IF NOT EXISTS reservas (
          id INTEGER PRIMARY KEY,
          hospedes TEXT,
          quartos TEXT,
          checkin INTEGER,
          checkout INTEGER,
          valor DOUBLE
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

  Future<List<Reserva>> reservas() async {
    // Get a reference to the database.
    final db = await _getDatabase();

    final List<Map<String, dynamic>> maps = await db.query('reservas');

    return List.generate(
      maps.length,
      (i) {
        return Reserva.fromMap(maps[i]);
      },
    );
  }

  Future<void> insertReserva(Map<String, Object?> reserva) async {
    // Get a reference to the database.
    final db = await _getDatabase();

    // carro.toMap().forEach((key, value) { print(value.runtimeType);});

    await db.insert(
      'reservas',
      reserva,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteReserva(Reserva reserva) async {
    final db = await _getDatabase();
    await db.delete('reservas', where: 'id = ${reserva.id}');
  }
}
