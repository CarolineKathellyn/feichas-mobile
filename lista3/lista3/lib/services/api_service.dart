import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class ApiService {
  static const String _base = 'http://localhost:3000';

  Future<List<User>> getUsers() async {
    final res = await http.get(Uri.parse('$_base/users'));
    _check(res);
    final List<dynamic> data = jsonDecode(res.body);
    return data.map((j) => User.fromJson(j as Map<String, dynamic>)).toList();
  }

  Future<User> createUser(User user) async {
    final res = await http.post(
      Uri.parse('$_base/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    _check(res);
    return User.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<User> updateUser(User user) async {
    final res = await http.put(
      Uri.parse('$_base/users/${user.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );
    _check(res);
    return User.fromJson(jsonDecode(res.body) as Map<String, dynamic>);
  }

  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$_base/users/$id'));
    _check(res);
  }

  void _check(http.Response res) {
    if (res.statusCode >= 400) {
      throw Exception('API error ${res.statusCode}: ${res.body}');
    }
  }
}
