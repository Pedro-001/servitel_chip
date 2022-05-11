
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/transference_sim_bloc.dart';
import 'package:servitel_chip/src/model/childrens_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/utils/custom_assets.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/progress_widget.dart';

class TransferenceSimScreen extends StatelessWidget {

  TransferenceSimScreen({Key key}) : super(key: key);

  bool clearData = false;

  @override
  Widget build(BuildContext context) {

    final TransferenceSimBloc transferenceSimBloc = Provider.of<TransferenceSimBloc>(context);
    transferenceSimBloc.clearData(clearData);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: StreamBuilder<StatusLoader>(
          initialData: StatusLoader(status: STATUS.READY, data: null),
          stream: transferenceSimBloc.observerLoader,
          builder: (context, snapshot) {
            if (snapshot.data.status == STATUS.READY){
              return ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CustomAssets.header,
                            fit: BoxFit.fitWidth
                        )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "TRANSFERIR SIMS",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: CustomColor.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Text(
                      "Seleccione un hijo o SubDistribuidor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: CustomColor.white,
                          fontSize: 15
                      ),
                    ),
                  ),
                  StreamBuilder<List<Children>>(
                      stream: transferenceSimBloc.observerChildrens,
                      initialData: transferenceSimBloc.listChildren,
                      builder: (context, snapshot){
                        if (snapshot.data != null && snapshot.data.length > 0){
                          List<Children> childrens = snapshot.data;
                          return Autocomplete<Children>(
                            optionsViewBuilder: (context, onSelected, options) => Align(
                              alignment: Alignment.topLeft,
                              child: Material(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width - 30,
                                  height: 200,
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: options
                                        .map((e) => ListTile(
                                      onTap: () => onSelected(e),
                                      title: Text(e.celular),
                                    ))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ),
                              fieldViewBuilder: (_, textFiled, focus, submitted){
                              textFiled.text = transferenceSimBloc.initValueHijoSubDistribuidor() ?? "";
                              return TextFormField(
                                keyboardType: TextInputType.number,
                                cursorColor: CustomColor.white,
                                decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColor.white
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColor.white,
                                            width: 2
                                        )
                                    ),
                                    hintStyle: TextStyle(
                                        color: CustomColor.gray
                                    ),
                                    hintText: "Teléfono hijo o SubDistribuidor",
                                    labelStyle: TextStyle(
                                        backgroundColor: CustomColor.white
                                    )
                                ),
                                controller: textFiled,
                                focusNode: focus,
                                style: const TextStyle(
                                  color: CustomColor.white,
                                ),
                              );
                              },
                              onSelected: (children) => transferenceSimBloc.childrenSelected(children),
                              displayStringForOption: transferenceSimBloc.displayStringForOption,
                              optionsBuilder: (TextEditingValue textValue){
                                if (textValue.text == ""){
                                  return const Iterable<Children>.empty();
                                }else{
                                  return childrens.where((element) => element.celular.contains(textValue.text));
                                }
                              }
                          );
                          /*return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: childrens.length,
                                itemBuilder: (context, index){
                                  Children children =  childrens[index];
                                  return InkWell(
                                    onTap: (){
                                      transferenceSimBloc.childrenSelected(children);
                                    },
                                    child: Container(
                                      height: 50,
                                      color: children.isSelected ? CustomColor.blue_touch : CustomColor.white,
                                      child: Center(
                                        child: Text(
                                          children.celular,
                                          style: TextStyle(
                                              color: CustomColor.black,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          );*/
                        }else{
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            color: CustomColor.purple,
                            child: Center(
                              child: Text(
                                "Teléfonos no disponibles",
                                style: TextStyle(
                                    color: CustomColor.white,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          );
                        }
                      }
                  ),
                  /*TextFormField(
                    controller: transferenceSimBloc.textPhoneSubDistribuidor,
                    keyboardType: TextInputType.number,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (_) => transferenceSimBloc.filter(),
                    style: TextStyle(
                        color: CustomColor.white
                    ),
                    cursorColor: CustomColor.white,
                    maxLength: 10,
                    maxLines: 1,
                    decoration: InputDecoration(
                        hintText: "Filtrar teléfono del SubDistribuidor",
                        hintStyle: TextStyle(
                            color: CustomColor.gray
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColor.white
                            )
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomColor.white,
                                width: 2
                            )
                        ),
                        counterText: '',
                        helperStyle: TextStyle(
                          color: CustomColor.white,
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: CustomColor.white,
                            )
                        )
                    ),
                  ),
                  StreamBuilder<List<Children>>(
                      stream: transferenceSimBloc.observerChildrens,
                      initialData: null,
                      builder: (context, snapshot){
                        if (snapshot.data != null && snapshot.data.length > 0){
                          List<Children> childrens = snapshot.data;
                          var height = 0.0;
                          if (childrens.length > 6){
                            height = 300;
                          }else{
                            height = childrens.length * 50.0;
                          }
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: height,
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: childrens.length,
                                itemBuilder: (context, index){
                                  Children children =  childrens[index];
                                  return InkWell(
                                    onTap: (){
                                      transferenceSimBloc.childrenSelected(children);
                                    },
                                    child: Container(
                                      height: 50,
                                      color: children.isSelected ? CustomColor.blue_touch : CustomColor.white,
                                      child: Center(
                                        child: Text(
                                          children.celular,
                                          style: TextStyle(
                                              color: CustomColor.black,
                                              fontSize: 15
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                            ),
                          );
                        }else{
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 10),
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            color: CustomColor.purple,
                            child: Center(
                              child: Text(
                                "Teléfonos no disponibles",
                                style: TextStyle(
                                    color: CustomColor.white,
                                    fontSize: 20
                                ),
                              ),
                            ),
                          );
                        }
                      }
                  ),*/
                  Container(
                    height: 200,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(
                              "Introduce teléfono o ICCID de la SIM a transferir",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomColor.white,
                                  fontSize: 15
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: StreamBuilder<bool>(
                                    initialData: true,
                                    builder: (context, snapshot) {
                                      return TextFormField(
                                        controller: transferenceSimBloc.textPhoneActivacion,
                                        keyboardType: TextInputType.number,
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        validator: transferenceSimBloc.validatorPhone,
                                        enabled: snapshot.data,
                                        style: TextStyle(
                                            color: CustomColor.white
                                        ),
                                        cursorColor: CustomColor.white,
                                        maxLength: 50,
                                        maxLines: 1,
                                        decoration: InputDecoration(
                                            hintText: "Número celular y/o ICCID",
                                            hintStyle: TextStyle(
                                                color: CustomColor.gray
                                            ),
                                            enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColor.white
                                                )
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: CustomColor.white,
                                                    width: 2
                                                )
                                            ),
                                            counterText: '',
                                            helperStyle: TextStyle(
                                              color: CustomColor.white,
                                            ),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: CustomColor.white,
                                                )
                                            )
                                        ),
                                      );
                                    }
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: InkWell(
                                    onTap: (){
                                      transferenceSimBloc.scanner();
                                    },
                                    child: Icon(Icons.fit_screen, color: Colors.white, size: 30)
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: transferenceSimBloc.observerButtonTransfer,
                    initialData: false,
                    builder: (context, snapshot) {
                      return ConstrainedBox(
                        constraints: BoxConstraints.tightFor(
                            height: 50
                        ),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty
                                  .resolveWith<Color>((states) {
                                    if (!snapshot.data){
                                      return CustomColor.gray;
                                    }
                                if (states.contains(MaterialState.pressed)){
                                  return CustomColor.blue_touch;
                                }else{
                                  return CustomColor.white;
                                }
                              })
                          ),
                          child: Text(
                            'TRANSFERIR',
                            style: TextStyle(
                                color: CustomColor.purple
                            ),
                          ),
                          onPressed: () => snapshot.data ? transferenceSimBloc.transfer() : null
                        ),
                      );
                    }
                  ),
                ],
              );
            }else{
              return ProgressWidget(
                width: 100,
                height: 100,
              );
            }
          }
        ),
      )
    );
  }
}
