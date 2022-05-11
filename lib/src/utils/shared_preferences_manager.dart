
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager{

  static const FIRMA = "servitel.firma";
  static const USER = "servitel.user";
  static const PADRE = "servitel.padre";

  Future<SharedPreferences> _sharedPreferences = SharedPreferences.getInstance();

  Future<bool> saveData(String data, String key) =>
      this._sharedPreferences.then((preferences) =>
          preferences.setString(key, data));

  Future<bool> saveDataBool(bool data, String key) =>
      this._sharedPreferences.then((preferences) =>
          preferences.setBool(key, data));

  Future removeData(String key) =>
      this._sharedPreferences.then((preferences) =>
          preferences.remove(key));

  Future getData(String key) async{
    return this._sharedPreferences.then((preferences) => preferences.get(key));
  }

}