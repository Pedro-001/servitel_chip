import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/login_bloc.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/utils/custom_assets.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/progress_widget.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen();

  @override
  Widget build(BuildContext context) {
    final LoginBloc loginBloc = Provider.of<LoginBloc>(context);

    return Scaffold(
      backgroundColor: CustomColor.purple,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: CustomAssets.background_mountain, fit: BoxFit.fill)),
        child: SafeArea(
            child: ListView(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CustomAssets.login, fit: BoxFit.cover)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Servitel GDL",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: CustomColor.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "Registro de usuario",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: CustomColor.white,
                ),
              ),
            ),
            StreamBuilder<bool>(
                initialData: true,
                stream: loginBloc.observerEnablePhone,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: loginBloc.validatorPhone,
                      enabled: snapshot.data,
                      controller: loginBloc.textPhone,
                      style: TextStyle(color: CustomColor.white),
                      cursorColor: CustomColor.white,
                      maxLength: 10,
                      maxLines: 1,
                      decoration: InputDecoration(
                          hintText: "*Ingrese número de celular (10 dígitos)",
                          hintStyle: TextStyle(color: CustomColor.gray),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: CustomColor.white)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: CustomColor.white, width: 2)),
                          counterText: '',
                          helperStyle: TextStyle(
                            color: CustomColor.white,
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                            color: CustomColor.white,
                          ))),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                "*Solo para usuarios autorizados",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColor.white,
                ),
              ),
            ),
            StreamBuilder<StatusLoader>(
                stream: loginBloc.observerLoader,
                initialData: StatusLoader(status: STATUS.READY, data: null),
                builder: (context, snapshot) {
                  StatusLoader statusLoader = snapshot.data;

                  if (statusLoader.status == STATUS.LOADING) {
                    return ProgressWidget(
                      width: 100,
                      height: 100,
                    );
                  } else if (statusLoader.data == null || !statusLoader.data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: 80),
                          StreamBuilder<bool>(
                              initialData: false,
                              stream: loginBloc.observerEnableButtonContinue,
                              builder: (context, snapshot) {
                                return ConstrainedBox(
                                  constraints:
                                      BoxConstraints.tightFor(height: 50),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        elevation: MaterialStateProperty.all(0),
                                        backgroundColor: MaterialStateProperty
                                            .resolveWith<Color>((states) {
                                          if (!snapshot.data) {
                                            return CustomColor.gray;
                                          } else {
                                            if (states.contains(
                                                MaterialState.pressed)) {
                                              return CustomColor.blue_touch;
                                            } else {
                                              return CustomColor.blue;
                                            }
                                          }
                                        })),
                                    child: Text('CONTINUAR'),
                                    onPressed: () => snapshot.data
                                        ? loginBloc.loginFaseUno()
                                        : null,
                                  ),
                                );
                              }),
                          Text(
                            "Recibirá por SMS un código de verificación",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: CustomColor.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: loginBloc.textCode,
                            style: TextStyle(color: CustomColor.white),
                            cursorColor: CustomColor.white,
                            maxLength: 10,
                            maxLines: 1,
                            decoration: InputDecoration(
                                hintText: "*Ingrese el código de verificación",
                                hintStyle: TextStyle(color: CustomColor.gray),
                                enabledBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: CustomColor.white)),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: CustomColor.white, width: 2)),
                                counterText: '',
                                helperStyle: TextStyle(
                                  color: CustomColor.white,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: CustomColor.white,
                                ))),
                          ),
                          SizedBox(height: 20),
                          ConstrainedBox(
                            constraints: BoxConstraints.tightFor(height: 50),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return CustomColor.blue_touch;
                                    } else {
                                      return CustomColor.blue;
                                    }
                                  })),
                              child: Text('ACEPTAR'),
                              onPressed: () {
                                loginBloc.loginFaseDos();
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                })
          ],
        )),
      ),
    );
  }
}
