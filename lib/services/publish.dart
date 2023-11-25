import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../ulits/base_provider.dart';

class PublishProvider extends BaseProvider {
  Future<int> push(
      {required String title,
        required String text,
        required String goodsId,
        required String thumbnail,
        required int type,
        String imagesPath = '',
        String? videoPath = '',
        String? recordingPath = '',
        int? channel = 0,
        int? recordingTime = 0,
        double? lat,
        double? lng,String? placeId,
        required double attaImageScale,
        topics
      }) async {
    Response res = await post('works/add', {
      'title': title,
      'text': text,
      'goodsId': goodsId,
      'placeId': placeId,
      'thumbnail': thumbnail,
      'type': type,
      'imagesPath': imagesPath,
      'videoPath': videoPath,
      'recordingPath': recordingPath,
      'recordingTime':recordingTime,
      'lat': lat,
      'lng': lng,
      'attaImageScale': attaImageScale,
      'channel': channel,
      'topics':topics,
    });
    // await Future.delayed(Duration(milliseconds: 30000),(){});
    print('接口返回');
    print(res.body);
    print(res.bodyString);
    if (res.statusCode != 200) {
      if(res.statusCode! >= 500){
        Fluttertoast.showToast(
            msg: '服务器出差了，请稍后再试'.tr,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        return 0;
      }
      var message = jsonDecode(res.bodyString!);
      if (message['message'] != null) {
        Fluttertoast.showToast(
            msg: message['message'],
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
      return 0;
    } else {

      var message = jsonDecode(res.bodyString!);
      if (message['id'] != null) {
        return int.parse(message['id']);
      }
    }
    return 0;
  }
}
