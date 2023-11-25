import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:audio_session/audio_session.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:circular_seek_bar/circular_seek_bar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/function.dart';
import 'package:lanla_flutter/common/widgets/button_black.dart';
import 'package:lanla_flutter/models/UsersAndUser.dart';
import 'package:lanla_flutter/pages/detail/ceshi/index.dart';
import 'package:lanla_flutter/pages/publish/Longgraphictext.dart';
import 'package:lanla_flutter/pages/publish/state.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_compress/video_compress.dart';
import 'package:video_player/video_player.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

import '../../models/ChannelList.dart';
import '../home/start/list_widget/list_logic.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as htmljx;

import 'Shop/view.dart';
import 'package:html/parser.dart' as html_parser;
/**
 * 发布作品总页面
 */
import 'logic.dart';

class LongraphicwritingPage extends StatefulWidget {
  @override
  LongraphicwritingState createState() => LongraphicwritingState();

}

class LongraphicwritingState extends State<LongraphicwritingPage> with WidgetsBindingObserver {

  final quill.QuillController _controlleres = quill.QuillController.basic();
  final logic = Get.put(LonggraphictextLogic());
  final startLogic = Get.find<StartListLogic>();
  final state = Get.put(LonggraphictextLogic()).state;
  var Check = false;
  var Friendspage=1;
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
  FocusNode focusNode = FocusNode();
  bool showlongtw=false;
  bool _showPlaceholder= true;
  var changewh=[];
  var BoldText=false;
  var SizeText=2;

