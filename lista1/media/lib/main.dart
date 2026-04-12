import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Média',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculadoraMedia(),
    );
  }
}

class CalculadoraMedia extends StatefulWidget {
  const CalculadoraMedia({super.key});

  @override
  State<CalculadoraMedia> createState() => _CalculadoraMediaState();
}

class _CalculadoraMediaState extends State<CalculadoraMedia> {
  final TextEditingController _nota1Controller = TextEditingController();
  final TextEditingController _nota2Controller = TextEditingController();
  final TextEditingController _nota3Controller = TextEditingController();
  String _resultado = '';

  void _calcularMedia() {
    final nota1 = double.tryParse(_nota1Controller.text);
    final nota2 = double.tryParse(_nota2Controller.text);
    final nota3 = double.tryParse(_nota3Controller.text);

    if (nota1 == null || nota2 == null || nota3 == null) {
      setState(() {
        _resultado = 'Por favor, insira valores válidos';
      });
      return;
    }

    final media = (nota1 + nota2 + nota3) / 3;
    setState(() {
      _resultado = 'Média: ${media.toStringAsFixed(2)}';
    });
  }

  void _limpar() {
    setState(() {
      _nota1Controller.clear();
      _nota2Controller.clear();
      _nota3Controller.clear();
      _resultado = '';
    });
  }

  @override
  void dispose() {
    _nota1Controller.dispose();
    _nota2Controller.dispose();
    _nota3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Média Aritmética'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nota1Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nota 1',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nota2Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nota 2',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nota3Controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nota 3',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _calcularMedia,
                  child: const Text('Calcular Média'),
                ),
                ElevatedButton(
                  onPressed: _limpar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: const Text('Limpar'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              _resultado,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
