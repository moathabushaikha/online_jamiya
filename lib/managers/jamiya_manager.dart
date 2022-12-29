import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'package:online_jamiya/api/api_service.dart';
import 'package:online_jamiya/models/models.dart';
import 'package:online_jamiya/managers/managers.dart';

class JamiyaManager extends ChangeNotifier {
  final AppCache _appCache = AppCache();
  // final SqlService sqlService = SqlService();
  final apiService = ApiService();
  List<Jamiya>? _jamiyaItems;

  List<Jamiya> get jamiyaItems {
    if (_jamiyaItems != null) {
      return List.unmodifiable(_jamiyaItems!);
    } else {
      return [];
    }
  }

  void getJamiyat() async {
   // _jamiyaItems = await _appCache.allJamiyat();
    _jamiyaItems = await apiService.getAllJamiyas();
  }

  void deleteJamiyaItem(int index) async {
    jamiyaItems.removeAt(index);
   // await sqlService.deleteJamiya((index + 1).toString());
    //TODO delete jamiya from mongooDb
    notifyListeners();
  }


  void addJamiyaItem(Jamiya item) async {
    // getJamiyat();
    // int newJamiyaId = await sqlService.createJamiya(item);
    Jamiya newJamiya = await apiService.createJamiya(item);
    // Jamiya newJamiya =
    //     await sqlService.readSingleJamiya(newJamiyaId.toString());
    _jamiyaItems?.add(newJamiya);
    _appCache.setJamiyat(_jamiyaItems!);
    notifyListeners();
  }

  Future<void> updateItem(Jamiya jamiyaItem) async {
    int index = _jamiyaItems!.indexWhere((element) => jamiyaItem.id == element.id);
    Jamiya updatedJamiya = await apiService.updateJamiya(jamiyaItem);
    //await sqlService.updateJamiya(jamiyaItem);
    //Jamiya updatedJamiya = await sqlService.readSingleJamiya(jamiyaItem.id);
   _jamiyaItems![index] = updatedJamiya;
    _appCache.setJamiyat(_jamiyaItems!);
    notifyListeners();
  }
}
