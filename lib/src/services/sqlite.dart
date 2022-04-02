import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class CRUDSQLITE {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE Persona(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nombre TEXT,
        fechaNac DATE,
        sexo TEXT,
        fecha_alta TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase('testflutter.db', version: 1, onCreate: (
      sql.Database database,
      int version,
    ) async {
      await createTables(database);
    });
  }

  static Future<int> crearPersona(
      String nombre, String fechaNac, String sexo) async {
    final db = await CRUDSQLITE.db();
    final data = {'nombre': nombre, 'fechaNac': fechaNac, 'sexo': sexo};
    final id = await db.insert('Persona', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> obtenerPesona() async {
    final db = await CRUDSQLITE.db();
    return db.query('Persona', orderBy: 'id');
  }

  static Future<int> actualizarPersona(
      int id, String nombre, String fechaNac, String sexo) async {
    final db = await CRUDSQLITE.db();
    final data = {
      'nombre': nombre,
      'fechaNac': fechaNac,
      'sexo': sexo,
      'fecha_alta': DateTime.now().toString()
    };
    final res =
        await db.update("Persona", data, where: "id=?", whereArgs: [id]);
    return res;
  }

  static Future<void> deletePersona(int id) async {
    final db = await CRUDSQLITE.db();
    try {
      await db.delete("Persona", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Algo salió mal al eliminar un elemento:$err");
    }
  }
}
