// To parse this JSON data, do
//
//     final genericResponse = genericResponseFromJson(jsonString);

import 'dart:convert';

GenericResponse genericResponseFromJson(String str) => GenericResponse.fromJson(json.decode(str));

String genericResponseToJson(GenericResponse data) => json.encode(data.toJson());

class GenericResponse {
  GenericResponse({
    this.operacionExitosa,
    this.redirigir,
    this.mensaje,
    this.urlRedireccion,
    this.codigoError,
  });

  bool operacionExitosa;
  bool redirigir;
  String mensaje;
  String urlRedireccion;
  int codigoError;

  factory GenericResponse.fromJson(Map<String, dynamic> json) => GenericResponse(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
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
