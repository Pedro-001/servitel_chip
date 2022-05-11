
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/src/bloc/base_bloc.dart';
import 'package:servitel_chip/src/model/childrens_response.dart';
import 'package:servitel_chip/src/model/generic_response.dart';
import 'package:servitel_chip/src/model/item_menu_navigator.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/repositories/phone_recharges_repository.dart';
import 'package:servitel_chip/src/utils/custom_dialog.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

class TransferenceSimBloc extends BaseBloc{

  final SharedPreferencesManager _sharedPreferencesManager;
  final PhoneRechargesRepository _phoneRechargesRepository;
  final BuildContext _buildContext;

  List<Children> listChildren = [];
  bool isFilter = false;

  final _publishStatusLoader = PublishSubject<StatusLoader>();
  Stream<StatusLoader> get observerLoader => _publishStatusLoader.stream;

  final _publishChildrens = BehaviorSubject<List<Children>>();
  Stream<List<Children>> get observerChildrens => _publishChildrens.stream;

  final _publishButtonTransfer = BehaviorSubject<bool>();
  Stream<bool> get observerButtonTransfer => _publishButtonTransfer.stream;

  final TextEditingController textPhoneActivacion = TextEditingController();

  TransferenceSimBloc(
      this._buildContext,
      this._sharedPreferencesManager,
      this._phoneRechargesRepository,
      ) : super(_buildContext, _sharedPreferencesManager){
    getChildrens();
  }

  initValueHijoSubDistribuidor(){
    String phone = "";

    listChildren.forEach((element) {
      if (element.isSelected){
        phone = element.celular;
      }
    });

    return phone;
  }

  clearData(bool clearData){
    if (clearData){
      _resetSelected();
      textPhoneActivacion.clear();
    }
  }

  getChildrens() async{
    
    StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING);
    _publishStatusLoader.sink.add(statusLoader);

    String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);

    ChildrensResponse response = await _phoneRechargesRepository.childrens(firma);
    statusLoader = StatusLoader(status: STATUS.READY);
    _publishStatusLoader.sink.add(statusLoader);

    if (response.operacionExitosa){
      if (response.objeto != null && response.objeto.length > 0){
        _publishChildrens.sink.add(response.objeto);
        listChildren.addAll(response.objeto);
      }
    }else{
      CustomDialog.showDialogAsync(
          context: _buildContext,
          description: response.mensaje,
          onAccept: (dialogContext){
            Navigator.pop(dialogContext);
            if (response.redirigir){
              closeSession();
            }
          }
      );
    }
  }

  childrenSelected(Children childrenSelected){

    _resetSelected();

    listChildren.forEach((element) {
      if (element.celular.compareTo(childrenSelected.celular) == 0){
        element.isSelected = true;
      }else{
        element.isSelected = false;
      }
    });

    //_publishChildrens.sink.add(_currentListChildren);
  }

  _resetSelected(){
    listChildren.forEach((element) {
      element.isSelected = false;
    });
  }

  /*filter(){
    _resetSelected();
    isFilter = false;
    _auxListChildren.clear();
    _listChildren.forEach((element) {
      if (element.celular.contains(textPhoneSubDistribuidor.text)){
        isFilter = true;
        _auxListChildren.add(element);
      }
    });

    if (!isFilter){
      _auxListChildren.clear();
    }

    _publishChildrens.sink.add(_auxListChildren);
  }*/

  String validatorPhone(String data){
    if (data.isNotEmpty && data.length >= 10){
      _publishButtonTransfer.sink.add(true);
      return null;
    }else{
      _publishButtonTransfer.sink.add(false);
      return "Ingresa un número de celular y/o ICCID";
    }
  }

  String displayStringForOption(Children children) => children.celular;

  transfer() async {

    Children childSelected;

    listChildren.forEach((element) {
      if (element.isSelected){
        childSelected = element;
      }
    });

    if (childSelected != null){
      if (textPhoneActivacion.text.isEmpty){
        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: "Ingresa el Número celular y/o ICCID",
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
            }
        );
      }else{

        StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING);
        _publishStatusLoader.sink.add(statusLoader);

        String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);
        GenericResponse response = await _phoneRechargesRepository.transfers(firma, childSelected.id, textPhoneActivacion.text);

        statusLoader = StatusLoader(status: STATUS.READY);
        _publishStatusLoader.sink.add(statusLoader);

        CustomDialog.showDialogAsync(
            context: _buildContext,
            description: response.mensaje,
            onAccept: (dialogContext){
              Navigator.pop(dialogContext);
              //_resetSelected();
              if (response.operacionExitosa){
                textPhoneActivacion.clear();
              }

              //_publishChildrens.sink.add(_listChildren);

              if (response.redirigir){
                closeSession();
              }
            }
        );
      }
    }else{
      CustomDialog.showDialogAsync(
          context: _buildContext,
          description: "Selecciona el SubDistribuidor o no existe el ingresado",
          onAccept: (dialogContext){
            Navigator.pop(dialogContext);
          }
      );
    }
  }

  scanner() async{
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        "CANCELAR",
        true,
        ScanMode.BARCODE);

    textPhoneActivacion.text = barcodeScanRes.compareTo("-1") == 0 ? "" : barcodeScanRes;
  }

  dispose(){
    _publishChildrens.close();
    _publishStatusLoader.close();
    _publishButtonTransfer.close();
  }
}