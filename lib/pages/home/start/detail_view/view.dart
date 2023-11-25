import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/admod/HomeGridAd.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/Topicxqpage.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_logic.dart';
import 'package:lanla_flutter/pages/home/start/list_widget/list_state.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../models/HomeItem.dart';
import '../../../../services/content.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/pages/user/loginmethod/view.dart';
import 'item.dart';
import 'loading_widget.dart';
import 'logic.dart';
import 'no_data_widget.dart';
// import 'package:flutter_udid/flutter_udid.dart';



enum PageStatus { loading, noData, init, normal, empty }

enum ApiType { home, search, myPublish, myLike, myCollect, loction, topicHot,topicNew }

/// 该组件负责所有的瀑布流界面
/// 使用方法 StartDetailPage( type: ApiType.myPublish, parameter: '12',)
/// 需要提前定义界面使用的接口 _fetchInterface()
GlobalKey<_startDetailState> childKey = GlobalKey();
class StartDetailPage extends StatefulWidget {

  late ApiType type;
  late String parameter;

  late bool lasting;

  StartDetailPage({super.key, required this.type, required this.parameter,required this.lasting});

  @override
  _startDetailState createState() => _startDetailState();
  final logic = Get.put<StartDetailLogic>(StartDetailLogic());
}

class _startDetailState extends State<StartDetailPage> with AutomaticKeepAliveClientMixin {

  List<HomeItem> dataSource = [];
  int page = 1; // 当前页数
  final ScrollController _controller = ScrollController(); // 滚动条控制器

  bool oneData = false; // 是否首次请求过-用于展示等待页面
  bool fetching = false; // 是否正在请求接口

  bool shengjifetching = false; // 是否正在请求接口
  PageStatus status = PageStatus.init; // 当前页面状态
  // final provider = Get.put(ContentProvider());
  final provider = Get.find<ContentProvider>();
  ///获取标题banner
  final bannerstate = Get.find<StartListLogic>().state;
  final userController = Get.find<UserLogic>();
  String searchString = '';
  var _UpdateHomeItemListListener;
  var _PublishEventListener;
  var _UploadContentListEventListener;
  var Firsttrigger=false;
  bool wantKeepAlives=false;
  final startTime = DateTime.now().millisecondsSinceEpoch;
  double _PagePostion = 0;
  bool Temporary=false;
  var img;
  String zcnum='';
  @override

  // bool get wantKeepAlive => _wantKeepAlive;

  // 用于控制手动刷新
  final GlobalKey<RefreshIndicatorState> _indicatorKey = GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    // huoquhc();
    AppLog('pagein', data: widget.type.toString(), event: widget.parameter.toString());
    _UpdateHomeItemListListener = eventBus.on<UpdateHomeItemList>().listen((event) {
      for (HomeItem item in dataSource) {
        if (item.id == event.contentId) {
          item.likes += (event.status ? 1 : -1);
          break;
        }
      }
      setState(() {});
    });
    _controller.addListener(_controllerListener);
    // 延迟1秒请求接口，防止渲染太多 引起卡顿
    Future.delayed(Duration(milliseconds: 500), ()  {
      _fetch(1);

    });
   //shenji();

    // 发送内容成功后的事件回调
    _PublishEventListener = eventBus.on<PublishEvent>().listen((event) {
      if (widget.type == ApiType.myPublish) {
        _indicatorKey.currentState?.show();
      }
    });
    // 刷新列表
    _UploadContentListEventListener = eventBus.on<UploadContentListEvent>().listen((event) {
        _indicatorKey.currentState?.show();
    });


      Firsttrigger=true;

