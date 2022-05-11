
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/src/bloc/base_bloc.dart';
import 'package:servitel_chip/src/model/news_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/repositories/news_repository.dart';
import 'package:servitel_chip/src/utils/custom_dialog.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

class NewsBloc extends BaseBloc{

  final BuildContext _buildContext;
  final SharedPreferencesManager _sharedPreferencesManager;
  final NewsRepository _newsRepository;

  final _statusLoader = BehaviorSubject<StatusLoader>();
  Stream<StatusLoader> get observerLoader => _statusLoader.stream;

  NewsBloc(
      this._buildContext,
      this._sharedPreferencesManager,
      this._newsRepository) : super(_buildContext, _sharedPreferencesManager){
    getNews();
  }

  getNews() async {
    StatusLoader statusLoader = StatusLoader(status: STATUS.LOADING);
    _statusLoader.sink.add(statusLoader);

    String firma = await _sharedPreferencesManager.getData(SharedPreferencesManager.FIRMA);
    NewsResponse response = await _newsRepository.getNews(firma);

    statusLoader = StatusLoader(status: STATUS.READY);

    if (response.operacionExitosa){
      if (response.objeto != null){
        statusLoader.data = response.objeto;
        _statusLoader.sink.add(statusLoader);
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

  dispose(){
    _statusLoader.close();
  }
}