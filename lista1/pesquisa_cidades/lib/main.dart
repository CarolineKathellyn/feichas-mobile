import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesquisa de Cidades',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CitySearchPage(),
    );
  }
}

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({super.key});

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  // Lista de cidades brasileiras
  final List<String> _cidadesBrasileiras = [
    'São Paulo',
    'Rio de Janeiro',
    'Belo Horizonte',
    'Brasília',
    'Salvador',
    'Fortaleza',
    'Curitiba',
    'Recife',
    'Porto Alegre',
    'Manaus',
    'Belém',
    'Goiânia',
    'Guarulhos',
    'Campinas',
    'São Luís',
    'São Gonçalo',
    'Maceió',
    'Duque de Caxias',
    'Natal',
    'Teresina',
    'Campo Grande',
    'Nova Iguaçu',
    'São Bernardo do Campo',
    'João Pessoa',
    'Santo André',
    'Osasco',
    'Jaboatão dos Guararapes',
    'São José dos Campos',
    'Ribeirão Preto',
    'Uberlândia',
    'Sorocaba',
    'Contagem',
    'Aracaju',
    'Feira de Santana',
    'Cuiabá',
    'Joinville',
    'Juiz de Fora',
    'Londrina',
    'Aparecida de Goiânia',
    'Porto Velho',
  ];

  String? _cidadeSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pesquisa de Cidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pesquise uma cidade brasileira:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _cidadesBrasileiras.where((String cidade) {
                  return cidade
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _cidadeSelecionada = selection;
                });
              },
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Digite o nome da cidade',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onSubmitted: (String value) {
                    onFieldSubmitted();
                  },
                );
              },
            ),
            const SizedBox(height: 30),
            if (_cidadeSelecionada != null) ...[
              const Text(
                'Cidade selecionada:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_city, color: Colors.blue.shade700),
                    const SizedBox(width: 10),
                    Text(
                      _cidadeSelecionada!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
