
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:servitel_chip/src/utils/custom_color.dart';

enum DialogAction {CANCEL, ACCEPT}

class CustomDialog{
  static Future<T> showDialogAsync<T>({
    @required BuildContext context,
    String title,
    String acceptButtonTitle,
    String cancelButtonTitle,
    String alertIcon,
    @required String description,
    @required Function(BuildContext) onAccept,
    Function(BuildContext) onCancel
  }){
    return showDialog<T>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext){
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            child: Container(
              width: 300,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        height: 1.42,
                        fontSize: 16.0,
                        letterSpacing: -0.15
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                      top: 8.0,
                      left: 16.0,
                      right: 16.0,
                      bottom: 24.0
                    ),
                    child: onCancel != null
                    ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            child: Material(
                              type: MaterialType.transparency,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(26.0),
                                  onTap: () => onCancel(dialogContext),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Text(
                                      cancelButtonTitle != null
                                          ? cancelButtonTitle : "Cancelar",
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: CustomColor.purple,
                                        height: 1.2,
                                        fontSize: 18.0
                                      ),
                                    ),
                                  ),
                                ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 8.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(26.0)
                            ),
                            child: Material(
                              type: MaterialType.transparency,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(26.0),
                                onTap: () => onAccept(dialogContext),
                                child: Padding(
                                  padding: const EdgeInsets.all(
                                    12.0
                                  ),
                                  child: Text(
                                    acceptButtonTitle != null
                                        ? acceptButtonTitle : "Aceptar",
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.purple,
                                      height: 1.2,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ) : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.0)
                      ),
                      child: Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(
                            26.0
                          ),
                          onTap: () => onAccept(dialogContext),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              acceptButtonTitle != null ? acceptButtonTitle : "Aceptar",
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: CustomColor.purple,
                                height: 1.2,
                                fontSize: 18.0
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
    );
  }
}