import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import 'user_form_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final _api = ApiService();
  late Future<List<User>> _future;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() => setState(() { _future = _api.getUsers(); });

  Future<void> _delete(int id) async {
    await _api.deleteUser(id);
    _reload();
  }

  Future<void> _openForm({User? user}) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => UserFormScreen(user: user)),
    );
    if (result == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: FutureBuilder<List<User>>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Error: ${snap.error}'));
          }
          final users = snap.data!;
          if (users.isEmpty) {
            return const Center(child: Text('No users yet. Tap + to add one.'));
          }
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (ctx, i) {
              final u = users[i];
              return ListTile(
                title: Text(u.name),
                subtitle: Text('Age: ${u.age}  |  ${u.address}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _openForm(user: u),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _delete(u.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
