
import 'package:flutter/cupertino.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/src/model/recharge_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/repositories/phone_recharges_repository.dart';
import 'package:servitel_chip/src/utils/custom_dialog.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';
import 'package:location/location.dart';

import 'base_bloc.dart';

class HomeBloc extends BaseBloc{

  final BuildContext _buildContext;
  final SharedPreferencesManager _sharedPreferencesManager;
  final PhoneRechargesRepository _phoneRechargesRepository;
  final Location _location = Location();
  double _latitude = 0;
  double _longitude = 0;

  final _publishStatusLoader = PublishSubject<StatusLoader>();
  Stream<StatusLoader> get observerLoader => _publishStatusLoader.stream;

  final _publishButtonActivar = PublishSubject<bool>();
  Stream<bool> get observerButtonActivar => _publishButtonActivar.stream;

  TextEditingController textPhone = TextEditingController();
  final _publishEnablePhone = PublishSubject<bool>();

  Stream<bool> get observerEnablePhone => _publishEnablePhone.stream;

  HomeBloc(this._buildContext,
      this._sharedPreferencesManager,
      this._phoneRechargesRepository
      ) : super(_buildContext, _sharedPreferencesManager){
    requestEnableLocation();
  }

  requestEnableLocation() async{
    bool serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: "Enciende el GPS",
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
            }
        );
      }else{
        bool permissionGranted = await requestPermissionGranted();
        locationActive(permissionGranted);
      }
    }else{
      bool permissionGranted = await requestPermissionGranted();
      locationActive(permissionGranted);
    }
  }

  locationActive(bool permissionGranted) async{
    if (permissionGranted){
      LocationData data = await _location.getLocation();
      _latitude = data.latitude;
      _longitude = data.longitude;
      print(_latitude.toString());
      print(_longitude.toString());
    }
  }

  Future<bool> requestPermissionGranted() async{
    PermissionStatus permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();

      switch (permissionGranted){

        case PermissionStatus.granted:
          return true;
          break;
        case PermissionStatus.grantedLimited:
          return true;
          break;
        case PermissionStatus.denied:
          CustomDialog.showDialogAsync(
              context: _buildContext,
              description: "Permisos de ubicación denegados",
              onAccept: (dialogContext){
                Navigator.pop(dialogContext);
              }
          );
          return false;
          break;
        case PermissionStatus.deniedForever:
          CustomDialog.showDialogAsync(
              context: _buildContext,
              description: "Tendrás que activar los permisos del gps manualmente desde la configuración",
              onAccept: (dialogContext){
                Navigator.pop(dialogContext);
              }
          );
          return false;
          break;
        default:
          return false;
          break;
      }
    }else{
      return true;
    }
  }

  Future recharge() async{

    if (_latitude == 0 || _longitude == 0 ){
      CustomDialog.showDialogAsync(
          context: _buildContext,
          description: "Estamos buscando tu ubicación",
          onAccept: (dialogContext){
            requestEnableLocation();
            Navigator.pop(dialogContext);
          }
      );
    }else{
      StatusLoader loader = StatusLoader(status: STATUS.LOADING, data: null);
      _publishEnablePhone.sink.add(false);
      _publishStatusLoader.sink.add(loader);

      String latitud = _latitude.toString();
      String longitud = _longitude.toString();
      String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);

      RechargeResponse recharge = await _phoneRechargesRepository.recharge(textPhone.text, latitud, longitud, firma);

      loader.status = STATUS.READY;

      _publishStatusLoader.sink.add(loader);
      _publishEnablePhone.sink.add(true);
      textPhone.text = "";

      if (recharge.operacionExitosa){
        //SHOW MESSAGE
        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: recharge.objeto,
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
            }
        );
      }else if (!recharge.operacionExitosa && recharge.redirigir){
        //SHOW MESSAGE AND GO TO LOGIN
        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: recharge.mensaje,
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
              if (recharge.redirigir){
                closeSession();
              }
            }
        );
      }else{
        //SHOW MESSAGE
        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: recharge.mensaje,
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
            }
        );
      }
    }
  }

  String validatorPhone(String data){
    if (data.isNotEmpty && data.length >= 10){
      _publishButtonActivar.sink.add(true);
      return null;
    }else{
      _publishButtonActivar.sink.add(false);
      return "Ingresa un número de celular y/o ICCID";
    }
  }

  Future<String> user() async{
    return await _sharedPreferencesManager.getData(SharedPreferencesManager.USER);
  }

  scanner() async{
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        "CANCELAR",
        true,
        ScanMode.BARCODE);

    textPhone.text = barcodeScanRes.compareTo("-1") == 0 ? "" : barcodeScanRes;
  }

  dispose(){
    _publishStatusLoader.close();
    _publishEnablePhone.close();
    _publishButtonActivar.close();
  }
}