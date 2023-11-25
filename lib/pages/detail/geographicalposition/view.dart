import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/common/widgets/home_item_widget.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/LocationDetails.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/detail/GoodleMap/view.dart';
import 'package:lanla_flutter/pages/home/me/tab_view.dart';
import 'package:lanla_flutter/pages/home/me/view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/item.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/positioninformation.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/language/camera_picker_text_delegate.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class geographicalPage extends StatefulWidget {
  @override
  _geographicalPageState createState() => _geographicalPageState();
}

class _geographicalPageState extends State<geographicalPage> {
  final provider = Get.put(positioninformation());
  final contentProvider = Get.put(ContentProvider());
  final userController = Get.find<UserLogic>();
  final ScrollController _controller = ScrollController();
  List<HomeItem> contentList = [];
  int page = 1;
  bool isOver = false;
  bool isLoading = false;
  int pageType = 1;
  int attitude = 0;
  LocationDetails? _dataSource;
  bool delay=true;
  bool Collectpopup=false;

  @override
  void initState() {
    _init(Get.arguments);
    _controller.addListener(_listener);
    super.initState();
  }

  _init(id) async {

    _dataSource = (await provider.LocationDetails(id)) as LocationDetails?;
    print('请求map');
    print(_dataSource?.distant=='');
    if (_dataSource == null) {
      ToastInfo("位置不存在".tr);
    }
     _getData();
    setState(() {});
  }

  _listener() {
    print('11122');
    print(_controller.offset);
    print(_controller.position.maxScrollExtent);
    // 拉取下一页
    if (_controller.offset == _controller.position.maxScrollExtent) {
      _getData();
    }
  }

  _getData() async {
    if (isOver || isLoading) {
      return;
    }
    isLoading = true;
    var result = await provider.MapGetTopicContent(
        pageType == 1 ? "New" : "Hot", Get.arguments, page);
    if (result.isEmpty) {
      isOver = true;
      ToastInfo('没有更多内容了'.tr);
    }
    contentList.addAll(result);
    page++;
    isLoading = false;
    setState(() {});
  }

