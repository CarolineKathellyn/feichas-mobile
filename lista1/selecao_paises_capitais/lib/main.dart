import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Classe para representar um país e sua capital
class Country {
  final String name;
  final String capital;

  Country({required this.name, required this.capital});

  @override
  String toString() => name;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seleção de Países e Capitais',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CountryCapitalPage(),
    );
  }
}

class CountryCapitalPage extends StatefulWidget {
  const CountryCapitalPage({super.key});

  @override
  State<CountryCapitalPage> createState() => _CountryCapitalPageState();
}

class _CountryCapitalPageState extends State<CountryCapitalPage> {
  // Lista de países e capitais
  final List<Country> _countries = [
    Country(name: 'Brasil', capital: 'Brasília'),
    Country(name: 'Portugal', capital: 'Lisboa'),
    Country(name: 'Espanha', capital: 'Madrid'),
    Country(name: 'França', capital: 'Paris'),
    Country(name: 'Itália', capital: 'Roma'),
    Country(name: 'Alemanha', capital: 'Berlim'),
    Country(name: 'Reino Unido', capital: 'Londres'),
    Country(name: 'Estados Unidos', capital: 'Washington D.C.'),
    Country(name: 'Canadá', capital: 'Ottawa'),
    Country(name: 'México', capital: 'Cidade do México'),
    Country(name: 'Argentina', capital: 'Buenos Aires'),
    Country(name: 'Chile', capital: 'Santiago'),
    Country(name: 'Japão', capital: 'Tóquio'),
    Country(name: 'China', capital: 'Pequim'),
    Country(name: 'Índia', capital: 'Nova Deli'),
    Country(name: 'Austrália', capital: 'Camberra'),
    Country(name: 'Rússia', capital: 'Moscou'),
    Country(name: 'África do Sul', capital: 'Pretória'),
    Country(name: 'Egito', capital: 'Cairo'),
    Country(name: 'Grécia', capital: 'Atenas'),
  ];

  final TextEditingController _capitalController = TextEditingController();
  Country? _selectedCountry;

  @override
  void dispose() {
    _capitalController.dispose();
    super.dispose();
  }

  void _onCountrySelected(Country country) {
    setState(() {
      _selectedCountry = country;
      _capitalController.text = country.capital;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Seleção de Países e Capitais'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pesquise um país:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Autocomplete<Country>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Country>.empty();
                }
                return _countries.where((Country country) {
                  return country.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Country country) => country.name,
              onSelected: _onCountrySelected,
              fieldViewBuilder: (BuildContext context,
                  TextEditingController textEditingController,
                  FocusNode focusNode,
                  VoidCallback onFieldSubmitted) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Digite o nome do país',
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
              optionsViewBuilder: (BuildContext context,
                  AutocompleteOnSelected<Country> onSelected,
                  Iterable<Country> options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Country option = options.elementAt(index);
                          return ListTile(
                            title: Text(option.name),
                            onTap: () {
                              onSelected(option);
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            const Text(
              'Capital:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _capitalController,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Selecione um país acima',
                prefixIcon: Icon(Icons.location_city),
              ),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_selectedCountry != null) ...[
              const SizedBox(height: 24),
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 48,
                        color: Colors.green,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'País selecionado: ${_selectedCountry!.name}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Capital: ${_selectedCountry!.capital}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
