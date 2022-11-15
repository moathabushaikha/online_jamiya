import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  Future<void> updateItem(Jamiya jamiyaItem,index) async {
    await sqlService.updateJamiya(jamiyaItem);
    Jamiya updatedJamiya = await sqlService.readSingleJamiya(jamiyaItem.id);
    _jamiyaItems![index] = updatedJamiya;
    _appCache.setJamiyat(_jamiyaItems!);
    notifyListeners();
  }
  Future<void> addNotification(Jamiya selectedJamiya, User? enrolledUser) async {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yy').format(now);
    EnrollModel newNotification = EnrollModel(
        selectedJamiya.id,
        selectedJamiya.creatorId!,
        enrolledUser!.id,
        formattedDate,
        'false');
    await DataBaseConn.instance.addNotification(newNotification);
    notifyListeners();
  }
}
