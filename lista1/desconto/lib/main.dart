import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Desconto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DescontoCalculadora(),
    );
  }
}

class Produto {
  final String nome;
  final double precoOriginal;
  final double porcentagemDesconto;
  final double precoFinal;

  Produto({
    required this.nome,
    required this.precoOriginal,
    required this.porcentagemDesconto,
  }) : precoFinal = precoOriginal - (precoOriginal * porcentagemDesconto / 100);
}

class DescontoCalculadora extends StatefulWidget {
  const DescontoCalculadora({super.key});

  @override
  State<DescontoCalculadora> createState() => _DescontoCalculadoraState();
}

class _DescontoCalculadoraState extends State<DescontoCalculadora> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _descontoController = TextEditingController();
  final List<Produto> _produtos = [];
  double? _precoFinal;

  @override
  void dispose() {
    _nomeController.dispose();
    _precoController.dispose();
    _descontoController.dispose();
    super.dispose();
  }

  void _calcularDesconto() {
    final preco = double.tryParse(_precoController.text);
    final desconto = double.tryParse(_descontoController.text);

    if (preco != null && desconto != null && desconto >= 0 && desconto <= 100) {
      setState(() {
        _precoFinal = preco - (preco * desconto / 100);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira valores válidos!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _adicionarProduto() {
    final nome = _nomeController.text.trim();
    final preco = double.tryParse(_precoController.text);
    final desconto = double.tryParse(_descontoController.text);

    if (nome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o nome do produto!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (preco != null && desconto != null && desconto >= 0 && desconto <= 100) {
      setState(() {
        _produtos.add(Produto(
          nome: nome,
          precoOriginal: preco,
          porcentagemDesconto: desconto,
        ));
        _nomeController.clear();
        _precoController.clear();
        _descontoController.clear();
        _precoFinal = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto adicionado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira valores válidos!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _removerProduto(int index) {
    setState(() {
      _produtos.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Desconto'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Formulário de entrada
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome do Produto',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _precoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Preço Original (R\$)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                      ),
                      onChanged: (_) {
                        if (_precoController.text.isNotEmpty && 
                            _descontoController.text.isNotEmpty) {
                          _calcularDesconto();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descontoController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Desconto (%)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.discount),
                      ),
                      onChanged: (_) {
                        if (_precoController.text.isNotEmpty && 
                            _descontoController.text.isNotEmpty) {
                          _calcularDesconto();
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    if (_precoFinal != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              'Preço Final:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ ${_precoFinal!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        // Expanded(
                        //   child: ElevatedButton.icon(
                        //     onPressed: _calcularDesconto,
                        //     icon: const Icon(Icons.calculate),
                        //     label: const Text('Calcular'),
                        //     style: ElevatedButton.styleFrom(
                        //       padding: const EdgeInsets.all(16),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _adicionarProduto,
                            icon: const Icon(Icons.add_shopping_cart),
                            label: const Text('Adicionar'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Lista de produtos
          Expanded(
            child: _produtos.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 64,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum produto adicionado',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _produtos.length,
                    itemBuilder: (context, index) {
                      final produto = _produtos[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.green,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            produto.nome,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                'Preço original: R\$ ${produto.precoOriginal.toStringAsFixed(2)}',
                              ),
                              Text(
                                'Desconto: ${produto.porcentagemDesconto.toStringAsFixed(0)}%',
                                style: TextStyle(color: Colors.orange.shade700),
                              ),
                              Text(
                                'Preço final: R\$ ${produto.precoFinal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removerProduto(index),
                          ),
                          isThreeLine: true,
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
