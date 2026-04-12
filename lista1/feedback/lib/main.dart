import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _comentariosController = TextEditingController();
  String? _avaliacao;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  void _enviarFeedback() {
    if (_formKey.currentState!.validate()) {
      // Simula o envio do feedback
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Feedback Enviado'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nome: ${_nomeController.text}'),
              Text('Email: ${_emailController.text}'),
              Text('Avaliação: $_avaliacao'),
              Text('Comentários: ${_comentariosController.text}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Limpa o formulário
                _nomeController.clear();
                _emailController.clear();
                _comentariosController.clear();
                setState(() {
                  _avaliacao = null;
                });
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Formulário de Feedback'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, informe seu email';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor, informe um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Avaliação do Serviço
              const Text(
                'Avalie nosso serviço:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              RadioGroup<String>(
                groupValue: _avaliacao,
                onChanged: (value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
                child: Column(
                  children: [
                    RadioListTile<String>(
                      title: const Text('Excelente'),
                      value: 'Excelente',
                    ),
                    RadioListTile<String>(
                      title: const Text('Bom'),
                      value: 'Bom',
                    ),
                    RadioListTile<String>(
                      title: const Text('Regular'),
                      value: 'Regular',
                    ),
                    RadioListTile<String>(
                      title: const Text('Ruim'),
                      value: 'Ruim',
                    ),
                  ],
                ),
              ),

              if (_avaliacao == null)
                const Padding(
                  padding: EdgeInsets.only(left: 16, top: 4),
                  child: Text(
                    'Por favor, selecione uma avaliação',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),

              const SizedBox(height: 16),

              // Campo Comentários
              TextFormField(
                controller: _comentariosController,
                decoration: const InputDecoration(
                  labelText: 'Comentários',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, deixe um comentário';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão Enviar
              ElevatedButton(
                onPressed: () {
                  if (_avaliacao == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor, selecione uma avaliação'),
                      ),
                    );
                    return;
                  }
                  _enviarFeedback();
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Enviar Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
