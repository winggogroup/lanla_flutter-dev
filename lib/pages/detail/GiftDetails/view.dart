import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/pages/detail/FlowDetails/ListDetails.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';

class GiftDetailsPage extends StatefulWidget {
  @override
  createState() => _GiftDetailsState();
}

class _GiftDetailsState extends State<GiftDetailsPage>  {
  final Interface = Get.find<GiftDetails>();
  var Details={};
  @override
  void initState() {
    super.initState();
    Giftdetails();
  }
  Giftdetails() async {
    var result = await Interface.detailLog(Get.arguments);
    if (result.statusCode == 200) {
      setState(() {
        Details = result.body;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(color:Color(0xffffffff)),
        child:Column(children: [
          const SizedBox(height: 50,),
          Container(width: 100,height: 100,alignment: Alignment.center,decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: const Color(0xffF5F5F5),
          ),child:Image.network(Details["giftPath"],width: 70,height: 70,),),

          const SizedBox(height: 20,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('被赠礼的作品'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),),
            Container(
              width: 55,
              height: 55,
              //超出部分，可裁剪
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(Details["thumbnail"],width: 55,height: 55,fit: BoxFit.cover,),
            )

          ],),
          const SizedBox(height: 20,),
          const Divider(height: 1.0,color: Color(0xffF1F1F1),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('赠礼人'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),),
            Text(Details["nickname"])
          ],),
          const SizedBox(height: 20,),
          const Divider(height: 1.0,color: Color(0xffF1F1F1),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('赠礼时间'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),),
            Text(Details["createdAt"])
          ],),
          const SizedBox(height: 20,),
          const Divider(height: 1.0,color: Color(0xffF1F1F1),),
          const SizedBox(height: 20,),
          Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
            Text('礼物收益'.tr,style: const TextStyle(fontSize: 15,color: Color(0xff999999)),),
            Text('${Details["price"]} +')
          ],),
          const SizedBox(height: 20,),
          const Divider(height: 1.0,color: Color(0xffF1F1F1),),
        ],),
      ),
      appBar: AppBar(
        elevation: 0, //消除阴影
        title: Text('礼物明细'.tr,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,//设置背景颜色为白色
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Get.back();
            }),
      ),
    );
  }

  deactivate() {
    super.dispose();

  }



}
//定义弹窗

