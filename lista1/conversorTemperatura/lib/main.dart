import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Temperatura',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  State<TemperatureConverter> createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _celsiusController = TextEditingController();
  double? _fahrenheit;

  void _convertTemperature() {
    setState(() {
      final celsius = double.tryParse(_celsiusController.text);
      if (celsius != null) {
        // Fórmula: F = (C * 9/5) + 32
        _fahrenheit = (celsius * 9 / 5) + 32;
      } else {
        _fahrenheit = null;
      }
    });
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Conversor de Temperatura'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.thermostat,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _celsiusController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Temperatura em Celsius (°C)',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.ac_unit),
              ),
              onChanged: (value) => _convertTemperature(),
            ),
            const SizedBox(height: 32),
            if (_fahrenheit != null)
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      const Text(
                        'Resultado:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${_fahrenheit!.toStringAsFixed(2)}°F',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
