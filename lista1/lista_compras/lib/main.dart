import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const ListaComprasPage(),
    );
  }
}

// Classe para representar um item da lista
class ItemCompra {
  String nome;
  bool comprado;

  ItemCompra({required this.nome, this.comprado = false});
}

class ListaComprasPage extends StatefulWidget {
  const ListaComprasPage({super.key});

  @override
  State<ListaComprasPage> createState() => _ListaComprasPageState();
}

class _ListaComprasPageState extends State<ListaComprasPage> {
  final TextEditingController _controlador = TextEditingController();
  final List<ItemCompra> _itens = [];

  void _adicionarItem() {
    if (_controlador.text.trim().isNotEmpty) {
      setState(() {
        _itens.add(ItemCompra(nome: _controlador.text.trim()));
        _controlador.clear();
      });
    }
  }

  void _removerItem(int index) {
    setState(() {
      _itens.removeAt(index);
    });
  }

  void _alternarComprado(int index) {
    setState(() {
      _itens[index].comprado = !_itens[index].comprado;
    });
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lista de Compras'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Campo de entrada para adicionar itens
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controlador,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar item',
                      hintText: 'Digite o nome do item',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                    onSubmitted: (_) => _adicionarItem(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _adicionarItem,
                  icon: const Icon(Icons.add_circle),
                  iconSize: 40,
                  color: Theme.of(context).colorScheme.primary,
                  tooltip: 'Adicionar',
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Lista de itens
          Expanded(
            child: _itens.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 80,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhum item na lista',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _itens.length,
                    itemBuilder: (context, index) {
                      final item = _itens[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.comprado,
                            onChanged: (bool? valor) {
                              _alternarComprado(index);
                            },
                          ),
                          title: Text(
                            item.nome,
                            style: TextStyle(
                              decoration: item.comprado
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.comprado
                                  ? Colors.grey
                                  : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            color: Colors.red,
                            onPressed: () => _removerItem(index),
                            tooltip: 'Remover',
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
