import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configurações de Preferência',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const PreferenciasPage(),
    );
  }
}

class PreferenciasPage extends StatefulWidget {
  const PreferenciasPage({super.key});

  @override
  State<PreferenciasPage> createState() => _PreferenciasPageState();
}

class _PreferenciasPageState extends State<PreferenciasPage> {
  // Estados das preferências
  String _temaSelecionado = 'Claro';
  String _idiomaSelecionado = 'Português';
  final TextEditingController _nomeUsuarioController = TextEditingController();

  @override
  void dispose() {
    _nomeUsuarioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configurações de Preferência'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Tema
            _buildSecaoTitulo('Tema'),
            _buildRadioOption('Claro', _temaSelecionado, (value) {
              setState(() {
                _temaSelecionado = value!;
              });
            }),
            _buildRadioOption('Escuro', _temaSelecionado, (value) {
              setState(() {
                _temaSelecionado = value!;
              });
            }),
            const SizedBox(height: 24),

            // Seção de Idioma
            _buildSecaoTitulo('Idioma'),
            _buildRadioOption('Português', _idiomaSelecionado, (value) {
              setState(() {
                _idiomaSelecionado = value!;
              });
            }),
            _buildRadioOption('Inglês', _idiomaSelecionado, (value) {
              setState(() {
                _idiomaSelecionado = value!;
              });
            }),
            _buildRadioOption('Espanhol', _idiomaSelecionado, (value) {
              setState(() {
                _idiomaSelecionado = value!;
              });
            }),
            const SizedBox(height: 24),

            // Seção de Nome de Usuário
            _buildSecaoTitulo('Nome de Usuário'),
            TextField(
              controller: _nomeUsuarioController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Digite seu nome de usuário',
                prefixIcon: Icon(Icons.person),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
            const SizedBox(height: 32),

            // Exibir Seleções Atuais
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Suas Preferências Atuais:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 16),
                    _buildPreferenciaItem(
                      Icons.brightness_6,
                      'Tema',
                      _temaSelecionado,
                    ),
                    const Divider(height: 24),
                    _buildPreferenciaItem(
                      Icons.language,
                      'Idioma',
                      _idiomaSelecionado,
                    ),
                    const Divider(height: 24),
                    _buildPreferenciaItem(
                      Icons.person,
                      'Nome de Usuário',
                      _nomeUsuarioController.text.isEmpty
                          ? 'Não definido'
                          : _nomeUsuarioController.text,
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

  Widget _buildSecaoTitulo(String titulo) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        titulo,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildRadioOption(
    String valor,
    String valorAtual,
    Function(String?) onChanged,
  ) {
    return RadioListTile<String>(
      title: Text(valor),
      value: valor,
      groupValue: valorAtual,
      onChanged: onChanged,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
    );
  }

  Widget _buildPreferenciaItem(IconData icone, String label, String valor) {
    return Row(
      children: [
        Icon(icone, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                valor,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