    super.initState();
  }

  @override
  // Future<void> ceshiadid() async {
  //   String adId = await FlutterUdid.udid;
  //   print('adia是${adId}');
  // }
  // Future<void> huoquhc() async {
  //   var sp = await SharedPreferences.getInstance();
  //   if(sp.getString("holduptank")!=null) {
  //     if (jsonDecode(sp.getString("holduptank")!)['${userController.userId}']!=null) {
  //       Temporary = true;
  //       zcnum =
  //           jsonDecode(sp.getString("holduptank")!)['${userController.userId}']
  //               .length.toString();
  //       if (jsonDecode(sp.getString("holduptank")!)['${userController
  //           .userId}'][0]['thumbnail'] != null) {
  //         img = jsonDecode(sp.getString("holduptank")!)['${userController
  //             .userId}'][0]['thumbnail'];
  //       } else {
  //         img = File(jsonDecode(sp.getString("holduptank")!)['${userController
  //             .userId}'][0]['dataListFile'].split(',')[0]);
  //       }
  //       setState(() {});
  //     }
  //   }
  // }
  bool isTimeBetween(DateTime startTime, DateTime endTime) {
    DateTime now = DateTime.now();
    return now.isAfter(startTime) && now.isBefore(endTime);
  }

  @override

  _controllerListener(){
    _PagePostion = _controller.offset;
      if (_controller.offset > _controller.position.maxScrollExtent - 800) {
        _fetch(2);
      }
  }

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    var topicindex;
    if (widget.parameter != searchString&&!Firsttrigger) {
      status = PageStatus.init; // 当前页面状态
      oneData = false; // 是否首次请求过-用于展示等待页面
      page = 1; // 当前页数
       _fetch(1);
    }
    if(widget.type==ApiType.home){
      wantKeepAlives = widget.lasting;
      this.updateKeepAlive();
      for(var i=0;i<bannerstate.channelDataSource.length;i++){
        if(bannerstate.channelDataSource[i].id==int.parse(widget.parameter)){
          topicindex=i;
        }
      }
    }

    return !oneData
        ? StartDetailLoading()
        : RefreshIndicator(
            key: _indicatorKey,
            onRefresh: () async {
              if (fetching) {
                return;
              }
              status = PageStatus.init;
              // 首页下拉刷新不是刷新是切换新数据
              if (widget.type != ApiType.home) {
                 page = 1;
              }
              await _fetch(1);
            },
            child: status == PageStatus.empty||dataSource.length==0
                ? ListView(children:[  Container(color: Colors.white,height: MediaQuery.of(context).size.height,child:
                  widget.type == ApiType.myPublish ? NoDataWidgetNofabubg() : (widget.type == ApiType.myLike ? NoDataWidgetNoZanguo() : NoDataWidgetNoShoucang()),)] )
                :ListView(scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  controller: widget.type == ApiType.myPublish ? null : _controller,
                  children:[
                    if(widget.type==ApiType.home&&bannerstate.channelDataSource[topicindex].banner.length>0&&userController.token!='')Container(
                      //超出部分，可裁剪
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: home_swiper(context,bannerstate.channelDataSource[topicindex].banner),
                    ),
                    MasonryGridView.count(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    // controller:
                    // widget.type == ApiType.myPublish ? null : _controller,
                    //key: PageStorageKey(item.id),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    // 上下间隔
                    crossAxisSpacing: 10,
                    //左右间隔
                    padding: const EdgeInsets.all(10),
                    // 总数
                    itemCount: dataSource.length,

                    itemBuilder: (context, index) {
                      // google 广告
                      if (dataSource[index].ad != null){
                        return HomeGridAd(index,userController.userInfo?.userId??0,widget.type);
                      }
                      if(dataSource[index].activity.length!=0){
                        List<Activity> filteredActivities = [];
                        for (var i = 0; i < dataSource[index].activity.length; i++) {
                          if (dataSource[index].activity[i].startTime != null &&
                              dataSource[index].activity[i].endTime != null &&
                              !isTimeBetween(
                                  DateTime.parse(dataSource[index].activity[i].startTime!),
                                  DateTime.parse(dataSource[index].activity[i].endTime!))) {
                            // 不满足条件的元素不添加到新列表
                          } else {
                            filteredActivities.add(dataSource[index].activity[i]);
                          }
                        }
                        dataSource[index].activity = filteredActivities;
                      }
                      bool isEnd = widget.type != ApiType.home;
                      //return Container(height:(index % 5 + 1) * 100, child: GestureDetector(onTap: (){Get.toNamed('/setting');},child: Text('第${index}个'),));
                      return Column(children: [
                        IndexItemWidget(
                          dataSource[index],
                          index,
                          userController.getLike(dataSource[index].id),
                          SetLike,
                          isEnd,
                          widget.type,
                          widget.parameter,
                          isLoading: false,
                          Delete,
                        )
                      ],);
                    },
                  ),
                    // if(dataSource.length<=2)Container(width: double.infinity,height: 500,)
                ]),
          );
  }

  @override
   bool get wantKeepAlive =>dataSource.length>0 ?wantKeepAlives:false;


  @override
  void dispose() {

    _controller.removeListener(_controllerListener);
    // 退出详情页
    // AppLog(
    //     'pageout',
    //     pagetime: ((DateTime.now().millisecondsSinceEpoch - startTime) / 1000)
    //         .truncate(),
    //     event: widget.type.toString(),
    //     data:widget.parameter,
    //     scroll:(1+_PagePostion/window.physicalSize.height).toStringAsFixed(2)
    // );

    //取消监听bus
    _UpdateHomeItemListListener.cancel();
    _PublishEventListener.cancel();
    _UploadContentListEventListener.cancel();
    super.dispose();
  }

  /// 请求数据
  Future<void> _fetch(type) async {
    if (fetching || status == PageStatus.empty || status == PageStatus.noData) {
      // 防止重复请求
      return;
    }
    searchString = widget.parameter;
    fetching = true;
    var result = await _fetchInterface();
    if(result.statusCode==200){
      //var result = await provider.GetHomeList(page, widget.parameter);
      page++;
      //延迟1秒请求，防止速率过快
      Future.delayed(const Duration(milliseconds: 1000), () {
        fetching = false;
      });
      setState(() {
        if(type==1){
          dataSource = [];
        }
        oneData = true;
        // 没有内容的情况
        if (dataSource.length == 0 && result.bodyString == '[]') {
          //setState(() {
            status = PageStatus.empty;
          //});
          return;
        }
        if (dataSource.length != 0 && result.bodyString == '[]') {
          status = PageStatus.noData;
          // 重置页码
          page = 0;
          return;
        }
        dataSource.addAll(homeItemFromJson(result.bodyString!));
        status = PageStatus.normal;
      });
    }else{
      setState(() {oneData = true;fetching = false;});
    }

  }

  SetLike(index) {
    if(dataSource[index].id!=0){
      final userLogic = Get.find<UserLogic>();
      if (!userLogic.checkUserLogin()) {
        Get.toNamed('/public/loginmethod');
        return;
      }

      bool status = userController.setLike(dataSource[index].id);
      status ? dataSource[index].likes++ : dataSource[index].likes--;
      setState(() {});
    }
  }

  Delete(index) async {
    if(dataSource[index].id!=0){
      EasyLoading.show(status: 'loading'.tr,maskType: EasyLoadingMaskType.black);
      await Get.put(ContentProvider()).Delete(dataSource[index].id);

      EasyLoading.dismiss();
      dataSource.removeAt(index);
      if (dataSource.isEmpty) {
        _indicatorKey.currentState?.show();
      }
      setState(() {});
    }

  }
  toupdate(data) async {
    oneData = false;
    var result =  await provider.GetSearch(data, 1);
    if(result.statusCode==200){
      setState(() {
        oneData = true;fetching = false;
        dataSource=homeItemFromJson(result.bodyString!);
      });
    }else{
      setState(() {oneData = true;fetching = false;});
    }
  }


  _fetchInterface() async {
    switch (widget.type) {
      // 首页
      case ApiType.home:
        return await provider.GetHomeList(page, widget.parameter);
      case ApiType.myPublish:
        return await provider.GetUserPublishList(page, widget.parameter);
      case ApiType.myCollect:
        return await provider.GetUserCollectList(page, widget.parameter);
      case ApiType.myLike:
        return await provider.GetUserLikeList(page, widget.parameter);
      case ApiType.search:
        return await provider.GetSearch(widget.parameter, page);
      case ApiType.topicHot:
        return await provider.GetTopicHot(widget.parameter, page);
      case ApiType.topicNew:
        return await provider.GetTopicNew(widget.parameter, page);

      case ApiType.loction:
        return await provider.GetLoction(page);
    }
  }

  ///弹窗
  // Future<void> toupdateDialog(context,type) async {
  //
  //   return showDialog<void>(
  //     context: context,
  //     barrierDismissible: type==2?true:false, // user must tap button!
  //     builder: (BuildContext context) {
  //
  //       return AlertDialog(
  //         backgroundColor: Colors.transparent,
  //         contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
  //         shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Container(
  //               //color: Colors.transparent,
  //               //color: Colors.red,
  //               // height: 280,
  //               child:Column(
  //                 mainAxisAlignment:MainAxisAlignment.center,
  //                 children: [
  //                   Container(width: MediaQuery.of(context).size.width-100,
  //                       //height: 311,
  //                       // decoration: BoxDecoration(
  //                       //   image: DecorationImage(
  //                       //     image: AssetImage('assets/images/gengxtc.png'),
  //                       //     fit: BoxFit.fill, // 完全填充
  //                       //   ),
  //                       // ),
  //                       child: Stack(children: [
  //                         Image.asset('assets/images/gengxtc.png',width: MediaQuery.of(context).size.width-100,),
  //                         Positioned(
  //                           bottom: 0,
  //                           child: Column(
  //                             children: [
  //                               Text('新版本优化啦，快来体验吧'.tr),
  //                               GestureDetector(child:Container(
  //                                 alignment: Alignment.center,
  //                                 padding: EdgeInsets.only(top: 12,bottom: 12),
  //                                 width: MediaQuery.of(context).size.width-180,
  //                                 margin: EdgeInsets.fromLTRB(40, 32, 40, 13),
  //                                 decoration: BoxDecoration(
  //                                   borderRadius: BorderRadius.circular(40),
  //                                   color: Colors.black,
  //                                   boxShadow: [
  //                                     BoxShadow(
  //                                       color: Color(0xFF55D200),
  //                                       offset: Offset(0, 1),
  //                                       blurRadius: 1,
  //                                       spreadRadius: 0,
  //                                     ),
  //                                   ],
  //                                 ),
  //
  //                                 child: Text('立刻升级'.tr,style: TextStyle(color: Colors.white),),
  //                               ),onTap: (){
  //                                 if (Platform.isAndroid) {
  //                                   _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
  //                                 } else if (Platform.isIOS) {
  //                                   _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
  //                                 }
  //                               },),
  //                               if(type==2)GestureDetector(child:Text('以后再说'.tr),onTap: (){
  //                                 Navigator.pop(context);
  //                               },),
  //                               SizedBox(height: 18,),
  //                             ],
  //                           ),
  //                         )
  //                       ],)
  //                   )
  //                 ],),),
  //           ]),
  //       );
  //     },
  //   );
  // }
  // Future<void> _launchUniversalLinkIos(Uri url) async {
  //   //启动APP 功能。可以带参数，如果启动原生的app 失败
  //   final bool nativeAppLaunchSucceeded = await launchUrl(
  //     url,
  //     //mode: LaunchMode.externalNonBrowserApplication,
  //   );
  //   //启动失败的话就使用应用内的webview 打开
  //   if (!nativeAppLaunchSucceeded) {
  //     await launchUrl(
  //       url,
  //       //mode: LaunchMode.inAppWebView,
  //     );
  //   }
  // }

  /**
   * 顶部轮播图
   */
  Widget home_swiper(BuildContext context, imgs) {
    double defultHeight = MediaQuery.of(context).size.width / 4;
    if (defultHeight > 500) {
      defultHeight = 500;
    }
    bool isOne = imgs.length == 1 ? true : false;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width, defultHeight)),
      child: isOne
          ? GestureDetector(
        onTap: () async {
          if(!Get.find<UserLogic>().checkUserLogin()){
            Get.toNamed('/public/loginmethod');
            return;
          }
          ///Banner
          FirebaseAnalytics.instance.logEvent(
            name: "Banner_click",
            parameters: {
              'BannerId':imgs.id,
              'userId':userController.userId,
              'deviceId':userController.deviceId
            },
          );
          // if(imgs[0].targetId != ""){
          //   Get.toNamed('/public/topic',arguments: int.parse(imgs[0].targetId));
          // }
          if(imgs[0].targetId != ''&&imgs[0].targetType == 1){
            Get.toNamed('/public/topic',arguments: int.parse(imgs[0].targetId));
          }else if(imgs[0].targetId != ''&&imgs[0].targetType == 4){
            Get.toNamed('/public/webview',arguments: imgs[0].targetId);
          }else if(imgs[0].targetId != ''&&imgs[0].targetType == 10){
            Get.toNamed('/public/user',arguments: int.parse(imgs[0].targetId));
          }else if(imgs[0].targetId != ''&&imgs[0].targetType == 11){
            if(imgs[0].targetOther=='/public/video'||imgs[0].targetOther=='/public/picture'||imgs[0].targetOther == '/public/xiumidata'){
              Get.toNamed(imgs[0].targetOther,arguments:  {
                'data': int.parse(imgs[0].targetId),
                'isEnd': false
              });
            }else if(imgs[0].targetId=='share/invite/index'){
              FirebaseAnalytics.instance.logEvent(
                name: "jumpwebh5",
                parameters: {
                  "userid": userController.userId,
                  "uuid":userController.deviceData['uuid'],
                },
              );
              Get.toNamed('/public/webview',arguments: BASE_DOMAIN+imgs[0].targetId+'?token='+userController.token+'&uuid='+userController.deviceData['uuid']);
            }else if(imgs[0].targetOther=='/public/Planningpage'){
              Get.toNamed(imgs[0].targetOther,arguments:  {
                'id': int.parse(imgs[0].targetId),
                'title': ''
              });
            }
            else{
              Get.toNamed(imgs[0].targetOther,arguments: int.parse(imgs[0].targetId),);
            }
          }else if(imgs[0].targetId != ''&&imgs[0].targetType ==12){
            //Get.toNamed('/public/webview',arguments: data.activity[i].targetId);
            await launchUrl(Uri.parse(imgs[0].targetId), mode: LaunchMode.externalApplication,);
          }
        },
            child: Container(
        child: ImageCacheWidget(imgs[0].imagePath,defultHeight),
        //margin: EdgeInsets.only(bottom: 15),
      ),
          )
          : Swiper(
        outer: false,
        itemBuilder: (c, i) {
          return GestureDetector(child: ImageCacheWidget(imgs[i].imagePath,defultHeight),onTap: () async {
            if(!Get.find<UserLogic>().checkUserLogin()){
              Get.toNamed('/public/loginmethod');
              return;
            }
            if(imgs[i].targetId != ''&&imgs[i].targetType == 1){
              Get.toNamed('/public/topic',arguments: int.parse(imgs[i].targetId));
            }else if(imgs[i].targetId != ''&&imgs[i].targetType == 4){
              Get.toNamed('/public/webview',arguments: imgs[i].targetId);
            }else if(imgs[i].targetId != ''&&imgs[i].targetType == 10){
              Get.toNamed('/public/user',arguments: int.parse(imgs[i].targetId));
            }else if(imgs[i].targetId != ''&&imgs[i].targetType == 5){

              _launchUniversalLinkIos(Uri.parse(imgs[i].targetOther),Uri.parse(imgs[i].targetId));
            }else if(imgs[i].targetId != ''&&imgs[i].targetType == 6){
              _launchUniversalLinkIos(Uri.parse(imgs[i].targetOther),Uri.parse(imgs[i].targetId));
            } else if(imgs[i].targetId != ''&&imgs[i].targetType == 11){
              if(imgs[i].targetOther=='/public/video' || imgs[i].targetOther=='/public/picture'||imgs[i].targetOther == '/public/xiumidata'){
                Get.toNamed(imgs[i].targetOther,arguments:  {
                  'data': int.parse(imgs[i].targetId),
                  'isEnd': false
                });
              }else if(imgs[i].targetId=='share/invite/index'){
                FirebaseAnalytics.instance.logEvent(
                  name: "jumpwebh5",
                  parameters: {
                    "userid": userController.userId,
                    "uuid":userController.deviceData['uuid'],
                  },
                );
                Get.toNamed('/public/webview',arguments: BASE_DOMAIN+imgs[i].targetId+'?token='+userController.token+'&uuid='+userController.deviceData['uuid']);
              }else if(imgs[i].targetOther=='/public/Planningpage'){
                Get.toNamed(imgs[i].targetOther,arguments:  {
                  'id': int.parse(imgs[i].targetId),
                  'title': false
                });
              }else{
                Get.toNamed(imgs[i].targetOther,arguments: int.parse(imgs[i].targetId),);
              }

            }else if(imgs[i].targetId != ''&&imgs[i].targetType ==12){
              //Get.toNamed('/public/webview',arguments: data.activity[i].targetId);
              await launchUrl(Uri.parse(imgs[i].targetId), mode: LaunchMode.externalApplication,);
            }
          },);
          // Image.network(imgs[i]);
        },
        pagination: const SwiperPagination(
          // margin: EdgeInsets.all(0),
          // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            alignment:	Alignment.bottomCenter,
            builder: DotSwiperPaginationBuilder(
              color: Colors.black12,
              size: 4,
              activeSize: 5,
              activeColor:Colors.white,
            )),
        itemCount: imgs.length,
      ),
      // constraints: BoxConstraints.loose(
      //     Size(MediaQuery.of(context).size.width, defultHeight))
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
          // print('浏览器也失败了');
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
  }

}
