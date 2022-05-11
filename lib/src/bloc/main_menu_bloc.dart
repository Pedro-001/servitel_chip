

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:servitel_chip/src/model/item_menu_navigator.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

import 'base_bloc.dart';

class MainMenuBloc extends BaseBloc {

  List<ItemMenuNavigator> itemList = [
    ItemMenuNavigator(
        index: INDEX_NAVIGATION.NOTICIAS,
        name: "Noticias",
        icon: Icon(Icons.ballot, color: CustomColor.purple),
        active: true
    ),
    ItemMenuNavigator(
        index: INDEX_NAVIGATION.RECARGAS,
        name: "Activaciones",
        icon: Icon(Icons.autorenew, color: CustomColor.gray),
        active: false
    ),
    ItemMenuNavigator(
        index: INDEX_NAVIGATION.REPORTES,
        name: "Reportes",
        icon: Icon(Icons.assessment_outlined, color: CustomColor.gray),
        active: false
    ),
  ];

  final _publishScreens = PublishSubject<INDEX_NAVIGATION>();
  Stream<INDEX_NAVIGATION> get observerScreens => _publishScreens.stream;

  final _publishMenuItems = PublishSubject<List<ItemMenuNavigator>>();
  Stream<List<ItemMenuNavigator>> get observerItems => _publishMenuItems.stream;

  final SharedPreferencesManager _sharedPreferences;
  final _buildContext;

  MainMenuBloc(
      this._buildContext,
      this._sharedPreferences
      ) : super(_buildContext, _sharedPreferences){
    refreshBottomNavigator();
  }

  refreshBottomNavigator() async{

    bool padre = await _sharedPreferences.getData(SharedPreferencesManager.PADRE) ?? false;

    if (padre){
      itemList.add(
          ItemMenuNavigator(
              index: INDEX_NAVIGATION.TRANSFERENCIAS,
              name: "Transferencias",
              icon: Icon(Icons.add_to_home_screen, color: CustomColor.gray),
              active: false
          )
      );
      _publishMenuItems.sink.add(itemList);
    }
  }

  changeMenu(INDEX_NAVIGATION index){

    bool reload = false;

    itemList.forEach((element) {
      if (element.index == index){
        if (!element.active){
          element.active = true;
          element.icon = Icon(element.icon.icon, color: CustomColor.purple);
          reload = true;
        }
      }else{
        element.active = false;
        element.icon = Icon(element.icon.icon, color: CustomColor.gray);
      }
    });

    if (reload){
      _publishMenuItems.sink.add(itemList);
      _publishScreens.sink.add(index);
    }

  }

  dispose(){
    _publishMenuItems.close();
    _publishScreens.close();
  }
}