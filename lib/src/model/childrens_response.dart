// To parse this JSON data, do
//
//     final childrensResponse = childrensResponseFromJson(jsonString);

import 'dart:convert';

ChildrensResponse childrensResponseFromJson(String str) => ChildrensResponse.fromJson(json.decode(str));

String childrensResponseToJson(ChildrensResponse data) => json.encode(data.toJson());

class ChildrensResponse {
  ChildrensResponse({
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
  List<Children> objeto;
  String urlRedireccion;
  int codigoError;

  factory ChildrensResponse.fromJson(Map<String, dynamic> json) => ChildrensResponse(
    operacionExitosa: json["operacionExitosa"],
    redirigir: json["redirigir"],
    mensaje: json["mensaje"],
    objeto: json.containsKey("objeto") ? List<Children>.from(json["objeto"].map((x) => Children.fromJson(x))) : null,
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

class Children {
  Children({
    this.celular,
    this.id,
    this.isSelected = false
  });

  String celular;
  String id;
  bool isSelected;

  factory Children.fromJson(Map<String, dynamic> json) => Children(
    celular: json["celular"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "celular": celular,
    "id": id,
  };
}