  _setPageType(int type) {
    if (pageType == type) {
      return false;
    }
    pageType = type;
    contentList = [];
    page = 1;
    isOver = false;
    isLoading = false;
    setState(() {});
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      body: Container(height:MediaQuery.of(context).size.height,child: Stack(
        children: [
          // Column(children: [
          //   _dataSource!=null?Expanded(
          //     child: ListView(scrollDirection: Axis.vertical,
          //         shrinkWrap: true,
          //         controller:  _controller,
          //         children:[
          //           Container(width: double.infinity,
          //             constraints: BoxConstraints(
          //                 maxHeight: 210,
          //               minHeight: 100,
          //             ),
          //             color: Color(0xff999999),
          //             // height: 210,
          //             child:  Stack(
          //               children: [
          //                 Image.network(fit: BoxFit.cover, _dataSource!.imagePath,width: double.infinity,),
          //                 Positioned(
          //                   bottom: 20,
          //                   right: 20,
          //                   child: Column(
          //                     crossAxisAlignment:CrossAxisAlignment.start,
          //                     children: [
          //                       Container(
          //                         child: Text(_dataSource!.name,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
          //                       ),
          //                       Row(
          //                         children: [
          //                           for(var i=0;i<_dataSource!.types.length;i++)
          //                             Row(
          //                               children: [
          //                                 Text(_dataSource!.types[i],style: TextStyle(color: Colors.white,fontSize: 12),),
          //                                 if(i!=_dataSource!.types.length-1)Container(decoration: BoxDecoration(
          //                                   border: Border.all(width: 0.5,color: Colors.white),
          //                                 ),
          //                                   height: 10,
          //                                   margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //                                 )
          //                               ],
          //                             )
          //                         ],
          //                       )
          //                     ],
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //           Container(
          //             padding: EdgeInsets.all(20),
          //             color: Colors.white,
          //             child: Column(
          //               children: [
          //                 Row(
          //                   children: [
          //                     Container(
          //                       width: 16,
          //                       height: 16,
          //                       child: SvgPicture.asset(
          //                         "assets/svg/kfsj.svg",
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                     SizedBox(width: 13,),
          //                     // Expanded(
          //                     //     child: _dataSource!.weekdayText.length>0?
          //                     //     Text(_dataSource!.weekdayText[0]!=null?_dataSource!.weekdayText[0]:''
          //                     //         +_dataSource!.weekdayText[1]!=null?_dataSource!.weekdayText[1]:''
          //                     //         +_dataSource!.weekdayText[2]!=null?_dataSource!.weekdayText[2]:''
          //                     //         +_dataSource!.weekdayText[3]!=null?_dataSource!.weekdayText[3]:''
          //                     //         +_dataSource!.weekdayText[4]!=null?_dataSource!.weekdayText[4]:''):Container()),
          //                     Expanded(
          //                         child: _dataSource!.weekdayText.length>0?
          //                         Text(_dataSource!.weekdayText[0]
          //                             +','+_dataSource!.weekdayText[1]
          //                             +','+_dataSource!.weekdayText[2]
          //                             +','+_dataSource!.weekdayText[3]
          //                             +','+_dataSource!.weekdayText[4],overflow: TextOverflow.ellipsis, ):Container()),
          //                     SizedBox(width: 19,),
          //                     GestureDetector(child:Row(
          //                       children: [
          //                         Text('详情'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 12),),
          //                         Container(
          //                           width: 15,
          //                           height: 15,
          //                           child: SvgPicture.asset(
          //                             "assets/svg/xiaojt.svg",
          //                             color: Color(0xffd9d9d9),
          //                           ),
          //                         ),
          //
          //                       ],
          //                     ) ,onTap: (){
          //                       detailsBottomSheet(context);
          //                     },)
          //
          //                   ],
          //                 ),
          //                 SizedBox(height: 24,),
          //                 Row(
          //                   children: [
          //                     Container(
          //                       width: 16,
          //                       height: 20,
          //                       child: SvgPicture.asset(
          //                         "assets/icons/publish/position.svg",
          //                         color: Colors.black,
          //                       ),
          //                     ),
          //                     SizedBox(width: 13,),
          //                     Expanded(
          //                       child: Column(
          //                         crossAxisAlignment:CrossAxisAlignment.start,
          //                         mainAxisAlignment:MainAxisAlignment.center,
          //                         children: [
          //                           Text(_dataSource!.vicinity,style: TextStyle(
          //                               fontSize: 14,
          //                               fontWeight: FontWeight.w600
          //                           ),),
          //                           if(_dataSource?.distant!='')SizedBox(height: 5,),
          //                           if(_dataSource?.distant!='')Text(_dataSource!.distant,style: TextStyle(
          //                               fontSize: 12,
          //                               color: Color(0xff999999)
          //                           )),
          //                         ],
          //                       ),
          //                     ),
          //                     SizedBox(width: 13,),
          //                     GestureDetector(child:Image.asset('assets/images/dingwei.png',width: 24,height: 24,),onTap: (){
          //                       print('sdjaksd');
          //                       Get.to(MapSample(),arguments: {'lat':_dataSource!.lat,'lng':_dataSource!.lng});
          //                     },),
          //                     SizedBox(width: 13,),
          //                     if(_dataSource!.phone!='')GestureDetector(child: Image.asset('assets/images/dianhuaxiao.png',width: 24,height: 24,),onTap: (){
          //                       _makePhoneCall(_dataSource!.phone);
          //                     },)
          //                   ],
          //                 )
          //               ],
          //             ),
          //           ),
          //           Divider(height: 1.0,color: Color(0xffe4e4e4),),
          //           SizedBox(height: 15,),
          //           Row(
          //             children: [
          //               SizedBox(width: 20,),
          //               GestureDetector(child: Text('最新'.tr,style: TextStyle(
          //                   fontSize: 14,
          //                   fontWeight:
          //                   pageType == 1 ? FontWeight.w600 : FontWeight.w500,
          //                   color: pageType == 1 ? Colors.black : Colors.black38)),onTap: (){
          //                 _setPageType(1);
          //               },),
          //               SizedBox(width: 15,),
          //               GestureDetector(child:Text('最热'.tr,style: TextStyle(
          //                   fontSize: 15,
          //                   fontWeight:
          //                   pageType == 2 ? FontWeight.w600 : FontWeight.w600,
          //                   color: pageType == 2 ? Colors.black : Colors.black38),),onTap: (){
          //                 _setPageType(2);
          //               },),
          //             ],
          //           ),
          //           SizedBox(height: 15,),
          //           MasonryGridView.count(
          //             shrinkWrap: true,
          //             physics: new NeverScrollableScrollPhysics(),
          //             crossAxisCount: 2,
          //             mainAxisSpacing: 0,
          //             // 上下间隔
          //             crossAxisSpacing: 0,
          //             //左右间隔
          //             padding: const EdgeInsets.all(2),
          //             // 总数
          //             itemCount: contentList.length,
          //             itemBuilder: (context, index) {
          //               return IndexItemWidget(
          //                 contentList[index],
          //                 index,
          //                 userController.getLike(contentList[index].id),
          //                     (index) {
          //                   bool status = userController.setLike(contentList[index].id);
          //                   status ? contentList[index].likes++ : contentList[index].likes--;
          //                   setState(() {});
          //                 },
          //                 false,
          //                 ApiType.topicHot,
          //                 "1",
          //                 isLoading: false,
          //                     () {},
          //               );
          //             },
          //           ),
          //
          //         ]),
          //   )
          //       :Expanded(
          //       child: Container(
          //         padding: EdgeInsets.only(top: 80),
          //         child: SpinKitCircle(
          //           itemBuilder: (BuildContext context, int index) {
          //             return Container(
          //               decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(40)),
          //             );
          //           },
          //         ),
          //       )),
          // ],),
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            bottom: 60,
            child: _dataSource!=null?
            ListView(scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller:  _controller,
                children:[
                  Container(width: double.infinity,
                    constraints: const BoxConstraints(
                      maxHeight: 210,
                      minHeight: 100,
                    ),
                    color: const Color(0xff999999),
                    // height: 210,
                    child:  Stack(
                      children: [
                        Image.network(fit: BoxFit.cover, _dataSource!.imagePath,width: double.infinity,),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(_dataSource!.name,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),),
                              ),
                              Row(
                                children: [
                                  for(var i=0;i<_dataSource!.types.length;i++)
                                    Row(
                                      children: [
                                        Text(_dataSource!.types[i],style: const TextStyle(color: Colors.white,fontSize: 12),),
                                        if(i!=_dataSource!.types.length-1)Container(decoration: BoxDecoration(
                                          border: Border.all(width: 0.5,color: Colors.white),
                                        ),
                                          height: 10,
                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        )
                                      ],
                                    )
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    color: Colors.white,
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              child: SvgPicture.asset(
                                "assets/svg/kfsj.svg",
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 13,),
                            // Expanded(
                            //     child: _dataSource!.weekdayText.length>0?
                            //     Text(_dataSource!.weekdayText[0]!=null?_dataSource!.weekdayText[0]:''
                            //         +_dataSource!.weekdayText[1]!=null?_dataSource!.weekdayText[1]:''
                            //         +_dataSource!.weekdayText[2]!=null?_dataSource!.weekdayText[2]:''
                            //         +_dataSource!.weekdayText[3]!=null?_dataSource!.weekdayText[3]:''
                            //         +_dataSource!.weekdayText[4]!=null?_dataSource!.weekdayText[4]:''):Container()),
                            Expanded(
                                child: _dataSource!.weekdayText.isNotEmpty?
                                Text('${_dataSource!.weekdayText[0]},${_dataSource!.weekdayText[1]},${_dataSource!.weekdayText[2]},${_dataSource!.weekdayText[3]},${_dataSource!.weekdayText[4]}',overflow: TextOverflow.ellipsis, ):Container()),
                            const SizedBox(width: 19,),
                            GestureDetector(child:Row(
                              children: [
                                Text('详情'.tr,style: const TextStyle(color: Color(0xff999999),fontSize: 12),),
                                Container(
                                  width: 15,
                                  height: 15,
                                  child: SvgPicture.asset(
                                    "assets/svg/xiaojt.svg",
                                    color: const Color(0xffd9d9d9),
                                  ),
                                ),

                              ],
                            ) ,onTap: (){
                              detailsBottomSheet(context);
                            },)

                          ],
                        ),
                        const SizedBox(height: 24,),
                        Row(
                          children: [
                            Container(
                              width: 16,
                              height: 20,
                              child: SvgPicture.asset(
                                "assets/icons/publish/position.svg",
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 13,),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:CrossAxisAlignment.start,
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [
                                  Text(_dataSource!.vicinity,style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600
                                  ),),
                                  if(_dataSource?.distant!='')const SizedBox(height: 5,),
                                  if(_dataSource?.distant!='')Text(_dataSource!.distant,style: const TextStyle(
                                      fontSize: 12,
                                      color: Color(0xff999999)
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(width: 13,),
                            GestureDetector(child:Image.asset('assets/images/dingwei.png',width: 24,height: 24,),onTap: (){
                              print('sdjaksd');
                              Get.to(MapSample(),arguments: {'lat':_dataSource!.lat,'lng':_dataSource!.lng});
                            },),
                            const SizedBox(width: 13,),
                            if(_dataSource!.phone!='')GestureDetector(child: Image.asset('assets/images/dianhuaxiao.png',width: 24,height: 24,),onTap: (){
                              _makePhoneCall(_dataSource!.phone);
                            },)
                          ],
                        )
                      ],
                    ),
                  ),
                  const Divider(height: 1.0,color: Color(0xffe4e4e4),),
                  const SizedBox(height: 15,),
                  Row(
                    children: [
                      const SizedBox(width: 20,),
                      GestureDetector(child: Text('最新'.tr,style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                          pageType == 1 ? FontWeight.w600 : FontWeight.w500,
                          color: pageType == 1 ? Colors.black : Colors.black38)),onTap: (){
                        _setPageType(1);
                      },),
                      const SizedBox(width: 15,),
                      GestureDetector(child:Text('最热'.tr,style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          pageType == 2 ? FontWeight.w600 : FontWeight.w600,
                          color: pageType == 2 ? Colors.black : Colors.black38),),onTap: (){
                        _setPageType(2);
                      },),
                    ],
                  ),
                  const SizedBox(height: 15,),
                  MasonryGridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    // 上下间隔
                    crossAxisSpacing: 0,
                    //左右间隔
                    padding: const EdgeInsets.all(2),
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
                        isLoading: false,
                            () {},
                      );
                    },
                  ),

                ]):Container(
              padding: const EdgeInsets.only(top: 80),
              child: SpinKitCircle(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(40)),
                  );
                },
              ),
            ),
          ),

          Positioned(
            top: 50,
            right: 20,
            child: GestureDetector(child: Container(
              width: 19,
              height: 22,
              child: SvgPicture.asset(
                "assets/svg/youjiantou.svg",
                color: _dataSource!=null?Colors.white:Colors.black,
              ),
            ),onTap: (){
              Get.back();
            },),
          ),

          if(_dataSource!=null)Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: _dataSource!=null&&_dataSource?.type!=1?Container(
              padding: const EdgeInsets.only(top: 16,bottom: 16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/xiangqu.svg',width: 19,height: 17,color: _dataSource?.type==2?const Color(0xff999999):Colors.black,),
                      const SizedBox(width: 10,),
                      Text(_dataSource?.type==2?'已想去'.tr:'想去'.tr,style: TextStyle(color: _dataSource?.type==2?const Color(0xff999999):Colors.black),),
                    ],
                  ),onTap: () async {
                    if(_dataSource?.type!=2&&delay){
                      print('cjifa');
                      delay=false;
                      var result = await provider.Addressevaluation(Get.arguments,2,0);
                      if(result.statusCode==200){
                        setState(() {
                          delay=true;
                          _dataSource?.type=2;
                          Collectpopup=true;
                          _dataSource!.addressGradeId=result.body['addressGradeId'];
                          Timer.periodic(
                              const Duration(milliseconds: 2000),(timer){
                            setState(() {
                              Collectpopup=false;
                            });

                          }
                          );

                        });

                      }
                      delay=true;
                    }else if(_dataSource?.type==2&&delay){
                        delay=false;
                        var result = await provider.delressevaluation(_dataSource!.addressGradeId);
                        if(result.statusCode==200){
                          setState(() {
                            delay=true;
                            _dataSource?.type=0;
                          });
                          // Navigator.pop(context);
                        }
                        delay=true;
                    }
                  },),
                  Container(height: 20,width: 1,color: Colors.black,),
                  GestureDetector(child:Row(
                    children: [
                      SvgPicture.asset('assets/svg/daka.svg',width: 17,height: 17,color: Colors.black,),
                      const SizedBox(width: 10,),
                      Text('打卡去过'.tr),

                    ],
                  ),onTap: (){
                    evaluateBottomSheet(context,Get.arguments);
                  },)
                ],
              ),
            ):Container(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
              color: Colors.white,
              child: Row(
                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(child:Row(
                    children: [
                      if(_dataSource?.grade==3)Image.asset('assets/images/buhao.png',width: 22,height: 22,),
                      if(_dataSource?.grade==2)Image.asset('assets/images/yiban.png',width: 22,height: 22,),
                      if(_dataSource?.grade==1)Image.asset('assets/images/tuijian.png',width: 22,height: 22,),
                      const SizedBox(width: 5,),
                      if(_dataSource?.grade==3)Text('不好'.tr),
                      if(_dataSource?.grade==2)Text('一般'.tr),
                      if(_dataSource?.grade==1)Text('推荐'.tr),
                      const SizedBox(width: 5,),
                      const Text('2022-11-25',textAlign: TextAlign.center,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                    ],
                  ) ,onTap: (){
                    print('8877663322');
                    print(_dataSource?.type);
                    evaluateBottomSheet(context,Get.arguments);
                  },),
                  GestureDetector(child: Container(
                    padding: const EdgeInsets.fromLTRB(30, 12, 30, 12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      color: Colors.black,
                    ),
                    child: Text('发布作品'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600),
                    ),
                  ),onTap: (){
                    _publish();
                  },)
                ],
              ),
            ),
          ),


          ///收藏弹窗
          if(_dataSource!=null&&Collectpopup)Positioned(
            bottom: 50,
            right: 20,
            left: 20,
            child: Container(

              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Container(width: 40,height: 40,color: Colors.red,),
                      Image.network(fit: BoxFit.cover, _dataSource!.imagePath,width: 40,height: 40,),
                      const SizedBox(width: 10,),
                      Container(child:Column(
                        crossAxisAlignment:CrossAxisAlignment.start,
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Text('收藏成功'.tr,style: const TextStyle(color: Colors.white)),
                          Text('请到个人收藏夹查看'.tr,style: const TextStyle(color: Colors.white,fontSize: 12))
                        ],
                      ) ,height: 40,)

                    ],
                  ),
                  GestureDetector(child: Row(
                    children: [
                      Text('点击查看'.tr,style: const TextStyle(color: Colors.white,fontSize: 12),),
                      const SizedBox(width: 10,),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 10,
                      ),

                    ],
                  ),onTap: (){
                    Get.to(MePage(),arguments: {"shou":1});
                  },)
                ],
              ),
            ),
          ),
        ],
      ),),

    );


  }
  _publish() {
   var topicObject = {
      "name": _dataSource!.name,
      "placeId": _dataSource!.placeId,
    };

    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-camera');
              Get.back();
              final AssetEntity? result = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: const CameraPickerConfig(
                    textDelegate: ArabCameraPickerTextDelegate(),
                    enableRecording: true,
                    shouldAutoPreviewVideo: true),
              );
              // 选择图片后跳转到发布页
              if (result != null) {
                Get.toNamed('/verify/publish', arguments: {"asset": result,"address": topicObject});
              }
              print('退出页面');
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '拍摄'.tr,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-picker');
              Get.back();
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                    textDelegate: ArabicAssetPickerTextDelegate()),
              );
              // 选择图片后跳转到发布页
              if (result != null && result.isNotEmpty) {
                Get.toNamed('/verify/publish',
                    arguments: {"asset": result, "address": topicObject});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                '从相册选择'.tr,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          Container(
            color: Colors.black12,
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              height: 70,
              color: Colors.white,
              child: Center(
                child: Text(
                  '取消'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }

  ///底部弹窗
  void detailsBottomSheet(context) {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag:true,
        // isDismissible:false,
        builder: (BuildContext context) {
          //构建弹框中的内容
          return Container(
              height: _dataSource!.text!=''?MediaQuery.of(context).size.height - 250:MediaQuery.of(context).size.height - 350,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0))
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8,),
                  Container(
                    width: 25,
                    height: 3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10),),
                      color: Color(0xffe4e4e4)
                    ),
                  ),
                  const SizedBox(height: 30,),
                  Container(margin: const EdgeInsets.only(left: 20,right: 20),width:double.infinity,child: Text('开放时间'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
                  const SizedBox(height: 10,),
                  for(var item in _dataSource!.weekdayText)
                    Container(margin: const EdgeInsets.only(left: 20,right: 20,bottom: 10),width:double.infinity,child: Text(item,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),),),
                  const SizedBox(height: 30,),
                  if(_dataSource!.phone!='')Container(margin: const EdgeInsets.only(left: 20,right: 20),width:double.infinity,child: Text('联系电话'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
                  const SizedBox(height: 10,),
                  if(_dataSource!.phone!='')Container(margin: const EdgeInsets.only(left: 20,right: 20,),width:double.infinity,child: Text(_dataSource!.phone,style: const TextStyle(fontSize: 12,color: Color(0xff999999)),),),
                  const SizedBox(height: 30,),
                  if(_dataSource!.text!='')Container(margin: const EdgeInsets.only(left: 20,right: 20),width:double.infinity,child: Text('简介'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),),
                  const SizedBox(height: 10,),
                  if(_dataSource!.text!='')Container(margin: const EdgeInsets.only(left: 20,right: 20,),width:double.infinity,child: Text(_dataSource!.text,style: const TextStyle(fontSize: 12,color: Color(0xff999999),height: 1.6,), maxLines: 5,overflow: TextOverflow.ellipsis,),),
                ],
              )

          );
        },
        backgroundColor: Colors.transparent, //重要
        context: context).then((value){
    });
  }

  ///评价弹窗
  void evaluateBottomSheet(context,id) {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        isScrollControlled: false,
        enableDrag:true,
        // isDismissible:false,
        builder: (BuildContext context,) {
          //构建弹框中的内容
          return StatefulBuilder(
            builder: (context1, setBottomSheetState){
              return Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height - 450,
                  ),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0))
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8,),
                      Container(
                        width: 25,
                        height: 3,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10),),
                            color: Color(0xffe4e4e4)
                        ),
                      ),
                      const SizedBox(height: 25,),
                      Text('表达一下你的态度'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),
                      const SizedBox(height: 25,),
                      const Divider(height: 1.0,color: Color(0xfff5f5f5),),
                      const SizedBox(height: 25,),
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(child:Column(
                            children: [
                              Container(decoration: BoxDecoration(
                                border: Border.all(width: 3,color: attitude==1?Colors.black:Colors.white),
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                              ),child:Image.asset('assets/images/tuijian.png',width: 50,height: 50,),),

                              const SizedBox(height: 15,),
                              Text('推荐'.tr)
                            ],
                          ) ,onTap: (){
                            print('1111');
                            setBottomSheetState(() {
                              attitude=1;
                            });
                          },),
                          GestureDetector(child:Column(
                            children: [
                              Container(decoration: BoxDecoration(
                                border: Border.all(width: 3,color: attitude==2?Colors.black:Colors.white),
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                              ),child:Image.asset('assets/images/yiban.png',width: 50,height: 50,),),
                              const SizedBox(height: 15,),
                              Text('一般'.tr)
                            ],
                          ) ,onTap: (){
                            setBottomSheetState(() {
                              attitude=2;
                            });
                          },),
                          GestureDetector(child:Column(
                            children: [
                              Container(decoration: BoxDecoration(
                                border: Border.all(width: 3,color: attitude==3?Colors.black:Colors.white),
                                borderRadius: const BorderRadius.all(Radius.circular(50)),
                              ),child:Image.asset('assets/images/buhao.png',width: 50,height: 50,),),
                              const SizedBox(height: 15,),
                              Text('不好'.tr)
                            ],
                          ) ,onTap: (){
                            setBottomSheetState(() {
                              attitude=3;
                            });
                          },)
                        ],
                      ),
                      if(attitude!=0||_dataSource?.type==1)const SizedBox(height: 25,),
                      if(attitude!=0&&_dataSource?.type!=1)Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(child:Container(
                            alignment: Alignment.center,//设置控件内容的位置
                            width: 150,
                            padding: const EdgeInsets.only(top: 15,bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.black),
                                color: Colors.black,
                                borderRadius: const BorderRadius.all(Radius.circular(50),)
                            ),
                            child: Text('发布作品'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,),),
                          ),onTap: (){
                            _publish();
                          },),
                          GestureDetector(child: Container(
                            alignment: Alignment.center,//设置控件内容的位置
                            width: 150,
                            padding: const EdgeInsets.only(top: 15,bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.black),
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(50),)
                            ),
                            child: Text('完成'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),
                          ),onTap: () async {
                            if(attitude!=0&&delay){

                              delay=false;
                              var result = await provider.Addressevaluation(id,1,attitude);
                              if(result.statusCode==200){
                                setState(() {
                                  delay=true;
                                  _dataSource?.type=1;
                                  _dataSource?.grade=attitude;
                                  _dataSource!.addressGradeId=result.body['addressGradeId'];
                                });
                                print('889955');
                                print(_dataSource?.grade);
                                Navigator.pop(context);
                              }
                              delay=true;
                            }
                          },)
                        ],
                      ),
                      if(_dataSource?.type==1)Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(child: Container(
                            alignment: Alignment.center,//设置控件内容的位置
                            width: 150,
                            padding: const EdgeInsets.only(top: 15,bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.black),
                                color: Colors.black,
                                borderRadius: const BorderRadius.all(Radius.circular(50),)
                            ),
                            child: Text('完成'.tr,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.w600,),),
                          ),onTap: () async {
                            if(attitude!=0&&delay){

                              delay=false;
                              var result = await provider.Addressevaluation(id,1,attitude);
                              if(result.statusCode==200){
                                setState(() {
                                  delay=true;
                                  _dataSource?.type=1;
                                  _dataSource?.grade=attitude;
                                  _dataSource!.addressGradeId=result.body['addressGradeId'];
                                });
                                print('889955');
                                print(_dataSource?.grade);
                                Navigator.pop(context);
                              }
                              delay=true;
                            }
                          },),
                          GestureDetector(child: Container(
                            alignment: Alignment.center,//设置控件内容的位置
                            width: 150,
                            padding: const EdgeInsets.only(top: 15,bottom: 15),
                            decoration: BoxDecoration(
                                border: Border.all(width: 1,color: Colors.black),
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(50),)
                            ),
                            child: Text('删除态度'.tr,style: const TextStyle(fontWeight: FontWeight.w600),),
                          ),onTap: () async {
                            if(_dataSource?.type==1&&delay){
                              delay=false;
                              var result = await provider.delressevaluation(_dataSource!.addressGradeId);
                              if(result.statusCode==200){
                                setState(() {
                                  delay=true;
                                  _dataSource?.type=0;
                                  _dataSource?.grade=0;
                                });
                                Navigator.pop(context);
                              }
                              delay=true;
                              Toast.toast(context,msg: "你对此标签的态度已删除".tr,position: ToastPostion.center);
                            }
                          },)
                        ],
                      ),
                    ],
                  )

              );
            }
          );
        },
        backgroundColor: Colors.transparent, //重要
        context: context).then((value){
          setState(() {
            print('1122233');
            if(_dataSource?.type!=1){
              attitude=0;
            }
          });


    });
  }

  ///打电话
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}


