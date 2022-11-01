import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class SqlService {
  Future<int> createUser(User user) async {
    return await DataBaseConn.instance.createUser(user);
  }
  Future<List<User>> getUsers()async {
    return await DataBaseConn.instance.allUsers();
  }
  Future<User> readSingleUser(int id)async{
    return await DataBaseConn.instance.readUser(id);
  }
  Future <void> updateUser(User user)async{
    await DataBaseConn.instance.updateUser(user);
  }
  Future<int> createJamiya(Jamiya jamiya) async {
    return await DataBaseConn.instance.createJamiya(jamiya);
  }
  Future<List<Jamiya>> getJamiyas()async {
    return await DataBaseConn.instance.allJamiyas();
  }
  Future<Jamiya> readSingleJamiya(String id)async{
    return await DataBaseConn.instance.readJamiya(id);
  }
  Future<List<Jamiya>?> getRegisteredJamiyas(List<String>? jamiyaIDs)async
  {
    List<Jamiya> registeredJamiyas = [];
    int listLength = 0;
    if (jamiyaIDs!=null) {
      listLength= jamiyaIDs.length;
    }
    for(var i =0; i<listLength;i++) {
      String id = jamiyaIDs![i];
      var element = await DataBaseConn.instance.readJamiya(id);
      registeredJamiyas.add(element);
    }
    return registeredJamiyas;
  }
  Future <void> updateJamiya(Jamiya jamiya)async{
      await DataBaseConn.instance.updateJamiya(jamiya);
  }
  Future <void> deleteJamiya(String id)async{
    await DataBaseConn.instance.deleteJamiya(id);
  }
}
