import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Tarefas Diárias',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const TarefasPage(),
    );
  }
}

enum Prioridade { baixa, media, alta }

class Tarefa {
  String nome;
  String descricao;
  bool concluida;
  Prioridade prioridade;

  Tarefa({
    required this.nome,
    required this.descricao,
    this.concluida = false,
    this.prioridade = Prioridade.media,
  });
}

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  final List<Tarefa> _tarefas = [];
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  Prioridade _prioridadeSelecionada = Prioridade.media;

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _adicionarTarefa() {
    if (_nomeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o nome da tarefa'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _tarefas.add(Tarefa(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        prioridade: _prioridadeSelecionada,
      ));
      _nomeController.clear();
      _descricaoController.clear();
      _prioridadeSelecionada = Prioridade.media;
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      _tarefas.removeAt(index);
    });
  }

  Color _getCorPrioridade(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.baixa:
        return Colors.green;
      case Prioridade.media:
        return Colors.orange;
      case Prioridade.alta:
        return Colors.red;
    }
  }

  String _getPrioridadeTexto(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cadastro de Tarefas Diárias'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Formulário de entrada
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Tarefa',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.task),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Prioridade:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Baixa'),
                        value: Prioridade.baixa,
                        groupValue: _prioridadeSelecionada,
                        onChanged: (Prioridade? value) {
                          setState(() {
                            _prioridadeSelecionada = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Média'),
                        value: Prioridade.media,
                        groupValue: _prioridadeSelecionada,
                        onChanged: (Prioridade? value) {
                          setState(() {
                            _prioridadeSelecionada = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<Prioridade>(
                        title: const Text('Alta'),
                        value: Prioridade.alta,
                        groupValue: _prioridadeSelecionada,
                        onChanged: (Prioridade? value) {
                          setState(() {
                            _prioridadeSelecionada = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _adicionarTarefa,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Tarefa'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Lista de tarefas
          Expanded(
            child: _tarefas.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma tarefa cadastrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tarefas.length,
                    padding: const EdgeInsets.all(8),
                    itemBuilder: (context, index) {
                      final tarefa = _tarefas[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: tarefa.concluida,
                            onChanged: (bool? value) {
                              setState(() {
                                tarefa.concluida = value!;
                              });
                            },
                          ),
                          title: Text(
                            tarefa.nome,
                            style: TextStyle(
                              decoration: tarefa.concluida
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (tarefa.descricao.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    tarefa.descricao,
                                    style: TextStyle(
                                      decoration: tarefa.concluida
                                          ? TextDecoration.lineThrough
                                          : null,
                                    ),
                                  ),
                                ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: _getCorPrioridade(tarefa.prioridade)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _getCorPrioridade(tarefa.prioridade),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  'Prioridade: ${_getPrioridadeTexto(tarefa.prioridade)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getCorPrioridade(tarefa.prioridade),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerTarefa(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
