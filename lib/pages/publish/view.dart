import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:audio_session/audio_session.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
// import 'package:extended_text_field/extended_text_field.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/IOSpopup.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/button_black.dart';
import 'package:lanla_flutter/models/UsersAndUser.dart';
import 'package:lanla_flutter/pages/publish/ceshu.dart';
import 'package:lanla_flutter/pages/publish/commodity.dart';
import 'package:lanla_flutter/pages/publish/lydome.dart';
import 'package:lanla_flutter/pages/publish/state.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/ulits/aliyun_oss/client.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../models/ChannelList.dart';
import '../home/Pricecomparison/view.dart';
import '../home/start/list_widget/list_logic.dart';
import 'package:intl/intl.dart' show DateFormat;



// import 'package:extended_text_field/extended_text_field.dart';
// import 'package:flutter/material.dart';


import 'Shop/view.dart';
/**
 * 发布作品总页面
 */
import 'logic.dart';

class PublishPage extends StatefulWidget {
  @override
  PublishState createState() => PublishState();

}

class PublishState extends State<PublishPage> with WidgetsBindingObserver {


  //TextEditingController selectionController = TextEditingController();
  final logic = Get.find<PublishLogic>();
  final startLogic = Get.find<StartListLogic>();
  final state = Get
      .find<PublishLogic>()
      .state;
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();
  var Check = false;
  var Friendspage=1;

  final TextEditingController _textEditingController = TextEditingController();
  ///初始化播放器
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  NewesProvider providerFriends =  Get.put(NewesProvider());
  final userController = Get.find<UserLogic>();
  final myKey = GlobalKey();
  final AppBarheight = GlobalKey();
  final _controller = ScrollController();
  ///@列表
  var Friendsdisplay=false;
  var Friendlist=[];
  ///#监听和列表
  var subjectplay=false;
  var subjectlist=[];

  void initState() {
    super.initState();
    Check = false;
    init();
    MyfollowList(userController.userId);
    // 添加监听
    WidgetsBinding.instance?.addObserver(this);
  }
  ///@列表
  Future<void> MyfollowList(userId) async {
    var result = await providerFriends.Myfollowinterface(userId,Friendspage);
    if(result.statusCode==200){
      Friendlist =UserandUserFromJson(result?.bodyString ?? "");
      setState(() {});
    }
  }

  ///注销页面
  @override
  void dispose() {
    super.dispose();
    logic.releaseFlauto();
    _stopPlayer();
    _textEditingController.dispose();
  }


  final InputDecoration decoration = const InputDecoration(
    prefixIcon: Icon(Icons.image),
    prefixText: '# ',
    hintText: '请输入内容',
  );


  ///页面进入后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        _stopPlayer();
        break;
    }
  }

  init() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    // await playerModule
    //     .setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  /// 开始播放
  Future<void> _startPlayer(_path) async {
    try {
      if (await logic.fileExists()) {
        await playerModule.startPlayer(
            fromURI: _path,
            codec: Codec.aacADTS,
            whenFinished: () {
              // print('==> 结束播放');
              _stopPlayer();
              setState(() {});
            });
      } else {
        ToastInfo('音频加载失败'.tr);
      }
      // print('===> 开始播放');
    } catch (err) {
      // print('==> 错误: $err');
    }
    setState(() {});
  }

  ///结束播放
  Future<void> _stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      state.Startplaying = false;
      logic.update();
      // print('===> 结束播放');
      //_cancelPlayerSubscriptions();
    } catch (err) {
      // print('==> 错误: $err');
    }
    // setState(() {
    //   _state = RecordPlayState.play;
    // });
  }

  /// 暂停/继续播放
  void _pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();

      ///暂停
      state.AudioPause = true;
      logic.update();
      // _state = RecordPlayState.play;
      // print('===> 暂停播放');
    } else {
      playerModule.resumePlayer();
      state.AudioPause = false;
      // _state = RecordPlayState.playing;
      // print('===> 继续播放');
    }
    setState(() {});
  }

  ///删除录音
  void Recordingdeletion() {
    _stopPlayer();
    logic.releaseFlauto();
    logic.releaseFlautosc();
    setState(() {});
  }

  //final AssetEntity? entity = await CameraPicker.pickFromCamera(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        key:AppBarheight,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              ///草稿箱返回
              // showDialog(
              //     barrierDismissible: true,//是否点击空白区域关闭对话框,默认为true，可以关闭
              //     context: context,
              //     builder: (BuildContext context) {
              //       var list = [];
              //       list.add('保存并退出'.tr);
              //       list.add('退出'.tr);
              //       return BottomSheetWidget(
              //         list: list,
              //         onItemClickListener: (index) async {
              //           print(index);
              //           if(index==1){
              //             // Navigator.of(context).pop();
              //             Get.back();
              //             Get.back();
              //           }
              //           if(index==0){
              //             // Navigator.of(context).pop();
              //             ///保存作品
              //             logic.SaveContent();
              //           }
              //           //Navigator.pop(context);
              //         },
              //       );
              //     });
            },
            // icon: Image.asset(
            //   'images/ic_back_black.png',
            //   width: 25,
            //   height: 25,
            //   color: Colors.white,
            // ),
            icon: SvgPicture.asset(
              "assets/icons/fanhui.svg",
            ),
          ),
        actions: [
// <<<<<<< HEAD
          GestureDetector(child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: const Icon(
              Icons.info_outline,
              color: Colors.black12,
              size: 28,
            ),
          ), onTap: () {
            Get.defaultDialog(titlePadding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                content:
                Container(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LanLa鼓励向上、真实、原创的内容，含以下内容的笔记将不会被推荐：'.tr),
                    const SizedBox(height: 10,),
                    Text('1．含有不文明语言、过度性感图片；'.tr),
                    const SizedBox(height: 10,),
                    Text('2．含有网址链接、联系方式、二维码或售卖语言；'.tr),
                    const SizedBox(height: 10,),
                    Text('3．冒充他人身份或搬运他人作品；'.tr),
                    const SizedBox(height: 10,),
                    Text('4．为刻意博取眼球，在标题、封面等处使用夸张表达'.tr),
                  ],
                ), padding: const EdgeInsets.fromLTRB(0, 10, 20, 10),),
                confirm: Column(children: [
                  ElevatedButton(onPressed: () {
                    Get.back();
                  },
                    child: Text(
                      "我知道了".tr, style: const TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color(0xff000000)), //背景颜色
                    ),),
                  const SizedBox(height: 20,),
                ],),
                title: '发布小贴士'.tr,
                titleStyle: const TextStyle(fontSize: 16));
          },)
