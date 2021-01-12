import 'package:my_notes/model/Note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class NoteHelper {

  static final String nameTable = "note";
  static final NoteHelper _noteHelper = NoteHelper._internal();
  Database _db;

  factory NoteHelper(){
    return _noteHelper;
  }

  NoteHelper._internal(){
  }

  get db async {

    if( _db != null ){
      return _db;
    }else{
      _db = await initializeDB();
    }

  }

  _onCreate(Database db, int version) async {

    String sql = "CREATE TABLE $nameTable (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR, description TEXT, date DATETIME)";
    await db.execute(sql);

  }

  initializeDB() async {

    final pathDatabase = await getDatabasesPath();
    final localDatabse = join(pathDatabase, "my_note.db");

    var db = await openDatabase(localDatabse, version: 1, onCreate: _onCreate );
    return db;

  }

  Future<int> saveNote(Note note) async {

    var database = await db;
    int result = await database.insert(nameTable, note.toMap() );
    return result;

  }

  getNotes() async {
    var database = await db;
    String sql = "SELECT * FROM $nameTable ORDER BY date";
    List notes = await database.rawQuery( sql );
    return notes;

  }

  Future<int> updateNote(Note note) async {
    var database = await db;
    return await database.update(
        nameTable,
        note.toMap(),
        where: "id = ?",
        whereArgs: [note.id]
    );
  }

  Future<int> removeNote( int id ) async {
    var database = await db;
    return await database.delete(
      nameTable,
      where: "id = ?",
      whereArgs: [id]
    );
  }

}

/*

class Normal {

  Normal(){

  }

}

class Singleton {

  static final Singleton _singleton = Singleton._internal();

  	factory Singleton(){
      print("Singleton");
      return _singleton;
    }

    Singleton._internal(){
    	print("_internal");
  	}

}

void main() {

  var i1 = Singleton();
  print("***");
  var i2 = Singleton();

  print( i1 == i2 );

}


* */