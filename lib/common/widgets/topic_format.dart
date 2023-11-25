import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

TopicFormat(List<dynamic> list,{isVideo:false}) {
  return Wrap(
    children: [
      ...list.map(
        (e) => GestureDetector(
          onTap: (){
            Get.toNamed('/public/topic',arguments: e["id"] as int);
          },
          child: Container(
            margin: const EdgeInsets.only(left: 10, right: 20),
            child: Text(
              "#${e["title"]}",
              style: TextStyle(color: isVideo ? Colors.white:Colors.blueGrey,fontSize: 15),
            ),
          ),
        ),
      )
    ],
  );
}
