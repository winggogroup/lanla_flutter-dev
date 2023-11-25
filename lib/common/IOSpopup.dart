import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:zmreader/common/index.dart';

/// 底部弹出框
class BottomSheetWidget extends StatefulWidget {
  BottomSheetWidget({ this.list, required this.onItemClickListener});

  final list;
  final OnItemClickListener onItemClickListener;

  @override
  _BottomSheetWidgetState createState() => _BottomSheetWidgetState();
}

typedef OnItemClickListener = void Function(int index);

class _BottomSheetWidgetState extends State<BottomSheetWidget> {
  late OnItemClickListener onItemClickListener;
  var itemCount;
  double itemHeight = 44;
  double circular = 10;


  @override
  void initState() {
    super.initState();
    onItemClickListener = widget.onItemClickListener;
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    int listLength=widget.list.length;
    /// 最后还有一个cancel，所以加1
    itemCount = listLength + 1;
    var height ;
    if(listLength==1){
      height = ((listLength + 2) * 48).toDouble();
    }else{
      height = ((listLength + 1) * 48).toDouble();
    }
    var cancelContainer = Container(
        height: itemHeight,
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: BorderRadius.circular(circular),
        ),
        child: Center(
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Text(
              "取消".tr,
              style: TextStyle(
                  fontFamily: 'Robot',
                  fontWeight: FontWeight.normal,
                  decoration: TextDecoration.none,
                  color: Color(0xff333333),
                  fontSize: 18),
            ),
          ),
        ));
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (index == itemCount - 1) {
            return new Container(
              child: cancelContainer,
              margin: const EdgeInsets.only(top: 10),
            );
          }
          return getItemContainer(context, index,listLength);
        });
    var totalContainer = Container(
      child: listview,
      height: height,
      width: deviceWidth * 0.98,
    );
    var stack = Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Positioned(
          bottom: 0,
          child: totalContainer,
        ),
      ],
    );
    return stack;
  }

  Widget getItemContainer(BuildContext context, int index,int listLength) {
    if (widget.list == null) {
      return Container();
    }

    var text = widget.list[index];
    var contentText = Text(
      text,
      style: TextStyle(
          fontWeight: FontWeight.normal,
          decoration: TextDecoration.none,
          color: Color(0xFF333333),
          fontSize: 18),
    );

    var decoration;

    var center;
    var itemContainer;
    center = Center(
      child: contentText,
    );
    var onTap2 = () {
      if (onItemClickListener != null) {
        onItemClickListener(index);
      }
    };
    if(listLength==1){
      decoration = BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: BorderRadius.circular(15),
          border: Border.all(width: 0.5, color: Color(0xffe5e5e5))
      );
    }else if(listLength>1){
      if (index == 0) {
        decoration = BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          border:Border.all(width: 0.5, color: Color(0xffe5e5e5)),
        );
      } else if (index == listLength - 1) {
        decoration = BoxDecoration(
          color: Colors.white, // 底色
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
          border: Border.all(width: 0.5, color: Color(0xffe5e5e5)),
        );
      } else {
        decoration = BoxDecoration(
          color: Colors.white, // 底色
          border: Border(
              left: BorderSide(color: Colors.white, width: 0.5),
              right: BorderSide(color: Colors.white, width: 0.5),
              bottom: BorderSide(width: 0.5, color: Color(0xffe5e5e5))),
        );
      }
    }
    itemContainer = Container(

        height: itemHeight,
        margin: EdgeInsets.only(left: 10, right: 10),
        decoration: decoration,
        child: center);

    return GestureDetector(
      onTap: onTap2,
      child: itemContainer,
    );
  }
}