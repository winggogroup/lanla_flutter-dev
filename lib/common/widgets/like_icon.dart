import 'package:flutter/material.dart';

Widget LikeWidget(int content_id){
  return Icon(
    content_id % 3 == 0
        ? Icons.favorite_border
        : Icons.favorite,
    size: 16,
    color: content_id % 3 == 0 ? Colors.black38 : Colors.red,
  );
}