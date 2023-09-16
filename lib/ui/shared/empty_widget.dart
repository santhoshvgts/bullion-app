import 'package:flutter/material.dart';

class EmptyWidget extends StatelessWidget {
  final String message;
  final String? image;

  EmptyWidget(this.message, this.image);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            image == null ? Container() : new Image.asset(
              image!,
              width: 100,
              height: 100,
            ),
            image == null ? Container() :new Padding(padding: EdgeInsets.only(top: 30)),
            Text(
              message,
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    );
  }
}
