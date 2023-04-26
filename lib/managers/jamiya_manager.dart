import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
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

  Future<List<Jamiya>?> getJamiyat(User? currentUser) async {
    _jamiyaItems = await apiService.getAllJamiyas();
    return _jamiyaItems;
  }
  void setJamiyatItem() async {
    _jamiyaItems = await apiMongoDb.getAllJamiyas();
  }
  void deleteJamiyaItem(int index) async {
    jamiyaItems.removeAt(index);
    // await sqlService.deleteJamiya((index + 1).toString());
    //TODO delete jamiya from mongooDb
    notifyListeners();
  }

  void addJamiyaItem(Jamiya item, BuildContext context) async {
    Map<String, Object?>? newJamiya = await apiMongoDb.createJamiya(item);
    if (newJamiya == null){
      buildDialog(context,'The jamiya name already exist');
    }
    else
      {
        Jamiya? jamiya = Jamiya.fromMap(newJamiya);
        _jamiyaItems?.add(jamiya);
        notifyListeners();
      }
  }

  Future<void> updateItem(Jamiya jamiyaItem) async {
    int index = 0;
    index = _jamiyaItems?.indexWhere((element) => jamiyaItem.id == element.id) ?? 0;
    Jamiya updatedJamiya = await apiMongoDb.updateJamiya(jamiyaItem);
    _jamiyaItems?[index] = updatedJamiya;
    notifyListeners();
  }

  void buildDialog(BuildContext context, String msg) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Authentication Error'),
          content: SingleChildScrollView(
            child: Text(msg),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Retry'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
