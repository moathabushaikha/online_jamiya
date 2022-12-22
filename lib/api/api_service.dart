import 'dart:convert';
import 'dart:io';
import 'package:online_jamiya/models/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<List<User>> getUsers() async {
    List<User> users;
    final response = await http.get(Uri.parse(_localhost()));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      users = body.map((json) => User.fromMap(json)).toList();
      return users;
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<User> createUser(User user) async {
    print(user.userName);
    print(user.password);
    final http.Response response = await http.post(
      Uri.parse('http://192.168.0.230:3000/api/signup'),
      body: jsonEncode(user.toJson()),
      headers: <String, String>{
        'Content-type': 'application/json; charset=UTF-8'
      }
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  String _localhost() {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:3000';
    } else {
      return 'http://localhost:3000';
    }
  }
}
