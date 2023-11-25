import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/function.dart';
import 'package:lanla_flutter/pages/home/message/Pictureview/view.dart';
import 'package:lanla_flutter/pages/home/message/Videoplayback/view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/ulits/aliyun_oss/client.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:lanla_flutter/ulits/language/camera_picker_text_delegate.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../services/newes.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatPage extends StatefulWidget {
  @override
  createState() => Chat();

  NewesProvider provider = Get.put(NewesProvider());
}

class Chat extends State<ChatPage> with WidgetsBindingObserver {
  final userController = Get.find<UserLogic>();

  final WebSocketes = Get.find<StartDetailLogic>();
  TextEditingController chatvalue = TextEditingController();

  var lttext = '';
  var uid;
  var uname;
  var Avatar;
  late num miid;
  double keyboardheight = 0;
  bool bottomhz = false;
  var dataListFile = [];


  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    //channel.sink.add(jsonEncode({'Code':30000,'Send':userLogic.userId}));





    super.initState();
    uid = Get.arguments['uid'];
    uname = Get.arguments['uname'];
    miid = Get.arguments['id'];
    Avatar=Get.arguments['Avatar'];
    // WebSocketes.channel.sink.add(jsonEncode({
    //   'Code': 10005,
    //   'Target': Get.arguments['uid'],
    //   'Send': Get.arguments['id'],
    //   'MessageType': 1,
    // }));
    //print('1151515515${userController.Chatrelated['${userController.userId}']['record']['${Get.arguments['uid']}']}');
    // print('1151515515${Get.arguments['id'] is num}');
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();

    // 键盘高度
    // final double viewInsetsBottom = EdgeInsets.fromWindowPadding(
    //     WidgetsBinding.instance.window.viewInsets,
    //     WidgetsBinding.instance.window.devicePixelRatio).bottom
    // ;
    //
    // print(viewInsetsBottom);
    //
    // setState(() {
    //   keyboardheight = viewInsetsBottom;
    // });

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      //setState(() {
      if (MediaQuery
          .of(context)
          .viewInsets
          .bottom > 0.0) {

      } else {
        bottomhz = false;
      }

