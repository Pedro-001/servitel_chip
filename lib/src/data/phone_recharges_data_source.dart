import 'package:http/io_client.dart';
import 'package:servitel_chip/src/model/childrens_response.dart';
import 'package:servitel_chip/src/model/generic_response.dart';
import 'package:servitel_chip/src/model/recharge_response.dart';
import 'package:servitel_chip/src/model/record_response.dart';

class PhoneRechargesDataSource {
  final BASE_URL = "https://express.servitelconnect.com/ditec/OperacionesApp";
  final IOClient _client;

  const PhoneRechargesDataSource(this._client);

  Future recharge(
      String phone, String latitud, String longitud, String firma) async {
    final response = await _client.get(Uri.parse(
        "$BASE_URL?idOperacion=recargar&telefono=$phone&firma=$firma&gpsLatitud=$latitud&gpsLongitud=$longitud"));

    print(response.body ?? "");
    if (response.statusCode == 200) {
      return rechargeResponseFromJson(response.body);
    } else {
      return rechargeResponseFromJson(
          '{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }

  Future record(String startDate, String endDate, String firma) async {
    final response = await _client.get(Uri.parse(
        "$BASE_URL?idOperacion=reporteActivaciones&fechaInicio=$startDate&fechaFin=$endDate&firma=$firma"));

    print(response.body ?? "");

    if (response.statusCode == 200) {
      return recordResponseFromJson(response.body);
    } else {
      return recordResponseFromJson(
          '{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }

  Future childrens(String firma) async {
    final response = await _client
        .get(Uri.parse("$BASE_URL?idOperacion=obtenerHijos&firma=$firma"));

    print(response.body ?? "");

    if (response.statusCode == 200) {
      return childrensResponseFromJson(response.body);
    } else {
      return childrensResponseFromJson(
          '{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }

  Future transfers(String idHijo, String lineaTransferir, String firma) async {
    final response = await _client.get(Uri.parse(
        "$BASE_URL?idOperacion=transferirSim&firma=$firma&idHijo=$idHijo&lineaTransferir=$lineaTransferir"));

    print(response.body ?? "");

    if (response.statusCode == 200) {
      return genericResponseFromJson(response.body);
    } else {
      return genericResponseFromJson(
          '{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }
}
