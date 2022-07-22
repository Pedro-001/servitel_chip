import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:servitel_chip/src/bloc/record_bloc.dart';
import 'package:servitel_chip/src/model/record_response.dart';
import 'package:servitel_chip/src/model/status_loader.dart';
import 'package:servitel_chip/src/utils/custom_assets.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';
import 'package:servitel_chip/src/utils/progress_widget.dart';

class RecordScreen extends StatelessWidget {
  const RecordScreen();

  @override
  Widget build(BuildContext context) {
    final RecordBloc recordBloc = Provider.of<RecordBloc>(context);
    recordBloc.startDate(DateTime.now());
    recordBloc.endDate(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: EdgeInsets.only(top: 20, left: 15, right: 15),
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: CustomAssets.header, fit: BoxFit.fitWidth)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 15, right: 15),
              child: Text(
                "Reportes",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColor.white,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: Text(
                "Seleccione la fecha inicial",
                textAlign: TextAlign.left,
                style: TextStyle(color: CustomColor.white, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: InkWell(
                onTap: () async {
                  DateTime date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: DateTime(DateTime.now().year + 5),
                    initialDate: DateTime.now(),
                    locale: Locale('es', "ES"),
                    initialEntryMode: DatePickerEntryMode.calendar,
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: CustomColor.white,
                            onPrimary: CustomColor.black,
                            surface: CustomColor.purple,
                            onSurface: CustomColor.white,
                          ),
                          dialogBackgroundColor: CustomColor.purple,
                        ),
                        child: child,
                      );
                    },
                  );

                  recordBloc.startDate(date);
                },
                child: StreamBuilder<String>(
                    stream: recordBloc.observerStartDate,
                    initialData: recordBloc.currentDate(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data,
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: CustomColor.white, fontSize: 15),
                      );
                    }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: Text(
                "Seleccione la fecha final",
                textAlign: TextAlign.left,
                style: TextStyle(color: CustomColor.white, fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
              child: InkWell(
                onTap: () async {
                  DateTime date = await showDatePicker(
                    context: context,
                    locale: Locale('es', "ES"),
                    firstDate: DateTime(DateTime.now().year - 5),
                    lastDate: DateTime(DateTime.now().year + 5),
                    initialDate: DateTime.now(),
                    initialEntryMode: DatePickerEntryMode.calendar,
                    builder: (BuildContext context, Widget child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: ColorScheme.dark(
                            primary: CustomColor.white,
                            onPrimary: CustomColor.black,
                            surface: CustomColor.purple,
                            onSurface: CustomColor.white,
                          ),
                          dialogBackgroundColor: CustomColor.purple,
                        ),
                        child: child,
                      );
                    },
                  );
                  recordBloc.endDate(date);
                },
                child: StreamBuilder<String>(
                    stream: recordBloc.observerEndDate,
                    initialData: recordBloc.currentDate(),
                    builder: (context, snapshot) {
                      return Text(
                        snapshot.data,
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: CustomColor.white, fontSize: 15),
                      );
                    }),
              ),
            ),
            StreamBuilder<StatusLoader>(
                stream: recordBloc.observerLoader,
                initialData: StatusLoader(status: STATUS.READY, data: null),
                builder: (context, snapshot) {
                  if (snapshot.data.status == STATUS.READY) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10, top: 20, left: 15, right: 15),
                      child: ConstrainedBox(
                        constraints: BoxConstraints.tightFor(height: 50),
                        child: ElevatedButton(
                          style: ButtonStyle(
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return CustomColor.gray;
                                } else {
                                  return CustomColor.white;
                                }
                              })),
                          child: Text(
                            'CONSULTAR',
                            style: TextStyle(color: CustomColor.purple),
                          ),
                          onPressed: () {
                            recordBloc.search();
                          },
                        ),
                      ),
                    );
                  } else {
                    return ProgressWidget(
                      width: 100,
                      height: 100,
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 10, top: 15, left: 15, right: 15),
              child: StreamBuilder<bool>(
                  stream: recordBloc.observerShowFilter,
                  initialData: false,
                  builder: (context, snapshot) {
                    return InkWell(
                      child: Text(
                        !snapshot.data ? "MOSTRAR FILTRO" : "OCULTAR FILTRO",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                            color: CustomColor.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        recordBloc.showHideFilter(snapshot.data);
                      },
                    );
                  }),
            ),
            StreamBuilder<bool>(
              stream: recordBloc.observerShowFilter,
              initialData: false,
              builder: (context, snapshot) {
                return Visibility(
                  visible: snapshot.data,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: recordBloc.filterController,
                          keyboardType: TextInputType.number,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          enabled: snapshot.data,
                          style: TextStyle(color: CustomColor.white),
                          cursorColor: CustomColor.white,
                          maxLength: 10,
                          maxLines: 1,
                          decoration: InputDecoration(
                              hintText: "Ingrese número de celular",
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
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 20),
                          child: ConstrainedBox(
                            constraints: BoxConstraints.tightFor(height: 50),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith<Color>(
                                          (states) {
                                    if (states
                                        .contains(MaterialState.pressed)) {
                                      return CustomColor.gray;
                                    } else {
                                      return CustomColor.white;
                                    }
                                  })),
                              child: Text(
                                'APLICAR FILTRO',
                                style: TextStyle(color: CustomColor.purple),
                              ),
                              onPressed: () {
                                recordBloc.filterData();
                              },
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20),
                color: CustomColor.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      "Celular",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: CustomColor.purple,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Monto",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: CustomColor.purple,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Fecha",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: CustomColor.purple,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Folio",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          color: CustomColor.purple,
                          fontSize: 15,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<List<Record>>(
                    stream: recordBloc.observerRecord,
                    initialData: null,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Record> records = snapshot.data;

                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: records.length,
                            itemBuilder: (context, index) {
                              Record record = records[index];

                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    record.linea,
                                    style: TextStyle(
                                        color: CustomColor.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    record.monto,
                                    style: TextStyle(
                                        color: CustomColor.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    DateFormat('yyyy-MM-dd HH:mm:ss')
                                        .format(record.fechaVenta),
                                    style: TextStyle(
                                        color: CustomColor.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    record.id,
                                    style: TextStyle(
                                        color: CustomColor.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            });
                      } else {
                        return Container();
                      }
                    }),
              )
            ],
          ),
        )
      ],
    );
  }
}
