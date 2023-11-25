import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/item.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:url_launcher/url_launcher.dart';

class Planningpage extends StatefulWidget {
  @override
  createState() => PlanningState();
}

class PlanningState extends State<Planningpage>with SingleTickerProviderStateMixin {
  ContentProvider provider = Get.put(ContentProvider());
  final userController = Get.find<UserLogic>();

  bool oneData = false; // 是否首次请求过-用于展示等待页面
  var dataId;
  int page=1;
  var Desireddata;
  List<HomeItem> contentList = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // 延迟1秒请求接口，防止渲染太多 引起卡顿
    Future.delayed(const Duration(milliseconds: 500), () {
      // _fetch();
      dataId=Get.arguments['id'];
      _getData();
      getDataList(1);
    });
    // 添加滚动监听器
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        // 到达底部，触发加载更多
       getDataList(page);
      }
    });
    super.initState();
  }


  _getData() async {
    var result = await provider.contentAreadetail(dataId);
    if(result.statusCode==200){
      Desireddata=result.body;
    }

    // contentList.addAll(result);

    setState(() {});
  }

  getDataList(pages) async{
    var result = await provider.contentAreacontents(dataId,pages);
    if(result.statusCode==200){
      if(homeItemFromJson(result.bodyString!).isNotEmpty){
        page=page+1;
        if(page==1){
          contentList=homeItemFromJson(result.bodyString!);
        }else{
          contentList=[...contentList,...homeItemFromJson(result.bodyString!)];
        }

      }

    }
    oneData=true;
    setState(() {

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            GestureDetector(child: Container(
              width: 19,
              height: 22,
              child: SvgPicture.asset(
                "assets/svg/youjiantou.svg",
              ),
            ), onTap: (){
              Get.back();
            },),
            Expanded(
                child: Center(
                  child: Text(
                    Get.arguments['title'] ?? '',
                    style: const TextStyle(fontSize: 20),
                  ),
                )),
            Container(
              width: 19,
            ),
          ],
        ),
      ),
      body:  !oneData ? StartDetailLoading():Column(children: [
        Container(
          height: 1.0,
          decoration: const BoxDecoration(
            color: Color(0xfff1f1f1),
            boxShadow: [
              BoxShadow(
                color: Color(0x0c00000),
                offset: Offset(0, 2),
                blurRadius: 5,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
        Expanded(child: ListView(controller: _scrollController,children: [
          const SizedBox(height: 20,),
          Container(padding: const EdgeInsets.only(right: 15),child: Text(Desireddata['boutique_assemble_title'],style: const TextStyle(fontWeight: FontWeight.w600),),),
          const SizedBox(height: 15,),
          Container( height:200,child: ListView(
              shrinkWrap: true,
              primary:false,
              // // controller:  pd_controller,
              scrollDirection: Axis.horizontal,
              children:[
                for(var item in Desireddata['boutique'])
                  GestureDetector(child:Container(
                    width: 140,
                    // decoration: BoxDecoration(color: Colors.white,
                    //   borderRadius: BorderRadius.all(Radius.circular(8)),
                    //   border: new Border.all(width: 0.2, color: Color.fromRGBO(0, 0, 1, 0.2)),
                    // ),
                    margin: const EdgeInsets.only(right: 15),
                    child:  Stack(children: [
                      Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          // Container(clipBehavior: Clip.hardEdge,width: double.infinity,height: 210,decoration:BoxDecoration(
                          //     borderRadius: BorderRadius.circular(10),
                          //     color: Colors.white,
                          //     boxShadow: [
                          //       BoxShadow(
                          //         color: Color.fromRGBO(0, 0, 0, 0.25),
                          //         offset: Offset(0, 0),
                          //         blurRadius: 0.8,
                          //         spreadRadius: 0,
                          //       ),
                          //     ],
                          // ),child: Image.network(item['boutique_image'],fit: BoxFit.cover,),),

                          Expanded(child: Container(
                            //超出部分，可裁剪
                            width: double.infinity,
                            clipBehavior: Clip.hardEdge,

                            decoration:const BoxDecoration(
                                borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8),bottomLeft:Radius.circular(8) ,bottomRight: Radius.circular(8))
                              // borderRadius: BorderRadius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: item['boutique_image'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(color: const Color(0xffF5F5F5),padding: const EdgeInsets.only(left: 20,right: 20),width: double.infinity,child:Image.asset('assets/images/LanLazhanwei.png') ,),
                            ),
                          )),

                          // Container(
                          //   padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          //   alignment: Alignment.centerRight,
                          //   margin: const EdgeInsets.only(top: 12,bottom: 12),
                          //   child: Text(
                          //     item['boutique_title'],
                          //     overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                          //     maxLines: 1,
                          //     style: const TextStyle(
                          //         fontWeight: FontWeight.w500, fontSize: 11),
                          //   ),
                          // ),
                        ],
                      ),
                      ///绿色火焰
                      Positioned(
                          top: 10,
                          left: 10,
                          child: item['is_fire_tag'] == 1
                              ?
                          // const Icon(
                          //     Icons.linked_camera,
                          //     color: Colors.white70,
                          //     size: 22,
                          //   )
                          SvgPicture.asset('assets/svg/greenflame.svg')
                              : Container())
                    ],) ,
                  ),onTap: () async {

                    FirebaseAnalytics.instance.logEvent(
                      name: "ContentZoneBoutique",
                      parameters: {
                        "event":item['boutique_target_type'],
                        "targetid":item['boutique_target_id'],
                        "dataId":item['id'],
                        'targetOther':item['boutique_target_other'],
                        'deviceId':userController.deviceId
                      },
                    );
                    if(item['boutique_target_id'] != ''&&item['boutique_target_type'] == 5){

                      _launchUniversalLinkIos(Uri.parse(item['boutique_target_other']),Uri.parse(item['boutique_target_id']));
                    }
                    else if(item['boutique_target_id'] != ''&&item['boutique_target_type'] == 11){
                      if(item['boutique_target_other']=='/public/video'||item['boutique_target_other']=='/public/picture'|| item['boutique_target_other'] == '/public/xiumidata'){
                        Get.toNamed(item['boutique_target_other'],arguments:  {
                          'data': int.parse(item['boutique_target_id']),
                          'isEnd': false
                        });
                      }else if(item['boutique_target_other']=='/public/Planningpage'){
                        Get.toNamed(item['boutique_target_other'],arguments:  {
                          'id': int.parse(item['boutique_target_id']),
                          'title': ''
                        });
                      }else{
                        Get.toNamed(item['boutique_target_other'],arguments: int.parse(item['boutique_target_id']),);
                      }
                    }
                    else if(item['boutique_target_id'] != ''&&item['boutique_target_type'] ==12){
                      //Get.toNamed('/public/webview',arguments: item['boutique_target_id']);
                      await launchUrl(Uri.parse(item['boutique_target_id']), mode: LaunchMode.externalApplication,);
                    }
                    // Get.toNamed('/public/Evaluationdetails');
                  },),
                const SizedBox(width: 20,)
              ]),),
          const SizedBox(height: 20,),
          ///中间banner
          Container(padding: const EdgeInsets.only(right: 15),child: Text(Desireddata['banner_title'],style: const TextStyle(fontWeight: FontWeight.w600),),),
          const SizedBox(height: 15,),
          GestureDetector(child: Container(margin:const EdgeInsets.only(left: 15,right: 15),clipBehavior: Clip.hardEdge,width: double.infinity,height: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),child: Image.network(Desireddata['banner_image'],fit: BoxFit.cover,),),onTap: () async {
            FirebaseAnalytics.instance.logEvent(
              name: "ContentZonebanner",
              parameters: {
                "event":Desireddata['banner_target_type'],
                "targetid":Desireddata['banner_target_id'],
                "dataId":Desireddata['id'],
                'targetOther':Desireddata['banner_target_other'],
                'deviceId':userController.deviceId
              },
            );
            if(Desireddata['banner_target_id'] != ''&&Desireddata['banner_target_type'] == 5){

              _launchUniversalLinkIos(Uri.parse(Desireddata['banner_target_other']),Uri.parse(Desireddata['banner_target_id']));
            }
            else if(Desireddata['banner_target_id'] != ''&&Desireddata['banner_target_type'] == 11){
              if(Desireddata['banner_target_other']=='/public/video'||Desireddata['banner_target_other']=='/public/picture'|| Desireddata['banner_target_other'] == '/public/xiumidata'){
                Get.toNamed(Desireddata['banner_target_other'],arguments:  {
                  'data': int.parse(Desireddata['banner_target_id']),
                  'isEnd': false
                });
              }else{
                Get.toNamed(Desireddata['banner_target_other'],arguments: int.parse(Desireddata['banner_target_id']),);
              }
            }
            else if(Desireddata['banner_target_id'] != ''&&Desireddata['banner_target_type'] ==12){
              //Get.toNamed('/public/webview',arguments: Desireddata['banner_target_id']);
              await launchUrl(Uri.parse(Desireddata['banner_target_id']), mode: LaunchMode.externalApplication,);
            }
          },),
          const SizedBox(height: 25,),
          Container(padding: const EdgeInsets.only(right: 15),child: Text('优选笔记'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
          const SizedBox(height: 15,),
          MasonryGridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), //禁止滚动
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            // 上下间隔
            crossAxisSpacing: 5,
            //左右间隔
            padding: const EdgeInsets.all(10),
            // 总数
            itemCount: contentList.length,
            itemBuilder: (context, index) {
              return IndexItemWidget(
                contentList[index],
                index,
                userController.getLike(contentList[index].id),
                    (index) {
                  bool status = userController.setLike(contentList[index].id);
                  status ? contentList[index].likes++ : contentList[index].likes--;
                  setState(() {});
                },
                false,
                ApiType.topicHot,
                "1",
                isLoading: true,
                    () {},
              );
            },
          ),
        ],))

      ],),
    );
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
      // await launchUrl(
      //   httpurl,
      //   mode: LaunchMode.inAppWebView,
      // );
    }

    //启动APP 功能。可以带参数，如果启动原生的app 失败


    //启动失败的话就使用应用内的webview 打开
  }
}