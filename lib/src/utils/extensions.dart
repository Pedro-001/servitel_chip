
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/home_bloc.dart';
import 'package:servitel_chip/src/bloc/login_bloc.dart';
import 'package:servitel_chip/src/bloc/main_menu_bloc.dart';
import 'package:servitel_chip/src/bloc/news_bloc.dart';
import 'package:servitel_chip/src/bloc/record_bloc.dart';
import 'package:servitel_chip/src/bloc/transference_sim_bloc.dart';
import 'package:servitel_chip/src/data/login_data_source.dart';
import 'package:servitel_chip/src/data/news_data_source.dart';
import 'package:servitel_chip/src/data/phone_recharges_data_source.dart';
import 'package:servitel_chip/src/model/item_menu_navigator.dart';
import 'package:servitel_chip/src/providers/http_provider.dart';
import 'package:servitel_chip/src/repositories/phone_recharges_repository.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

PageRouteBuilder fadeTransition({
  @required RouteSettings settings,
  @required RoutePageBuilder pageBuilder,
  bool opaque = true,
}) => PageRouteBuilder(
  opaque: opaque,
  pageBuilder: pageBuilder,
  settings: settings,
  transitionsBuilder: (_, animation, __, child){
    return FadeTransition(opacity: animation, child: child);
  }
);

LoginBloc generateLoginBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;
  final _loginDataSource = LoginDataSource(_iOClient);

  return LoginBloc(
    routeContext,
    _sharedPreferencesManager,
    _loginDataSource
  );
}

HomeBloc generateHomeBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;
  final _phoneRechargesDataSource = PhoneRechargesDataSource(_iOClient);
  final _phoneRehcargesRepository = PhoneRechargesRepository(_phoneRechargesDataSource);

  return HomeBloc(
      routeContext,
      _sharedPreferencesManager,
      _phoneRehcargesRepository
  );
}

RecordBloc generateRecordBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;
  final _phoneRechargesDataSource = PhoneRechargesDataSource(_iOClient);
  final _phoneRechargesRepository = PhoneRechargesRepository(_phoneRechargesDataSource);

  return RecordBloc(
      routeContext,
      _sharedPreferencesManager,
      _phoneRechargesRepository
  );

}

MainMenuBloc generateMenuBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;

  return MainMenuBloc(
    routeContext,
    _sharedPreferencesManager
  );

}

NewsBloc generateNewsBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;
  final _newsDataSource = NewsDataSource(_iOClient);

  return NewsBloc(
      routeContext,
      _sharedPreferencesManager,
      _newsDataSource
  );

}

TransferenceSimBloc generateTransferenceSimBloc(BuildContext routeContext){

  final _sharedPreferencesManager = Provider.of<SharedPreferencesManager>(routeContext, listen: false);
  final _iOClient = Provider.of<IOClientProvider>(routeContext, listen: false).iOClient;
  final _phoneRechargesDataSource = PhoneRechargesDataSource(_iOClient);
  final _phoneRechargesRepository = PhoneRechargesRepository(_phoneRechargesDataSource);

  return TransferenceSimBloc(
      routeContext,
      _sharedPreferencesManager,
      _phoneRechargesRepository
  );

}