  void initState() {
    super.initState();
    Check = false;
    init();
    MyfollowList(userController.userId);
    // 添加监听
    WidgetsBinding.instance?.addObserver(this);
    ///长图文监听
    _controlleres.addListener(() {
      if(_controlleres.document.toPlainText().length >= 2 && _controlleres.document.toPlainText()[_controlleres.document.toPlainText().length - 2] == '\n'){
        setState(() {

        });
      }
      logic.setFrom('title', _controlleres.document.toPlainText());
      // 在保存部分的代码中
      final delta = _controlleres.document.toDelta().toList();

// // 遍历 Delta 对象
//       final modifiedDelta = delta.map((op) {
//         if (op.isInsert && op.data is Map && (op.data as Map).containsKey('image')) {
//
//           final imageInfo = (op.data as Map)['image'];
//           if (imageInfo != null) {
//             print('tupian');
//             print('tupian${imageInfo['width']}');
//             final imageUrl = imageInfo['src'];
//             final width = int.parse(imageInfo['width']);
//             final height = int.parse(imageInfo['height']);
//
//             if (imageUrl != null && width != null && height != null) {
//               final attributes = Map<String, dynamic>.from(op.attributes ?? {});
//               attributes['width'] = width;
//               attributes['height'] = height;
//               return quill.Operation.insert(imageUrl, attributes);
//             }
//           }
//         }
//
//         return op;
//       }).toList();
      final deltaJson = _controlleres.document.toDelta().toJson();
      final converter = QuillDeltaToHtmlConverter(
        List.castFrom(deltaJson),
        // ConverterOptions.forEmail(),
      );
      String html = converter.convert();
      html = html.replaceAllMapped(RegExp(r'class="ql-size-(\d+)"'), (match) => 'style="font-size: ${match.group(1)}px"');
      print('转化的html${html}');
      final document = html_parser.parse(html);
      final images = document.getElementsByTagName('img');
      for (var image in images) {
        final src = image.attributes['src'];
        if (changewh.contains(src)) {
          image.attributes['style'] = 'max-width: 100%; object-fit: contain; width:50%;display: block;margin: 0 auto;';
        } else {
          image.attributes['style'] = 'max-width: 100%;object-fit: contain';
        }
      }
      // final newwenstyle = document.getElementsByTagName('p');
      // for (var wenzi in newwenstyle) {
      //   wenzi.attributes['style'] = 'font-size: 16px';
      // }
      final modifiedHtml = document.outerHtml;
      logic.setFrom('text', modifiedHtml);
      // logic.setFrom('text',html_parser.parse(html).outerHtml );

    });
    ///长图文焦点监听
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          // 当编辑器获得焦点时，将 placeholder 设置为空字符串
          _showPlaceholder = false;
        });
      } else {
        setState(() {
          // 当编辑器失去焦点时，将 placeholder 设置为默认值
          _showPlaceholder = true;
        });
      }
    });
  }
  String? customConvertAttributeToHtml(quill.Attribute attribute) {
    if (attribute.key == quill.Attribute.bold.key) {
      return '<strong>${attribute.value}</strong>';
    } else if (attribute.key == quill.Attribute.italic.key) {
      return '<em>${attribute.value}</em>';
    } else if (attribute.key == quill.Attribute.size.key) {
      var size = attribute.value;
      return '<span style="font-size: ${size}px">${attribute.value}</span>';
    }
    return null;
  }
  ///文字和图片拼接
  Picturetextsplicing(text){
    var runtext='';
    for(var i=0;i<text.length;i++){
      if(text[i]["insert"] is String){
        runtext=runtext+text[i]["insert"];
      }else{
        runtext=runtext+'<!--IMAGE-->'+text[i]["insert"]["image"]+'<!--IMAGE-->';
      }
    }
    return runtext;
  }
  Longraphiccontent(){
    final delta = _controlleres.document.toDelta();
    final List<Map<String, dynamic>> ops = delta.toList().map((op) {
      final insertData = op.data;
      if (op.isInsert) {
        //   if (insertData is String && !regex.hasMatch(insertData.trim())) {
        //   // 判断字符串不为空或只包含空白字符
        //     print('插入的文本非空');
        // }else{
        //     print('插入的文本空');
        //   }
        //   if (insertData.toString().trim().isNotEmpty) {
        //     return ;
        //   }
        if (insertData is quill.Embed) {
          final embed = insertData as quill.Embed;
          if (embed.value is quill.BlockEmbed && embed.value.type == 'image') {
            final imageUrl = embed.value.data['source'] ?? '';
            return {'insert': '[Image: $imageUrl]'};
          }
        }
      }
      if (insertData.toString().trim().isNotEmpty) {
        return op.toJson();
      }else{
        return {'insert': ''};
      }
    }).toList();
    return ops;
  }
  ///@列表
  Future<void> MyfollowList(userId) async {
    var result = await providerFriends.Myfollowinterface(userId,Friendspage);
    if(result.statusCode==200){
      Friendlist =UserandUserFromJson(result?.bodyString ?? "");
      setState(() {});
    }
  }

  ///插入图片
  void _insertImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      print('tupiandd${pickedFile.path}');
      final file = File(pickedFile.path);
      final imageUrl = file.path;
      insertImage(imageUrl);
      // if (imageUrl != null) {
      //   load(context);
      //   ///谷歌存储桶设置
      //   final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
      //   File imageObj = await CompressImageFile(File(imageUrl!));
      //   ///谷歌上传缩略图
      //   final spaceRef =  storageRef.child('user/img/Longraphictext'+_getFileName()+'.png');
      //   final uploadTask = spaceRef.putFile(File(imageObj.path));
      //    await uploadTask.whenComplete(() {});
      //   String LonggraphictextPath =  await spaceRef.getDownloadURL();
      //   insertImage(LonggraphictextPath);
      //   Navigator.pop(context);
      // }
    }
  }

  ///插入视频
  void _insertVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery,);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final videoUrl = file.path;
      insertVideo(videoUrl);
      // if (videoUrl != null) {
      //   load(context);
      //   final regex = RegExp(r'<iframe|<img');
      //   final matches = regex.allMatches(logic.state.formData['text']);
      //
      //   if (matches.isEmpty) {
      //     await logic.getVideoThumbnail(videoUrl);
      //   }
      //   /// 谷歌存储桶设置
      //   final storageRef = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
      //   MediaInfo? mediaInfo;
      //   if(file.lengthSync()>40000000){
      //     mediaInfo = await VideoCompress.compressVideo(
      //       state.videoPath!,
      //       quality: VideoQuality.DefaultQuality,
      //       deleteOrigin: false, // It's false by default
      //     );
      //   }
      //   final pictureName =  storageRef.child("user/video/" + _getFileName()+'.mp4');
      //   final pictureUpload = pictureName.putFile(mediaInfo != null ? File(mediaInfo.path!) : file,);
      //   pictureUpload.snapshotEvents.listen((taskSnapshot) {
      //     switch (taskSnapshot.state) {
      //       case TaskState.running:
      //         final progress =
      //             100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
      //         print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
      //
      //         break;
      //       case TaskState.paused:
      //       // ...
      //         break;
      //       case TaskState.success:
      //       // ...
      //         break;
      //       case TaskState.canceled:
      //         break;
      //       case TaskState.error:
      //       // ...
      //         break;
      //     }
      //   });
      //   await pictureUpload.whenComplete(() {});
      //   String newVideoPath =  await pictureName.getDownloadURL();
      //   print('视频地址${newVideoPath}');
      //   insertVideo(newVideoPath);
      //   Navigator.pop(context);
      // }
    }
  }
  String _getFileName() {
    DateTime dateTime = DateTime.now();
    String timeStr = "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
    return timeStr + getUUid();
  }
  ///弹窗
  Future<void> load(context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new LoadingDialog(text: '',);
        });
  }
  void insertImage(String imageUrl) {
    final index = _controlleres.selection.baseOffset;
    final embed = quill.BlockEmbed.image(imageUrl);
    _controlleres.document.insert(index, '\n');
    _controlleres.document.insert(index+1, embed);
    _controlleres.document.insert(index+2, '\n');
    // 更新光标位置
    _controlleres.updateSelection(
      TextSelection.collapsed(offset: index + 3),
      quill.ChangeSource.LOCAL,
    );
  }

  void insertVideo(String videoUrl) {
    final index = _controlleres.selection.baseOffset;
    final embed = quill.BlockEmbed.video(videoUrl);
    _controlleres.document.insert(index, '\n');
    _controlleres.document.insert(index+1, embed);
    _controlleres.document.insert(index+2, '\n');
    // 更新光标位置
    _controlleres.updateSelection(
      TextSelection.collapsed(offset: index + 3),
      quill.ChangeSource.LOCAL,
    );
    // final index = _controlleres!.selection.baseOffset;
    // final videoEmbed = 'video:$videoUrl'; // 使用自定义的格式来表示视频嵌入
    // final delta = delta.Delta()..insert(videoEmbed, {'type': 'video'});
    // _controlleres!.document.compose(delta);
    // _controlleres!.updateSelection(TextSelection.collapsed(offset: index + 1));
  }


  ///注销页面
  @override
  void dispose() {
    super.dispose();
    logic.releaseFlauto();
    _stopPlayer();
  }


  final InputDecoration decoration = InputDecoration(
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
              _stopPlayer();
              setState(() {});
            });
      } else {
        ToastInfo('音频加载失败'.tr);
      }
    } catch (err) {}
    setState(() {});
  }

  ///结束播放
  Future<void> _stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      state.Startplaying = false;
      logic.update();
      print('===> 结束播放');
      //_cancelPlayerSubscriptions();
    } catch (err) {
      print('==> 错误: $err');
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
      print('===> 暂停播放');
    } else {
      playerModule.resumePlayer();
      state.AudioPause = false;
      // _state = RecordPlayState.playing;
      print('===> 继续播放');
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
  ///提取地址
  void extractImageAndIframeSources(String html) {
    final document = html_parser.parse(html);

    final imgElements = document.querySelectorAll('img');
    final iframeElements = document.querySelectorAll('iframe');

    var srcList = [];

    for (final element in imgElements) {
      final src = element.attributes['src'];
      if (src != null) {
        srcList.add({'type':1,"asset":src,"network":''});
        // logic.state.Longgraphicvideodata.add({'type':1,"asset":imageUrl,"network":''});
      }
    }

    for (final element in iframeElements) {
      final src = element.attributes['src'];
      if (src != null) {
        srcList.add({'type':2,"asset":src,"network":''});
      }
    }
    logic.state.Longgraphicvideodata=srcList;
    print('Image and Iframe src addresses: ${logic.state.Longgraphicvideodata}');
  }
  //final AssetEntity? entity = await CameraPicker.pickFromCamera(context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        key:AppBarheight,
        leadingWidth: 58,
        leading:
        FittedBox(
          fit: BoxFit.none, // 或 BoxFit.fitWidth
          child:
          !showlongtw
              ? IconButton(
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
                  icon: SvgPicture.asset(
                    "assets/icons/fanhui.svg",
                  ),
                )
              : GestureDetector(
                  child: Container(
                    alignment: Alignment.center,

                    child: Container(
                      margin: EdgeInsets.only(right: 15),
                      alignment: Alignment.center,
                      width: 58,
                      height: 28,
                      // padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.all(Radius.circular(38))
                      ),
                      child: Text(
                        '完成'.tr,
                        style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w600,),
                      ),
                    ),
                  ),
                  onTap: () {
                    print('新数据123${state.formData['text']}');
                    setState(() {
                      showlongtw = false;
                    });
                    extractImageAndIframeSources(state.formData['text']);
                  },
                ),
        ),
        actions: [
          GestureDetector(child: Container(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Icon(
              Icons.info_outline,
              color: Colors.black12,
              size: 28,
            ),
          ), onTap: () {
            Get.defaultDialog(titlePadding: EdgeInsets.fromLTRB(8, 20, 8, 8),
                content:
                Container(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('LanLa鼓励向上、真实、原创的内容，含以下内容的笔记将不会被推荐：'.tr),
                    SizedBox(height: 10,),
                    Text('1．含有不文明语言、过度性感图片；'.tr),
                    SizedBox(height: 10,),
                    Text('2．含有网址链接、联系方式、二维码或售卖语言；'.tr),
                    SizedBox(height: 10,),
                    Text('3．冒充他人身份或搬运他人作品；'.tr),
                    SizedBox(height: 10,),
                    Text('4．为刻意博取眼球，在标题、封面等处使用夸张表达'.tr),
                  ],
                ), padding: EdgeInsets.fromLTRB(0, 10, 20, 10),),
                confirm: Column(children: [
                  ElevatedButton(onPressed: () {
                    Get.back();
                  },
                    child: Text(
                      "我知道了".tr, style: TextStyle(color: Colors.white),),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color(0xff000000)), //背景颜色
                    ),),
                  SizedBox(height: 20,),
                ],),
                title: '发布小贴士'.tr,
                titleStyle: TextStyle(fontSize: 16));
          },)
        ],
      ),
      body: GestureDetector(child:
      !showlongtw?Container(height: MediaQuery.of(context).size.height,color: Colors.white, child:
        SingleChildScrollView(
          controller: _controller,
          child:
          GetBuilder<LonggraphictextLogic>(builder: (logic) {
            return Container(
              height: MediaQuery.of(context).size.height-200,
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child:
                  GestureDetector(child:  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                      bottom: 8,
                    ),
                    child: SingleChildScrollView(child:
                    state.formData['text']!=null&&state.formData['text']!=''?
                        Container(width: double.infinity,child:
                        htmljx.HtmlWidget(
                          state.formData['text'],
                          customWidgetBuilder: (element) {
                            if (element.localName == 'iframe') {
                              final videoUrl = element.attributes['src'];
                              if (videoUrl != null) {
                                return _ButterFlyAssetVideo(
                                  data: videoUrl,
                                );
                              }
                            }
                            if (element.localName == 'img') {
                              final pictureUrl = element.attributes['src'];
                              if (pictureUrl != null) {
                                  return Container(padding:EdgeInsets.only(top: 10,bottom: 10),width: double.infinity,alignment:Alignment.center,child: Container(
                                    width: element.attributes['style']!.contains('width:50%;')?MediaQuery.of(context).size.width*0.5:double.infinity,
                                    child:
                                    // CachedNetworkImage(
                                    //   imageUrl: pictureUrl,
                                    //   fit: BoxFit.cover,
                                    //   placeholder: (context, url) => Container(
                                    //     width: MediaQuery.of(context).size.width,
                                    //     constraints: BoxConstraints(minHeight: 100),
                                    //     child: Center(
                                    //       child: CircularProgressIndicator(
                                    //         color: Color(0xffD1FF34),
                                    //         strokeWidth: 4,
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                    Image.file(
                                      File(pictureUrl),
                                    )
                                  ),);
                              }
                            }
                            return null;
                          },
                        ),)
                    :Text("说说你此刻的心情".tr,style: TextStyle(color: Colors.black12,fontSize: 16))),

                  ),onTap: (){
                    // print('淡季了');
                    setState(() {
                      showlongtw=true;
                    });
                    focusNode.requestFocus();
                  },)
                  ),
                  ///新标签位置
                  Container(alignment: Alignment.centerRight,
                    child: Container(padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      decoration: BoxDecoration(color: Color(0xfff5f5f5),
                          borderRadius: BorderRadius.all(Radius.circular(20))),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        GestureDetector(child: SizedBox(
                          width: 20,
                          child: SvgPicture.asset(
                            "assets/icons/publish/dingwei.svg",
                            color: logic.state.positioninformation.toString() ==
                                '{}' ? Color(0xffe4e4e4) : Colors.black,
                          ),
                        ),onTap: (){
                          Get.toNamed('/verify/locationlist');
                        },),

                        GestureDetector(child: Container(
                          constraints: BoxConstraints(
                            maxWidth: 210,
                          ),
                          child: logic.state.positioninformation
                              .toString() ==
                              '{}'
                              ? Text(
                            '添加地址'.tr,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Color(0xff666666),
                                fontSize: 12,
                                height: 1),
                          )
                              : Text(
                              logic.state.positioninformation['name'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Color(0xff666666),
                                  fontSize: 12,
                                  height: 1)),
                        ),onTap: (){
                          Get.toNamed('/verify/locationlist');
                        },),
                        if(logic.state.positioninformation
                            .toString() !=
                            '{}')SizedBox(width: 5,),
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
                                color: Color(0xffE1E1E1),
                              ),
                            ),
                          ),
                          onTap: () {
                            logic.state.positioninformation = {};
                            logic.update();
                          },
                        ):Container(width: 3,),
                      ],)
                      ,),),
                  SizedBox(height: 15,),
                  Divider(height: 1.0,color: Color(0xffF1F1F1),),
                  ///录音
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                "assets/icons/publish/mac.svg",
                                color: logic.state.formData["recorderpath"]!=null&&logic.state
                                    .formData["recorderpath"] != ''
                                    ? Colors.black
                                    : Color(0xffe4e4e4),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              logic.state.formData["recorderpath"]!=null&&logic.state.formData["recorderpath"] != ''
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
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          height: 16,
                                          decoration: BoxDecoration(
                                              image:
                                              DecorationImage(
                                                image: AssetImage(
                                                  'assets/images/yinbotwo.png',
                                                ),
                                                fit: BoxFit.fill,
                                              )),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text(
                                        "${logic.state
                                            .formData['recordingtime']}s",
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight:
                                            FontWeight.w600),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : GestureDetector(
                                child: Padding(
                                    padding: EdgeInsets.only(right: 10),
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
                              SizedBox(
                                width: 15,
                              ),
                              if (logic.state.formData["recorderpath"]!=null&&logic.state.formData["recorderpath"] != '')
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
                              SizedBox(
                                width: 40,
                              ),
                              // GestureDetector(child:Text('播放') ,onTap: (){
                              //   _startPlayer(logic.state.formData["recorderpath"]);
                              // },)
                            ],
                          ),
                        ),
                        // Icon(Icons.chevron_right,)
                      ],
                    ),
                  ),
                  Divider(
                    height: 1.0,
                    color: Color(0xffF1F1F1),
                  ),
                  GestureDetector(
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
                              color: logic.state.selectTopic.isEmpty ? Color(
                                  0xffe4e4e4) : Colors.black,
                            ),
                          ),
                          Expanded(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: logic.state.selectTopic.isEmpty
                                    ? Padding(
                                    padding: EdgeInsets.only(right: 10),
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
                  ),
                  Divider(
                    height: 1.0,
                    color: Color(0xffF1F1F1),
                  ),
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
                              color: Check ? Colors.black : Color(0xffe4e4e4),
                            )),
                        if(logic.state.formData['channel']!=null)Expanded(
                            child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: startLogic.state.channelDataSource
                                      .map((x) =>
                                      _channalTag(
                                          x.name,
                                          x.id,
                                          logic.state.formData['channel'],
                                          logic))
                                      .toList(),
                                ))),
                      ],
                    ),
                  ),
                  ///关联宝贝
                  const Divider(
                    height: 1.0,
                    color: Color(0xffF1F1F1),
                  ),
                  GestureDetector(
                    onTap: () {
                      //Get.to(commodityPage());
                      Get.to(PricecomparisonpageCorrelation())?.then((value) {
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
                        children: [
                          Container(
                            alignment: Alignment.centerRight,
                            width: 18,
                            child: SvgPicture.asset(
                              "assets/svg/guanlianht.svg",
                              color: logic.state.listItem.length ==
                                  0 ? Color(0xffe4e4e4) : Colors.black,
                            ),
                          ),
                          Expanded(
                              child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Text('关联宝贝'.tr))
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    child: Column(
                      children: logic.state.listItem.length > 0 ? logic.state.listItem.map((value){
                        return
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(color: Color(0xffF5F5F5),borderRadius: BorderRadius.all(Radius.circular(5)),),
                                margin: EdgeInsets.only(bottom: 10),
                                padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                  Row(children: [Container(width: 40, height: 40,
                                    //超出部分，可裁剪
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                      color:Color(0xfff5f5f5),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Image.network(
                                      value.thumbnail,
                                      //fit: BoxFit.fill,
                                      fit: BoxFit.cover,
                                      width: 40, height: 40,
                                    ),
                                  ),
                                    SizedBox(width: 5,),
                                    Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                      Container(constraints: BoxConstraints(maxWidth: 200,),child:
                                      Text(value.title,overflow: TextOverflow.ellipsis,
                                        maxLines: 1,style: TextStyle(fontSize: 14),),),
                                      SizedBox(height: 5,),
                                      Row(children: [
                                        Container(height: 25,child: Text('评估'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 14),),),
                                        SizedBox(width: 5,),
                                        XMStartRating(rating: double.parse(value.score) ,showtext:true)
                                      ],),
                                    ]),],),
                                  GestureDetector(child: Container(
                                    width: 15,
                                    height: 15,
                                    child: SvgPicture.asset(
                                      "assets/svg/cha.svg",
                                      color: Color(0xff999999),
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
                  if(logic.state.listItem.length>0&&logic.state.listItem.length<3)GestureDetector(
                    child: Container(width: double.infinity,height: 47,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/xuxian.png'),
                          fit: BoxFit.fill, // 完全填充
                        ),
                      ),
                      child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text('继续关联'.tr),SizedBox(width: 10,),SvgPicture.asset(
                        "assets/svg/jia.svg",
                        width: 10,
                        height: 10,
                      )],),
                    ),
                    onTap: (){
                      Get.to(PricecomparisonpageCorrelation())?.then((value) {
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
            );
          },
        ),)):
      // KeyboardActions(
      //           config: KeyboardActionsConfig(
      //               keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      //               keyboardBarColor: Colors.white,
      //               nextFocus: false,
      //               defaultDoneWidget: Text("完成".tr),
      //               actions: [
      //                 KeyboardActionsItem(
      //                   focusNode: focusNode,
      //                   toolbarButtons: [
      //                         (node) {
      //                       return
      //                       Container(width: MediaQuery.of(context).size.width,
      //                         child: Row(
      //                         mainAxisAlignment:MainAxisAlignment.start,
      //                         children: [
      //                           SizedBox(width: 10,),
      //                           quill.QuillIconButton(highlightElevation: 0, hoverElevation: 0, size: 25,
      //                             icon:SvgPicture.asset(
      //                               "assets/svg/Vector.svg",
      //                             ),
      //                             fillColor: _controlleres.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key)
      //                                 ? Colors.red
      //                                 : null,
      //                             onPressed: () {
      //                               final style = _controlleres.getSelectionStyle();
      //                               final isBold = style.attributes.containsKey(quill.Attribute.bold.key);
      //                               _controlleres.formatSelection(
      //                                 isBold ? quill.Attribute.clone(quill.Attribute.bold, null) : quill.Attribute.bold,
      //                               );
      //                               setState(() {
      //                                 // Reset fillColor to null after the format is applied or canceled
      //
      //                               });
      //                             },
      //                           ),
      //                           SizedBox(width: 10,),
      //                           quill.QuillIconButton(
      //                             highlightElevation: 0,
      //                             hoverElevation: 0,
      //                             size: 25,
      //                             icon: SvgPicture.asset(
      //                               "assets/svg/zisize.svg",
      //                             ),
      //                             onPressed: () {
      //                               showDialog(
      //                                 context: context,
      //                                 builder: (context) => AlertDialog(
      //                                   title: Text('Select Font Size'),
      //                                   content:StatefulBuilder(
      //                                       builder: (BuildContext context, StateSetter setState) {
      //                                         return Column(
      //                                           mainAxisSize: MainAxisSize.min,
      //                                           children: [
      //                                             ElevatedButton(
      //                                               onPressed: () {
      //                                                 final selectionStyle = quill.Attribute.clone(
      //                                                     quill.Attribute.size, '16');
      //                                                 _controlleres.formatSelection(selectionStyle);
      //                                                 Navigator.pop(context);
      //                                               },
      //                                               child: Text('Small'),
      //                                               style: ElevatedButton.styleFrom(
      //                                                 backgroundColor: _controlleres
      //                                                     .getSelectionStyle()
      //                                                     .attributes
      //                                                     .containsKey(quill.Attribute.size.key) &&
      //                                                     _controlleres
      //                                                         .getSelectionStyle()
      //                                                         .attributes[quill.Attribute.size.key] ==
      //                                                         '16'
      //                                                     ? Colors.red
      //                                                     : null,
      //                                               ),
      //                                             ),
      //                                             ElevatedButton(
      //                                               onPressed: () {
      //                                                 final selectionStyle = quill.Attribute.clone(
      //                                                     quill.Attribute.size, '18');
      //                                                 _controlleres.formatSelection(selectionStyle);
      //                                                 Navigator.pop(context);
      //                                               },
      //                                               child: Text('Medium'),
      //                                               style: ElevatedButton.styleFrom(
      //                                                 backgroundColor: _controlleres
      //                                                     .getSelectionStyle()
      //                                                     .attributes
      //                                                     .containsKey(quill.Attribute.size.key) &&
      //                                                     _controlleres
      //                                                         .getSelectionStyle()
      //                                                         .attributes[quill.Attribute.size.key] ==
      //                                                         '18'
      //                                                     ? Colors.red
      //                                                     : null,
      //                                               ),
      //                                             ),
      //                                             ElevatedButton(
      //                                               onPressed: () {
      //                                                 final selectionStyle = quill.Attribute.clone(
      //                                                     quill.Attribute.size, '20');
      //                                                 _controlleres.formatSelection(selectionStyle);
      //                                                 setState(()=>{});
      //                                                 // Navigator.pop(context);
      //                                               },
      //                                               child: Text('Large'),
      //                                               style: ElevatedButton.styleFrom(
      //                                                 backgroundColor: _controlleres
      //                                                     .getSelectionStyle()
      //                                                     .attributes
      //                                                     .containsKey(quill.Attribute.size.key) &&
      //                                                     _controlleres
      //                                                         .getSelectionStyle()
      //                                                         .attributes[quill.Attribute.size.key] ==
      //                                                         '20'
      //                                                     ? Colors.red
      //                                                     : null,
      //                                               ),
      //                                             ),
      //                                           ],
      //                                         );
      //                                       }
      //                                   ),
      //                                 ),
      //                               );
      //                             },
      //                           ),
      //                           SizedBox(width: 10,),
      //                           quill.QuillIconButton(
      //                             highlightElevation: 0,
      //                             hoverElevation: 0,
      //                             size: 25,
      //                             icon:SvgPicture.asset(
      //                               "assets/svg/longtup.svg",
      //                             ),
      //                             onPressed: () {
      //                               _insertImage();
      //                             },
      //                           ),
      //                           SizedBox(width: 10,),
      //                           quill.QuillIconButton(
      //                             highlightElevation: 0,
      //                             hoverElevation: 0,
      //                             size: 25,
      //                             icon:SvgPicture.asset(
      //                               "assets/svg/longship.svg",
      //                             ),
      //                             onPressed: () {
      //                               _insertVideo();
      //                             },
      //                           ),
      //                         ],
      //                       ),
      //                       );
      //                     },
      //                   ],
      //                 ),
      //               ]),
      //           child: Container(
      //               padding: EdgeInsets.fromLTRB(20, 0, 20, 30),
      //               height: MediaQuery.of(context).size.height,
      //               color: Colors.white,
      //               child: Column(
      //                 children: [
      //                   Expanded(
      //                     child: Stack(
      //                       children: [
      //                         if (_showPlaceholder &&
      //                             (state.formData['text'] == '' ||
      //                                 state.formData['text'] == null))
      //                           Positioned(
      //                               right: 0,
      //                               top: 0,
      //                               child: Text(
      //                                 "说说你此刻的心情".tr,
      //                                 style: TextStyle(
      //                                     color: Colors.black12, fontSize: 16),
      //                               )),
      //                         quill.QuillEditor(
      //                           locale: Locale('ar'),
      //                           controller: _controlleres,
      //                           focusNode: focusNode,
      //                           autoFocus: false,
      //                           expands: true,
      //                           padding: EdgeInsets.zero,
      //                           scrollController: ScrollController(),
      //                           scrollable: true,
      //                           readOnly: false,
      //                           embedBuilders: [
      //                             CustomImageEmbedBuilder(
      //                                 aspectRatio: setaspectRatio,
      //                                 onAspectRatioChanged: (double value) {
      //                                   setState(() {
      //                                     setaspectRatio = value;
      //                                   });
      //                                 }),
      //                             CustomVideoEmbedBuilder(),
      //                             // ...FlutterQuillEmbeds.builders(),// 添加自定义视频EmbedBuilder
      //                           ],
      //                         )
      //                       ],
      //                     ),
      //                   ),
      //                   Container(width: MediaQuery.of(context).size.width,
      //                     child: Row(
      //                       mainAxisAlignment:MainAxisAlignment.start,
      //                       children: [
      //                         SizedBox(width: 10,),
      //                         quill.QuillIconButton(highlightElevation: 0, hoverElevation: 0, size: 25,
      //                           icon:SvgPicture.asset(
      //                             "assets/svg/Vector.svg",
      //                           ),
      //                           fillColor: _controlleres.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key)
      //                               ? Colors.red
      //                               : null,
      //                           onPressed: () {
      //                             final style = _controlleres.getSelectionStyle();
      //                             final isBold = style.attributes.containsKey(quill.Attribute.bold.key);
      //                             _controlleres.formatSelection(
      //                               isBold ? quill.Attribute.clone(quill.Attribute.bold, null) : quill.Attribute.bold,
      //                             );
      //                             setState(() {
      //                               // Reset fillColor to null after the format is applied or canceled
      //
      //                             });
      //                           },
      //                         ),
      //                         SizedBox(width: 10,),
      //                         quill.QuillIconButton(
      //                           highlightElevation: 0,
      //                           hoverElevation: 0,
      //                           size: 25,
      //                           icon: SvgPicture.asset(
      //                             "assets/svg/zisize.svg",
      //                           ),
      //                           onPressed: () {
      //                             showDialog(
      //                               context: context,
      //                               builder: (context) => AlertDialog(
      //                                 title: Text('Select Font Size'),
      //                                 content:StatefulBuilder(
      //                                     builder: (BuildContext context, StateSetter setState) {
      //                                       return Column(
      //                                         mainAxisSize: MainAxisSize.min,
      //                                         children: [
      //                                           ElevatedButton(
      //                                             onPressed: () {
      //                                               final selectionStyle = quill.Attribute.clone(
      //                                                   quill.Attribute.size, '16');
      //                                               _controlleres.formatSelection(selectionStyle);
      //                                               Navigator.pop(context);
      //                                             },
      //                                             child: Text('Small'),
      //                                             style: ElevatedButton.styleFrom(
      //                                               backgroundColor: _controlleres
      //                                                   .getSelectionStyle()
      //                                                   .attributes
      //                                                   .containsKey(quill.Attribute.size.key) &&
      //                                                   _controlleres
      //                                                       .getSelectionStyle()
      //                                                       .attributes[quill.Attribute.size.key] ==
      //                                                       '16'
      //                                                   ? Colors.red
      //                                                   : null,
      //                                             ),
      //                                           ),
      //                                           ElevatedButton(
      //                                             onPressed: () {
      //                                               final selectionStyle = quill.Attribute.clone(
      //                                                   quill.Attribute.size, '18');
      //                                               _controlleres.formatSelection(selectionStyle);
      //                                               Navigator.pop(context);
      //                                             },
      //                                             child: Text('Medium'),
      //                                             style: ElevatedButton.styleFrom(
      //                                               backgroundColor: _controlleres
      //                                                   .getSelectionStyle()
      //                                                   .attributes
      //                                                   .containsKey(quill.Attribute.size.key) &&
      //                                                   _controlleres
      //                                                       .getSelectionStyle()
      //                                                       .attributes[quill.Attribute.size.key] ==
      //                                                       '18'
      //                                                   ? Colors.red
      //                                                   : null,
      //                                             ),
      //                                           ),
      //                                           ElevatedButton(
      //                                             onPressed: () {
      //                                               final selectionStyle = quill.Attribute.clone(
      //                                                   quill.Attribute.size, '20');
      //                                               _controlleres.formatSelection(selectionStyle);
      //                                               setState(()=>{});
      //                                               // Navigator.pop(context);
      //                                             },
      //                                             child: Text('Large'),
      //                                             style: ElevatedButton.styleFrom(
      //                                               backgroundColor: _controlleres
      //                                                   .getSelectionStyle()
      //                                                   .attributes
      //                                                   .containsKey(quill.Attribute.size.key) &&
      //                                                   _controlleres
      //                                                       .getSelectionStyle()
      //                                                       .attributes[quill.Attribute.size.key] ==
      //                                                       '20'
      //                                                   ? Colors.red
      //                                                   : null,
      //                                             ),
      //                                           ),
      //                                         ],
      //                                       );
      //                                     }
      //                                 ),
      //                               ),
      //                             );
      //                           },
      //                         ),
      //                         SizedBox(width: 10,),
      //                         quill.QuillIconButton(
      //                           highlightElevation: 0,
      //                           hoverElevation: 0,
      //                           size: 25,
      //                           icon:SvgPicture.asset(
      //                             "assets/svg/longtup.svg",
      //                           ),
      //                           onPressed: () {
      //                             _insertImage();
      //                           },
      //                         ),
      //                         SizedBox(width: 10,),
      //                         quill.QuillIconButton(
      //                           highlightElevation: 0,
      //                           hoverElevation: 0,
      //                           size: 25,
      //                           icon:SvgPicture.asset(
      //                             "assets/svg/longship.svg",
      //                           ),
      //                           onPressed: () {
      //                             _insertVideo();
      //                           },
      //                         ),
      //                       ],
      //                     ),
      //                   )
      //                 ],
      //               ))),
      Column(children: [
        Expanded(
          child: Container(padding: EdgeInsets.only(left: 20,right: 20),child:Stack(
            children: [
              if (_showPlaceholder &&
                  (state.formData['text'] == '' ||
                      state.formData['text'] == null))
                Positioned(
                    right: 0,
                    top: 0,
                    child: Text(
                      "说说你此刻的心情".tr,
                      style: TextStyle(
                          color: Colors.black12, fontSize: 16),
                    )),
              quill.QuillEditor(
                locale: Locale('ar'),
                controller: _controlleres,
                focusNode: focusNode,
                autoFocus: false,
                expands: true,
                padding: EdgeInsets.only(bottom: 20,top: 5),
                scrollController: ScrollController(),
                scrollable: true,
                readOnly: false,
                embedBuilders: [
                  CustomImageEmbedBuilder(
                      changewh: changewh,
                      onAspectRatioChanged: (url,types) {
                        if(types==2){
                          if(changewh.contains(url)){
                            changewh.remove(url);
                          }
                        }else if(types==1){
                          if(!changewh.contains(url)){
                            changewh.add(url);
                          }
                        }
                        setState(() {});
                      }),
                  CustomVideoEmbedBuilder(),
                  // ...FlutterQuillEmbeds.builders(),// 添加自定义视频EmbedBuilder
                ],
              )
            ],
          ),),

        ),
        ///分割线
        Container(height: 1.0, decoration: BoxDecoration(color: Color(0xfff1f1f1), boxShadow: [BoxShadow(color: Color(0x0c00000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
        ),),
        Container(width: MediaQuery.of(context).size.width,
          height: 45,
          child: Row(
            mainAxisAlignment:MainAxisAlignment.start,
            children: [
              SizedBox(width: 20,),
              GestureDetector(child: Container(
                width: 25,
                height: 25,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:  _controlleres.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key)
                      ? Color(0xffD1FF34)
                      : null,
                  borderRadius: BorderRadius.all(Radius.circular(5))
                ),
               child: SvgPicture.asset(
                 width: 12,
                 height: 15,
                  "assets/svg/Vector.svg",
              ),),onTap: (){
                final style = _controlleres.getSelectionStyle();
                final isBold = style.attributes.containsKey(quill.Attribute.bold.key);
                if(isBold){
                  BoldText=false;
                }else{
                  BoldText=true;
                }
                _controlleres.formatSelection(
                  isBold ? quill.Attribute.clone(quill.Attribute.bold, null) : quill.Attribute.bold,
                );

                setState(() {
                  // Reset fillColor to null after the format is applied or canceled

                });
              },),
              SizedBox(width: 15,),
              GestureDetector(child: Container(
                padding: EdgeInsets.all(5),
               child: SvgPicture.asset(
                "assets/svg/zisize.svg",
                 width: 18,
                 height: 16,
              ),),onTap: (){
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Colors.transparent, // 设置透明背景色
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 设置边框圆角
                    ),
                    contentPadding: EdgeInsets.all(0),
                    // title: Text('选择字号'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                    content:StatefulBuilder(
                        builder: (BuildContext context, StateSetter setState) {
                          return Container(decoration:BoxDecoration(borderRadius: BorderRadius.circular(10.0), color: Colors.white),child: Column(

                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(height: 30,),
                              Text('选择字号'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),textAlign: TextAlign.center,),
                              SizedBox(height: 30,),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     final selectionStyle = quill.Attribute.clone(
                              //         quill.Attribute.size, '16');
                              //     _controlleres.formatSelection(selectionStyle);
                              //     Navigator.pop(context);
                              //   },
                              //   child: Text('Small'),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: _controlleres
                              //         .getSelectionStyle()
                              //         .attributes
                              //         .containsKey(quill.Attribute.size.key) &&
                              //         _controlleres
                              //             .getSelectionStyle()
                              //             .attributes[quill.Attribute.size.key] ==
                              //             '16'
                              //         ? Colors.red
                              //         : null,
                              //   ),
                              // ),
                              GestureDetector(child: Container(width: 150,height: 50,alignment:Alignment.center,decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05), // 设置阴影颜色
                                    offset: Offset(0, 1), // 设置阴影偏移量
                                    blurRadius: 2, // 设置阴影模糊半径
                                    spreadRadius: 2, // 设置阴影扩展半径
                                  ),
                                ],),child: Text('小'.tr,style: TextStyle(fontSize: 14),),),onTap: (){
                                final selectionStyle = quill.Attribute.clone(
                                    quill.Attribute.size, '14');
                                _controlleres.formatSelection(selectionStyle);
                                Navigator.pop(context);
                              },),
                              SizedBox(height: 25,),
                              GestureDetector(child: Container(width: 150,height: 50,alignment:Alignment.center,decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05), // 设置阴影颜色
                                    offset: Offset(0, 1), // 设置阴影偏移量
                                    blurRadius: 2, // 设置阴影模糊半径
                                    spreadRadius: 2, // 设置阴影扩展半径
                                  ),
                                ],),child: Text('中'.tr,style: TextStyle(fontSize: 16),),),onTap: (){
                                final selectionStyle = quill.Attribute.clone(
                                    quill.Attribute.size, '16');
                                _controlleres.formatSelection(selectionStyle);
                                Navigator.pop(context);
                              },),
                              SizedBox(height: 25,),
                              GestureDetector(child: Container(width: 150,height: 50,alignment:Alignment.center,decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.circular(50.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.05), // 设置阴影颜色
                                    offset: Offset(0, 1), // 设置阴影偏移量
                                    blurRadius: 2, // 设置阴影模糊半径
                                    spreadRadius: 2, // 设置阴影扩展半径
                                  ),
                                ],),child: Text('大'.tr,style: TextStyle(fontSize: 18),),),onTap: (){
                                final selectionStyle = quill.Attribute.clone(
                                    quill.Attribute.size, '18');
                                _controlleres.formatSelection(selectionStyle);
                                Navigator.pop(context);
                              },),
                              SizedBox(height: 30,),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     final selectionStyle = quill.Attribute.clone(
                              //         quill.Attribute.size, '18');
                              //     _controlleres.formatSelection(selectionStyle);
                              //     Navigator.pop(context);
                              //   },
                              //   child: Text('Medium'),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: _controlleres
                              //         .getSelectionStyle()
                              //         .attributes
                              //         .containsKey(quill.Attribute.size.key) &&
                              //         _controlleres
                              //             .getSelectionStyle()
                              //             .attributes[quill.Attribute.size.key] ==
                              //             '18'
                              //         ? Colors.red
                              //         : null,
                              //   ),
                              // ),
                              // ElevatedButton(
                              //   onPressed: () {
                              //     final selectionStyle = quill.Attribute.clone(
                              //         quill.Attribute.size, '20');
                              //     _controlleres.formatSelection(selectionStyle);
                              //     setState(()=>{});
                              //     // Navigator.pop(context);
                              //   },
                              //   child: Text('Large'),
                              //   style: ElevatedButton.styleFrom(
                              //     backgroundColor: _controlleres
                              //         .getSelectionStyle()
                              //         .attributes
                              //         .containsKey(quill.Attribute.size.key) &&
                              //         _controlleres
                              //             .getSelectionStyle()
                              //             .attributes[quill.Attribute.size.key] ==
                              //             '20'
                              //         ? Colors.red
                              //         : null,
                              //   ),
                              // ),
                            ],
                          ),);
                        }
                    ),
                  ),
                );
              },),
              SizedBox(width: 15,),
              GestureDetector(child: Container(
                padding: EdgeInsets.all(5),
                child: SvgPicture.asset(
                  width: 19,
                  height: 19,
                "assets/svg/longtup.svg",
              ),),onTap: (){
                _insertImage();
              },),
              SizedBox(width: 15,),
              GestureDetector(child: Container(
                padding: EdgeInsets.all(5),
                child: SvgPicture.asset(
                  width: 24,
                  height: 24,
                "assets/svg/longship.svg",
              ),),onTap: (){
                _insertVideo();
              },),
              // quill.QuillIconButton(highlightElevation: 0, hoverElevation: 0, size: 25,
              //   icon:SvgPicture.asset(
              //     "assets/svg/Vector.svg",
              //   ),
              //   fillColor: _controlleres.getSelectionStyle().attributes.containsKey(quill.Attribute.bold.key)
              //       ? Colors.red
              //       : null,
              //   onPressed: () {
              //     final style = _controlleres.getSelectionStyle();
              //     final isBold = style.attributes.containsKey(quill.Attribute.bold.key);
              //     _controlleres.formatSelection(
              //       isBold ? quill.Attribute.clone(quill.Attribute.bold, null) : quill.Attribute.bold,
              //     );
              //     setState(() {
              //       // Reset fillColor to null after the format is applied or canceled
              //
              //     });
              //   },
              // ),
              // SizedBox(width: 10,),
              // quill.QuillIconButton(
              //   highlightElevation: 0,
              //   hoverElevation: 0,
              //   size: 25,
              //   icon: SvgPicture.asset(
              //     "assets/svg/zisize.svg",
              //   ),
              //   onPressed: () {
              //     showDialog(
              //       context: context,
              //       builder: (context) => AlertDialog(
              //         title: Text('Select Font Size'),
              //         content:StatefulBuilder(
              //             builder: (BuildContext context, StateSetter setState) {
              //               return Column(
              //                 mainAxisSize: MainAxisSize.min,
              //                 children: [
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       final selectionStyle = quill.Attribute.clone(
              //                           quill.Attribute.size, '16');
              //                       _controlleres.formatSelection(selectionStyle);
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text('Small'),
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: _controlleres
              //                           .getSelectionStyle()
              //                           .attributes
              //                           .containsKey(quill.Attribute.size.key) &&
              //                           _controlleres
              //                               .getSelectionStyle()
              //                               .attributes[quill.Attribute.size.key] ==
              //                               '16'
              //                           ? Colors.red
              //                           : null,
              //                     ),
              //                   ),
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       final selectionStyle = quill.Attribute.clone(
              //                           quill.Attribute.size, '18');
              //                       _controlleres.formatSelection(selectionStyle);
              //                       Navigator.pop(context);
              //                     },
              //                     child: Text('Medium'),
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: _controlleres
              //                           .getSelectionStyle()
              //                           .attributes
              //                           .containsKey(quill.Attribute.size.key) &&
              //                           _controlleres
              //                               .getSelectionStyle()
              //                               .attributes[quill.Attribute.size.key] ==
              //                               '18'
              //                           ? Colors.red
              //                           : null,
              //                     ),
              //                   ),
              //                   ElevatedButton(
              //                     onPressed: () {
              //                       final selectionStyle = quill.Attribute.clone(
              //                           quill.Attribute.size, '20');
              //                       _controlleres.formatSelection(selectionStyle);
              //                       setState(()=>{});
              //                       // Navigator.pop(context);
              //                     },
              //                     child: Text('Large'),
              //                     style: ElevatedButton.styleFrom(
              //                       backgroundColor: _controlleres
              //                           .getSelectionStyle()
              //                           .attributes
              //                           .containsKey(quill.Attribute.size.key) &&
              //                           _controlleres
              //                               .getSelectionStyle()
              //                               .attributes[quill.Attribute.size.key] ==
              //                               '20'
              //                           ? Colors.red
              //                           : null,
              //                     ),
              //                   ),
              //                 ],
              //               );
              //             }
              //         ),
              //       ),
              //     );
              //   },
              // ),
              // SizedBox(width: 10,),
              // quill.QuillIconButton(
              //   highlightElevation: 0,
              //   hoverElevation: 0,
              //   size: 25,
              //   icon:SvgPicture.asset(
              //     "assets/svg/longtup.svg",
              //   ),
              //   onPressed: () {
              //     _insertImage();
              //   },
              // ),
              // SizedBox(width: 10,),
              // quill.QuillIconButton(
              //   highlightElevation: 0,
              //   hoverElevation: 0,
              //   size: 25,
              //   icon:SvgPicture.asset(
              //     "assets/svg/longship.svg",
              //   ),
              //   onPressed: () {
              //     _insertVideo();
              //   },
              // ),
            ],
          ),
        )
      ],),
      onTap: (){
          // FocusScope.of(context).unfocus();
        },),
      bottomNavigationBar: !showlongtw?Container(
        color: Colors.white,
        height: 70,
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
                  onTap: () {
                    logic.onPublish(context);
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: 70,
                    padding: EdgeInsets.only(bottom: 3),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Center(
                      child: Text(
                        '发布笔记'.tr,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ):null,
    );
  }
  Widget _channalTag(String name, int id, int activeId, LonggraphictextLogic logic) {
    if (id == 0) {
      return Container();
    }
    return Container(
      margin: EdgeInsets.only(right: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: id == activeId ? Colors.white : Colors.black87,
          backgroundColor: id == activeId ? Colors.black : Colors.white,
          surfaceTintColor: Colors.white,
          minimumSize: Size(66, 28),
          padding: EdgeInsets.symmetric(horizontal: 16),
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
            SizedBox(
              height: 55,
            ),
            Text(
              '快用语音简单描述一下吧'.tr,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
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
  final logics = Get.find<LonggraphictextLogic>();
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
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
    _cancelRecorderSubscriptions();
    stopRecorder();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LonggraphictextLogic>(builder: (logic) {
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
                    padding: EdgeInsets.fromLTRB(20, 8, 20, 8),
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
                color: Color.fromARGB(1, 0, 0, 0), //一个透明的color
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
                      trackColor: Color(0xfff1f1f1),
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
                      color: Color(0xffF5F5F5),
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
    await recorderModule!.openRecorder();
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
          toFile: "${dir.path}/${path}",
          codec: Codec.aacADTS,
        )
            .then((value) {
          setState(() {});
        });
        recorderModule.setSubscriptionDuration(Duration(milliseconds: 1000));

        /// 监听录音
        recorderSubscription = recorderModule.onProgress!.listen((e) {
          if (e != null && e.duration != null) {
            var date = DateTime.fromMillisecondsSinceEpoch(
                e.duration.inMilliseconds,
                isUtc: true);
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
              return;
            }
          }
        });
      });
    } catch (err) {
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

    File file = File("${dir.path}/${path}");

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
    final recordingUpload = recordingName.putFile(File("${dir.path}/${path}"),);

    await recordingUpload.whenComplete(() {});
    String newThumbnailPath =  await recordingName.getDownloadURL();


    // String newThumbnailPath = await AliOssClient().putObject(
    //     "${dir.path}/${path}",
    //     'thumb',
    //     "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
    //         .hour}${dateTime.minute}${dateTime.second}");

    ///保存本地地址
    logics.state.formData['recorderpath'] = "${dir.path}/${path}";

    ///保存oss地址

    logics.state.formData['ossrecorderpath'] = newThumbnailPath;
    logics.update();
    Navigator.pop(context);
    Navigator.pop(context);
  }

  ///关闭录制
  void stopRecorder() async {
    await recorderModule!.stopRecorder().then((value) {
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
    if (recorderSubscription != null) {
      recorderSubscription.cancel();
    }
  }
}

class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({required this.text}) : super();

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
                Padding(
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

class CustomImageEmbedBuilder extends quill.EmbedBuilder {
  var changewh;
  var onAspectRatioChanged;
  final logic = Get.put(LonggraphictextLogic());

  CustomImageEmbedBuilder({
    required this.changewh,
    required this.onAspectRatioChanged,
  });

  @override
  String get key => 'image';

  void applyStylesToImages(String url,type) {
    final document = html_parser.parse(logic.state.formData['text']);
    final images = document.getElementsByTagName('img');

    for (var image in images) {
      final src = image.attributes['src'];
      final customAttribute = image.attributes['data-custom'];

      if (src == url) {
        if(type==1){
          // 图片有特定标识，应用自定义样式
          image.attributes['style'] = 'max-width: 100%; object-fit: contain; width:50%;display: block;margin: 0 auto;';
        }else if(type==2){
          image.attributes['style'] = 'max-width: 100%; object-fit: contain;display: block;margin: 0 auto;';
        }
      } else {}
    }
    final modifiedHtml = document.outerHtml;
    logic.setFrom('text', modifiedHtml);
  }


  @override
  Widget build(
      BuildContext context,
      quill.QuillController controller,
      quill.Embed node,
      bool readOnly,
      bool requestFocus,
      ) {
    final imageUrl = node.value.data as String?;
    if (imageUrl != null) {
      return Container( padding: EdgeInsets.only(top: 20, bottom: 20),alignment: Alignment.center,child: Container(width: changewh.contains(imageUrl)?MediaQuery.of(context).size.width * 0.5:MediaQuery.of(context).size.width,child: Stack(
        children: [
          Container(
            width: changewh.contains(imageUrl)?MediaQuery.of(context).size.width * 0.5:MediaQuery.of(context).size.width,
            child:
            // CachedNetworkImage(
            //   imageUrl: imageUrl,
            //   fit: BoxFit.cover,
            //   placeholder: (context, url) => Container(
            //     width: MediaQuery.of(context).size.width,
            //     constraints: BoxConstraints(minHeight: 100),
            //     child: Center(
            //       child: CircularProgressIndicator(
            //         color: Color(0xffD1FF34),
            //         strokeWidth: 4,
            //       ),
            //     ),
            //   ),
            // ),
            Image.file(
              File(imageUrl),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Container(height: 23,alignment:Alignment.center,decoration: const BoxDecoration(color: Color.fromRGBO(0, 0, 0, 0.5),borderRadius: BorderRadius.all(Radius.circular(5))),child: Row(children: [
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  applyStylesToImages(imageUrl,1);
                  onAspectRatioChanged(imageUrl,1);
                },
                child: Container(
                  width: 15,
                  height: 15,
                  // padding: EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    "assets/svg/reduce.svg",
                    color: changewh.contains(imageUrl)?Colors.white:Color.fromRGBO(255, 255, 255, 0.5),
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
              SizedBox(width: 10,),
              GestureDetector(
                onTap: () {
                  applyStylesToImages(imageUrl,2);
                  onAspectRatioChanged(imageUrl,2);

                },
                child: SvgPicture.asset(
                  "assets/svg/Tile.svg",
                  color: !changewh.contains(imageUrl)?Colors.white:Color.fromRGBO(255, 255, 255, 0.5),
                  width: 15,
                  height: 15,
                ),
              ),
              SizedBox(width: 10,),
              Container(height: 23,width: 0.5,color: Colors.white,),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: () {
                  controller.document.delete(node.documentOffset, 1);
                },
                child: Container(
                  width: 15,
                  height: 15,
                  // padding: EdgeInsets.all(2),
                  child: SvgPicture.asset(
                    "assets/svg/chahaolong.svg",
                    color: Colors.white,
                    width: 15,
                    height: 15,
                  ),
                ),
              ),
              SizedBox(width: 5,),
            ],),),
          ),
          // Positioned(
          //   top: 10,
          //   right: 10,
          //   child: GestureDetector(
          //     onTap: () {
          //       controller.document.delete(node.documentOffset, 1);
          //     },
          //     child: Container(
          //       width: 22,
          //       height: 22,
          //       padding: EdgeInsets.all(2),
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(50)),
          //         color: Colors.black38,
          //       ),
          //       child: Icon(
          //         Icons.close,
          //         color: Colors.white,
          //         size: 18,
          //       ),
          //     ),
          //   ),
          // ),
          // ///缩小
          // Positioned(
          //   top: 10,
          //   right: 50,
          //   child: GestureDetector(
          //     onTap: () {
          //       applyStylesToImages(imageUrl,1);
          //       onAspectRatioChanged(imageUrl,1);
          //     },
          //     child: Container(
          //       padding: EdgeInsets.all(5),
          //       width: 22,
          //       height: 22,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(50)),
          //         color: Colors.black38,
          //       ),
          //       child: Image.asset('assets/images/reduce.png',color: Colors.white,fit: BoxFit.cover,),
          //     ),
          //   ),
          // ),
          // ///平铺
          // Positioned(
          //   top: 10,
          //   right: 90,
          //   child: GestureDetector(
          //     onTap: () {
          //       applyStylesToImages(imageUrl,2);
          //       onAspectRatioChanged(imageUrl,2);
          //
          //     },
          //     child: Container(
          //       padding: EdgeInsets.all(5),
          //       width: 22,
          //       height: 22,
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.all(Radius.circular(50)),
          //         color: Colors.black38,
          //       ),
          //       child: Image.asset('assets/images/Tile.png',color: Colors.white,fit: BoxFit.cover,),
          //     ),
          //   ),
          // ),
        ],
      ),),);
    } else {
      return SizedBox();
    }
  }
}

class CustomVideoEmbedBuilder extends quill.EmbedBuilder {
  @override
  String get key => 'video';

  @override
  Widget build(
      BuildContext context,
      quill.QuillController controller,
      quill.Embed node,
      bool readOnly,
      bool requestFocus,
      ) {
    final videoUrl = node.value.data as String?;
    if (videoUrl != null) {
      return Container(padding: EdgeInsets.fromLTRB(0, 10, 0, 10),child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: _ButterFlyAssetVideo(
              data: videoUrl,
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                controller.document.delete(node.documentOffset, 1);
              },
              child: Container(
                width: 22,
                height: 22,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  color: Colors.black38,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),);
    } else {
      return SizedBox();
    }
  }
}
class _ButterFlyAssetVideo extends StatefulWidget {
  final  data;
  const _ButterFlyAssetVideo({super.key, required this.data});
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;
// 监控是否暂停
  bool  isPause = true;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.data);
    _controller.initialize().then((_) => setState(() {}));
    // _controller.play();
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
        GestureDetector(child: Stack(alignment: Alignment.bottomCenter, children: [
          Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(0),
              ), clipBehavior: Clip.hardEdge,
              child: Column(
                children: <Widget>[
                  Container(
                    // width: 200,
                    width: MediaQuery.of(context).size.width,
                    child: AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _controller.value.isInitialized
                              ? VideoPlayer(_controller)
                              : Container(),
                          isPause&&_controller.value.isInitialized?Positioned(
                            top: 10,
                            right: 10,
                            left: 10,
                            bottom: 10,
                            // child: Icon(
                            //   Icons.play_circle_outline,
                            //   size: 90,
                            //   color: Colors.white54,
                            // )
                            child: Container(
                                color: Colors.white10,
                                width: 70,
                                height: 70,
                                child: Image.asset('assets/images/zanting.png',width: 18,height: 18,)
                            ),
                          ):Container()
                        ],
                      ),
                    ),
                    // width: MediaQuery.of(context).size.width,
                  ),
                ],
              )
          ),

          ///倍速
          //_ControlsOverlay(controller: _controller),
          ///进度条
          VideoProgressIndicator(_controller, allowScrubbing: true,
            // colors: VideoProgressColors(playedColor: Colors.cyan),
          ),
        ]),onTap: (){
          VideoPlayerValue videoPlayerValue = _controller.value;
          if (videoPlayerValue.isInitialized) {
            // 视频已初始化
            if (videoPlayerValue.isPlaying) {
              // 正播放 --- 暂停
              _controller.pause();
              setState(() {
                isPause = true;
              });
            } else {
              //暂停 ----播放
              _controller.play();
              setState(() {
                isPause = false;
              });
            }
            setState(() {});
          } else {
            // //未初始化
            // videoPlayerValue.isInitialized().then((_) {
            //   // videoPlayerController.play();
            //   // setState(() {});
            // });
          }
        },)
      ,
    );
  }
}
