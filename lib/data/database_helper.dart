import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'user_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_data(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_code TEXT,
        user_display_name TEXT,
        email TEXT,
        user_employee_code TEXT,
        company_code TEXT
      )
    ''');
  }

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final db = await database;
    await db.insert(
      'user_data',
      {
        'user_code': userData['User_Code'],
        'user_display_name': userData['User_Display_Name'],
        'email': userData['Email'],
        'user_employee_code': userData['User_Employee_Code'],
        'company_code': userData['Company_Code'],
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('user_data');
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<void> deleteUserData() async {
    final db = await database;
    await db.delete('user_data');
  }
}