      // });
    });
  }
  ///生命周期
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        empty();
        break;
    }
  }
  empty(){
    Future.delayed(const Duration(milliseconds: 200)).then((e) {
      for (var i = 0; i <
          userController.Chatrelated['${userController.userId}']['Chatlist']
              .length; i++) {
        if (userController.Chatrelated['${userController
            .userId}']['Chatlist'][i]['Uid'] == uid) {
          userController.Clearunread(i);
        }
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    empty();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        resizeToAvoidBottomInset: !bottomhz,
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
          title: Text(uname, style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),),
        ),
        body: GestureDetector(child: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Divider(height: 1.0, color: Colors.grey.shade200,),
              Expanded(flex: 1, child: Container(
                  width: double.infinity,
                  color: const Color(0xfff5f5f5),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: Column(children: [
                    Expanded(child:
                    Container(
                      //列表内容少的时候靠上
                        alignment: Alignment.topCenter,
                        // ListView(
                        //   reverse: true,
                        //   // shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
                        //   //  physics: const NeverScrollableScrollPhysics(), //禁止滚动
                        //   children: [
                        child: GetBuilder<UserLogic>(builder: (logic) {
                          // empty();
                          return ListView.builder(
                              primary: false,
                              reverse: true,
                              shrinkWrap: true,
                              //范围内进行包裹（内容多高ListView就多高）
                              // physics: const NeverScrollableScrollPhysics(), //禁止滚动
                              itemCount: userController
                                  .Chatrelated['${userController
                                  .userId}']['record']['$uid'] != null
                                  ? userController.Chatrelated['${userController
                                  .userId}']['record']['$uid'].length
                                  : 0,

                              itemBuilder: (context, i) {
                                return userController
                                    .Chatrelated['${userController
                                    .userId}']['record']['$uid'][i]['send'] ==
                                    miid ? Column(children: [
                                  const SizedBox(height: 20,),
                                  Column(children: [
                                    i == userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'].length -
                                        1 ? Text(messageTime(userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'][i]["Times"]))
                                        : compare(userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'][i]["Times"],
                                        userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i +
                                            1]["Times"]) ? Text(messageTime(
                                        userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i]["Times"]))
                                        : Container(),
                                    const SizedBox(height: 20,),
                                    Row(crossAxisAlignment: CrossAxisAlignment
                                        .start, children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              50),
                                          color: Colors.black12,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  userController.userAvatar),
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      const SizedBox(width: 10,),
                                      if(userController
                                          .Chatrelated['${userController
                                          .userId}']['record']['$uid'][i]["MessageType"] ==
                                          1)
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 90,
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              15, 12, 15, 12),
                                          decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color(0xff222222)),
                                          child: Text(userController
                                              .Chatrelated['${userController
                                              .userId}']['record']['$uid'][i]["message"]
                                              .toString(),
                                            style: const TextStyle(
                                                color: Colors.white),),
                                        ),
                                      if(userController
                                          .Chatrelated['${userController
                                          .userId}']['record']['$uid'][i]["MessageType"] ==
                                          2)
                                        GestureDetector(child: Stack(children: [

                                          Container(constraints: BoxConstraints(
                                            maxWidth: MediaQuery
                                                .of(context)
                                                .size
                                                .width - 90,
                                            minHeight: 50,
                                          ), width: 200,
                                            child: Card(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadiusDirectional
                                                      .circular(10)),
                                              clipBehavior: Clip.antiAlias,
                                              child: Image.network(
                                                (userController
                                                    .Chatrelated['${userController
                                                    .userId}']['record']['$uid'][i]["message"]
                                                    .split(",")[0]), width: 200,
                                                fit: BoxFit.cover,),
                                            ),
                                          ),

                                          const Positioned(
                                            top: 10,
                                            right: 10,
                                            left: 10,
                                            bottom: 10,
                                            child: Icon(
                                              Icons.play_circle_outline,
                                              size: 60,
                                              color: Colors.white54,
                                            ),
                                          ),
                                        ],),

                                          onTap: () {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            Get.to(Videoplaybackpage(),
                                                arguments: userController
                                                    .Chatrelated['${userController
                                                    .userId}']['record']['$uid'][i]["message"]);
                                          },),
                                      if(userController
                                          .Chatrelated['${userController
                                          .userId}']['record']['$uid'][i]["MessageType"] ==
                                          3)
                                        GestureDetector(child: Card(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadiusDirectional
                                                  .circular(10)),
                                          clipBehavior: Clip.antiAlias,
                                          child: Image.network((userController
                                              .Chatrelated['${userController
                                              .userId}']['record']['$uid'][i]["message"]),
                                            width: 200, fit: BoxFit.cover,),
                                        ), onTap: () {
                                          SystemChannels.textInput.invokeMethod(
                                              'TextInput.hide');
                                          Get.to(Pictureviewpage(),
                                              arguments: userController
                                                  .Chatrelated['${userController
                                                  .userId}']['record']['$uid'][i]["message"]);
                                        },),
                                    ],),
                                  ],),
                                ],) :
                                Column(children: [

                                  ///对方消息
                                  const SizedBox(height: 20,),
                                  Column(children: [
                                    i == userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'].length -
                                        1 ? Text(messageTime(userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'][i]["Times"]))
                                        : compare(userController
                                        .Chatrelated['${userController
                                        .userId}']['record']['$uid'][i]["Times"],
                                        userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i +
                                            1]["Times"]) ? Text(messageTime(
                                        userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i]["Times"]))
                                        : Container(),
                                    const SizedBox(height: 20,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // if(userController.Chatrelated['${userController.userId}']['record']['${uid}'][i]["MessageType"]==1) Container(padding: EdgeInsets.fromLTRB(
                                        //     15, 12, 15, 12),
                                        //   decoration: BoxDecoration(
                                        //       borderRadius: BorderRadius.all(
                                        //           Radius.circular(5)),
                                        //       color: Color(0xff222222)),
                                        //   child: Text(userController.Chatrelated['${userController.userId}']['record']['${uid}'][i]["message"].toString(),
                                        //     style: TextStyle(
                                        //         color: Colors.white),),
                                        // ),
                                        if(userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i]["MessageType"] ==
                                            1)
                                          Expanded(child: Row(
                                            mainAxisAlignment: MainAxisAlignment
                                                .end, children: [Container(
                                            constraints: BoxConstraints(
                                              maxWidth: MediaQuery
                                                  .of(context)
                                                  .size
                                                  .width - 90,
                                            ),
                                            padding: const EdgeInsets.fromLTRB(
                                                15, 12, 15, 12),
                                            decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5)),
                                                color: Color(0xff222222)),
                                            child: Text(userController
                                                .Chatrelated['${userController
                                                .userId}']['record']['$uid'][i]["message"]
                                                .toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),),
                                          )
                                          ],),),
                                        if(userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i]["MessageType"] ==
                                            2)
                                          GestureDetector(child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadiusDirectional
                                                    .circular(10)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network((userController
                                                .Chatrelated['${userController
                                                .userId}']['record']['$uid'][i]["message"]
                                                .split(",")[0]), width: 200,
                                              fit: BoxFit.cover,),
                                          ), onTap: () {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            Get.to(Videoplaybackpage(),
                                                arguments: userController
                                                    .Chatrelated['${userController
                                                    .userId}']['record']['$uid'][i]["message"]
                                                    .split(",")[1]);
                                          },),
                                        if(userController
                                            .Chatrelated['${userController
                                            .userId}']['record']['$uid'][i]["MessageType"] ==
                                            3)
                                          GestureDetector(child: Card(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadiusDirectional
                                                    .circular(10)),
                                            clipBehavior: Clip.antiAlias,
                                            child: Image.network((userController
                                                .Chatrelated['${userController
                                                .userId}']['record']['$uid'][i]["message"]),
                                              width: 200, fit: BoxFit.cover,),
                                          ), onTap: () {
                                            SystemChannels.textInput
                                                .invokeMethod('TextInput.hide');
                                            Get.to(Pictureviewpage(),
                                                arguments: userController
                                                    .Chatrelated['${userController
                                                    .userId}']['record']['$uid'][i]["message"]);
                                          },),
                                        const SizedBox(width: 10,),
                                        if(Avatar!=null)GestureDetector(child: Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                50),
                                            color: Colors.black12,
                                            image: DecorationImage(
                                                image: NetworkImage(Avatar),
                                                fit: BoxFit.cover),
                                          ),
                                        ),onTap: (){
                                          FocusScope.of(context).unfocus();
                                          Get.toNamed('/public/user', arguments: uid);
                                        },),

                                      ],),
                                  ],)
                                ]);
                              }
                          );
                        })),
                      //],)
                    ),
                  ],)
              )),
              Container(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [Expanded(child: TextField(
                    controller: chatvalue,
                    onChanged: (value) {
                      setState(() {
                        lttext = value;
                      });
                    },
                    maxLines: null,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.black, height: 1.3),
                    //输入文本的样式
                    decoration: const InputDecoration(
                      fillColor: Color(0xfff9f9f9),
                      //背景颜色，必须结合filled: true,才有效
                      filled: true,
                      //重点，必须设置为true，fillColor才有效
                      // hintText: '请填写'.tr,
                      hintStyle: TextStyle(color: Colors.black12),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white, // 边框颜色
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      isCollapsed: true,

                      ///设置内容内边距
                      contentPadding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 15, right: 15),
                    ),
                    autofocus: true,
                  ),), const SizedBox(width: 15,),
                    lttext == '' ? GestureDetector(child: Image.asset(
                        'assets/images/ltianjia.png', width: 24,
                        height: 24,
                        fit: BoxFit.cover), onTap: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      setState(() {
                        bottomhz = true;
                      });
                    }) :
                    GetBuilder<UserLogic>(builder: (logic) {
                      return GestureDetector(child: Image.asset(
                          'assets/images/faxiaoxi.png', width: 24,
                          height: 24,
                          fit: BoxFit.cover), onTap: () {
                        //lttext
                        if (!userController.Chatdisconnected) {
                          ToastInfo('连接失败请重启app'.tr);
                          return;
                        }
                        WebSocketes.channel.sink.add(
                            jsonEncode({
                              'Code': 10001,
                              'Target': uid,
                              'Send': miid,
                              'MessageType': 1,
                              'Message': lttext
                            }));
                        //print('45666');
                        setState(() {
                          lttext = '';
                          chatvalue.clear(); //清除textfield的值
                        });
                      },);
                    }),
                  ],
                ),),
              if(bottomhz)Container(
                width: double.infinity,
                height: 250,
                color: const Color(0xfff9f9f9),
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      GestureDetector(onTap: () async {
                        final List<AssetEntity>? result = await AssetPicker
                            .pickAssets(
                          context,
                          pickerConfig: const AssetPickerConfig(
                              textDelegate: ArabicAssetPickerTextDelegate()),
                        );
                        // 选择图片后跳转到发布页
                        if (result != null && result.isNotEmpty) {
                          print('数据${result[0].file}');
                         // uploadoss();
                          ///谷歌存储桶设置
                          final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
                          for (var item in result) {
                            if (item.type == AssetType.image) {
                              load(context);
                              //dataListFile.add(item.file);
                              // // 视频上传
                              // if (item.type == AssetType.video) {
                              //   _uploadVideo();
                              // }
                              // 图片上传

                              File? file = await item.file;
                              _uploadPicture(file!,storageRef);
                            }
                            if (item.type == AssetType.video) {
                              load(context);
                              var data = item;
                              var file = await data.file;

                              Directory dir = await getTemporaryDirectory();
                              var thumbnailPath = await VideoThumbnail
                                  .thumbnailFile(
                                video: file!.path,
                                thumbnailPath: "${"${dir.path}/" + getUUid()}.png",
                                //imageFormat: ImageFormat.PNG,
                                maxWidth: 300,
                                quality: 25,
                              );
                              _uploadVideo(thumbnailPath, file,storageRef);
                              // state.type = PublishType.video;
                              // state.videoPath = file!.path;
                              // state.thumbnailPath = thumbnailPath;
                              // state.dataList = [dataSource[i]];
                              // state.selectThumbnail = false;
                              // LogV([state.videoPath, state.thumbnailPath]);
                              // update();
                              //break;
                            }
                          }
                          // Get.toNamed('/verify/publish',
                          //     arguments: {"asset": result, "address": topicObject});
                        }
                      }, child: Column(children: [
                        Image.asset('assets/images/xiangce.png', width: 60,
                          height: 60,
                          fit: BoxFit.cover,),
                        const SizedBox(height: 10,),
                        Text('相册'.tr)
                      ],),),
                      const SizedBox(width: 20,),
                      GestureDetector(child: Column(children: [
                        Image.asset('assets/images/paizhao.png', width: 60,
                          height: 60,
                          fit: BoxFit.cover,),
                        const SizedBox(height: 10,),
                        Text('拍照'.tr)
                      ],), onTap: () async {
                        final AssetEntity? result = await CameraPicker
                            .pickFromCamera(
                          context,
                          pickerConfig: const CameraPickerConfig(
                              textDelegate: ArabCameraPickerTextDelegate(),
                              enableRecording: true,
                              shouldAutoPreviewVideo: true),
                        );
                        if (result != null) {
                          // uploadoss();

                          ///谷歌存储桶设置
                          final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
                          File? file = await result.file;
                          if (result.type == AssetType.image) {
                            load(context);
                            // 图片上传
                            _uploadPicture(file!,storageRef);
                          }
                          if (result.type == AssetType.video) {
                            load(context);
                            var data = result;
                            var file = await data.file;

                            Directory dir = await getTemporaryDirectory();
                            var thumbnailPath = await VideoThumbnail
                                .thumbnailFile(
                              video: file!.path,
                              thumbnailPath: "${"${dir.path}/" + getUUid()}.png",
                              //imageFormat: ImageFormat.PNG,
                              maxWidth: 300,
                              quality: 25,
                            );
                            _uploadVideo(thumbnailPath, file,storageRef);
                            // state.type = PublishType.video;
                            // state.videoPath = file!.path;
                            // state.thumbnailPath = thumbnailPath;
                            // state.dataList = [dataSource[i]];
                            // state.selectThumbnail = false;
                            // LogV([state.videoPath, state.thumbnailPath]);
                            // update();
                            //break;
                          }
                        }
                      },),
                    ],)
                  ],
                ),)


            ],
          ),
        ), onTap: () {
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          setState(() {
            bottomhz = false;
          });
        },),

      );
  }

