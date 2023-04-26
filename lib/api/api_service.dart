import 'dart:convert';
import 'dart:io';
import 'package:online_jamiya/managers/app_cache.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:http/http.dart' as http;

class ApiService {
  AppCache appCache = AppCache();
  // final NetworkInfo _networkInfo = NetworkInfo();

  Future<User> signInUser(String userName, String password) async {
    final response = await http.post(
      Uri.parse('${_localhost()}/api/signin'),
      body: jsonEncode({'userName': userName, 'password': password}),
      headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'},
    );
    if (response.statusCode == 200) {
      appCache.setToken(response.body);
      return User.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create user.');
    }
  }

  Future<void> createUser(User user) async {
    final http.Response response = await http.post(Uri.parse('${_localhost()}/api/signup'),
        body: jsonEncode(user.toJson()),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    if (response.statusCode != 200) {
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
    http.Response response = await http.put(Uri.parse('${_localhost()}/api/users?_id=${user.id}'),
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

  Future<List<MyNotification>> getCUserNotifications() async {
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> cUserNotifications = [];
    List<MyNotification> allNotifications = await getAllNotifications();
    for (var notification in allNotifications) {
      if (notification.notificationReceiverId == currentUser?.id) {
        cUserNotifications.add(notification);
      }
    }
    return cUserNotifications;
  }
  Stream<List<MyNotification>?>? getCuNots() async*{
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> cUserNotifications = [];
    List<MyNotification> allNotifications = await getAllNotifications();
    for (var notification in allNotifications) {
      if (notification.notificationReceiverId == currentUser?.id) {
        cUserNotifications.add(notification);
      }
    }
    yield cUserNotifications;
  }
  Future<MyNotification> getNotificationsById(MyNotification notification) async {
    final http.Response response = await http.get(
        Uri.parse('${_localhost()}:3000/api/notifications?_id=${notification.id}'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'});
    return jsonDecode(response.body);
  }

  Future<void> deleteNotification(MyNotification notification) async {
    String jsonString = '{"_id": "${notification.id}"}';
    await http.post(Uri.parse('${_localhost()}/api/deleteNotifications'),
        headers: <String, String>{'Content-type': 'application/json; charset=UTF-8'},
        body: jsonString);
  }

  Future<List<User>> getJamiyaRegisteredUsers(Jamiya? selectedJamiya) async {
    List<User> users = [];
    for (var i = 0; i < selectedJamiya!.participantsId.length; i++) {
     // print(selectedJamiya!.participantsId[i]);
      String userId = selectedJamiya.participantsId[i];
      User user = await getUserById(userId);
      users.add(user);
    }

    return users;
  }

  Future<List<Jamiya>> getUserRegisteredJamiyas(User? user) async {
    List<Jamiya> userRegisteredJamiyas = [];
    for (var i = 0; i < user!.registeredJamiyaID.length; i++) {
      Jamiya jamiya = await getJamiyaById(user.registeredJamiyaID[i]);
      userRegisteredJamiyas.add(jamiya);
    }
    return userRegisteredJamiyas;
  }

  String _localhost() {
     if (Platform.isAndroid)
       {
         return 'http://192.168.1.102:3000';
       }
     else {
       return 'localhost:3000';
     }
  }
}
