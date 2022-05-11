
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/routes/routes.dart';
import 'package:servitel_chip/src/model/response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/repositories/login_repository.dart';
import 'package:servitel_chip/src/utils/custom_dialog.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

class LoginBloc{

  final SharedPreferencesManager _sharedPreferencesManager;
  final LoginRepository _loginRepository;

  final _publishStatusLoader = PublishSubject<StatusLoader>();
  Stream<StatusLoader> get observerLoader => _publishStatusLoader.stream;
  final _publishEnablePhone = PublishSubject<bool>();
  Stream<bool> get observerEnablePhone => _publishEnablePhone.stream;
  final _publishEnableButtonContinue = PublishSubject<bool>();
  Stream<bool> get observerEnableButtonContinue => _publishEnableButtonContinue.stream;

  TextEditingController textPhone = TextEditingController();
  TextEditingController textCode = TextEditingController();

  BuildContext _buildContext;

  LoginBloc(this._buildContext,this._sharedPreferencesManager, this._loginRepository){
    validateAccount();
  }

  validateAccount() async{
    String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);

    if (firma != null && firma.isNotEmpty){
      Navigator.of(_buildContext).pushNamedAndRemoveUntil(Routes.MAIN_MENU, (Route<dynamic> route) => false);
    }
  }

  loginFaseUno()async {
    _publishEnablePhone.sink.add(false);

    StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING, data: null);
    _publishStatusLoader.sink.add(statusLoader);

    String token = await FirebaseMessaging.instance.getToken();
    print(token);

    Response loginFaseUno = await _loginRepository.loginFaseUno(textPhone.text, token);

    statusLoader.status = STATUS.READY;
    if (loginFaseUno.operacionExitosa){

      statusLoader.data = true;

    }else{
      statusLoader.data = false;
      _publishEnablePhone.sink.add(true);

      CustomDialog.showDialogAsync(
          context: _buildContext,
          description: loginFaseUno.mensaje,
          onAccept: (dialogContext){
            Navigator.pop(dialogContext);
          }
      );
    }

    _publishStatusLoader.sink.add(statusLoader);

  }

  String validatorPhone(String data){
    if (data.isNotEmpty && data.length == 10){
      _publishEnableButtonContinue.sink.add(true);
      return null;
    }else{
      _publishEnableButtonContinue.sink.add(false);
      return "Ingresa un número de teléfono válido";
    }
  }

  String validatorCode(String data){
    if (data.isNotEmpty){
      return null;
    }else{
      return "Ingresa el código del SMS";
    }
  }



  loginFaseDos() async{

    StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING, data: null);
    _publishStatusLoader.sink.add(statusLoader);

    String token = await FirebaseMessaging.instance.getToken();

    Response loginFaseDos = await _loginRepository.loginFaseDos(textCode.text, token);

    statusLoader.status = STATUS.READY;

    if (loginFaseDos.operacionExitosa){
      await _sharedPreferencesManager.saveData(loginFaseDos.credentials.firma, SharedPreferencesManager.FIRMA);
      await _sharedPreferencesManager.saveData(loginFaseDos.credentials.usuario, SharedPreferencesManager.USER);
      await _sharedPreferencesManager.saveDataBool(loginFaseDos.credentials.padre, SharedPreferencesManager.PADRE);

      Navigator.of(_buildContext).pushNamedAndRemoveUntil(Routes.MAIN_MENU, (Route<dynamic> route) => false);

    }else{
      CustomDialog.showDialogAsync(
          context: _buildContext,
          description: loginFaseDos.mensaje,
          onAccept: (dialogContext){
            Navigator.pop(dialogContext);
          }
      );
    }

    statusLoader.data = false;
    _publishEnablePhone.sink.add(true);
    _publishStatusLoader.sink.add(statusLoader);

  }

  dispose(){
    _publishStatusLoader.close();
    _publishEnablePhone.close();
    _publishEnableButtonContinue.close();
  }
}