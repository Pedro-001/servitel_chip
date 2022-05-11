// To parse this JSON data, do
//
//     final rechargeResponse = rechargeResponseFromJson(jsonString);

import 'dart:convert';

RechargeResponse rechargeResponseFromJson(String str) => RechargeResponse.fromJson(json.decode(str));

String rechargeResponseToJson(RechargeResponse data) => json.encode(data.toJson());

class RechargeResponse {
  RechargeResponse({
    this.operacionExitosa,
    this.redirigir,
    this.mensaje,
    this.urlRedireccion,
    this.codigoError,
    this.objeto,
  });

  bool operacionExitosa;
  bool redirigir;
  String mensaje;
  String urlRedireccion;
  int codigoError;
  String objeto;

  factory RechargeResponse.fromJson(Map<String, dynamic> json) => RechargeResponse(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
    urlRedireccion: json["urlRedireccion"],
    codigoError: json["codigoError"],
    objeto: json.containsKey("objeto") ? json["objeto"] : null,
  );

  Map<String, dynamic> toJson() => {
    "operacionExitosa": operacionExitosa,
    "redirigir": redirigir,
    "mensaje": mensaje,
    "urlRedireccion": urlRedireccion,
    "codigoError": codigoError,
    "objeto": objeto,
  };
}
