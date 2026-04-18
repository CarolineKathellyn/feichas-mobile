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
      title: 'Controle de Estoque',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const EstoquePage(),
    );
  }
}

// ── Database helper ──────────────────────────────────────────────────────────

class DatabaseHelper {
  static Database? _db;

  static Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'estoque.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE produtos (id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT NOT NULL, quantidade INTEGER NOT NULL)',
        );
      },
    );
  }

  static Future<void> inserir(String nome, int quantidade) async {
    final db = await database;
    await db.insert('produtos', {'nome': nome, 'quantidade': quantidade});
  }

  static Future<List<Map<String, dynamic>>> listar({String? busca}) async {
    final db = await database;
    if (busca == null || busca.isEmpty) {
      return db.query('produtos', orderBy: 'nome ASC');
    }
    return db.query(
      'produtos',
      where: 'nome LIKE ?',
      whereArgs: ['%$busca%'],
      orderBy: 'nome ASC',
    );
  }
}

// ── UI ───────────────────────────────────────────────────────────────────────

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  final _nomeController = TextEditingController();
  final _qtdController = TextEditingController();
  final _buscaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _produtos = [];

  @override
  void initState() {
    super.initState();
    _carregarProdutos();
    _buscaController.addListener(() => _carregarProdutos());
  }

  Future<void> _carregarProdutos() async {
    final lista = await DatabaseHelper.listar(busca: _buscaController.text);
    setState(() => _produtos = lista);
  }

  Future<void> _salvar() async {
    if (!_formKey.currentState!.validate()) return;
    final nome = _nomeController.text.trim();
    final quantidade = int.parse(_qtdController.text.trim());
    await DatabaseHelper.inserir(nome, quantidade);
    _nomeController.clear();
    _qtdController.clear();
    await _carregarProdutos();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _qtdController.dispose();
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Controle de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome do produto',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Informe o nome' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _qtdController,
                    decoration: const InputDecoration(
                      labelText: 'Quantidade',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Informe a quantidade';
                      if (int.tryParse(v.trim()) == null) return 'Apenas números inteiros';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _salvar,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Produtos em estoque',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                labelText: 'Buscar produto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _produtos.isEmpty
                  ? const Center(child: Text('Nenhum produto cadastrado.'))
                  : ListView.builder(
                      itemCount: _produtos.length,
                      itemBuilder: (context, index) {
                        final p = _produtos[index];
                        return Card(
                          child: ListTile(
                            leading: const Icon(Icons.inventory_2),
                            title: Text(p['nome'] as String),
                            trailing: Text(
                              'Qtd: ${p['quantidade']}',
                              style: const TextStyle(fontSize: 14),
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
