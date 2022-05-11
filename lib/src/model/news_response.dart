// To parse this JSON data, do
//
//     final newsResponse = newsResponseFromJson(jsonString);

import 'dart:convert';

NewsResponse newsResponseFromJson(String str) => NewsResponse.fromJson(json.decode(str));

String newsResponseToJson(NewsResponse data) => json.encode(data.toJson());

class NewsResponse {
  NewsResponse({
    this.operacionExitosa,
    this.redirigir,
    this.mensaje,
    this.objeto,
    this.urlRedireccion,
    this.codigoError,
  });

  bool operacionExitosa;
  bool redirigir;
  String mensaje;
  List<Notice> objeto;
  String urlRedireccion;
  int codigoError;

  factory NewsResponse.fromJson(Map<String, dynamic> json) => NewsResponse(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
    objeto: json.containsKey("objeto") ? List<Notice>.from(json["objeto"].map((x) => Notice.fromJson(x))) : null,
    urlRedireccion: json["urlRedireccion"],
    codigoError: json["codigoError"],
  );

  Map<String, dynamic> toJson() => {
    "operacionExitosa": operacionExitosa,
    "redirigir": redirigir,
    "mensaje": mensaje,
    "objeto": List<dynamic>.from(objeto.map((x) => x.toJson())),
    "urlRedireccion": urlRedireccion,
    "codigoError": codigoError,
  };
}

class Notice {
  Notice({
    this.titulo,
    this.contenido,
    this.fecha,
    this.id,
  });

  String titulo;
  String contenido;
  DateTime fecha;
  String id;

  factory Notice.fromJson(Map<String, dynamic> json) => Notice(
    titulo: json["titulo"],
    contenido: json["contenido"],
    fecha: DateTime.parse(json["fecha"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "titulo": titulo,
    "contenido": contenido,
    "fecha": fecha.toIso8601String(),
    "id": id,
  };
}
