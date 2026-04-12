import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notas Rápidas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotasRapidasHome(),
    );
  }
}

// Modelo para representar uma nota
class Nota {
  String titulo;
  String conteudo;

  Nota({required this.titulo, required this.conteudo});
}

// Tela principal com a lista de notas
class NotasRapidasHome extends StatefulWidget {
  const NotasRapidasHome({super.key});

  @override
  State<NotasRapidasHome> createState() => _NotasRapidasHomeState();
}

class _NotasRapidasHomeState extends State<NotasRapidasHome> {
  final List<Nota> _notas = [];

  void _adicionarNota(Nota nota) {
    setState(() {
      _notas.add(nota);
    });
  }

  void _navegarParaAdicionarNota() async {
    final novaNota = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AdicionarNotaScreen(),
      ),
    );

    if (novaNota != null) {
      _adicionarNota(novaNota);
    }
  }

  void _mostrarConteudoNota(Nota nota) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VisualizarNotaScreen(nota: nota),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Notas Rápidas'),
      ),
      body: _notas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma nota ainda.\nToque no + para adicionar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _notas.length,
              itemBuilder: (context, index) {
                final nota = _notas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  child: ListTile(
                    title: Text(
                      nota.titulo.isEmpty ? 'Sem título' : nota.titulo,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      nota.conteudo.isEmpty
                          ? 'Sem conteúdo'
                          : nota.conteudo.length > 50
                              ? '${nota.conteudo.substring(0, 50)}...'
                              : nota.conteudo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _mostrarConteudoNota(nota),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarParaAdicionarNota,
        tooltip: 'Adicionar Nota',
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Tela para adicionar uma nova nota
class AdicionarNotaScreen extends StatefulWidget {
  const AdicionarNotaScreen({super.key});

  @override
  State<AdicionarNotaScreen> createState() => _AdicionarNotaScreenState();
}

class _AdicionarNotaScreenState extends State<AdicionarNotaScreen> {
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _conteudoController = TextEditingController();

  @override
  void dispose() {
    _tituloController.dispose();
    _conteudoController.dispose();
    super.dispose();
  }

  void _salvarNota() {
    if (_tituloController.text.isEmpty && _conteudoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A nota não pode estar vazia!'),
        ),
      );
      return;
    }

    final novaNota = Nota(
      titulo: _tituloController.text,
      conteudo: _conteudoController.text,
    );

    Navigator.pop(context, novaNota);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Nova Nota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _salvarNota,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(
                labelText: 'Título',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: TextField(
                controller: _conteudoController,
                decoration: const InputDecoration(
                  labelText: 'Conteúdo',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _salvarNota,
        tooltip: 'Salvar Nota',
        child: const Icon(Icons.save),
      ),
    );
  }
}

// Tela para visualizar o conteúdo completo de uma nota
class VisualizarNotaScreen extends StatelessWidget {
  final Nota nota;

  const VisualizarNotaScreen({super.key, required this.nota});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(nota.titulo.isEmpty ? 'Sem título' : nota.titulo),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (nota.titulo.isNotEmpty) ...[
              const Text(
                'Título:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                nota.titulo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
            ],
            const Text(
              'Conteúdo:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              nota.conteudo.isEmpty ? 'Sem conteúdo' : nota.conteudo,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
