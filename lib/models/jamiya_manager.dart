import 'package:flutter/material.dart';
import 'package:online_jamiya/api/api.dart';
import 'models.dart';

class JamiyaManager extends ChangeNotifier {
  final AppCache _appCache = AppCache();
  final SqlService sqlService = SqlService();
  List<Jamiya>? _jamiyaItems;

  List<Jamiya> get jamiyaItems {
    if (_jamiyaItems != null) {
      return List.unmodifiable(_jamiyaItems!);
    } else {
      return [];
    }
  }

  Future<void> getJamiyat() async {
    _jamiyaItems = await _appCache.allJamiyat();
  }

  void deleteJamiyaItem(int index) async {
    jamiyaItems.removeAt(index);
    await sqlService.deleteJamiya((index + 1).toString());
    notifyListeners();
  }

  String getJamiyaItemId(int index) {
    final jamiyaItem = _jamiyaItems![index];
    return jamiyaItem.id;
  }

  Jamiya? getJamiyaItem(String id) {
    final index = _jamiyaItems?.indexWhere((element) => element.id == id);
    if (index == -1) return null;
    return jamiyaItems[index!];
  }

  void addJamiyaItem(Jamiya item) async {
    getJamiyat();
    int newJamiyaId = await sqlService.createJamiya(item);
    Jamiya newJamiya =
        await sqlService.readSingleJamiya(newJamiyaId.toString());
    _jamiyaItems?.add(newJamiya);
    _appCache.setJamiyat(_jamiyaItems!);
    notifyListeners();
  }

  void updateItem(Jamiya jamiyaItem) async {
    await sqlService.updateJamiya(jamiyaItem);
    Jamiya updatedJamiya = await sqlService.readSingleJamiya(jamiyaItem.id);
    print('update jamiya ${updatedJamiya.participantsId}');
    final index =
        _jamiyaItems?.indexWhere((element) => element.id == updatedJamiya.id);
    _jamiyaItems![index!] = updatedJamiya;
    notifyListeners();
  }
}