// =======
        ],
      ),
      body: Container(color: Colors.white, child:
      // KeyboardActions(
      //   config: KeyboardActionsConfig(
      //       keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      //       keyboardBarColor: Colors.white,
      //       nextFocus: true,
      //       defaultDoneWidget: Text("完成".tr),
      //       actions: [
      //         KeyboardActionsItem(
      //           focusNode: _nodeText1,
      //         ),
      //         KeyboardActionsItem(
      //           focusNode: _nodeText2,
      //         ),
      //       ]),
      //   child:
      //   SingleChildScrollView(
      //     controller: _controller,
      //     child: Container(
      //       padding: EdgeInsets.all(15),
      //       child: Column(
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           GetBuilder<PublishLogic>(builder: (logic) {
      //             return Container(
      //                 height: logic.state.type == PublishType.video ? 200 : 100,
      //                 child: logic.state.type == PublishType.video
      //                     ? _videoBox(context)
      //                     : ReorderableListView(
      //                   scrollDirection: Axis.horizontal,
      //                   onReorder: (int oldIndex, int newIndex) {
      //                     logic.onReorder(oldIndex, newIndex);
      //                   },
      //                   children: _foreachList(),
      //                 ));
      //           }),
      //           Container(
      //             key: myKey,
      //             height: 10,
      //           ),
      //           GetBuilder<PublishLogic>(
      //             assignId: true,
      //             builder: (logic) {
      //               return Row(
      //                 children: [
      //                   logic.state.type == PublishType.picture
      //                       ? GestureDetector(
      //                     onTap: () {
      //                       logic.addImages(context);
      //                     },
      //                     child: Container(
      //                       color: HexColor('f6f6f6'),
      //                       padding: const EdgeInsets.only(
      //                           left: 10, right: 10, top: 5, bottom: 5),
      //                       child: Row(
      //                         children: [
      //                           const Icon(
      //                             Icons.add_circle_outline,
      //                             size: 12,
      //                           ),
      //                           Container(
      //                             width: 3,
      //                           ),
      //                           Text(
      //                             '添加图片'.tr,
      //                             style: TextStyle(fontSize: 12),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //                       : GestureDetector(
      //                     onTap: () {
      //                       Get.toNamed('/verify/publishPreview',
      //                           arguments: state.videoPath);
      //                     },
      //                     child: Container(
      //                       color: HexColor('f6f6f6'),
      //                       padding: EdgeInsets.only(
      //                           left: 10, right: 10, top: 5, bottom: 5),
      //                       child: Row(
      //                         children: [
      //                           Icon(
      //                             Icons.play_circle,
      //                             size: 12,
      //                           ),
      //                           Container(
      //                             width: 3,
      //                           ),
      //                           Text(
      //                             '预览视频'.tr,
      //                             style: TextStyle(fontSize: 12),
      //                           ),
      //                         ],
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               );
      //             },
      //           ),
      //           Container(
      //
      //             margin: EdgeInsets.only(top: 15, bottom: 10),
      //             child: TextField(
      //               //控制大小写
      //
      //               textCapitalization: TextCapitalization.none,
      //               focusNode: _nodeText1,
      //               decoration: InputDecoration(
      //                 hintText: "写标题会得到更多赞哦".tr,
      //                 hintStyle: TextStyle(color: Colors.black12),
      //                 enabledBorder: UnderlineInputBorder(
      //                   borderSide: BorderSide(color: HexColor('efefef')),
      //                 ),
      //                 focusedBorder: UnderlineInputBorder(
      //                   borderSide: BorderSide(color: Colors.black12),
      //                 ),
      //               ),
      //               onChanged: (v) {
      //                 logic.setFrom('title', v);
      //                 print('输入${v}');
      //               },
      //             ),
      //           ),
      //           Container(
      //             margin: EdgeInsets.only(
      //               bottom: 10,
      //             ),
      //             child:
      //             TextField(
      //               focusNode: _nodeText2,
      //               controller: _textEditingController,
      //               maxLines: 6,
      //               style: TextStyle(fontSize: 16, color: Colors.black38),
      //               //控制大小写
      //               textCapitalization: TextCapitalization.none,
      //               decoration: InputDecoration(
      //                 hintText: "说说你此刻的心情".tr,
      //                 hintStyle: const TextStyle(color: Colors.black12),
      //                 enabledBorder: UnderlineInputBorder(
      //                   borderSide: BorderSide(color: HexColor('efefef')),
      //                 ),
      //                 focusedBorder: UnderlineInputBorder(
      //                   borderSide: BorderSide(color: Colors.black12),
      //                 ),
      //               ),
      //               onChanged: (v) {
      //
      //                 logic.setFrom('text', v);
      //
      //                 final atIndex = v.contains("@");
      //
      //                 //final spaceIndex = v.indexOf(' ', atIndex);
      //                 // if (atIndex != -1 && spaceIndex != -1) {
      //                 //   final atText = v.substring(atIndex, spaceIndex);
      //                 //   debugPrint(atText);
      //                 //   print('输入123${atText}');
      //                 // }
      //                 if (atIndex) {
      //                   Friendsdisplay=true;
      //                   Future.delayed(Duration(milliseconds: 100), () {
      //                     final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      //                     if (keyboardHeight == 0) return; // Keyboard closed
      //                     _controller.animateTo(
      //                       _controller.position.maxScrollExtent,
      //                       duration: Duration(milliseconds: 300),
      //                       curve: Curves.easeOut,
      //                     );
      //                   });
      //                 }else {
      //                   Friendsdisplay=false;
      //                 }
      //                 if(v.endsWith(" ") && Friendsdisplay) {
      //                   print('结束了');
      //                   Friendsdisplay=false;
      //                 }
      //                 print('结尾${v.endsWith(" ")}');
      //                 print('展示${v.contains("@")}');
      //                 print('输入${v}');
      //                 setState(() {});
      //               },
      //             ),
      //           ),
      //           if(Friendsdisplay)GestureDetector(child:Container(width: double.infinity,child: Text('11111112222'),height: 80,color: Colors.red,),onTap: (){
      //            Get.to(KeyboardScrollDemo());
      //            // final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      //            // if (keyboardHeight == 0) return; // Keyboard closed
      //            // _controller.animateTo(
      //            //   _controller.position.maxScrollExtent,
      //            //   duration: Duration(milliseconds: 300),
      //            //   curve: Curves.easeOut,
      //            // );
      //            // final RenderBox renderBox = myKey.currentContext?.findRenderObject() as RenderBox;
      //            // final RenderBox appbarBox = AppBarheight.currentContext?.findRenderObject() as RenderBox;
      //            // final position = renderBox.localToGlobal(Offset.zero);
      //            // print('偏移量${appbarBox.size.height}');
      //            //_controller.animateTo(position.dy-appbarBox.size.height, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      //             // _textEditingController.text=_textEditingController.text+'1353';
      //           },),
      //
      //
      //
      //           ///录音
      //           GetBuilder<PublishLogic>(
      //               assignId: true,
      //               builder: (logic) {
      //                 print('类型');
      //                 print(logic.state.type);
      //                 if (logic.state.type == PublishType.video) {
      //                   return Container();
      //                 }
      //                 return SizedBox(
      //                   height: 60,
      //                   child: Row(
      //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                     children: [
      //                       GetBuilder<PublishLogic>(builder: (logic) {
      //                         return Expanded(
      //                           flex: 1,
      //                           child: Row(
      //                             children: [
      //                               SvgPicture.asset(
      //                                 "assets/icons/publish/mac.svg",
      //                                 color: logic.state
      //                                     .formData["recorderpath"] != ''
      //                                     ? Colors.black
      //                                     : Color(0xffe4e4e4),
      //                               ),
      //                               const SizedBox(
      //                                 width: 10,
      //                               ),
      //                               logic.state.formData["recorderpath"] != ''
      //                                   ? Expanded(
      //                                 flex: 1,
      //                                 child: Container(
      //                                   decoration: BoxDecoration(
      //                                     borderRadius:
      //                                     BorderRadius.circular(40),
      //                                     color: Colors.red,
      //                                     gradient: const LinearGradient(
      //                                         begin:
      //                                         Alignment.centerRight,
      //                                         end: Alignment.centerLeft,
      //                                         colors: [
      //                                           Color(0xff474747),
      //                                           Color(0xff171717),
      //                                           Color(0xff0B0000),
      //                                         ]),
      //                                   ),
      //                                   // width: double.infinity,
      //                                   height: 36,
      //                                   child: Row(
      //                                     children: [
      //                                       const SizedBox(
      //                                         width: 20,
      //                                       ),
      //
      //                                       ///开始图片
      //                                       GestureDetector(
      //                                         child: Container(
      //                                           child: state.AudioPause ||
      //                                               !state
      //                                                   .Startplaying
      //                                               ? Image.asset(
      //                                             'assets/images/kaily.png',
      //                                             width: 20,
      //                                             height: 20,
      //                                           )
      //                                               : Image.asset(
      //                                             'assets/images/bfzanting.png',
      //                                             width: 20,
      //                                             height: 20,
      //                                           ),
      //                                         ),
      //                                         onTap: () {
      //                                           if (!state.Startplaying) {
      //                                             state.Startplaying =
      //                                             true;
      //                                             logic.update();
      //                                             _startPlayer(logic
      //                                                 .state.formData[
      //                                             "recorderpath"]);
      //                                           } else if (state
      //                                               .Startplaying) {
      //                                             _pauseResumePlayer();
      //                                             logic.update();
      //                                           }
      //                                         },
      //                                       ),
      //                                       SizedBox(
      //                                         width: 15,
      //                                       ),
      //                                       Expanded(
      //                                         flex: 1,
      //                                         child: Container(
      //                                           height: 16,
      //                                           decoration: BoxDecoration(
      //                                               image:
      //                                               DecorationImage(
      //                                                 image: AssetImage(
      //                                                   'assets/images/yinbotwo.png',
      //                                                 ),
      //                                                 fit: BoxFit.fill,
      //                                               )),
      //                                         ),
      //                                       ),
      //                                       SizedBox(
      //                                         width: 15,
      //                                       ),
      //                                       Text(
      //                                         "${logic.state
      //                                             .formData['recordingtime']}s",
      //                                         style: TextStyle(
      //                                             fontSize: 15,
      //                                             color: Colors.white,
      //                                             fontWeight:
      //                                             FontWeight.w600),
      //                                       ),
      //                                       SizedBox(
      //                                         width: 20,
      //                                       ),
      //                                     ],
      //                                   ),
      //                                 ),
      //                               )
      //                                   : GestureDetector(
      //                                 child: Padding(
      //                                     padding: EdgeInsets.only(right: 10),
      //                                     child: Text('录音'.tr)),
      //                                 onTap: () {
      //                                   showBottomSheet(
      //                                       context,
      //                                       MediaQuery
      //                                           .of(context)
      //                                           .size
      //                                           .height);
      //                                 },
      //                               ),
      //                               SizedBox(
      //                                 width: 15,
      //                               ),
      //                               if (logic.state.formData["recorderpath"] !=
      //                                   '')
      //                                 GestureDetector(
      //                                   child: Image.asset(
      //                                     'assets/images/lyquxiao.png',
      //                                     width: 25,
      //                                     height: 25,
      //                                   ),
      //                                   onTap: () {
      //                                     Recordingdeletion();
      //                                   },
      //                                 ),
      //                               SizedBox(
      //                                 width: 40,
      //                               ),
      //                               // GestureDetector(child:Text('播放') ,onTap: (){
      //                               //   _startPlayer(logic.state.formData["recorderpath"]);
      //                               // },)
      //                             ],
      //                           ),
      //                         );
      //                       }),
      //                       // Icon(Icons.chevron_right,)
      //                     ],
      //                   ),
      //                 );
      //               }),
      //           GetBuilder<PublishLogic>(
      //               assignId: true,
      //               builder: (logic) {
      //                 print('选择话题');
      //                 print(logic.state.selectTopic);
      //                 return logic.state.type == PublishType.video
      //                     ? Container()
      //                     : const Divider(
      //                   height: 1.0,
      //                   color: Colors.black12,
      //                 );
      //               }),
      //           GetBuilder<PublishLogic>(builder: (logic) {
      //             return GestureDetector(
      //               onTap: () {
      //                 Get.toNamed('/verify/publishTopic');
      //               },
      //               child: Container(
      //                 height: 60,
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Container(
      //                       alignment: Alignment.centerRight,
      //                       width: 22,
      //                       child: SvgPicture.asset(
      //                         "assets/icons/publish/topic.svg",
      //                         color: logic.state.selectTopic.isEmpty ? Color(
      //                             0xffe4e4e4) : Colors.black,
      //                       ),
      //                     ),
      //                     Expanded(
      //                         child: SingleChildScrollView(
      //                           scrollDirection: Axis.horizontal,
      //                           child: logic.state.selectTopic.isEmpty
      //                               ? Padding(
      //                               padding: EdgeInsets.only(right: 10),
      //                               child: Text('没有选择话题'.tr))
      //                               : _TopicListWidget(logic.state.selectTopic),
      //                         )),
      //                     SizedBox(
      //                       width: 30,
      //                       child: SvgPicture.asset(
      //                         "assets/icons/publish/arrow.svg",
      //                         color: Colors.black45,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             );
      //           }),
      //           GetBuilder<PublishLogic>(
      //               assignId: true,
      //               builder: (logic) {
      //                 print('选择话题');
      //                 print(logic.state.selectTopic);
      //                 return logic.state.type == PublishType.video
      //                     ? Container()
      //                     : const Divider(
      //                   height: 1.0,
      //                   color: Colors.black12,
      //                 );
      //               }),
      //
      //           ///地理位置
      //           // GetBuilder<PublishLogic>(builder: (logic) {
      //           //   return GestureDetector(
      //           //     onTap: () {
      //           //       Get.toNamed('/verify/locationlist');
      //           //     },
      //           //     child: Container(
      //           //       height: 60,
      //           //       child: Row(
      //           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           //         children: [
      //           //           Container(
      //           //             alignment: Alignment.centerRight,
      //           //             width: 22,
      //           //             child: SvgPicture.asset(
      //           //               "assets/icons/publish/position.svg",
      //           //               color: logic.state.positioninformation
      //           //                   .toString() ==
      //           //                   '{}' ? Color(0xffe4e4e4) : Colors.black,
      //           //             ),
      //           //           ),
      //           //           Expanded(
      //           //               child:
      //           //               logic.state.positioninformation.toString() ==
      //           //                   '{}'
      //           //                   ? Padding(
      //           //                   padding: EdgeInsets.only(right: 10),
      //           //                   child: Text('添加地址'.tr))
      //           //                   : Padding(
      //           //                   padding: EdgeInsets.only(right: 10),
      //           //                   child: Text(
      //           //                     logic.state.positioninformation['name'],
      //           //                     overflow: TextOverflow.ellipsis,))
      //           //           ),
      //           //           SizedBox(
      //           //             width: 30,
      //           //             child: SvgPicture.asset(
      //           //               "assets/icons/publish/arrow.svg",
      //           //               color: Colors.black45,
      //           //             ),
      //           //           ),
      //           //         ],
      //           //       ),
      //           //     ),
      //           //   );
      //           // }),
      //           // const Divider(
      //           //   height: 1.0,
      //           //   color: Colors.black12,
      //           // ),
      //           Container(
      //             height: 60,
      //             child: Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               children: [
      //                 Container(
      //                     alignment: Alignment.centerRight,
      //                     width: 22,
      //                     child: SvgPicture.asset(
      //                       "assets/icons/publish/bilibili.svg",
      //                       color: Check ? Colors.black : Color(0xffe4e4e4),
      //                     )),
      //                 Expanded(
      //                     child: SingleChildScrollView(
      //                         scrollDirection: Axis.horizontal,
      //                         child: GetBuilder<PublishLogic>(builder: (logic) {
      //                           return Row(
      //                             children: startLogic.state.channelDataSource
      //                                 .map((ChannelList x) =>
      //                                 _channalTag(
      //                                     x.name,
      //                                     x.id,
      //                                     logic.state.formData['channel'],
      //                                     logic))
      //                                 .toList(),
      //                           );
      //                         }))),
      //               ],
      //             ),
      //           ),
      //
      //           ///关联宝贝
      //           const Divider(
      //             height: 1.0,
      //             color: Colors.black12,
      //           ),
      //           GetBuilder<PublishLogic>(builder: (logic) {
      //             return GestureDetector(
      //               onTap: () {
      //                 Get.to(commodityPage());
      //               },
      //               child: Container(
      //                 height: 60,
      //                 child: Row(
      //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                   children: [
      //                     Container(
      //                       alignment: Alignment.centerRight,
      //                       width: 18,
      //                       child: SvgPicture.asset(
      //                         "assets/svg/guanlianht.svg",
      //                         color: logic.state.positioninformation
      //                             .toString() ==
      //                             '{}' ? Color(0xffe4e4e4) : Colors.black,
      //                       ),
      //                     ),
      //                     Expanded(
      //                         child: Padding(
      //                             padding: EdgeInsets.only(right: 10),
      //                             child: Text('关联宝贝'.tr))
      //                     ),
      //                     SizedBox(
      //                       width: 30,
      //                       child: SvgPicture.asset(
      //                         "assets/icons/publish/arrow.svg",
      //                         color: Colors.black45,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             );
      //           }),
      //           Container(padding: EdgeInsets.all(10),decoration: BoxDecoration(color: Color(0xfff5f5f5),borderRadius: BorderRadius.all(Radius.circular(10))),
      //             child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [
      //               Row(children: [
      //                 Container(width: 40,height: 40,color: Colors.red,),
      //                 SizedBox(width: 5,),
      //                 Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children: [
      //                   Text('dior春季新款#999',style: TextStyle(),),
      //                   Text('dior',style: TextStyle(fontSize: 12),)
      //                 ],),
      //               ],),
      //               SvgPicture.asset(
      //                 "assets/icons/publish/arrow.svg",
      //                 color: Colors.black45,
      //               )
      //             ],),
      //           ),
      //           ///继续关联
      //           ///Container(width: 30,height: 30,margin: EdgeInsets.only(top: 10),color: Colors.red,)
      //         ],
      //       ),
      //     ),
      //   ),
      // )
      SingleChildScrollView(
        controller: _controller,
        child: Container(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GetBuilder<PublishLogic>(builder: (logic) {
                if(logic.state.formData['text']!=null){
                  _textEditingController.text=logic.state.formData['text'];
                }
                return Container(
                    height: logic.state.type == PublishType.video ? 200 : 100,
                    child: logic.state.type == PublishType.video
                        ? _videoBox(context)
                        : ReorderableListView(
                      scrollDirection: Axis.horizontal,
                      onReorder: (int oldIndex, int newIndex) {
                        logic.onReorder(oldIndex, newIndex);
                      },
                      children: _foreachList(),
                    ));
              }),
              Container(
                height: 10,
              ),
              GetBuilder<PublishLogic>(
                assignId: true,
                builder: (logic) {
                  return Row(
                    children: [
                      logic.state.type == PublishType.picture
                          ? GestureDetector(
                        onTap: () {
                          logic.addImages(context);
                        },
                        child: Container(
                          color: HexColor('f6f6f6'),
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                size: 12,
                              ),
                              Container(
                                width: 3,
                              ),
                              Text(
                                '添加图片'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                          : GestureDetector(
                        onTap: () {
                          Get.toNamed('/verify/publishPreview',
                              arguments: state.videoPath);
                        },
                        child: Container(
                          color: HexColor('f6f6f6'),
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.play_circle,
                                size: 12,
                              ),
                              Container(
                                width: 3,
                              ),
                              Text(
                                '预览视频'.tr,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                },
              ),
              ///两个输入框
              Container( key: myKey,height: 275,child:
              KeyboardActions(
                  autoScroll:false,
                  config: KeyboardActionsConfig(
                      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      keyboardBarColor: Colors.white,
                      nextFocus: true,
                      defaultDoneWidget: Text("完成".tr),
                      actions: [
                        KeyboardActionsItem(
                          focusNode: _nodeText1,
                        ),
                        KeyboardActionsItem(
                          focusNode: _nodeText2,
                        ),
                      ]),
                  child:Column(children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15,),
                      child: TextField(
                        //控制大小写
                        textCapitalization: TextCapitalization.none,
                        maxLength: 25,
                        controller: TextEditingController(text: logic.state.formData['title']),
                        focusNode: _nodeText1,
                        decoration: InputDecoration(
                          hintText: "写标题会得到更多赞哦".tr,
                          // counterText: '',
                          hintStyle: const TextStyle(color: Colors.black12),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: HexColor('efefef')),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xffF1F1F1),),
                          ),
                        ),
                        onChanged: (v) {
                          logic.setFrom('title', v);
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        bottom: 8,
                      ),
                      child:
                      TextField(
                        focusNode: _nodeText2,
                        controller: _textEditingController,
                        maxLines: 6,
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        //控制大小写
                        textCapitalization: TextCapitalization.none,
                        decoration: InputDecoration(
                          hintText: "说说你此刻的心情".tr,
                          hintStyle: const TextStyle(color: Colors.black12),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        onChanged: (v) {
                          logic.setFrom('text', v);
                          // final atIndex = v.contains("@");
                          // final subjectjt = v.contains("#");
                          // //final spaceIndex = v.indexOf(' ', atIndex);
                          // // if (atIndex != -1 && spaceIndex != -1) {
                          // //   final atText = v.substring(atIndex, spaceIndex);
                          // //   debugPrint(atText);
                          // //   print('输入123${atText}');
                          // // }
                          // if (atIndex) {
                          //   Friendsdisplay=true;
                          //   final RenderBox renderBox = myKey.currentContext?.findRenderObject() as RenderBox;
                          //   final RenderBox appbarBox = AppBarheight.currentContext?.findRenderObject() as RenderBox;
                          //   final position = renderBox.localToGlobal(Offset.zero);
                          //   print('偏移量${appbarBox.size.height}');
                          //   _controller.animateTo(position.dy-appbarBox.size.height+10, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          // }else {
                          //   Friendsdisplay=false;
                          // }
                          // if(v.endsWith(" ") && Friendsdisplay) {
                          //   print('结束了');
                          //   Friendsdisplay=false;
                          // }
                          // print('结尾${v.endsWith(" ")}');
                          // print('展示${v.contains("@")}');
                          // print('输入${v}');
                          //
                          // ///监听#号
                          // if (subjectjt) {
                          //   subjectplay=true;
                          //   final RenderBox renderBox = myKey.currentContext?.findRenderObject() as RenderBox;
                          //   final RenderBox appbarBox = AppBarheight.currentContext?.findRenderObject() as RenderBox;
                          //   final position = renderBox.localToGlobal(Offset.zero);
                          //   print('偏移量${appbarBox.size.height}');
                          //   _controller.animateTo(position.dy-appbarBox.size.height+10, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
                          // }else {
                          //   subjectplay=false;
                          // }
                          // if(v.endsWith(" ") && subjectplay) {
                          //   print('结束了');
                          //   subjectplay=false;
                          // }
// <<<<<<< HEAD
//
// =======
// >>>>>>> 02a09d24ddd38ec8a20c8813d8b6218049a8ce25
                        },
                      ),
                    ),
                  ],)),),
              ///@
              if(Friendsdisplay)
                Container(width: double.infinity,child: Column(children: [
                  //for(var i=0;i<Friendlist.length;i++)
                  Expanded(child: ListView.builder(
                      itemCount: Friendlist.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(child: Column(children: [
                          const SizedBox(height: 10,),
                          Row(children: [
                            GestureDetector(
                              onTap: () {
                                // 进入个人主页
                                // Get.toNamed('/public/user',
                                //     arguments: data.userId);
                              },
                              child: Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(35),
                                  color: Colors.black12,
                                  image: DecorationImage(
                                      image: NetworkImage(Friendlist[i].userAvatar),
                                      fit: BoxFit.cover),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10,),
                            Text(Friendlist[i].userName)
                          ],),
                          const SizedBox(height: 10,),
                          ///分割线
                          Container(
                            height: 1.0,
                            decoration: const BoxDecoration(
                              color: Color(0xfffcfafa),
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
                        ],),onTap: (){
                          _textEditingController.text='${_textEditingController.text+Friendlist[i].userName} ';
                          Friendsdisplay=false;
                          setState(() {});
                          _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                        },);
                      }
                  ))


                ],),height: 200,color: Colors.white,),
              ///#
              if(subjectplay)
                Container(width: double.infinity,child: Column(children: [
                  Expanded(child: ListView.builder(
                      itemCount: subjectlist.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(child: Column(children: [
                          const SizedBox(height: 10,),
                          Row(children: const [
                            Text('#'),
                            SizedBox(width: 10,),
                            Text('1233333')
                          ],),
                          const SizedBox(height: 10,),
                          ///分割线
                          Container(
                            height: 1.0,
                            decoration: const BoxDecoration(
                              color: Color(0xfffcfafa),
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
                        ],),onTap: (){
                          _textEditingController.text='${_textEditingController.text}123332 ';
                          subjectplay=false;
                          setState(() {});
                          _textEditingController.selection = TextSelection.fromPosition(TextPosition(offset: _textEditingController.text.length));
                        },);
                      }
                  ))


                ],),height: 200,color: Colors.white,),

              ///新标签位置
              //if(logic.state.positioninformation.toString() != '{}')
              GetBuilder<PublishLogic>(builder: (logic) {
                return  Container(alignment: Alignment.centerRight,
                  child: Container(padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                    decoration: const BoxDecoration(color: Color(0xfff5f5f5),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      GestureDetector(child: SizedBox(
                        width: 20,
                        child: SvgPicture.asset(
                          "assets/icons/publish/dingwei.svg",
                          color: logic.state.positioninformation.toString() ==
                              '{}' ? const Color(0xffe4e4e4) : Colors.black,
                        ),
                      ),onTap: (){
                        Get.toNamed('/verify/locationlist');
                      },),

                      GestureDetector(child: Container(
                        constraints: const BoxConstraints(
                          maxWidth: 210,
                        ),
                        child: logic.state.positioninformation
                            .toString() ==
                            '{}'
                            ? Text(
                          '添加地址'.tr,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: Color(0xff666666),
                              fontSize: 12,
                              height: 1),
                        )
                            : Text(
                            logic.state.positioninformation['name'],
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Color(0xff666666),
                                fontSize: 12,
                                height: 1)),
                      ),onTap: (){
                        Get.toNamed('/verify/locationlist');
                      },),
                      if(logic.state.positioninformation
                          .toString() !=
                          '{}')const SizedBox(width: 5,),
                      logic.state.positioninformation.toString() != '{}'?GestureDetector(
                            child: Container(
                              width: 20,
                              height: 20,
                              alignment: Alignment.center,
                              color: Colors.transparent,
                              child: Container(
                                child: SvgPicture.asset(
                                  "assets/svg/cha.svg",
                                  width: 8,
                                  height: 8,
                                  color: const Color(0xffE1E1E1),
                                ),
                              ),
                            ),
                            onTap: () {
                              logic.state.positioninformation = {};
                              logic.update();
                            },
                          ):Container(width: 3,),
                        ],)
                    ,),);
              }),
              const SizedBox(height: 15,),
              const Divider(height: 1.0,color: Color(0xffF1F1F1),),


              ///录音
              GetBuilder<PublishLogic>(
                  assignId: true,
                  builder: (logic) {
                    if (logic.state.type == PublishType.video) {
                      return Container();
                    }
                    return SizedBox(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GetBuilder<PublishLogic>(builder: (logic) {
                            return Expanded(
                              flex: 1,
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/publish/mac.svg",
                                    color: logic.state
                                        .formData["recorderpath"] != ''
                                        ? Colors.black
                                        : const Color(0xffe4e4e4),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  logic.state.formData["recorderpath"] != ''
                                      ? Expanded(
                                    flex: 1,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.circular(40),
                                        color: Colors.red,
                                        gradient: const LinearGradient(
                                            begin:
                                            Alignment.centerRight,
                                            end: Alignment.centerLeft,
                                            colors: [
                                              Color(0xff474747),
                                              Color(0xff171717),
                                              Color(0xff0B0000),
                                            ]),
                                      ),
                                      // width: double.infinity,
                                      height: 36,
                                      child: Row(
                                        children: [
                                          const SizedBox(
                                            width: 20,
                                          ),

                                          ///开始图片
                                          GestureDetector(
                                            child: Container(
                                              child: state.AudioPause ||
                                                  !state
                                                      .Startplaying
                                                  ? Image.asset(
                                                'assets/images/kaily.png',
                                                width: 20,
                                                height: 20,
                                              )
                                                  : Image.asset(
                                                'assets/images/bfzanting.png',
                                                width: 20,
                                                height: 20,
                                              ),
                                            ),
                                            onTap: () {
                                              if (!state.Startplaying) {
                                                state.Startplaying =
                                                true;
                                                logic.update();
                                                _startPlayer(logic
                                                    .state.formData[
                                                "recorderpath"]);
                                              } else if (state
                                                  .Startplaying) {
                                                _pauseResumePlayer();
                                                logic.update();
                                              }
                                            },
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              height: 16,
                                              decoration: const BoxDecoration(
                                                  image:
                                                  DecorationImage(
                                                    image: AssetImage(
                                                      'assets/images/yinbotwo.png',
                                                    ),
                                                    fit: BoxFit.fill,
                                                  )),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Text(
                                            "${logic.state
                                                .formData['recordingtime']}s",
                                            style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w600),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                      : GestureDetector(
                                    child: Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text('录音'.tr)),
                                    onTap: () {
                                      showBottomSheet(
                                          context,
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .height);
                                    },
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  if (logic.state.formData["recorderpath"] !=
                                      '')
                                    GestureDetector(
                                      child: Image.asset(
                                        'assets/images/lyquxiao.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      onTap: () {
                                        Recordingdeletion();
                                      },
                                    ),
                                  const SizedBox(
                                    width: 40,
                                  ),
                                  // GestureDetector(child:Text('播放') ,onTap: (){
                                  //   _startPlayer(logic.state.formData["recorderpath"]);
                                  // },)
                                ],
                              ),
                            );
                          }),
                          // Icon(Icons.chevron_right,)
                        ],
                      ),
                    );
                  }),
              GetBuilder<PublishLogic>(
                  assignId: true,
                  builder: (logic) {
                    return logic.state.type == PublishType.video
                        ? Container()
                        : const Divider(
                      height: 1.0,
                      color: Color(0xffF1F1F1),
                    );
                  }),
              GetBuilder<PublishLogic>(builder: (logic) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed('/verify/publishTopic');
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          width: 22,
                          child: SvgPicture.asset(
                            "assets/icons/publish/topic.svg",
                            color: logic.state.selectTopic.isEmpty ? const Color(
                                0xffe4e4e4) : Colors.black,
                          ),
                        ),
                        Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: logic.state.selectTopic.isEmpty
                                  ? Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Text('没有选择话题'.tr))
                                  : _TopicListWidget(logic.state.selectTopic),
                            )),
                        SizedBox(
                          width: 30,
                          child: SvgPicture.asset(
                            "assets/icons/publish/arrow.svg",
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              GetBuilder<PublishLogic>(
                  assignId: true,
                  builder: (logic) {
                    return logic.state.type == PublishType.video
                        ? Container()
                        : const Divider(
                      height: 1.0,
                      color: Color(0xffF1F1F1),
                    );
                  }),

              ///地理位置
              // GetBuilder<PublishLogic>(builder: (logic) {
              //   return GestureDetector(
              //     onTap: () {
              //       Get.toNamed('/verify/locationlist');
              //     },
              //     child: Container(
              //       height: 60,
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Container(
              //             alignment: Alignment.centerRight,
              //             width: 22,
              //             child: SvgPicture.asset(
              //               "assets/icons/publish/position.svg",
              //               color: logic.state.positioninformation
              //                   .toString() ==
              //                   '{}' ? Color(0xffe4e4e4) : Colors.black,
              //             ),
              //           ),
              //           Expanded(
              //               child:
              //               logic.state.positioninformation.toString() ==
              //                   '{}'
              //                   ? Padding(
              //                   padding: EdgeInsets.only(right: 10),
              //                   child: Text('添加地址'.tr))
              //                   : Padding(
              //                   padding: EdgeInsets.only(right: 10),
              //                   child: Text(
              //                     logic.state.positioninformation['name'],
              //                     overflow: TextOverflow.ellipsis,))
              //           ),
              //           SizedBox(
              //             width: 30,
              //             child: SvgPicture.asset(
              //               "assets/icons/publish/arrow.svg",
              //               color: Colors.black45,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   );
              // }),
              // const Divider(
              //   height: 1.0,
              //   color: Colors.black12,
              // ),


              Container(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        alignment: Alignment.centerRight,
                        width: 22,
                        child: SvgPicture.asset(
                          "assets/icons/publish/bilibili.svg",
                          color: Check ? Colors.black : const Color(0xffe4e4e4),
                        )),
                    if(logic.state.formData['channel']!=null)Expanded(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: GetBuilder<PublishLogic>(builder: (logic) {
                              return Row(
                                children: startLogic.state.channelDataSource
                                    .map((ChannelList x) =>
                                    _channalTag(
                                        x.name,
                                        x.id,
                                        logic.state.formData['channel'],
                                        logic))
                                    .toList(),
                              );
                            }))),
                  ],
                ),
              ),

              ///关联宝贝
              const Divider(
                height: 1.0,
                color: Color(0xffF1F1F1),
              ),
              GetBuilder<PublishLogic>(builder: (logic) {
                return GestureDetector(
                  onTap: () {
                    //Get.to(commodityPage());
                    Get.to(PricecomparisonpageCorrelation())?.then((value) {
                      // print('89757 value: ${value}');
                      setState(() {
                        if (logic.state.listItem.length >= 3){
                          ToastInfo('最多选择3件商品'.tr);
                         }
                        else {
                          logic.state.listItem.add(value[0]);
                        }
                      });
                      String result = logic.state.listItem.map((item) => item.id).join(',');
                      state.goodIds = result;
                      return false;
                    });
                  },
                  child: Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:
                      [
                        Container(
                          alignment: Alignment.centerRight,
                          width: 18,
                          child: SvgPicture.asset(
                            "assets/svg/guanlianht.svg",
                            color: logic.state.listItem.isEmpty ? const Color(0xffe4e4e4) : Colors.black,
                          ),
                        ),
                        Expanded(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Text('关联宝贝'.tr))
                        ),
                      ],
                    ),
                  ),
                );
              }),
                  // children: [Row(children: [
                  //   Container(width: 40,height: 40,color: Colors.red,),
                  //   SizedBox(width: 5,),
                  //   Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children: [
                  //     Text('dior春季新款#999',style: TextStyle(),),
                  //     Text('dior',style: TextStyle(fontSize: 12),)
                  //   ],),
                  // ],),
                  // SvgPicture.asset(
                  //   "assets/icons/publish/arrow.svg",
                  //   color: Colors.black45,
                  // )],
              // )
              // Color(0xfff5f5f5)
              Container(
                child: Column(
                  // 禁止listview滑动
                  // physics: const NeverScrollableScrollPhysics(),
                  children: logic.state.listItem.isNotEmpty ? logic.state.listItem.map((value){
                    return
                      Column(
                        children: [
                         Container(
                           decoration: const BoxDecoration(color: Color(0xffF5F5F5),borderRadius: BorderRadius.all(Radius.circular(5)),),
                           margin: const EdgeInsets.only(bottom: 10),
                           padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                           child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                              Row(children: [Container(width: 40, height: 40,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                color:const Color(0xfff5f5f5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Image.network(
                                value.thumbnail,
                                //fit: BoxFit.fill,
                                fit: BoxFit.cover,
                                width: 40, height: 40,
                              ),
                            ),
                              const SizedBox(width: 5,),
                              Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                Container(constraints: const BoxConstraints(maxWidth: 200,),child:
                                Text(value.title,overflow: TextOverflow.ellipsis,
                                  maxLines: 1,style: const TextStyle(fontSize: 14),),),
                                const SizedBox(height: 5,),
                                Row(children: [
                                  Container(height: 25,child: Text('评估'.tr,style: const TextStyle(color: Color(0xff999999),fontSize: 14),),),
                                  const SizedBox(width: 5,),
                                  XMStartRating(rating: double.parse(value.score) ,showtext:true)
                                ],),
                              ]),],),
                              GestureDetector(child: Container(
                               width: 15,
                               height: 15,
                               child: SvgPicture.asset(
                                 "assets/svg/cha.svg",
                                 color: const Color(0xff999999),
                               ),
                             ),onTap: (){
                               setState(() {
                                 // 删除数据
                                 logic.state.listItem.remove(value);
                               });
                             },)
                              ],),
                            )
                         ],
                    );
                  }).toList() : [],
              ),),
              ///继续关联
              if(logic.state.listItem.isNotEmpty&&logic.state.listItem.length<3)GestureDetector(
                child: Container(width: double.infinity,height: 47,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/xuxian.png'),
                      fit: BoxFit.fill, // 完全填充
                    ),
                  ),
                  child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text('继续关联'.tr),const SizedBox(width: 10,),SvgPicture.asset(
                    "assets/svg/jia.svg",
                    width: 10,
                    height: 10,
                  )],),
                ),
                onTap: (){
                  Get.to(PricecomparisonpageCorrelation())?.then((value) {
                    // print('89757 value: ${value}');
                    setState(() {
                      if (logic.state.listItem.length >= 3){
                        ToastInfo('最多选择3件商品'.tr);
                      }
                      else {
                        logic.state.listItem.add(value[0]);
                      }
                    });
                    String result = logic.state.listItem.map((item) => item.id).join(',');
                    state.goodIds = result;
                    return false;
                  });
                },
              )
            ],
          ),
        ),
      ),),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 70,
        child: Row(
          children: [
            // /// TODO: 草稿箱，下一版本做
            // Container(
            //   margin: EdgeInsets.all(10),
            //   color: Colors.black12,
            //   width: 50,
            // ),
            Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onPublish();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    height: 70,
                    padding: const EdgeInsets.only(bottom: 3),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Center(
                      child: Text(
                        '发布笔记'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  /**
   * 图片列表
   */
  List<Widget> _foreachList() {
    List<Widget> data = [];
    for (var i = 0; i < logic.state.dataListFile.length; i++) {
      data.add(Container(
        key: ValueKey(state.dataListFile[i]),
        width: 100,
        height: 120,
        child: GestureDetector(
          onTap: () {
            Get.toNamed('/verify/publishImagePreview',
                arguments: state.dataListFile[i]);

          },
          onDoubleTap: () {

            if (logic.state.dataList.length < 2) {
              Get.snackbar("无法删除".tr, '仅剩一张图片'.tr);
              return;
            }
            Get.defaultDialog(
              title: '提示'.tr,
              middleText: '是否要删除该照片'.tr,
              textConfirm: '删除'.tr,
              textCancel: '取消'.tr,
              onConfirm: () {
                logic.onRemove(i);
                Get.back();
              },
            );
          },
          child: Container(
            margin: const EdgeInsets.all(5),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  state.dataListFile[i],
                  fit: BoxFit.cover,
                )),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ));
    }
    return data;
  }

  /**
   * 视频
   */
  _videoBox(context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            logic.editThumbnail(context);
          },
          child: Container(
            width: 120,
            height: 200,
            margin: const EdgeInsets.all(5),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Image.file(
                      File(logic.state?.thumbnailPath ?? ""),
                      fit: BoxFit.cover,
                    )),
                Center(
                  child: ClipRect(
                    // 可裁切矩形
                    child: BackdropFilter(
                      // 背景过滤器
                      filter: ImageFilter.blur(sigmaX: 1.0, sigmaY: 1.0),
                      child: Opacity(
                        opacity: 0.1,
                        child: Container(
                          alignment: Alignment.center,
                          height: double.infinity,
                          width: double.infinity,
                          decoration:
                          BoxDecoration(color: Colors.grey.shade500),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Text(
                      '更换封面'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _channalTag(String name, int id, int activeId, PublishLogic logic) {
    if (id == 0) {
      return Container();
    }
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: id == activeId ? Colors.white : Colors.black87,
          backgroundColor: id == activeId ? Colors.black : Colors.white,
          surfaceTintColor: Colors.white,
          minimumSize: const Size(66, 28),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
        ),
        onPressed: () {
          setState(() {
            Check = true;
          });
          logic.setChannel(id);
        },
        child: Text(name),
      ),
    );
  }

  ///底部弹窗
  void showBottomSheet(context, height) {
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        isScrollControlled: false,
        enableDrag: false,
        // isDismissible:false,
        builder: (BuildContext context) {
          //构建弹框中的内容
          return buildBottomSheetWidget(context, height);
        },
        backgroundColor: Colors.transparent,
        //重要
        context: context).then((value) {

        });
  }

  ///底部弹出框的内容
  Widget buildBottomSheetWidget(BuildContext context, height) {
    // GlobalKey<_TextWidgetState> textKey = GlobalKey();
    return Container(
        height: height / 2 - 20,
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0))),
        child: Column(
          children: [
            const SizedBox(
              height: 55,
            ),
            Text(
              '快用语音简单描述一下吧'.tr,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            Expanded(
              flex: 1,
              child: AudioRecordWidget(),
            ),
          ],
        ));
  }

  _TopicListWidget(data) {
    return Row(
      children: [
        ...data.map((e) {
          return TopicButton(e["name"], () {}, hideIcon: true);
        })
      ],
    );
  }
}

//音频录制按钮
class AudioRecordWidget extends StatefulWidget {
  @override
  AudioRecordState createState() => AudioRecordState();
}

class AudioRecordState extends State<AudioRecordWidget> {
  final logics = Get.find<PublishLogic>();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  // const AudioRecordWidget({
  //   // required Key key,
  //   required this.recroding,
  // }) : super();
  late StreamSubscription recorderSubscription;
  bool recroding = false;
  bool recovery = false;
  bool Recordingoperation = false;
  var path;
  var Recordingtime = 0;

  @override
  void initState() {
    initly();
    super.initState();
  }

  initly() async {
    await recorderModule.closeRecorder();
    openTheRecorder().then((value) {});
  }

  @override
  void dispose() {
    super.dispose();

    // setState(() {
    //   recroding = false;
    //   recovery=false;
    //   Recordingoperation=false;
    // });
    _cancelRecorderSubscriptions();
    stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PublishLogic>(builder: (logic) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            '${Recordingtime}s',
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (Recordingoperation)
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        "assets/svg/duigou.svg",
                      ),
                    ),
                  ),
                  onTap: () async {
                    // Navigator.pop(context);
                    setState(() {
                      Recordingoperation = false;
                      //更新录音时长
                      Recordingtime = 0;
                      stopRecorder();
                    });
                  },
                ),
              Container(
                color: const Color.fromARGB(1, 0, 0, 0), //一个透明的color
                width: 100,
                height: 100,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularSeekBar(
                      width: 98,
                      height: 98,
                      interactive: false,
                      progress: Recordingtime.toDouble(),
                      minProgress: 0,
                      maxProgress: 59,
                      barWidth: 4,
                      startAngle: 180,
                      sweepAngle: 360,
                      strokeCap: StrokeCap.butt,
                      progressColor: Colors.black,
                      trackColor: const Color(0xfff1f1f1),
                      child: Center(
                        child: GestureDetector(
                          child: Container(
                            width: 76,
                            height: 76,
                            decoration: const BoxDecoration(
                              color: Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 200),
                                transitionBuilder: (child, animation) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: FadeTransition(
                                      opacity: animation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if(!recroding && !recovery)SvgPicture.asset(
                                      'assets/svg/kaishily.svg', width: 40,
                                      height: 40,),
                                    if(recroding && !recovery)SvgPicture.asset(
                                      'assets/svg/zantly.svg', width: 40,
                                      height: 40,
                                      color: Colors.white,),
                                    if(!recroding && recovery)SvgPicture.asset(
                                      'assets/svg/hfly.svg', width: 40,
                                      height: 40,
                                      color: Colors.white,),
                                  ],
                                )
                              // Icon(
                              //   recroding
                              //       ? Icons.pause_circle_filled
                              //       : Icons.play_circle_filled,
                              //   color: Colors.white,
                              //   // 这里必须要添加 key
                              //   key: ValueKey<bool>(recroding),
                              //   size: 50,
                              // ),
                            ),
                          ),
                          onTap: () {
                            if (!recroding && !recovery) {
                              _startRecorder();
                            } else if (recroding && !recovery) {
                              ///暂停录制
                              Pauserecording();
                            } else if (!recroding && recovery) {
                              Recoveryrecording();
                            }
                            // recroding = !recroding;
                            // logic.update();
                          },
                        ),
                      ),
                      //animation: true,
                    ),
                  ],
                ),
              ),
              if (Recordingoperation)
                GestureDetector(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                    decoration: BoxDecoration(
                      color: const Color(0xffF5F5F5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Container(
                      width: 22,
                      height: 22,
                      child: SvgPicture.asset(
                        "assets/svg/shanchu.svg",
                      ),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      Recordingoperation = false;
                      //更新录音时长
                      Recordingtime = 0;
                    });
                    logics.releaseFlautosc();
                  },
                ),
            ],
          ),
          !recroding
              ? Text(
            '单点就开始录音'.tr,
            style: const TextStyle(
              color: Color(0xff999999),
              fontSize: 13,
            ),
          )
              : Text('点击暂停'.tr, style: const TextStyle(
              color: Color(0xff999999),
              fontSize: 13,
            ),
          ),
        ],
      );
    });
  }

  ///初始化录音
  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorderModule.openRecorder();
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }

  ///开始录制
  void _startRecorder() async {
    try {
      await logics.getPermissionStatus().then((value) async {
        if (!value) {
          return;
        }
        setState(() {
          recroding = true;
          // Recordingoperation=true;
        });
        //用户允许使用麦克风之后开始录音
        DateTime dateTime = DateTime.now();

        var time =
            "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
            .hour}${dateTime.minute}${dateTime.second}";
        Directory dir = await getTemporaryDirectory();
        path = '$time${ext[Codec.aacADTS.index]}';

        await recorderModule
            .startRecorder(
          toFile: "${dir.path}/$path",
          codec: Codec.aacADTS,
        )
            .then((value) {
          setState(() {});
        });
        recorderModule.setSubscriptionDuration(const Duration(milliseconds: 1000));

        /// 监听录音
        recorderSubscription = recorderModule.onProgress!.listen((e) {
          var date = DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);
          // print('监听中');
          setState(() {
            //更新录音时长
            Recordingtime = Recordingtime + 1;
          });
          logics.state.formData['recordingtime'] = Recordingtime;
          logics.update();
          // var txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
          //设置了最大录音时长

          if (Recordingtime >= 59.0) {
            stopRecorder();
            // print('录音超时了');
            return;
          }
        });
        // print("没监听${recorderSubscription}");
      });
    } catch (err) {
      // print('出错了${err}');
      // setState(() {
      //   _stopRecorder();
      //   _state = RecordPlayState.record;
      //   _cancelRecorderSubscriptions();
      // });
    }
  }

  ///上传oss
  void uploadyinpin() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(
            text: "音频上传中".tr,
          );
        });
    Directory dir = await getTemporaryDirectory();
    // print('临时目录 : ${dir.path}');

    File file = File("${dir.path}/$path");
    // print(file.existsSync());

    // AliOssClient.init(
    //   //tokenGetter: _tokenGetterMethod,
    //   stsUrl: BASE_DOMAIN + 'sts/stsAvg',
    //   ossEndpoint: "oss-accelerate.aliyuncs.com",
    //   bucketName: "dayuhaichuang",
    // );

    ///谷歌存储桶设置
    final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
    DateTime dateTime = DateTime.now();

    final recordingName =  storageRef.child("user/audio/${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
        .hour}${dateTime.minute}${dateTime.second}.mp3");
    final recordingUpload = recordingName.putFile(File("${dir.path}/$path"),);

    await recordingUpload.whenComplete(() {});
    String newThumbnailPath =  await recordingName.getDownloadURL();


    // String newThumbnailPath = await AliOssClient().putObject(
    //     "${dir.path}/${path}",
    //     'thumb',
    //     "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
    //         .hour}${dateTime.minute}${dateTime.second}");

    ///保存本地地址
    logics.state.formData['recorderpath'] = "${dir.path}/$path";
    ///保存oss地址
    logics.state.formData['ossrecorderpath'] = newThumbnailPath;
    logics.update();
    Navigator.pop(context);
    Navigator.pop(context);
    print(newThumbnailPath);
  }

  ///关闭录制
  void stopRecorder() async {
    await recorderModule.stopRecorder().then((value) {
      setState(() {
        recroding = false;
      });
      uploadyinpin();
    });
  }

  ///暂停录制
  void Pauserecording() async {
    await recorderModule.pauseRecorder().then((value) {
      setState(() {
        //var url = value;
        recroding = false;
        recovery = true;
        Recordingoperation = true;
      });
    });
  }

  ///恢复录制
  void Recoveryrecording() async {
    await recorderModule.resumeRecorder().then((value) {
      setState(() {
        recroding = true;
        recovery = false;
        Recordingoperation = false;
      });
    });
  }

  /// 取消录音监听
  void _cancelRecorderSubscriptions() {
    recorderSubscription.cancel();
  }
}

class LoadingDialog extends Dialog {
  final String text;

  const LoadingDialog({required this.text}) : super();

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Center(
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: const ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const CircularProgressIndicator(),
                if(text!='')Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(text),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}