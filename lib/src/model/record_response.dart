// To parse this JSON data, do
//
//     final recordResponse = recordResponseFromJson(jsonString);

import 'dart:convert';

RecordResponse recordResponseFromJson(String str) => RecordResponse.fromJson(json.decode(str));

String recordResponseToJson(RecordResponse data) => json.encode(data.toJson());

class RecordResponse {
  RecordResponse({
    this.operacionExitosa,
    this.redirigir,
    this.mensaje,
    this.records,
    this.urlRedireccion,
    this.codigoError,
  });

  bool operacionExitosa;
  bool redirigir;
  String mensaje;
  List<Record> records;
  String urlRedireccion;
  int codigoError;

  factory RecordResponse.fromJson(Map<String, dynamic> json) => RecordResponse(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
    records: json.containsKey("objeto") ? List<Record>.from(json["objeto"].map((x) => Record.fromJson(x))) : null,
    urlRedireccion: json["urlRedireccion"],
    codigoError: json["codigoError"],
  );

  Map<String, dynamic> toJson() => {
    "operacionExitosa": operacionExitosa,
    "redirigir": redirigir,
    "mensaje": mensaje,
    "objeto": List<dynamic>.from(records.map((x) => x.toJson())),
    "urlRedireccion": urlRedireccion,
    "codigoError": codigoError,
  };
}

class Record {
  Record({
    this.linea,
    this.monto,
    this.fechaVenta,
    this.topupid,
    this.telefonoOrigen,
    this.recarga,
    this.id,
  });

  String linea;
  String monto;
  DateTime fechaVenta;
  String topupid;
  String telefonoOrigen;
  String recarga;
  String id;

  factory Record.fromJson(Map<String, dynamic> json) => Record(
    linea: json["linea"],
    monto: json["monto"],
    fechaVenta: DateTime.parse(json["fechaVenta"]),
    topupid: json["topupid"],
    telefonoOrigen: json["telefonoOrigen"],
    recarga: json["recarga"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "linea": linea,
    "monto": monto,
    "fechaVenta": fechaVenta.toIso8601String(),
    "topupid": topupid,
    "telefonoOrigen": telefonoOrigen,
    "recarga": recarga,
    "id": id,
  };
}
