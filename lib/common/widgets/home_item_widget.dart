import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
/// 允许滑动的瀑布流内容
class HomeItemWidget extends StatefulWidget{
  final HomeItem dataSource;
  const HomeItemWidget({super.key, required this.dataSource});

  @override
  _HomeItemState createState() => _HomeItemState();

}

class _HomeItemState extends State<HomeItemWidget>{
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black38,
      child: Text(widget.dataSource.title),
    );
  }

}