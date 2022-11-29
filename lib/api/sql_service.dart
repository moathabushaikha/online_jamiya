import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class SqlService {
  Future<int> createUser(User user) async {
    return await DataBaseConn.instance.createUser(user);
  }

  Future<List<User>> getUsers() async {
    return await DataBaseConn.instance.allUsers();
  }

  Future<User> readSingleUser(int id) async {
    return await DataBaseConn.instance.readUser(id);
  }

  Future<void> updateUser(User user) async {
    await DataBaseConn.instance.updateUser(user);
  }

  Future<int> createJamiya(Jamiya jamiya) async {
    return await DataBaseConn.instance.createJamiya(jamiya);
  }

  Future<List<Jamiya>> getJamiyas() async {
    return await DataBaseConn.instance.allJamiyas();
  }

  Future<Jamiya> readSingleJamiya(String id) async {
    return await DataBaseConn.instance.readJamiya(id);
  }

  Future<List<Jamiya>> getUserRegisteredJamiyas(User? currentUser) async {
    List<Jamiya> registeredJamiyas = [];
    List<Jamiya> allJamiyas = await DataBaseConn.instance.allJamiyas();
    for (var jamiya in allJamiyas) {
      if (currentUser != null) {
        if (currentUser.registeredJamiyaID.contains(jamiya.id)) {
          registeredJamiyas.add(jamiya);
        }
      }
    }
    return registeredJamiyas;
  }

  Future<List<User>> getJamiyaRegisteredUsers(Jamiya? selectedJamiya) async {
    List<User> registeredUsers = [];
    List<User> allUsers = await DataBaseConn.instance.allUsers();
    for (var user in allUsers) {
      if (selectedJamiya != null) {
        if (selectedJamiya.participantsId.contains(user.id)) {
          registeredUsers.add(user);
        }
      }
    }
    return registeredUsers;
  }

  Future<void> updateJamiya(Jamiya jamiya) async {
    await DataBaseConn.instance.updateJamiya(jamiya);
  }

  Future<void> deleteJamiya(String id) async {
    await DataBaseConn.instance.deleteJamiya(id);
  }
  Future<int> createNotification(MyNotification myNotification) async {
    return await DataBaseConn.instance.createNotification(myNotification);
  }
  Future<MyNotification> readSingleNotification(String id) async {
    return await DataBaseConn.instance.getNotificationById(id);
  }
  Future<List<MyNotification>> allNotifications() async{
    return await DataBaseConn.instance.allNotifications();
  }
  Future<void> updateNotification(MyNotification myNotification)async{
    // await DataBaseConn.instance.updateNotification();
  }
  Future<void> deleteNotification(String id) async {
    await DataBaseConn.instance.deleteNotification(id);
  }
}
