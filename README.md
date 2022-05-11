# servitel_chip

Recarga chp

## Getting Started

This project is a starting point for a Flutter application.


##


Para correr la aplicación
modificar el archivo launch.json y configurarlo de la siguiente manera: 




 "configurations": [
        {
            "name": "servitel_chipFLUTTER",
            "request": "launch",
            "type": "dart",
            "program": "lib/environments/develop.dart"
        },
        {
            "name": "servitel_chipFLUTTER (profile mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "profile",
            "program": "lib/environments/develop.dart"
        },
        {
            "name": "servitel_chipFLUTTER (release mode)",
            "request": "launch",
            "type": "dart",
            "flutterMode": "release",
            "program": "lib/environments/develop.dart"
        },
    ]

    -fvm flutter run  -t lib/environments/develop.dart 


Para crear el apk
    -fvm flutter build apk -t lib/environments/develop.dart 

Checar keys

##

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
