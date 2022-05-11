// To parse this JSON data, do
//
//     final loginFaseUno = loginFaseUnoFromJson(jsonString);

import 'dart:convert';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    this.operacionExitosa,
    this.redirigir,
    this.mensaje,
    this.urlRedireccion,
    this.codigoError,
    this.credentials
  });

  bool operacionExitosa;
  bool redirigir;
  String mensaje;
  String urlRedireccion;
  int codigoError;
  Credentials credentials;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
    credentials: json.containsKey('objeto') ? Credentials.fromJson(json["objeto"]) : null,
    urlRedireccion: json["urlRedireccion"],
    codigoError: json["codigoError"],
  );

  Map<String, dynamic> toJson() => {
    "operacionExitosa": operacionExitosa,
    "redirigir": redirigir,
    "mensaje": mensaje,
    "urlRedireccion": urlRedireccion,
    "codigoError": codigoError,
  };
}

class Credentials {
  Credentials({
    this.usuario,
    this.firma,
    this.padre
  });

  String usuario;
  String firma;
  bool padre;

  factory Credentials.fromJson(Map<String, dynamic> json) => Credentials(
    usuario: json["usuario"],
    firma: json["firma"],
    padre: json["padre"]
  );

  Map<String, dynamic> toJson() => {
    "usuario": usuario,
    "firma": firma,
    "padre": padre
  };
}

