import 'dart:convert';
import 'models.dart';

User userFromJson(String str) => User.fromMap(json.decode(str));

User userFromJsonSharedPrefs(String str) => User.fromMapSharedPrefs(json.decode(str));

String userToJson(User data) => json.encode(data.toMap());

String userToMap(User data) => json.encode(data.toJson());

class User {
  String id;
  String firstName;
  String lastName;
  String userName;
  String? password;
  bool darkMode;
  List<String> registeredJamiyaID;
  String imgUrl;

  User(this.id,
      {required this.userName,
      required this.firstName,
      required this.lastName,
      required this.password,
      required this.imgUrl,
      required this.registeredJamiyaID,
      required this.darkMode});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      UserTableCols.idCol: id,
      UserTableCols.firstNameCol: firstName,
      UserTableCols.lastNameCol: lastName,
      UserTableCols.userNameCol: userName,
      UserTableCols.passwordCol: password,
      UserTableCols.imgUrlCol: imgUrl,
      UserTableCols.darkModeCol: darkMode.toString(),
      UserTableCols.registeredJamiyaID: registeredJamiyaID.join(","),
    };
    return map;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      UserTableCols.firstNameCol: firstName,
      UserTableCols.lastNameCol: lastName,
      UserTableCols.userNameCol: userName,
      UserTableCols.passwordCol: password,
      UserTableCols.imgUrlCol: imgUrl,
      UserTableCols.darkModeCol: darkMode.toString(),
      UserTableCols.registeredJamiyaID: registeredJamiyaID.join(","),
    };
    return map;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    List<dynamic> registeredJamiyatList = map[UserTableCols.registeredJamiyaID];

    return User(
      map['_id'].$oid,
      firstName: map[UserTableCols.firstNameCol],
      lastName: map[UserTableCols.lastNameCol],
      userName: map[UserTableCols.userNameCol],
      password: map[UserTableCols.passwordCol],
      imgUrl: map[UserTableCols.imgUrlCol],
      darkMode: map[UserTableCols.darkModeCol] == 'false' ? false : true,
      registeredJamiyaID: registeredJamiyatList.map((e) => e.toString()).toList(),
    );
  }

  factory User.fromMapSharedPrefs(Map<String, dynamic> map) {
    return User(
      map['id'].toString(),
      firstName: map[UserTableCols.firstNameCol],
      lastName: map[UserTableCols.lastNameCol],
      userName: map[UserTableCols.userNameCol],
      password: map[UserTableCols.passwordCol],
      imgUrl: map[UserTableCols.imgUrlCol],
      darkMode: map[UserTableCols.darkModeCol] == 'false' ? false : true,
      registeredJamiyaID: map[UserTableCols.registeredJamiyaID].split(','),
    );
  }
}
