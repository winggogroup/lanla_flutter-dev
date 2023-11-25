import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget NoDataWidget(){
  return Container(
    padding: const EdgeInsets.only(top: 60),
    child: Center(child: Column(children: [
      // Icon(Icons.description,color: Colors.black12,size: 87,),
      Image.asset('assets/images/Nocontent.png',width: 200,height: 200,),
      const SizedBox(height: 10,),
      Text('没有内容'.tr,style: const TextStyle(color: Color(0xff999999)),)
    ],),),
  );
}

Widget NoDataWidgetNofabubg(){
  return Container(
    padding: const EdgeInsets.only(top: 60),
    child: Center(child: Column(children: [
      // Icon(Icons.description,color: Colors.black12,size: 87,),
      Image.asset('assets/images/nofabubg.png',width: 200,height: 200,),
      const SizedBox(height: 10,),
      Text('没有内容'.tr,style: const TextStyle(color: Color(0xff999999)),)
    ],),),
  );
}

Widget NoDataWidgetNoZanguo(){
  return Container(
    padding: const EdgeInsets.only(top: 60),
    child: Center(child: Column(children: [
      // Icon(Icons.description,color: Colors.black12,size: 87,),
      Image.asset('assets/images/noZanguobg.png',width: 200,height: 200,),
      const SizedBox(height: 10,),
      Text('没有内容'.tr,style: const TextStyle(color: Color(0xff999999)),)
    ],),),
  );
}

Widget Nodatashuju(){
  return Container(
    padding: const EdgeInsets.only(top: 60),
    child: Center(child: Column(children: [
      // Icon(Icons.description,color: Colors.black12,size: 87,),
      Image.asset('assets/images/nodatashuju.png',width: 148,height: 148,),
      const SizedBox(height: 20,),
      Text('没有内容'.tr,style: const TextStyle(color: Color(0xff999999)),)
    ],),),
  );
}

Widget NoDataWidgetNoShoucang(){
  return Container(
    padding: const EdgeInsets.only(top: 60),
    child: Center(child: Column(children: [
      // Icon(Icons.description,color: Colors.black12,size: 87,),
      Image.asset('assets/images/noShouCangbg.png',width: 200,height: 200,),
      const SizedBox(height: 10,),
      Text('没有内容'.tr,style: const TextStyle(color: Color(0xff999999)),)
    ],),),
  );
}