import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';

class ConnectionStartPage extends StatefulWidget {
  const ConnectionStartPage({Key? key}) : super(key: key);

  @override
  State<ConnectionStartPage> createState() => _ConnectionStartPageState();
}

class _ConnectionStartPageState extends State<ConnectionStartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("附近".tr, style: TextStyle(fontSize: 20)),
      ),
      body: Center(
          child: StartDetailPage(
            type: ApiType.loction,
            parameter: '',
            lasting:false,
          )),
    );
  }
}
