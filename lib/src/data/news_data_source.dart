import 'package:http/io_client.dart';
import 'package:servitel_chip/src/model/news_response.dart';
import 'package:servitel_chip/src/repositories/news_repository.dart';

class NewsDataSource implements NewsRepository {
  final BASE_URL = "https://express.servitelconnect.com/ditec/OperacionesApp";
  final IOClient _client;

  const NewsDataSource(this._client);

  @override
  Future getNews(String firma) async {
    final response = await _client
        .get(Uri.parse("$BASE_URL?idOperacion=obtenerNoticias&firma=$firma"));

    print(response.body ?? "");
    if (response.statusCode == 200) {
      return newsResponseFromJson(response.body);
    } else {
      return newsResponseFromJson(
          '{"operacionExitosa": false,"redirigir": false,"mensaje": "Intente de nuevo mas tarde ${response.statusCode}","urlRedireccion": "","codigoError": 0}');
    }
  }
}
