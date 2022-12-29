import 'dart:convert';
import 'dart:io';
import 'package:online_jamiya/models/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<String> signInUser(String userName, String password) async {
    final response = await http.post(
      Uri.parse('${_localhost()}/api/signin'),
      body: jsonEncode({'userName': userName, 'password': password}),
      headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'},
    );
    return response.body;
  }

  Future<User> createUser(User user) async {
    final http.Response response = await http.post(Uri.parse('${_localhost()}/api/signup'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    // print(response.statusCode);
    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<User> getUserById(String userId) async {
    final http.Response response = await http.get(
        Uri.parse('${_localhost()}/api/users?_id=$userId'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    if (response.statusCode == 200) {
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<User> updateUser(User user) async {
    http.Response response = await http.put(Uri.parse('${_localhost()}/api/jamiyas?_id=${user.id}'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    return User.fromMap(jsonDecode(response.body));
  }

  Future<Jamiya> createJamiya(Jamiya jamiya) async {
    final http.Response response = await http.post(Uri.parse('${_localhost()}/api/addJamiya'),
        body: jsonEncode(jamiya.toJson()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    if (response.statusCode == 200) {
      return Jamiya.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<Jamiya> getJamiyaById(String jamiyaId) async {
    Uri url = Uri.parse('${_localhost()}/api/jamiyas?_id=$jamiyaId');
    final http.Response response = await http
        .get(url, headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    if (response.statusCode == 200) {
      return Jamiya.fromMap(jsonDecode(response.body)[0]);
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<List<Jamiya>> getAllJamiyas() async {
    List<Jamiya> jamiyasList = [];
    final http.Response response = await http.get(Uri.parse('${_localhost()}/api/jamiyas'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      Jamiya jamiyaItem = Jamiya.fromMap(jsonDecode(response.body)[i]);
      jamiyasList.add(jamiyaItem);
    }
    return jamiyasList;
  }

  Future<Jamiya> updateJamiya(Jamiya jamiya) async {
    http.Response response = await http.put(
        Uri.parse('${_localhost()}/api/jamiyas?_id=${jamiya.id}'),
        body: jsonEncode(jamiya.toJson()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    return Jamiya.fromMap(jsonDecode(response.body));
  }

  Future<MyNotification> createNotification(MyNotification notification) async {
    final http.Response response = await http.post(Uri.parse('${_localhost()}/api/addNotification'),
        body: jsonEncode(notification.toMap()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    print(response.statusCode);
    if (response.statusCode == 200) {
      return MyNotification.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create notification.');
    }
  }

  Future<List<MyNotification>> getAllNotifications() async {
    List<MyNotification> allNotifications = [];
    final http.Response response = await http.get(Uri.parse('${_localhost()}/api/notifications'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    for (var i = 0; i < jsonDecode(response.body).length; i++) {
      MyNotification notification = MyNotification.fromMap(jsonDecode(response.body)[i]);
      allNotifications.add(notification);
    }
    return allNotifications;
  }

  Future<MyNotification> getNotificationsById(MyNotification notification) async {
    final http.Response response = await http.get(
        Uri.parse('${_localhost()}/api/notifications?_id=${notification.id}'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    return jsonDecode(response.body);
  }

  Future<void> deleteNotification(MyNotification notification) async {
    String jsonString = '{"_id": "${notification.id}"}';
    await http.post(Uri.parse('${_localhost()}/api/deleteNotifications'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'},
        body: jsonString);
  }

  String _localhost() {
    if (Platform.isAndroid) {
      return 'http://192.168.1.28:3000';
    } else {
      return 'http://localhost:3000';
    }
  }
}
