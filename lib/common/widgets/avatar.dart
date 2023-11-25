import 'package:flutter/material.dart';

Widget Avatar(String url, double size){
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(size),
      border: Border.all(width: 1,color: Colors.white),
      color: Colors.black12,
      image: DecorationImage(
          image: NetworkImage(url ??
              'https://dyhc-dev.oss-cn-beijing.aliyuncs.com/topic/topic-9.png'),
          fit: BoxFit.cover),
    ),
    //child: Image.network(data.userAvatar,fit:BoxFit.cover),
  );
}