import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CatalogScreen(),
    );
  }
}

// Modelo de produto
class Product {
  final String name;
  final String price;
  final String description;

  Product({
    required this.name,
    required this.price,
    required this.description,
  });
}

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dados dos produtos por categoria
  final List<Product> electronics = [
    Product(
      name: 'Smartphone Samsung Galaxy S24',
      price: 'R\$ 3.999,00',
      description: 'Tela 6.2", 128GB, 8GB RAM',
    ),
    Product(
      name: 'Notebook Dell Inspiron',
      price: 'R\$ 4.299,00',
      description: 'Intel i5, 8GB RAM, SSD 256GB',
    ),
    Product(
      name: 'Tablet iPad Air',
      price: 'R\$ 5.499,00',
      description: '10.9", 64GB, Wi-Fi',
    ),
    Product(
      name: 'Smart TV LG 55"',
      price: 'R\$ 2.899,00',
      description: '4K UHD, Smart, ThinQ AI',
    ),
    Product(
      name: 'Fone Bluetooth Sony WH-1000XM5',
      price: 'R\$ 1.899,00',
      description: 'Cancelamento de ruído, 30h bateria',
    ),
  ];

  final List<Product> clothing = [
    Product(
      name: 'Camiseta Básica Algodão',
      price: 'R\$ 49,90',
      description: 'Tamanhos P ao GG, várias cores',
    ),
    Product(
      name: 'Calça Jeans Slim',
      price: 'R\$ 159,90',
      description: 'Corte moderno, elastano',
    ),
    Product(
      name: 'Jaqueta de Couro',
      price: 'R\$ 599,00',
      description: 'Couro legítimo, forrado',
    ),
    Product(
      name: 'Vestido Floral',
      price: 'R\$ 189,90',
      description: 'Tecido leve, estampa florida',
    ),
    Product(
      name: 'Tênis Esportivo',
      price: 'R\$ 299,90',
      description: 'Confortável, ideal para corrida',
    ),
  ];

  final List<Product> books = [
    Product(
      name: 'Clean Code - Robert Martin',
      price: 'R\$ 89,90',
      description: 'Guia de boas práticas de programação',
    ),
    Product(
      name: '1984 - George Orwell',
      price: 'R\$ 34,90',
      description: 'Clássico da literatura distópica',
    ),
    Product(
      name: 'Sapiens - Yuval Harari',
      price: 'R\$ 54,90',
      description: 'Uma breve história da humanidade',
    ),
    Product(
      name: 'O Programador Pragmático',
      price: 'R\$ 79,90',
      description: 'De aprendiz a mestre',
    ),
    Product(
      name: 'Dom Casmurro - Machado de Assis',
      price: 'R\$ 24,90',
      description: 'Clássico da literatura brasileira',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Catálogo de Produtos'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.devices),
              text: 'Eletrônicos',
            ),
            Tab(
              icon: Icon(Icons.checkroom),
              text: 'Roupas',
            ),
            Tab(
              icon: Icon(Icons.book),
              text: 'Livros',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductList(electronics),
          _buildProductList(clothing),
          _buildProductList(books),
        ],
      ),
    );
  }

  Widget _buildProductList(List<Product> products) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          elevation: 2,
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              product.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(
                  product.description,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.price,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${product.name} adicionado ao carrinho!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
