import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/home_bloc.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/utils/custom_assets.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/progress_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen();

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = Provider.of<HomeBloc>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: StreamBuilder<StatusLoader>(
          initialData: StatusLoader(status: STATUS.READY, data: null),
          stream: homeBloc.observerLoader,
          builder: (context, snapshot) {
            if (snapshot.data.status == STATUS.READY) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 100,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CustomAssets.header,
                                  fit: BoxFit.fitWidth)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Servitel GDL",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CustomColor.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Text(
                            "Bienvenido",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CustomColor.white, fontSize: 30),
                          ),
                        ),
                        FutureBuilder<String>(
                            future: homeBloc.user(),
                            initialData: "",
                            builder: (context, snapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Text(
                                  snapshot.data ?? "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: CustomColor.white, fontSize: 25),
                                ),
                              );
                            }),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Text(
                                  "Realizar activación",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: CustomColor.white, fontSize: 15),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: StreamBuilder<bool>(
                                        stream: homeBloc.observerEnablePhone,
                                        initialData: true,
                                        builder: (context, snapshot) {
                                          return TextFormField(
                                            controller: homeBloc.textPhone,
                                            keyboardType: TextInputType.number,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: homeBloc.validatorPhone,
                                            enabled: snapshot.data,
                                            style: TextStyle(
                                                color: CustomColor.white),
                                            cursorColor: CustomColor.white,
                                            maxLength: 50,
                                            maxLines: 1,
                                            decoration: InputDecoration(
                                                hintText:
                                                    "Número celular y/o ICCID",
                                                hintStyle: TextStyle(
                                                    color: CustomColor.gray),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color:
                                                                CustomColor
                                                                    .white)),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                        borderSide: BorderSide(
                                                            color: CustomColor
                                                                .white,
                                                            width: 2)),
                                                counterText: '',
                                                helperStyle: TextStyle(
                                                  color: CustomColor.white,
                                                ),
                                                border: OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                  color: CustomColor.white,
                                                ))),
                                          );
                                        }),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: InkWell(
                                        onTap: () {
                                          homeBloc.scanner();
                                        },
                                        child: Icon(Icons.fit_screen,
                                            color: Colors.white, size: 30)),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        StreamBuilder<bool>(
                            stream: homeBloc.observerButtonActivar,
                            initialData: false,
                            builder: (context, snapshot) {
                              return ConstrainedBox(
                                constraints:
                                    BoxConstraints.tightFor(height: 50),
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          if (states.contains(
                                              MaterialState.disabled)) {
                                            return CustomColor.gray;
                                          } else if (states.contains(
                                              MaterialState.pressed)) {
                                            return CustomColor.gray;
                                          } else {
                                            return CustomColor.white;
                                          }
                                        })),
                                    child: Text(
                                      'ACTIVAR',
                                      style:
                                          TextStyle(color: CustomColor.purple),
                                    ),
                                    onPressed: () {
                                      if (snapshot.data) {
                                        homeBloc.recharge();
                                      }
                                    }),
                              );
                            }),
                      ],
                    ),
                  ),
                  /*ConstrainedBox(
                constraints: BoxConstraints.tightFor(
                    height: 50
                ),
                child: ElevatedButton(
                  style: ButtonStyle(
                      elevation: MaterialStateProperty.all(0),
                      backgroundColor: MaterialStateProperty
                          .resolveWith<Color>((states) {
                        if (states.contains(MaterialState.pressed)){
                          return CustomColor.gray;
                        }else{
                          return CustomColor.white;
                        }
                      })
                  ),
                  child: Text(
                    'CONSULTAR ACTIVACIONES',
                    style: TextStyle(
                        color: CustomColor.purple
                    ),
                  ),
                  onPressed: (){
                    Navigator.pushNamed(context, Routes.RECORD_SCREEN);
                  },
                ),
              ),*/
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    height: 100,
                    /*decoration: BoxDecoration(
                        image: DecorationImage(
                            image: CustomAssets.header,
                            fit: BoxFit.fitWidth
                        )
                    )*/
                  ),
                ],
              );
            } else {
              return ProgressWidget(
                width: 100,
                height: 100,
              );
            }
          }),
    );
  }
}
