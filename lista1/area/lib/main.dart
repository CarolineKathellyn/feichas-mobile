import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Área',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RectangleAreaCalculator(),
    );
  }
}

class RectangleAreaCalculator extends StatefulWidget {
  const RectangleAreaCalculator({super.key});

  @override
  State<RectangleAreaCalculator> createState() => _RectangleAreaCalculatorState();
}

class _RectangleAreaCalculatorState extends State<RectangleAreaCalculator> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  String _result = '';

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateArea() {
    final width = double.tryParse(_widthController.text);
    final height = double.tryParse(_heightController.text);

    if (width == null || height == null) {
      setState(() {
        _result = 'Por favor, insira valores válidos!';
      });
      return;
    }

    if (width <= 0 || height <= 0) {
      setState(() {
        _result = 'Os valores devem ser maiores que zero!';
      });
      return;
    }

    final area = width * height;
    setState(() {
      _result = 'Área do retângulo: ${area.toStringAsFixed(2)}';
    });
  }

  void _clearFields() {
    setState(() {
      _widthController.clear();
      _heightController.clear();
      _result = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Área'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              const Icon(
                Icons.crop_square,
                size: 80,
                color: Colors.blue,
              ),
              const SizedBox(height: 20),
              const Text(
                'Cálculo da Área de um Retângulo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Fórmula: Área = largura × altura',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              TextField(
                controller: _widthController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Largura',
                  hintText: 'Digite a largura',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.horizontal_rule),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Altura',
                  hintText: 'Digite a altura',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.vertical_align_center),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculateArea,
                      icon: const Icon(Icons.calculate),
                      label: const Text('Calcular'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _clearFields,
                      icon: const Icon(Icons.clear),
                      label: const Text('Limpar'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              if (_result.isNotEmpty)
                Card(
                  elevation: 4,
                  color: _result.contains('Área')
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      _result,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _result.contains('Área')
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
