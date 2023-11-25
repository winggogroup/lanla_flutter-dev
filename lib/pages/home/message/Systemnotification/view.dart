import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/newes.dart';
import 'package:lanla_flutter/pages/home/message/Dashedline/view.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:url_launcher/url_launcher.dart';
class SystemtzPage  extends StatefulWidget{
  @override
  createState() => Systemtz();
}
enum NewConcernStatus { loading, noData, init, normal, empty }
class Systemtz extends State<SystemtzPage>{
  NewesProvider provider = Get.find<NewesProvider>();
  ScrollController _scrollControllerls = ScrollController(); //listview 的控制器
  final userLogic = Get.find<UserLogic>();
  final logictwo = Get.find<MessageLogic>();
  var newslist=[];
  num page=0;
  NewConcernStatus status = NewConcernStatus.init;
  @override
  void initState() {
    super.initState();
    fetches();
    _scrollControllerls.addListener(() {
      if (_scrollControllerls.position.pixels >
          _scrollControllerls.position.maxScrollExtent - 50) {
        //达到最大滚动位置

        fetches();
      }
    });
  }
  void dispose() {
    super.dispose();
    logictwo.empty();
    newslist=[];
    page = 0;
    _scrollControllerls.dispose();
  }

  Future<void> fetches() async {
    if (status == NewConcernStatus.loading) {
      // 防止重复请求
      return;
    }
    status = NewConcernStatus.loading;
    page++;
    setState(() {

    });
    var result = await provider.Messageinterface(1, page);


    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 2000), () {
      status = NewConcernStatus.normal;
    });
    if (result.statusCode == 200) {
      if(MessageFromJson(result?.bodyString ?? "").toString()!='[]'){
        newslist.addAll(MessageFromJson(result?.bodyString ?? ""));
        setState(() {

        });
      }else{
        setState(() {
          page--;
        });
      }
      // userLogicone.emptyNews();
    }else{
      setState(() {
        page--;
      });
    }
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
              onPressed: () {
                Get.back();
              },
              icon: SvgPicture.asset(
                "assets/icons/fanhui.svg",
                width: 22,
                height: 22,
              ),
            ),
            title: Text('系统消息'.tr, style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),),
          ),
          body: Container(
            decoration: BoxDecoration(color: Color(0xfff5f5f5)),
            child: Column(
              children: [
                Divider(height: 1.0, color: Colors.grey.shade200,),
                Expanded(flex: 1,child:
                  ListView.builder(
                      controller: _scrollControllerls,
                      itemCount: newslist.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(child: Container(
                            width: double.infinity,
                            color: Color(0xfff5f5f5),
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: Column(children: [
                              Text(newslist[i].createdAt),
                              SizedBox(height: 15,),
                              //Container(width: double.infinity,),
                              Container(width: double.infinity,decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(5)),),
                                child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                  // Container(height: 100,color: Colors.red,),
                                  if(newslist[i].thumbnail!='')Image.network(newslist[i].thumbnail,fit:BoxFit.cover),
                                  SizedBox(height: 15,),
                                  Container(padding:EdgeInsets.only(left: 10,right: 10),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                    Text(newslist[i].title,style: TextStyle(fontWeight: FontWeight.w600),),
                                    SizedBox(height: 10,),
                                    Text(newslist[i].text,style: TextStyle(fontSize: 13),),
                                    SizedBox(height: 10,),
                                    DottedLineDivider(
                                      color: Color(0xffE1E1E1),
                                      height: 1.0,
                                      indent: 16.0,
                                      endIndent: 16.0,
                                    ),
                                    SizedBox(height: 15,),
                                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                      Text('查看进入'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                                      Container(
                                        width: 10,
                                        height: 10,
                                        child: SvgPicture.asset(
                                          "assets/svg/zuojiantou.svg",
                                        ),
                                      )
                                    ],),
                                    SizedBox(height: 15,),
                                  ],),)

                                ],),
                              ),
                            ],)
                        ),onTap: () async {
                          await FirebaseAnalytics.instance.logEvent(
                            name: "mail",
                            parameters: {
                              "router":newslist[i].router,
                              "id":newslist[i].targetId,
                              'mail_id':newslist[i].id,
                              'userId':userLogic.userId,
                              'deviceId':userLogic.deviceId,
                            },
                          );
                          //print(newslist.System[i].router);
                          if (newslist[i].router == 2) {
                            Get.toNamed(
                                '/public/picture', preventDuplicates: false,
                                arguments: {
                                  "data": newslist[i].targetId,
                                  "isEnd": false
                                });
                          } else if (newslist[i].router == 4) {
                            Get.toNamed('/public/webview',
                                arguments: 'https://api.lanla.app/bests?bestId=${newslist[i].targetId}');
                          } else if (newslist[i].router == 3) {
                            Get.toNamed('/public/topic',
                                arguments: newslist[i].targetId as int);
                          }else if(newslist[i].router==1){
                            Get.toNamed('/public/video',arguments: {
                              'data':
                              newslist[i].targetId,
                              'isEnd': false
                            });
                          }else if(newslist[i].router == 11){
                            if(newslist[i].targetOther=='/public/video'||newslist[i].targetOther=='/public/picture'|| newslist[i].targetOther == '/public/xiumidata'){
                              Get.toNamed(newslist[i].targetOther,arguments:  {
                                'data': newslist[i].targetId,
                                'isEnd': false
                              });
                            } else if(newslist[i]['target_id']=='share/invite/index'){
                              List<String> list = newslist[i].targetOther.split('-').toList();
                              FirebaseAnalytics.instance.logEvent(
                                name: "jumpwebh5",
                                parameters: {
                                  "userid": userLogic.userId,
                                  "uuid":userLogic.deviceData['uuid'],
                                },
                              );
                              //if(int.parse(data.activity[i].targetId)==1){
                              Get.toNamed('/public/webview',arguments: BASE_DOMAIN+list[1]+'?token='+userLogic.token+'&uuid='+userLogic.deviceData['uuid']);
                              //}
                            }else if(newslist[i]['target_other']=='/public/Planningpage'){
                              Get.toNamed(newslist[i]['target_other'],arguments:  {
                                'id': int.parse(newslist[i]['target_id']),
                                'title': ''
                              });
                            }
                            else{
                              Get.toNamed(newslist[i].targetOther,arguments: newslist[i].targetId,);
                            }
                          }
                          else if(newslist[i].router ==12){
                            //Get.toNamed('/public/webview',arguments: data.activity[i].targetId);
                            await launchUrl(Uri.parse(newslist[i].targetOther), mode: LaunchMode.externalApplication,);
                          }
                        },);
                      }
                  )
                ),
              ],
            ),
          )
      );
  }

}