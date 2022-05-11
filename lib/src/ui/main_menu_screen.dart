
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/home_bloc.dart';
import 'package:servitel_chip/src/bloc/main_menu_bloc.dart';
import 'package:servitel_chip/src/bloc/news_bloc.dart';
import 'package:servitel_chip/src/bloc/record_bloc.dart';
import 'package:servitel_chip/src/bloc/transference_sim_bloc.dart';
import 'package:servitel_chip/src/model/item_menu_navigator.dart';
import 'package:servitel_chip/src/ui/news_screen.dart';
import 'package:servitel_chip/src/ui/record_screen.dart';
import 'package:servitel_chip/src/ui/transference_sim_screen.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/extensions.dart';

import 'home_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<MainMenuScreen> {

  static const homeScreen = HomeScreen();
  static const recordScreen = RecordScreen();
  static const newsScreen = NewsScreen();
  TransferenceSimScreen transferenceSimScreen = TransferenceSimScreen();
  bool transferenceSimScreenCleanData = false;

  @override
  Widget build(BuildContext context) {

    final MainMenuBloc homeBloc = Provider.of<MainMenuBloc>(context);

    return MultiProvider(
      providers: [
        Provider<HomeBloc>(
          create: (_) => generateHomeBloc(context),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<RecordBloc>(
          create: (_) => generateRecordBloc(context),
          dispose: (_, bloc) => bloc.dispose(),
        ),
        Provider<NewsBloc>(
          create: (_) => generateNewsBloc(context),
          dispose: (_ , bloc) => bloc.dispose,
        ),
        Provider<TransferenceSimBloc>(
          create: (_) => generateTransferenceSimBloc(context),
          dispose: (_ , bloc) => bloc.dispose,
        )
      ],
      child: Scaffold(
        backgroundColor: CustomColor.purple,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  child: StreamBuilder<INDEX_NAVIGATION>(
                      stream: homeBloc.observerScreens,
                      initialData: INDEX_NAVIGATION.NOTICIAS,
                      builder: (context, snapshot){

                        switch(snapshot.data){

                          case INDEX_NAVIGATION.NOTICIAS:
                            transferenceSimScreenCleanData = true;
                            return newsScreen;
                            break;
                          case INDEX_NAVIGATION.RECARGAS:
                            transferenceSimScreenCleanData = true;
                            return homeScreen;
                            break;
                          case INDEX_NAVIGATION.REPORTES:
                            transferenceSimScreenCleanData = true;
                            return recordScreen;
                            break;
                          case INDEX_NAVIGATION.TRANSFERENCIAS:
                            transferenceSimScreen.clearData = transferenceSimScreenCleanData;
                            transferenceSimScreenCleanData = false;
                            return transferenceSimScreen;
                            break;

                          default:
                            return Container(color: Colors.red);
                            break;
                        }
                      }
                  ),
                ),
              ),
              Container(
                color: CustomColor.white,
                width: MediaQuery.of(context).size.width,
                height: 70,
                child: StreamBuilder<List<ItemMenuNavigator>>(
                    stream: homeBloc.observerItems,
                    initialData: homeBloc.itemList,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (_, index){
                          ItemMenuNavigator item = snapshot.data[index];
                          return InkWell(
                            onTap: () => homeBloc.changeMenu(item.index),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width/snapshot.data.length,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  item.icon,
                                  Text(item.name,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: item.active ? CustomColor.purple : CustomColor.gray,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}
