
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/news_bloc.dart';
import 'package:servitel_chip/src/model/news_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/progress_widget.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final NewsBloc newsBloc = Provider.of<NewsBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<StatusLoader>(
          initialData: StatusLoader(status: STATUS.READY, data: null),
          stream: newsBloc.observerLoader,
        builder: (context, snapshot){
            StatusLoader statusLoader = snapshot.data;
            if (statusLoader.status == STATUS.LOADING){
              return ProgressWidget(
                width: 100,
                height: 100,
              );
            }else{
              List<Notice> noticias = statusLoader.data;
              if (noticias != null && noticias.length > 0){
                return RefreshIndicator(
                  onRefresh: (){
                    return newsBloc.getNews();
                  },
                  child: ListView.builder(
                      itemCount: noticias.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: (contextList, index){
                        Notice notice = noticias[index];
                        return Container(
                          color: CustomColor.white,
                          margin: EdgeInsets.symmetric(vertical: 5),
                          height: 80,
                          width: MediaQuery.of(contextList).size.width,
                          child: ListTile(
                            onTap: (){
                              showDialog(context: context, builder: (context){
                                return AlertDialog(
                                  title: Text('Mensaje'),
                                  content: Html(
                                    data: notice.contenido,
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                            'Cerrar',
                                          style: TextStyle(
                                            color: CustomColor.purple
                                          ),
                                        )
                                    ),
                                  ],
                                );
                              });
                            },
                            title: Text(
                              notice.fecha.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  color: CustomColor.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal
                              ),
                            ),
                            subtitle: Text(
                              notice.titulo,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: CustomColor.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        );
                      }
                  ),
                );
              }else{
                return Container(
                  child: Center(
                    child: Text(
                      "No hay noticias disponibles",
                      style: TextStyle(
                          color: CustomColor.white,
                          fontSize: 20
                      ),
                    ),
                  ),
                );
              }
            }
        }
      ),
    );
  }
}
