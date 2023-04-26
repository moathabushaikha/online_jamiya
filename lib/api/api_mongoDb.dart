import 'dart:convert';
import 'dart:io';
import 'package:dart_encrypter/dart_encrypter.dart' as encrypter;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:online_jamiya/api/local_db.dart';
import 'package:online_jamiya/managers/app_cache.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:http/http.dart' as http;

class ApiMongoDb {
  AppCache appCache = AppCache();

  Future<int> signInUser(String userName, String password) async {
    userName = userName.toLowerCase();
    if (userName.contains(' ')) {
      userName.trim();
      int index = userName.indexOf(' ');
      userName = userName.substring(0, index);
    }
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    Map<String, dynamic>? user = await collection.findOne(where.eq('userName', userName));
    if (user == null || user.isEmpty) {
      return 1;
    }
    User newUser = User.fromMap(user);
    ObjectId objectId = user['_id'];
    List<Map<String, Object?>> keys = await DataBaseConn.instance.getKeys(objectId.$oid);
    if (keys.isEmpty) {
      return 3;
    }
    String userPassword = user['password'];
    String? decryptedPass = userPassword.decryptMyData(
        keys[0]['passwordKey'].toString(), keys[0]['passwordIV'].toString());
    if (password != decryptedPass) {
      return 2;
    }
    appCache.setCurrentUser(newUser);
    return 0;
  }

  Future<bool> createUser(User user, String? passwordKey, String? passwordIV) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    Map<String, dynamic>? newUser = await collection.findOne(where.eq('userName', user.userName));
    if (newUser != null) {
      return false;
    } else {
      await collection.insertOne({
        'userName': user.userName,
        'password': user.password,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'darkMode': user.darkMode.toString(),
        'registeredJamiyaID': user.registeredJamiyaID,
        'imgUrl': user.imgUrl,
      });
      Map<String, dynamic>? newUser = await collection.findOne(where.eq('userName', user.userName));
      ObjectId objectId = newUser?['_id'];
      String obid = objectId.$oid;
      await DataBaseConn.instance.addKey(obid, passwordKey, passwordIV);
      return true;
    }
  }

  Future<User> getUserById(String userId) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    ObjectId mongoUserId = ObjectId.parse(userId);
    Map<String, dynamic>? userFromMongo = await collection.findOne(where.eq('_id', mongoUserId));
    User targetUser = User.fromMap(userFromMongo!);
    return targetUser;
  }

  Future<void> updateUser(User user) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    Map<String, dynamic>? result =
        await collection.findAndModify(query: where.eq('userName', user.userName), update: {
      'userName': user.userName,
      'password': user.password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'darkMode': user.darkMode,
      'registeredJamiyaID': user.registeredJamiyaID,
      'imgUrl': user.imgUrl
    });
  }

  Future<Map<String, Object?>?> createJamiya(Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    Map<String, dynamic>? result = await collection.findOne(where.eq('jamiyaName', jamiya.name));
    if (result != null) {
      return null;
    }
    WriteResult newJamiya = await collection.insertOne({
      JamiyaTable.name: jamiya.name,
      JamiyaTable.participantsId: jamiya.participantsId,
      JamiyaTable.startingDate: jamiya.startingDate,
      JamiyaTable.endingDate: jamiya.endingDate,
      JamiyaTable.maxParticipants: jamiya.maxParticipants,
      JamiyaTable.shareAmount: jamiya.shareAmount,
      JamiyaTable.creatorId: jamiya.creatorId,
    });
    return newJamiya.document;
  }

  Future<Jamiya> getJamiyaById(String jamiyaId) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    ObjectId mongoJamiyaId = ObjectId.parse(jamiyaId);
    Map<String, dynamic>? jamiyaFromMongo = await collection.findOne(where.eq('_id', mongoJamiyaId));
   Jamiya jamiya = Jamiya.fromMap(jamiyaFromMongo!);
   return jamiya;
  }

  Future<List<Jamiya>> getAllJamiyas() async {
    List<Jamiya> jamiyasList = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    List<Map<String, dynamic>> allJamiyas = await collection.find().toList();
    for (var doc in allJamiyas) {
      jamiyasList.add(Jamiya.fromMap(doc));
    }
    return jamiyasList;
  }
  Stream<List<Jamiya>?>? getJamiyas() async* {
    List<Jamiya> jamiyasList = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    List<Map<String, dynamic>> queryResult = await collection.find().toList();
    for (var doc in queryResult) {
      jamiyasList.add(Jamiya.fromMap(doc));
    }
    yield jamiyasList;
  }


  Future<Jamiya> updateJamiya(Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    Map<String, dynamic>? updatedJamiya = await collection.findAndModify(query: where.eq('_id', ObjectId.parse(jamiya.id)),update: {
     'name': jamiya.name,
    'participantsId': jamiya.participantsId,
    'startingDate':jamiya.startingDate,
    'endingDate': jamiya.endingDate,
    'maxParticipants': jamiya.maxParticipants,
    'shareAmount':jamiya.shareAmount,
    'creatorId': jamiya.creatorId
    });
    return Jamiya.fromMap(updatedJamiya!);
  }

  createNotification(MyNotification notification) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    Map<String, dynamic>? queryResult =
        await collection.findOne(where.eq('jamiyaId', notification.jamiyaId));
    if (queryResult != null &&
        queryResult['notification_receiver_id'] == notification.notificationReceiverId) {
      if (queryResult['notification_creator_id'] == notification.notificationCreatorId) {
        print('notification already sent');
        return;
      }
    }
    WriteResult addedNotification = await collection.insertOne({
      'jamiyaId': notification.jamiyaId,
      'notification_creator_id': notification.notificationCreatorId,
      'notification_receiver_id': notification.notificationReceiverId,
      'notificationDate': notification.notificationDate,
      'notificationType': notification.notificationType
    });
    return MyNotification.fromMap(addedNotification.document);
  }

  Future<List<MyNotification>> getAllNotifications() async {
    List<MyNotification> allNotifications = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    List<Map<String, dynamic>> queryResult = await collection.find().toList();
    // print('all nots $queryResult');
    return allNotifications;
  }

  Future<List<MyNotification>> getCUserNotifications() async {
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> cUserNotifications = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    List<Map<String, dynamic>> queryResult =
    await collection.find(where.eq('notification_receiver_id', currentUser?.id)).toList();
    print('cuid: ${currentUser?.id}');
    for (var element in queryResult) {
      MyNotification notification = MyNotification.fromMap(element);

      print('ntid: ${notification.id} , recvr: ${notification.notificationReceiverId}');
      cUserNotifications.add(notification);
    }
    return cUserNotifications;
  }

  Stream<List<MyNotification>?>? getCuNotStream() async* {
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> cUserNotifications = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    List<Map<String, dynamic>> queryResult =
        await collection.find(where.eq('notification_receiver_id', currentUser?.id)).toList();
    for (var element in queryResult) {
      MyNotification notification = MyNotification.fromMap(element);
      cUserNotifications.add(notification);
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
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/test?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    ObjectId objectId = ObjectId.parse(notification.id);
    var d = await collection.deleteOne({'_id':objectId});
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
    if (Platform.isAndroid) {
      return 'http://192.168.1.102:3000';
    } else {
      return 'localhost:3000';
    }
  }
}
