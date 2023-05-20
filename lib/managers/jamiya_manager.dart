import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/models/models.dart';

class JamiyaManager extends ChangeNotifier {
  final ApiMongoDb apiMongoDb = ApiMongoDb();
  final ApiService apiService = ApiService();
  List<Jamiya>? _jamiyaItems;

  List<Jamiya> get jamiyaItems {
    if (_jamiyaItems != null) {
      return List.unmodifiable(_jamiyaItems!);
    } else {
      return [];
    }
  }

  Future<List<Jamiya>> getJamiyat() async {
    return _jamiyaItems = await apiMongoDb.getAllJamiyas();
  }

  void deleteJamiyaItem(Jamiya? jamiya) async {
    jamiyaItems.removeWhere((element) => element == jamiya!);
    await apiMongoDb.deleteJamiya(jamiya);
    notifyListeners();
  }

  Future<Jamiya?> addJamiyaItem(Jamiya item) async {
    Map<String, Object?>? newJamiya = await apiMongoDb.createJamiya(item);
    if (newJamiya == null) {
      return null;
    }
    Jamiya? jamiya = Jamiya.fromMap(newJamiya);
    _jamiyaItems?.add(jamiya);
    notifyListeners();
    return jamiya;
  }
  Future<List<Jamiya>> getRegisteredJamias(User? user) async{
    List<Jamiya> registeredJamiyas = await apiMongoDb.getUserRegisteredJamiyas(user);
    notifyListeners();
    return registeredJamiyas;
  }
  Future<void> updateItem(Jamiya jamiyaItem) async {
    int index = 0;
    index = _jamiyaItems?.indexWhere((element) => jamiyaItem.id == element.id) ?? 0;
    Jamiya updatedJamiya = await apiMongoDb.updateJamiya(jamiyaItem);
    _jamiyaItems?[index] = updatedJamiya;
    notifyListeners();
  }
}
