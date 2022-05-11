

import 'dart:io';
import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/providers/http_provider.dart';
import 'package:servitel_chip/src/utils/shared_preferences_manager.dart';

import '../main_app.dart';

void main() async{

  final HttpClient httpClient = HttpClient();
  final IOClient ioClient = IOClient(httpClient);

  final multiProvider = MultiProvider(
    providers: [
      Provider<IOClientProvider>(
          create: (_) => IOClientProvider(ioClient)
      ),
      Provider<SharedPreferencesManager>(
        create: (_) => SharedPreferencesManager(),
      )
    ],
    child: MainApp()/*Directionality(
        textDirection: TextDirection.ltr,
        child: Banner(
          location: BannerLocation.topStart,
          message: "Dev",
          color: Colors.red.withOpacity(0.6),
          textStyle: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12.0,
              letterSpacing: 1.0,
              color: Colors.white
          ),
          child: MainApp(),
        )
    ),*/
  );

  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp();
  //FirebaseMessaging.instance.requestPermission();
  runApp(multiProvider);

}