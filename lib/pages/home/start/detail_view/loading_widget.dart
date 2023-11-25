import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

Widget StartDetailLoading() {
  return Column(
    children: [
      Row(
        children: [_loadingWidget(true)],
      ),
    ],
  );
}

Widget _loadingWidget(bool right) {
  return Expanded(
      child: Container(
    padding: const EdgeInsets.only(top: 80),
    child: SpinKitChasingDots(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
              color: Colors.black,borderRadius: BorderRadius.circular(40)),
        );
      },
    ),
  ));
}
