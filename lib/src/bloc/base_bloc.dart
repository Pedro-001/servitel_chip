

import 'package:flutter/material.dart';
import 'package:servitel_chip/routes/routes.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

class BaseBloc{

  final BuildContext _buildContext;
  final SharedPreferencesManager _sharedPreferencesManager;

  BaseBloc(this._buildContext, this._sharedPreferencesManager);

  closeSession() async{

    await _sharedPreferencesManager.removeData(SharedPreferencesManager.FIRMA);
    await _sharedPreferencesManager.removeData(SharedPreferencesManager.USER);
    await _sharedPreferencesManager.removeData(SharedPreferencesManager.PADRE);

    Navigator.of(_buildContext).pushNamedAndRemoveUntil(
        Routes.LOGIN_SCREEN, (Route<dynamic> route) => false
    );
  }
}