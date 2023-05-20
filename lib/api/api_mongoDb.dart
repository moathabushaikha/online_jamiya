import 'package:dart_encrypter/dart_encrypter.dart' as encrypter;
import 'package:mongo_dart/mongo_dart.dart';
import 'package:online_jamiya/managers/app_cache.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:provider/provider.dart';

import '../managers/profile_manager.dart';

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
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    Map<String, dynamic>? user = await collection.findOne(where.eq('userName', userName));
    if (user == null || user.isEmpty) {
      return 1;
    }
    User newUser = User.fromMap(user);
    String userPassword = user['password'];
    String? decryptedPass = userPassword.decryptMyData(user['key'], user['iv']);
    if (password != decryptedPass) {
      return 2;
    }
    appCache.setCurrentUser(newUser);
    return 0;
  }

  Future<bool> createUser(User user) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
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
        'darkMode': user.darkMode,
        'registeredJamiyaID': user.registeredJamiyaID,
        'imgUrl': user.imgUrl,
        'key': user.key,
        'iv': user.iv
      });
      return true;
    }
  }

  Future<User> getUserById(String userId) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    ObjectId mongoUserId = ObjectId.parse(userId);
    Map<String, dynamic>? userFromMongo = await collection.findOne(where.eq('_id', mongoUserId));
    User targetUser = User.fromMap(userFromMongo!);
    return targetUser;
  }

  Future<void> updateUser(User user) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('users');
    Map<String, dynamic>? updatedUser =
        await collection.findAndModify(query: where.eq('userName', user.userName), update: {
      'userName': user.userName,
      'password': user.password,
      'firstName': user.firstName,
      'lastName': user.lastName,
      'darkMode': user.darkMode,
      'registeredJamiyaID': user.registeredJamiyaID,
      'imgUrl': user.imgUrl,
      'key': user.key,
      'iv': user.iv
    });
  }

  Future<Map<String, Object?>?> createJamiya(Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
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
    await database.close();
    return newJamiya.document;
  }

  Future<Map<String, Object?>?> initiatePayment(Jamiya jamiya, User user, int index) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyaPayment');
    Map<String, dynamic>? userPayment =
        await collection.findOne({'jamiyaId': jamiya.id, 'userPayment.userId': user.id});
    List<Map<String, dynamic>?> participantsCount =
        await collection.find({'jamiyaId': jamiya.id}).toList();

    if (userPayment == null) {
      int total = participantsCount.length + 1;
      List isPaidInit = List.generate(total, (index) => false);
      WriteResult paymentNew = await collection.insertOne({
        'jamiyaId': jamiya.id,
        'userPayment': {
          'userId': user.id,
          'paymentDates': [jamiya.endingDate],
          'isPaid': isPaidInit
        }
      });
      await database.close();
      return paymentNew.document;
    }
    List<DateTime> paymentDates = [];
    DateTime date = jamiya.startingDate;
    for (int i = 0; i < participantsCount.length; i++) {
      date = date.add(const Duration(days: 30));
      paymentDates.add(date);
    }
    List isPaid = userPayment['userPayment']['isPaid'];
    if (paymentDates[index].isAfter(DateTime.now())) {
      int lastPaidDateIndex = isPaid.lastIndexWhere((element) => element == true);
      if (index != lastPaidDateIndex + 1) {
        return null;
      }
      isPaid[index] = true;
    }
    Map<String, dynamic>? payment = await collection.findAndModify(query: {
      'userPayment.userId': user.id
    }, update: {
      'jamiyaId': jamiya.id,
      'userPayment': {'userId': user.id, 'paymentDates': paymentDates, 'isPaid': isPaid}
    });
    await database.close();
    return payment;
  }

  Future<Map<String, dynamic>?> getUserPayments(User user, Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyaPayment');
    Map<String, dynamic>? userPayment =
        await collection.findOne({'jamiyaId': jamiya.id, 'userPayment.userId': user.id});
    return userPayment;
  }

  Future<List<Map<String, dynamic>?>> getJamiyaPayments(Jamiya? jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyaPayment');
    List<Map<String, dynamic>?> userPayment =
        await collection.find({'jamiyaId': jamiya?.id}).toList();
    await database.close();
    return userPayment;
  }

  Future<void> updatePaymentDates(Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyaPayment');
    List<Map<String, dynamic>?> payments = await collection.find({'jamiyaId': jamiya.id}).toList();
    List<DateTime> paymentDates = [];
    List<bool> isPaid = List.generate(payments.length, (index) => false);
    DateTime date = jamiya.startingDate;
    for (int i = 0; i < payments.length; i++) {
      date = date.add(const Duration(days: 30));
      paymentDates.add(date);
    }
    for (int i = 0; i < payments.length; i++) {
      String targetUser = payments[i]!['userPayment']['userId'];
      Map<String, dynamic>? modified = await collection.findAndModify(query: {
        'userPayment.userId': targetUser
      }, update: {
        'jamiyaId': jamiya.id,
        'userPayment': {'userId': targetUser, 'paymentDates': paymentDates, 'isPaid': isPaid}
      });
    }
    await database.close();
  }

  void deleteJamiyaPayment(Jamiya? jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyaPayment');
    WriteResult payments = await collection.deleteMany({'jamiyaId': jamiya?.id});
  }

  Future<Jamiya> getJamiyaById(String jamiyaId) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    ObjectId mongoJamiyaId = ObjectId.parse(jamiyaId);
    Map<String, dynamic>? jamiyaFromMongo =
        await collection.findOne(where.eq('_id', mongoJamiyaId));
    Jamiya jamiya = Jamiya.fromMap(jamiyaFromMongo!);
    await database.close();
    return jamiya;
  }

  Future<List<Jamiya>> getAllJamiyas() async {
    List<Jamiya> jamiyasList = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    List<Map<String, dynamic>> allJamiyas = await collection.find().toList();

    for (var doc in allJamiyas) {
      jamiyasList.add(Jamiya.fromMap(doc));
    }
    await database.close();
    return jamiyasList;
  }


  Future<Jamiya> updateJamiya(Jamiya jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    Map<String, dynamic>? updatedJamiya =
        await collection.findAndModify(query: where.eq('_id', ObjectId.parse(jamiya.id)), update: {
      'name': jamiya.name,
      'participantsId': jamiya.participantsId,
      'startingDate': jamiya.startingDate,
      'endingDate': jamiya.endingDate,
      'maxParticipants': jamiya.maxParticipants,
      'shareAmount': jamiya.shareAmount,
      'creatorId': jamiya.creatorId
    });
    await database.close();
    return Jamiya.fromMap(updatedJamiya!);
  }

  deleteJamiya(Jamiya? jamiya) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    if (jamiya != null) {
      ObjectId objectId = ObjectId.parse(jamiya.id);
      await collection.deleteOne({'_id': objectId});
    }
    await database.close();
  }

  createNotification(MyNotification notification) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    Map<String, dynamic>? queryResult =
        await collection.findOne(where.eq('jamiyaId', notification.jamiyaId));
    if (queryResult != null &&
        queryResult['notification_receiver_id'] == notification.notificationReceiverId) {
      if (queryResult['notification_creator_id'] == notification.notificationCreatorId) {
        await database.close();
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
    await database.close();
    return MyNotification.fromMap(addedNotification.document);
  }

  Future<List<MyNotification>> getCUserNotifications() async {
    User? currentUser = await appCache.getCurrentUser();
    List<MyNotification> cUserNotifications = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    List<Map<String, dynamic>> queryResult =
        await collection.find(where.eq('notification_receiver_id', currentUser?.id)).toList();

    for (var element in queryResult) {
      MyNotification notification = MyNotification.fromMap(element);
      cUserNotifications.add(notification);
    }
    await database.close();
    return cUserNotifications;
  }

  Future<void> deleteNotification(MyNotification notification) async {
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('notifications');
    ObjectId objectId = ObjectId.parse(notification.id);
    WriteResult deleted = await collection.deleteOne({'_id': objectId});
    await database.close();
  }

  Future<List<User>> getJamiyaRegisteredUsers(Jamiya? selectedJamiya) async {
    List<User> users = [];
    for (var i = 0; i < selectedJamiya!.participantsId.length; i++) {
      String userId = selectedJamiya.participantsId[i];
      User user = await getUserById(userId);
      users.add(user);
    }
    return users;
  }

  Future<List<Jamiya>> getUserRegisteredJamiyas(User? user) async {
    List<Jamiya> userRegisteredJamiyas = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    List<Map<String, dynamic>> jamiyas =
    await collection.find(where.eq('participantsId', user?.id)).toList();
    for (var doc in jamiyas) {
      var jamiya = Jamiya.fromMap(doc);
      userRegisteredJamiyas.add(jamiya);
    }
    await database.close();
    return userRegisteredJamiyas;
  }
  Future<List<Jamiya>> getUsersCreatedJamiyas(User? user) async {
    List<Jamiya> createdJamiyas = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    List<Map<String, dynamic>> jamiyas =
        await collection.find(where.eq('creatorId', user?.id)).toList();
    for (var doc in jamiyas) {
      var jamiya = Jamiya.fromMap(doc);
      createdJamiyas.add(jamiya);
    }
    await database.close();
    return createdJamiyas;
  }

  Future<List<Jamiya>?> filteredJamiya(String? filter) async{
    List<Jamiya> searchResult = [];
    Db database = await Db.create(
        "mongodb+srv://moath:moath85@cluster0.ip45qud.mongodb.net/jamiya_online?retryWrites=true&w=majority");
    await database.open();
    DbCollection collection = database.collection('jamiyat');
    if (filter == null) {
      List<Map<String, dynamic>?> result = await collection.find().toList();
      await database.close();
      for (var jamiya in result) {
        searchResult.add(Jamiya.fromMap(jamiya!));
      }
      return searchResult;
    }
    List<Map<String, dynamic>?> result = await collection.find(where.match('name', filter)).toList();
    await database.close();
    for (var jamiya in result) {
      searchResult.add(Jamiya.fromMap(jamiya!));
    }
    return searchResult;
  }
}
