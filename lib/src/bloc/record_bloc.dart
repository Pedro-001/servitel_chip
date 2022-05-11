
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/src/bloc/base_bloc.dart';
import 'package:servitel_chip/src/model/record_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/repositories/phone_recharges_repository.dart';
import 'package:servitel_chip/src/utils/custom_dialog.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

class RecordBloc extends BaseBloc{

  String endDateData = "";
  String startDateData = "";
  List<Record> records;

  TextEditingController filterController = TextEditingController();

  final SharedPreferencesManager _sharedPreferencesManager;
  final PhoneRechargesRepository _phoneRechargesRepository;

  final _publishStartDate = PublishSubject<String>();
  Stream<String> get observerStartDate => _publishStartDate.stream;

  final _publishEndDate = PublishSubject<String>();
  Stream<String> get observerEndDate => _publishEndDate.stream;

  final _publishRecord = PublishSubject<List<Record>>();
  Stream<List<Record>> get observerRecord => _publishRecord.stream;

  final _publishStatusLoader = PublishSubject<StatusLoader>();
  Stream<StatusLoader> get observerLoader => _publishStatusLoader.stream;

  final _publishShowFilter = PublishSubject<bool>();
  Stream<bool> get observerShowFilter => _publishShowFilter.stream;

  BuildContext _buildContext;

  RecordBloc(
      this._buildContext,
      this._sharedPreferencesManager,
      this._phoneRechargesRepository
      ) : super(_buildContext, _sharedPreferencesManager);


  search() async{
    StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING);

    _publishStatusLoader.sink.add(statusLoader);

    String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);

    RecordResponse response = await _phoneRechargesRepository.record(startDateData, endDateData, firma);

    statusLoader.status = STATUS.READY;
    _publishStatusLoader.sink.add(statusLoader);
    if (response.operacionExitosa){
      records = response.records;
      _publishRecord.sink.add(response.records);
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

  startDate(DateTime date){
    startDateData = _formateDate(date);
    _publishStartDate.sink.add(startDateData);
  }

  endDate(DateTime date){
    endDateData = _formateDate(date);
    _publishEndDate.sink.add(endDateData);
  }

  String currentDate(){
    DateTime now = DateTime.now();
    return _formateDate(now);
  }

  String _formateDate(DateTime date){
    return DateFormat('yyyy-MM-dd').format(date);
  }

  filterData(){
    List<Record> aux = [];

    if (filterController.text.isNotEmpty){
      if (records.isNotEmpty){
        records.forEach((element) {
          if (element.linea.contains(filterController.text)){
            aux.add(element);
          }
        });
      }
      _publishRecord.sink.add(aux);
    }else{
      _publishRecord.sink.add(records);
    }
  }

  String validatorPhone(String data){
    if (data.isNotEmpty){
      //_publishEnablePhone.sink.add(false);
      return null;
    }else{
      return "Ingresa un número de celular y/o ICCID";
    }
  }

  showHideFilter(bool status){
    _publishShowFilter.sink.add(!status);
  }


  dispose(){
    _publishEndDate.close();
    _publishStartDate.close();
    _publishRecord.close();
    _publishStatusLoader.close();
    _publishShowFilter.close();
  }


}