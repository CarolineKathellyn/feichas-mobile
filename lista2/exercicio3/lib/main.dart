import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

void main() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Registro de Frequência',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const AttendancePage(),
    );
  }
}

class AttendanceDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    print('DB path: $dbPath');
    _db = await openDatabase(
      join(dbPath, 'attendance.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE attendance(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)',
        );
      },
      version: 1,
    );
    return _db!;
  }

  static Future<void> insertName(String name) async {
    final db = await database;
    await db.insert('attendance', {'name': name});
  }

  static Future<List<Map<String, dynamic>>> getAll() async {
    final db = await database;
    return db.query('attendance', orderBy: 'id DESC');
  }

  static Future<void> deleteName(int id) async {
    final db = await database;
    await db.delete('attendance', where: 'id = ?', whereArgs: [id]);
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _controller = TextEditingController();
  List<Map<String, dynamic>> _names = [];

  @override
  void initState() {
    super.initState();
    _loadNames();
  }

  Future<void> _loadNames() async {
    final names = await AttendanceDatabase.getAll();
    setState(() => _names = names);
  }

  Future<void> _addName() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    await AttendanceDatabase.insertName(name);
    _controller.clear();
    await _loadNames();
  }

  Future<void> _deleteName(int id) async {
    await AttendanceDatabase.deleteName(id);
    await _loadNames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registro de Frequência'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nome do aluno',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addName(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _addName,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Presenças registradas: ${_names.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _names.isEmpty
                  ? const Center(child: Text('Nenhuma presença registrada.'))
                  : ListView.builder(
                      itemCount: _names.length,
                      itemBuilder: (context, index) {
                        final entry = _names[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.person),
                            title: Text(entry['name'] as String),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteName(entry['id'] as int),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
