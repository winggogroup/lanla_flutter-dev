import 'dart:io';
import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_logic.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_state.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/HomeItem.dart';
import '../../../../services/content.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/pages/user/loginmethod/view.dart';

enum PageStatus { loading, noData, init, normal, empty }

enum ApiType { home, search, myPublish, myLike, myCollect, loction, topicHot,topicNew }



class ListDetailsPage extends StatefulWidget {
  late ApiType type;
  late int pagetype;
  ListDetailsPage({super.key, required this.type, required this.pagetype});

  @override
  _ListDetailsState createState() => _ListDetailsState();

}

class _ListDetailsState extends State<ListDetailsPage> {
  bool oneData = false; // 请求-用于展示等待页面
  List<dynamic> FlowList=[];
  final provider = Get.put(GiftDetails());
  int page=1;
  String dateTime= DateTime.now().toString().substring(0,19);
  var Antishake=true;
  ScrollController _scrollControllerls = ScrollController(); //listview 的控制器
  void onGooglePayResult(paymentResult) {
    debugPrint(paymentResult.toString());
  }
  @override
  void initState() {
    super.initState();
    print('jiankailea');
    Interface(1);
    _scrollControllerls.addListener(() {
      if (_scrollControllerls.position.pixels >
          _scrollControllerls.position.maxScrollExtent - 50) {
        //达到最大滚动位置
        _fetch();
      }
    });
  }
  Interface(page) async {
    if(oneData){
      setState(() {
        oneData = false;
      });
    }
    var result =await provider.detailedlist(widget.pagetype,dateTime,page);
    if(result.statusCode==200){
      setState(() {
        FlowList=[1,...FlowDetailsFromJson(result.bodyString!)];
      });
    }
    if(!oneData){
      setState(() {
        oneData = true;
      });
    }
  }

  /// 请求数据
  Future<void> _fetch() async {
   if(Antishake){
     setState(() {
       page++;
       Antishake=false;
     });
     var result =await provider.detailedlist(widget.pagetype,dateTime,page);
     // 延迟1秒请求，防止速率过快
     Future.delayed(Duration(milliseconds: 1000), () {
       setState(() {
         Antishake=true;
       });
     });
     if(result.statusCode==200 && FlowDetailsFromJson(result.bodyString!).length>0){
       setState(() {
         FlowList.addAll(FlowDetailsFromJson(result.bodyString!));
       });
     }else{
       setState(() {
         page--;
       });
     }
   }
  }

  @override
  Widget build(BuildContext context) {
    return
      !oneData
        ? StartDetailLoading()
        : RefreshIndicator(
        onRefresh: _onRefresh,
        displacement: 10.0,
        child:
        ListView.builder(
          controller: _scrollControllerls,
            itemCount: FlowList.length,
            itemBuilder: (context, i) {
              return i==0?Container(decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1 ,color: Color(0xffF1F1F1) ),)),padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                child:
                Row(children: [
                  GestureDetector(child: Container(width: 110,height: 30,
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))),
                    child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text(dateTime.substring(0,7)),SizedBox(width: 10,),SvgPicture.asset("assets/svg/xiajiantou.svg", color: Colors.black, width: 9, height: 5,)],),
                  ),onTap: (){
                    showPickerDateTimeRoundBg(context);
                  },),],)
              ):
              Container(margin: EdgeInsets.only(left: 20,right: 20,top: 20,),padding:EdgeInsets.only(bottom: 20),decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 1 ,color: Color(0xffF1F1F1) ),)),
                child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(FlowList[i].title,),Text(FlowList[i].type==1?'${FlowList[i].price} +':'${FlowList[i].price} -',style: TextStyle(fontWeight: FontWeight.w500),)],),
                  SizedBox(height: 10,),

                  Text(FlowList[i].createdAt.toString(),style: TextStyle(fontSize: 12,color: Color(0xff999999)),)
                  //Row(children: [Text('15:22',style: TextStyle(fontSize: 12,color: Color(0xff999999)),),SizedBox(width: 10,),Text('15:22',style: TextStyle(fontSize: 12,color: Color(0xff999999)),)],)
                ],),
              );
            }),
      );

  }

  @override
  void dispose() {
    super.dispose();
      FlowList=[];
      page = 0;
    _scrollControllerls.dispose();
  }

  Future<void> _onRefresh() async {
    // await Future.delayed(Duration(seconds: 1), () {
    //   widget.logic.NewConcerns();
    // });
    //DataRefresh();
    page = 1;
    FlowList=[];
    setState(() {

    });
    Interface(1);
  }


  ///日期选择器
  showPickerDateTimeRoundBg(BuildContext context) {
    var picker = Picker(
        height: 250,
        squeeze:1.1,
        cancelTextStyle:TextStyle(color: Color(0xff999999)),
        backgroundColor: Colors.transparent,

        // cancel:GestureDetector(child:Container(child: SvgPicture.asset(
        //   "assets/svg/chahao.svg",
        //   color: Colors.black,
        //   width: 15,
        //   height: 15,
        // ), margin: EdgeInsets.only(right: 20,bottom: 15),) ,onTap: (){
        //
        // },),
        // confirm:Container(child: SvgPicture.asset(
        //   "assets/svg/duigou.svg",
        //   color: Colors.black,
        //   width: 22,
        //   height: 22,
        // ), margin: EdgeInsets.only(left: 20,bottom: 15),),
        headerDecoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Colors.white, width: 0.5))),
        adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYM,
          isNumberMonth: true,
          maxValue:DateTime.now(),
          minuteInterval:30,
          value: DateTime.parse(dateTime),
          // yearSuffix: "年",
          // monthSuffix: "月"
        ),
        // title: Text("Select DateTime"),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text.substring(0,7));
          setState(() {
            dateTime=picker.adapter.text.substring(0,19);
          });
          Interface(1);
        },
        onSelect: (Picker picker, int index, List<int> selected) {
          // showMsg(picker.adapter.toString());
        });
    picker.showModal(context, backgroundColor: Colors.transparent,
        builder: (context, view) {
          return Material(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                padding: const EdgeInsets.only(top: 5),
                child: view,
              ));
        });
  }

}
