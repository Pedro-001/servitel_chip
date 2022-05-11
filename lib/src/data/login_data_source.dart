
import 'package:http/io_client.dart';
import 'package:servitel_chip/src/model/response.dart';
import 'package:servitel_chip/src/repositories/login_repository.dart';

class LoginDataSource implements LoginRepository{

  final BASE_URL = "https://express.servitelconnect.com/recargachip2022/OperacionesApp";
  final IOClient _client;

  const LoginDataSource(this._client);

  @override
  Future loginFaseUno(String phone, String token) async {
    final response = await _client.get(Uri.parse(
        "$BASE_URL?idOperacion=logInF1&linea=$phone&token=$token"
    ));
    print(response.body??"");

    if (response.statusCode == 200){
      return responseFromJson(response.body);
    }else{
      return responseFromJson('{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }

  @override
  Future loginFaseDos(String code, String token) async {
    final response = await _client.get(Uri.parse(
        "$BASE_URL?idOperacion=logInF2&codigo=$code&token=$token"
    ));
    print(response.body??"");

    if (response.statusCode == 200){
      return responseFromJson(response.body);
    }else{
      return responseFromJson('{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }
}