import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/pages/home/friend/Planningpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ActivityZonePage extends StatefulWidget {
  @override
  createState() => ActivityZoneState();
}
class ActivityZoneState extends State<ActivityZonePage> with AutomaticKeepAliveClientMixin {
  ContentProvider provider = Get.put(ContentProvider());
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  final userLogic = Get.find<UserLogic>();
  bool get wantKeepAlive => true; // 是否开启缓存
  final ScrollController _scrollController = ScrollController(); //listview 的控制器
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  bool antishake=true;
  var newdata;
  int page=1;
  @override
  void initState() {
    _fetch(1);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        _fetch(page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _fetch(pages) async {
    if(antishake){
      antishake=false;
      if(page==1){
        setState(() {
          oneData=false;
        });
      }

      var res =await provider.eventlist(pages);
      if(res.statusCode==200){
        if(res.body['data'].length!=0){
          page=res.body['currPage']+1;
          if(res.body['currPage']==1){
            newdata=res.body['data'];
          }else{
            newdata=[...newdata,...res.body['data']];
          }
        }

        oneData=true;
      }
      antishake=true;
    }

    setState(() {
    });
  }

  timedetermine(startTime,endTime){
    if(startTime==null||endTime==null){
      return "01";
    }
    final now = DateTime.now();
    if (now.isAfter(DateTime.parse(endTime))) {
      return "0"; // 已经超过结束时间
    }
    if(!now.isAfter(DateTime.parse(startTime))) {
      final difference = DateTime.parse(startTime).difference(now);
      final remainingDays = difference.inDays + 1; // 加1是为了包括今天
      return remainingDays.toString();
    }else{
      return "01";
    }
  }
  Widget build(BuildContext context) {
    return !oneData
        ? StartDetailLoading()
        : Container(padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),child: newdata!=null?ListView.builder(
        controller: _scrollController,
        itemCount: newdata.length,
        itemBuilder: (context, i) {
          return GestureDetector(child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(alignment: Alignment.centerRight,child: Text(newdata[i]['title'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),),
                const SizedBox(
                  height: 15,
                ),
                Stack(children: [
                  Container(clipBehavior: Clip.hardEdge,width: double.infinity,height: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),child: Image.network(newdata[i]['image'],fit: BoxFit.cover,),),
                  if(timedetermine(newdata[i]['start_time'],newdata[i]['end_time'])!="0"&&timedetermine(newdata[i]['start_time'],newdata[i]['end_time'])!="01")
                  Container(clipBehavior: Clip.hardEdge,width: double.infinity,height: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color.fromRGBO(0, 0, 0, 0.4)),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                    Text('即将开始'.tr,style: const TextStyle(fontSize: 27,fontWeight: FontWeight.w600,color: Colors.white),),
                    const SizedBox(height: 10,),
                    Row(mainAxisAlignment:MainAxisAlignment.center,children:  [
                      Text('倒计时'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),),
                      const SizedBox(width: 5,),
                      Container(alignment: Alignment.center,decoration: BoxDecoration(borderRadius: BorderRadius.circular(2),color:const Color.fromRGBO(255, 255, 255, 0.4)),padding: const EdgeInsets.only(left: 10,right: 10,top: 1,bottom:1),child: Text(timedetermine(newdata[i]['start_time'],newdata[i]['end_time']),style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 15,height: 1,color: Colors.white),),),
                      const SizedBox(width: 5,),
                      Text('天'.tr,style: const TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white),)],)
                  ],),),
                  if(timedetermine(newdata[i]['start_time'],newdata[i]['end_time'])=="0")Container(clipBehavior: Clip.hardEdge,width: double.infinity,height: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: const Color.fromRGBO(255, 255, 255, 0.4)),),
                  if(timedetermine(newdata[i]['start_time'],newdata[i]['end_time'])=="0")Positioned(right: 10,bottom:10,child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(68),color: const Color.fromRGBO(0, 0, 0, 0.5)),padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),child: Text('活动结束'.tr,style: const TextStyle(fontSize: 12,color: Color.fromRGBO(255, 255, 255, 0.8)),),)),
                ],),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),onTap: () async {
            if(timedetermine(newdata[i]['start_time'],newdata[i]['end_time'])=="01"){
              if(newdata[i]['target_id'] != ''&&newdata[i]['target_type'] == 5){
                _launchUniversalLinkIos(Uri.parse(newdata[i]['target_other']),Uri.parse(newdata[i]['target_id']));
              }
              else if(newdata[i]['target_id'] != ''&&newdata[i]['target_type'] == 11){
                if(newdata[i]['target_other']=='/public/video'||newdata[i]['target_other']=='/public/picture'|| newdata[i]['target_other'] == '/public/xiumidata'){
                  Get.toNamed(newdata[i]['target_other'],arguments:  {
                    'data': int.parse(newdata[i]['target_id']),
                    'isEnd': false
                  });
                }else if(newdata[i]['target_id']=='share/invite/index'){
                  FirebaseAnalytics.instance.logEvent(
                    name: "jumpwebh5",
                    parameters: {
                      "userid": userLogic.userId,
                      "uuid":userLogic.deviceData['uuid'],
                    },
                  );
                  Get.toNamed('/public/webview',arguments: '${BASE_DOMAIN+newdata[i]['target_id']}?token=${userLogic.token}&uuid='+userLogic.deviceData['uuid']);
                }else if(newdata[i]['target_other']=='/public/Planningpage'){
                  Get.toNamed(newdata[i]['target_other'],arguments:  {
                    'id': int.parse(newdata[i]['target_id']),
                    'title': ''
                  });
                }else{
                  Get.toNamed(newdata[i]['target_other'],arguments: int.parse(newdata[i]['target_id']),);
                }
              }
              else if(newdata[i]['target_id'] != ''&&newdata[i]['target_type'] ==12){
                await launchUrl(Uri.parse(newdata[i]['target_id']), mode: LaunchMode.externalApplication,);
              }
            }

          },);
        }):Container(),);
  }
  Future<void> _launchUniversalLinkIos(Uri url,Uri httpurl) async {
    try {
      final bool nativeAppLaunchSucceeded = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      // 失败后使用浏览器打开,未捕捉到异常时
      if(!nativeAppLaunchSucceeded){
        bool isUrl = await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
        if(!isUrl){

        }
      }
    } catch(e) {
      // 失败后使用浏览器打开,未捕捉到异常时
      await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
    }
  }
}