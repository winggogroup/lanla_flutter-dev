import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../services/newes.dart';

class MoretopicsPage extends StatefulWidget {
  @override
  createState() => Moretopics();
}

class Moretopics extends State<MoretopicsPage> {
  final userController = Get.find<UserLogic>();
  ScrollController _scrollController = ScrollController();
  final provider = Get.find<ContentProvider>();
  ///数据
  var topicslist=[];

  ///防抖
  var Antishaking=true;

  ///页数
  var page=0;

  bool oneData = false; // 是否首次请求过-用于展示等待页面

  @override
  void initState() {
    super.initState();
    _fetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置

        _fetch();
      }
    });
  }
  /// 请求数据
  Future<void> _fetch() async {
    if(Antishaking){
      Antishaking=false;
      page++;
      var result = await provider.Topicslist(page);
      if(result.statusCode==200){
        if(topicModelFromJson(result.bodyString!).length>0){
          setState(() {
            topicslist.addAll(topicModelFromJson(result.bodyString!));
            oneData = true;
          });
          Future.delayed(Duration(milliseconds: 1000), () {
            setState(() {
              Antishaking=true;
            });
          });
        }else{
          if(page>0){
            page--;
          }
          Future.delayed(Duration(milliseconds: 1500), () {
            setState(() {
              Antishaking=true;
            });
          });
        }
      }else{
        if(page>0){
          page--;
        }
        Antishaking=true;
      }
    }

  }

  @override
  void dispose() {
    super.dispose();
    page=0;
    topicslist=[];
    Antishaking=true;
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            elevation: 0,
            //消除阴影
            backgroundColor: Colors.white,
            //设置背景颜色为白色
            centerTitle: true,
            leading: IconButton(
                color: Colors.black,
                icon: Icon(Icons.arrow_back_ios),
                tooltip: "Search",
                onPressed: () {
                  //print('menu Pressed');
                  Navigator.of(context).pop();
                }),
            title: Text('热门话题'.tr, style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),),
          ),
          body:  !oneData
              ? StartDetailLoading()
              : Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: [
                Divider(height: 1.0, color: Colors.grey.shade200,),
                Expanded(
                    flex: 1,
                    child: RefreshIndicator(onRefresh: _onRefresh,
                          child: topicslist.length>0?
                          ListView.builder(
                              itemCount: topicslist.length,
                              controller: _scrollController,
                              itemBuilder: (context, i) {
                                return GestureDetector(child:Container(padding: EdgeInsets.fromLTRB(0, 20, 0, 20),margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,//宽度
                                        color: Color(0xfff1f1f1), //边框颜色
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 73,
                                        height: 47,
                                        //超出部分，可裁剪
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Image.network(
                                          topicslist[i].imagePath,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 10,),
                                      Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                        Row(children: [Image.asset('assets/images/jinghao.png',width: 19,height: 19,),SizedBox(width: 3,),Text(topicslist[i].title,style: TextStyle(fontSize: 16),)],),
                                        SizedBox(height: 10,),
                                        Text('浏览量'.tr+' '+topicslist[i].visits.toString(),style: TextStyle(fontSize: 14,color: Color(0xff666666)),),
                                      ],)
                                    ],
                                  ),
                                ) ,onTap: (){
                                  Get.toNamed('/public/topic',arguments: topicslist[i].id);
                                },);
                              }):Container(
                            width: double.infinity,
                            // decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red),),
                            child:Column(
                              children: [
                                SizedBox(height: 120,),
                                Image.asset('assets/images/nobeijing.png',width: 200,height: 200,),
                                SizedBox(height: 40,),
                                Text('暂无内容'.tr,style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff999999)
                                ),),
                              ],
                            ),))
                    )
              ],
            ),
          )
      );
  }

Future<void> _onRefresh() async {
  if(Antishaking){
    Antishaking=false;
    var result = await provider.Topicslist(1);
    if(result.statusCode==200){
      if(topicModelFromJson(result.bodyString!).length>0){
        setState(() {
          topicslist=topicModelFromJson(result.bodyString!);
          Antishaking=true;
        });
      }else{
        Antishaking=true;
      }
    }
  }
}
}
