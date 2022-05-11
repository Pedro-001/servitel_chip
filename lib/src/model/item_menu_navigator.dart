

import 'package:flutter/material.dart';

enum INDEX_NAVIGATION{
  NOTICIAS,
  RECARGAS,
  REPORTES,
  TRANSFERENCIAS
}

class ItemMenuNavigator{

  INDEX_NAVIGATION index;
  String name;
  Icon icon;
  bool active;

  ItemMenuNavigator({@required this.index, @required this.name, @required this.icon, @required this.active});
}