// Future<void> _onRefresh() async {
//   await Future.delayed(Duration(seconds: 1), () {
//     widget.logic.NewConcerns();
//   });
// }
  static String messageTime(timeStamp) {
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    num _distance = time - timeStamp;
    if (_distance <= 180) {
      return '刚刚'.tr;
    } else if (_distance <= 3600) {
      return '${'前'.tr}${(_distance / 60).floor()}${'分钟'.tr}';
    } else if (_distance <= 43200) {
      return '${'前'.tr}${(_distance / 60 / 60).floor()}${'小时'.tr}';
    } else if (DateTime
        .fromMillisecondsSinceEpoch(time * 1000)
        .year == DateTime
        .fromMillisecondsSinceEpoch(timeStamp * 1000)
        .year) {
      //return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
      return '${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .hour}:${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .minute} ${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .day}/${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .month}';
    } else {
      return '${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .hour}:${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .minute} ${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .day}/${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .month}/${DateTime
          .fromMillisecondsSinceEpoch(timeStamp * 1000)
          .year}';
    }
  }


  compare(times, twotime) {
    // 当前时间
    //int times = (new DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    num _distances = times - twotime;
    if (_distances >= 300) {
      return true;
    } else {
      return false;
    }
  }

  ///上传oss
  uploadoss() async {
    // 检测表单
    // 设置oss
    // AliOssClient.init(
    //   //tokenGetter: _tokenGetterMethod,
    //   stsUrl: BASE_DOMAIN + 'sts/stsAvg',
    //   ossEndpoint: "oss-accelerate.aliyuncs.com",
    //   bucketName: "dayuhaichuang",
    // );
    ///谷歌存储桶设置
    final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
  }

  /// 发布图文
  _uploadPicture(File file,storageRef) async {
    // var width;
    // var height;
    File imageObj = await CompressImageFile(file);
    // String newThumbnailPath =
    // await AliOssClient().putObject(imageObj.path, 'thumb', _getFileName());

    final pictureName =  storageRef.child("user/img/${_getFileName()}.png");
    final pictureUpload = pictureName.putFile(File(imageObj.path));
    await pictureUpload.whenComplete(() {});
    String newThumbnailPath =  await pictureName.getDownloadURL();

    // imagesPath.add(newThumbnailPath);
    //await publiDataLogic.finishTask();
    print('publish:$newThumbnailPath');

    // var client = http.Client();
    // http.Response response = await client.get(Uri.parse(newThumbnailPath + '?x-oss-process=image/info'));
    // .then((value) {
    // height=jsonDecode(value.body)["ImageHeight"]["value"].toDouble();
    // width=jsonDecode(value.body)["ImageWidth"]["value"].toDouble();
    // //height=jsonDecode(value.body).ImageHeight;
    // });
    // print('宽高${height},${jsonDecode(response.body)["ImageHeight"]["value"].toString()}');
    WebSocketes.channel.sink.add(
        jsonEncode({
          'Code': 10001,
          'Target': uid,
          'Send': miid,
          'MessageType': 3,
          'Message': newThumbnailPath,
        }));
    Navigator.pop(context);
  }

  /// 发布视频
  _uploadVideo(thumbnailPath, file,storageRef) async {
    //publiDataLogic.startPublish(3, state.thumbnailPath!);
    // ---任务1-上传缩略图--
    File imageObj = await CompressImageFile(File(thumbnailPath));
    // String newThumbnailPath = await AliOssClient()
    //     .putObject(imageObj.path!, 'thumb', _getFileName());

    ///谷歌上传缩略图
    final spaceRef =  storageRef.child("user/img/v${_getFileName()}.png");
    final uploadTask = spaceRef.putFile(File(imageObj.path));
    await uploadTask.whenComplete(() {});
    String newThumbnailPath =  await spaceRef.getDownloadURL();

    //await publiDataLogic.finishTask();
    // if (newThumbnailPath == '') {
    //   publiDataLogic.fail("操作失败".tr, "上传封面失败了,请检图片是否存在".tr);
    //   return;
    // }
    var fileq = File(file!.path);
    print('压缩前大小:${fileq.lengthSync()}');
    MediaInfo? mediaInfo;
    if (fileq.lengthSync() > 40000000) {
      mediaInfo = await VideoCompress.compressVideo(
        file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, // It's false by default
      );
      print('压缩后：${mediaInfo?.path}');
      var files = File(mediaInfo!.path!);
      print('压缩大小:${files.lengthSync()}');
    }

    print('压缩后：$mediaInfo');

    // ---任务2-上传视频--
    // var newVideoPath = await AliOssClient()
    //     .putObject(mediaInfo != null ? mediaInfo.path! : file.path!, 'video',
    //     _getFileName());


    final pictureName =  storageRef.child("user/video/" + _getFileName()+'.mp4');
    final pictureUpload = pictureName.putFile(mediaInfo != null ? File(mediaInfo.path!) : File(file.path!),);
    await pictureUpload.whenComplete(() {});
    String newVideoPath =  await pictureName.getDownloadURL();
    print('视频上传$newVideoPath');
    WebSocketes.channel.sink.add(
        jsonEncode({
          'Code': 10001,
          'Target': uid,
          'Send': miid,
          'MessageType': 2,
          'Message': '$newThumbnailPath,$newVideoPath'
        }));
    Navigator.pop(context);
  }


  String _getFileName() {
    DateTime dateTime = DateTime.now();
    String timeStr =
        "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
        .hour}${dateTime.minute}${dateTime.second}";
    return timeStr + getUUid();
  }

  ///弹窗
  Future<void> load(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(text: '上传中'.tr,
          );
        });
  }

}
