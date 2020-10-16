import 'package:flutter/material.dart';

class Loading {
  static final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  static Future showLoadingDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return new WillPopScope(
          onWillPop: () async => false,
          child: SimpleDialog(
            key: _keyLoader,
            backgroundColor: Colors.black54,
            children: <Widget>[
              Center(
                child: Column(
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Veuillez patienter....",
                      style: TextStyle(color: Colors.blueAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static closeLoadingDialog() {
    Navigator.of(_keyLoader.currentContext, rootNavigator: true).pop();
  }
}
