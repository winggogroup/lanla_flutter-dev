import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart' as dio2;
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/models/commoditylistanalysis.dart';
import 'package:lanla_flutter/pages/detail/share/share.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/me/view.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/services/publish.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:lanla_flutter/ulits/get_location.dart';
import 'package:lanla_flutter/ulits/log_util.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:html/parser.dart' as parser;
import '../../common/controller/PublishDataLogic.dart';
import '../../common/function.dart';
import '../../services/oss.dart';
import '../../ulits/aliyun_oss/client.dart';
import '../../ulits/toast.dart';
import 'state.dart';
import 'package:video_compress/video_compress.dart';

import 'package:flutter_oss_aliyun/flutter_oss_aliyun.dart' as Util;
import 'package:firebase_analytics/firebase_analytics.dart';

///firebase链接谷歌存储桶插件
import 'package:firebase_storage/firebase_storage.dart';

class LonggraphictextLogic extends GetxController {
  final PublishState state = PublishState();
  final publiDataLogic = Get.find<PublishDataLogic>();
  final provider = Get.put<PublishProvider>(PublishProvider());
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  final ossProVider = Get.put(OssProvider());
  final homeLogic = Get.find<HomeLogic>();
  final userLogic = Get.put(UserLogic());
  var videothumbnail='';

  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  ///初始化播放器
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  var schedule=0.0;

  @override
  void onReady() async{
    _initPosition();
    _initForm();
    super.onReady();
  }

  // 初始化表单内容
  _initForm() {
    state.formData = {"title": '', 'text': '', 'channel': 0, 'recorderpath':'',"ossrecorderpath":'',"recordingtime":0};
  }

  // 设置表单内容
  setFrom(String field, dynamic value) {
    state.formData[field] = value;
  }

  // 检测表单必填项
  _checkForm() {
    if (state.formData['title'].replaceAll('\n', '').replaceAll(' ', '').replaceAll('\ufffc', '') == '') {
      ToastInfo('请填写内容'.tr);
      return false;
    }
    if (state.formData['channel'] == 0) {
      ToastInfo('请选择频道'.tr);
      return false;
    }
    return true;
  }

  _initPosition() async {
    state.position = await GetLocation();
  }






  ///申请权限
  void requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  String truncateString(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return text.substring(0, maxLength);
    }
  }

  ///获取视频封面
 getVideoThumbnail(String videoPath) async {

    final thumbnailPath = await VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: ImageFormat.JPEG,
      timeMs: 1000, // 设置截取第一秒的时间
    );

    if (thumbnailPath != null) {
      ///谷歌存储桶设置
      final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
      File imageObj = await CompressImageFile(File(thumbnailPath!));
      ///谷歌上传缩略图
      final spaceRef =  storageRef.child('user/img/Longraphictext'+_getFileName()+'.png');
      final uploadTask = spaceRef.putFile(File(imageObj.path));
      await uploadTask.whenComplete(() {});
      videothumbnail =  await spaceRef.getDownloadURL();

      print('进来了');
      print(videothumbnail);
    }
  }
  ///筛选特殊标签
  String? hasIframeAndFirstIsIframe(String htmlString) {
    final regex = RegExp(r'<iframe|<img');
    final matches = regex.allMatches(htmlString);

    if (matches.isEmpty) {
      return null;
    }

    final firstMatch = matches.first;
    final firstTag = htmlString.substring(firstMatch.start, firstMatch.end);

    if (firstTag.startsWith('<iframe')) {
      final document = parser.parse(htmlString);
      final iframeElement = document.getElementsByTagName('iframe').first;
      if (iframeElement != null) {

        return iframeElement.attributes['src'];
      }
    }

    return null;
  }


  /// 发布内容
  onPublish(context) async {
    //print(truncateString(state.formData['title'].replaceAll('\n', '').replaceAll(' ', '').replaceAll('\ufffc', ''), 24));
    // return;

    ///开启登录验证
    if (!userLogic.checkUserLogin()) {
      Get.toNamed('/public/loginmethod');
      return;
    }
    // 检测表单
    if (!_checkForm()) {
      return false;
    }
    if(!ContentInspection(state.formData['text'])){
      return false;
    }
    // Publicmethods.loades(context);

    final regex = RegExp(r'<iframe|<img');
    final matches = regex.allMatches(state.formData['text']);

    if (matches.isEmpty) {
      final videofm = await VideoThumbnail.thumbnailFile(
        video:  state.Longgraphicvideodata[0]["asset"],
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        timeMs: 1000, // 设置截取第一秒的时间
      );

      publiDataLogic.startPublish(3, videofm!);
    }else{
      publiDataLogic.startPublish(3, state.Longgraphicvideodata[0]["asset"]!);
    }

    Get.offAll(HomePage());
    Timer.periodic(Duration(milliseconds: 500), (timer) {
      homeLogic.setNowPage(3);
      timer.cancel(); //取消定时器
    });
    ///上次视频图片
    await Circularupload();
    publiDataLogic.contentId = await provider.push(
        title: truncateString(state.formData['title'].replaceAll('\n', '').replaceAll('\ufffc', ''), 24),
        text: state.formData['text'],
        goodsId: state.goodIds,
        thumbnail: videothumbnail,
        type: 3,
        lat: state.position?.latitude??0,
        lng: state.position?.longitude??0,
        channel: state.formData['channel'],
        topics:state.selectTopic.map((e) => e["id"]).toList(),
        recordingTime:state.formData['recordingtime'],
        recordingPath:state.formData['ossrecorderpath'],
        videoPath: '',
        attaImageScale: 0,
        placeId:state.positioninformation['placeId']==null?'':state.positioninformation['placeId']
    );
    // Navigator.pop(context);
    if (publiDataLogic.contentId == 0) {
      publiDataLogic.fail("操作失败".tr, "视频上传失败，请检查您的网络后重新上传".tr);
      return;
    }
    // Get.offAll(HomePage());
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   homeLogic.setNowPage(3);
    //   timer.cancel(); //取消定时器
    // });
    await publiDataLogic.finishTasklong();
    // ---任务4-生成分享---
    // 发送成功事件
    print('发送事件');
    eventBus.fire(PublishEvent());
    // ---任务4-生成分享---
    ToastInfo('🌟 发布成功,快去分享给你好朋友吧'.tr);
    await Future.delayed(const Duration(seconds: 2), (){});

    // Get.to(SharePage(), transition: Transition.downToUp, arguments: {
    //   "thumbnailPath": state.thumbnailPath,
    //   "id": publiDataLogic.contentId
    // });
    // 发送成功事件
    eventBus.fire(PublishEvent());
    //Get.back();
  }

  ///循环上传操作
  Circularupload() async {
    for(var i=0;i<state.Longgraphicvideodata.length;i++) {
      if(state.Longgraphicvideodata[i]['type']==1){
        print('修改图片啦');
        await updatetp(state.Longgraphicvideodata[i]["asset"],i);
      }if(state.Longgraphicvideodata[i]['type']==2){
        await updateshipin(state.Longgraphicvideodata[i]["asset"],i);
      }
    }
  }
  /**
   * 上传视频
   */
  updateshipin(videoUrl,i) async {
    if (videoUrl != null) {
      final file = File(videoUrl);
      final regex = RegExp(r'<iframe|<img');
      final matches = regex.allMatches(state.formData['text']);

      if (matches.isEmpty) {
        await getVideoThumbnail(videoUrl);
      }
      /// 谷歌存储桶设置
      final storageRef = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
      MediaInfo? mediaInfo;
      if(file.lengthSync()>40000000){
        mediaInfo = await VideoCompress.compressVideo(
          state.videoPath!,
          quality: VideoQuality.DefaultQuality,
          deleteOrigin: false, // It's false by default
        );
      }
      final pictureName =  storageRef.child("user/video/" + _getFileName()+'.mp4');
      final pictureUpload = pictureName.putFile(mediaInfo != null ? File(mediaInfo.path!) : file,);
      pictureUpload.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
            // if(progress==100.0){
            //
            //   publiDataLogic.updateProlong(1/state.Longgraphicvideodata.length*(i+1));
            // }
            publiDataLogic.updateProlong(1/state.Longgraphicvideodata.length*(progress-schedule)/100);
            if(taskSnapshot.bytesTransferred / taskSnapshot.totalBytes!=1.0){
              print('监督');
              schedule=progress;
            }else{
              schedule=0.0;
            }


            break;
          case TaskState.paused:
          // ...
            break;
          case TaskState.success:
          // ...
            break;
          case TaskState.canceled:
            break;
          case TaskState.error:
          // ...
            break;
        }
      });
      await pictureUpload.whenComplete(() {});
      String newVideoPath =  await pictureName.getDownloadURL();
      print('视频地址${newVideoPath}');
      if (state.formData['text'].contains(videoUrl)) {
        state.formData['text'] = state.formData['text'].replaceAll(videoUrl, newVideoPath);
        print('Updated string: ${state.formData['text']}');
      } else {
        print('Search string not found in the main string');
      }
    }
  }
  ///图片上传
  updatetp(imageUrl,i) async {
    if (imageUrl != null) {

      ///谷歌存储桶设置
      final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
      File imageObj = await CompressImageFile(File(imageUrl!));
      ///谷歌上传缩略图
      final spaceRef =  storageRef.child('user/img/Longraphictext'+_getFileName()+'.png');
      final uploadTask = spaceRef.putFile(File(imageObj.path));
      uploadTask.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
            // if(progress==100.0){
              publiDataLogic.updateProlong(1/state.Longgraphicvideodata.length*(progress-schedule)/100);
            if(taskSnapshot.bytesTransferred / taskSnapshot.totalBytes!=1.0){
              print('监督');
              schedule=progress;
            }else{
              schedule=0.0;
            }
            // }
            break;
          case TaskState.paused:
          // ...
            break;
          case TaskState.success:
          // ...
            break;
          case TaskState.canceled:
          // ...
            break;
          case TaskState.error:
          // ...
            break;
        }
      });
      await uploadTask.whenComplete(() {});
      String LonggraphictextPath =  await spaceRef.getDownloadURL();
      if (state.formData['text'].contains(imageUrl)) {
        state.formData['text'] = state.formData['text'].replaceAll(imageUrl, LonggraphictextPath);
        print('Updated string: ${state.formData['text']}');
      } else {
        print('Search string not found in the main string');
      }

    }
  }



  ///保持内容
  SaveContent() async {

    ///开启登录验证
    if (!userLogic.checkUserLogin()) {
      Get.toNamed('/public/loginmethod');
      return;
    }


    // ///谷歌存储桶设置
    // final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
    // print('publish:请求oss结束');
    //
    // // 视频上传
    // if (state.type == PublishType.video) {
    //   _uploadVideo(storageRef);
    // }
    // // 图片上传
    // if (state.type == PublishType.picture) {
    //   _uploadPicture(storageRef);
    // }


    //
    // title: state.formData['title'],
    // text: state.formData['text'],
    // goodsId: state.goodIds,
    // thumbnail: state.dataListFile[0].path,
    // type: 1,
    // lat: state.position?.latitude??0,
    // lng: state.position?.longitude??0,
    // channel: state.formData['channel'],
    // topics:state.selectTopic.map((e) => e["id"]).toList(),
    // videoPath: state.videoPath!,
    // imagesPath:state.dataListFile.join(',')
    // attaImageScale: await __getImageScale(state.thumbnailPath!),
    // placeId:state.positioninformation['placeId']==null?'':state.positioninformation['placeId']
    var sp = await SharedPreferences.getInstance();
    var cunpicpath=[];
    for(var item in state.dataListFile){
      cunpicpath.add(item.path);
    }
    // sp.remove('holduptank');
    // return;
    if(sp.getString("holduptank")==null){
      sp.setString("holduptank",jsonEncode({'${userLogic.userId}':[]}));
    }
    var days=jsonDecode(sp.getString("holduptank")!);
    if(jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}']==null){
      sp.setString("holduptank",jsonEncode({'${userLogic.userId}':[]}));
    }
    var bendidata=jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}'];
    var Stagingdata={};
    if(state.id==null){
      Stagingdata['id']=DateTime.now().millisecondsSinceEpoch;
    }else{
      // if(Get.arguments['holduptank']['id']==null){
      //   Stagingdata['id']=DateTime.now().millisecondsSinceEpoch;
      // }else{
      Stagingdata['id']=state.id;
      //}
    }

    Stagingdata["formData"]=state.formData;
    Stagingdata["goodsId"]=state.goodIds;
    if (state.type == PublishType.video) {
      Stagingdata["type"]=1;
    }
    // 图片上传
    if (state.type == PublishType.picture) {
      Stagingdata["type"]=2;
    }

    if(state.thumbnailPath!=null){
      Stagingdata["thumbnail"]=state.thumbnailPath;
    }
    if(state.videoPath!=null){
      Stagingdata["videoPath"]=state.videoPath;
    }


    Stagingdata["dataListFile"]=cunpicpath.join(',');
    Stagingdata["positioninformation"]=state.positioninformation;



    if(state.position!=null){
      Stagingdata["position"]=state.position;
    }

    Stagingdata["selectTopic"]=state.selectTopic;
    Stagingdata["listItem"]=jsonEncode(state.listItem) ;
    //jsonEncode(Stagingdata);
    print('sssssssssss${state.id}');
    if(state.id!=null){
      for(var i=0;i<bendidata.length;i++){
        print('tttttt${bendidata[i]['id']}');
        if(bendidata[i]['id']==state.id){
          bendidata.fillRange(i, i+1, Stagingdata);
        }
      }
    }else{
      bendidata?.add(Stagingdata);
    }


    print("datasssss${bendidata}");

    var chucundata=jsonDecode(sp.getString("holduptank")!);
    chucundata['${userLogic.userId}']=bendidata;
    print('类型${chucundata is String}');
    // return;
    sp.setString("holduptank", jsonEncode(chucundata)!);
    //
    Get.back();
    Get.back();
    // Get.offAll(HomePage());
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   homeLogic.setNowPage(3);
    //   timer.cancel(); //取消定时器
    // });
  }

  ///内容检测
  ContentInspection(text){
    // 正则表达式匹配图片标签
      RegExp imgRegex = RegExp(r'<img\b[^>]*>');

    // 正则表达式匹配视频标签
      RegExp videoRegex = RegExp(r'<iframe\b[^>]*>');

      bool containsImage = imgRegex.hasMatch(text);
      bool containsVideo = videoRegex.hasMatch(text);

      print('Contains Image: $text');
      print('Contains Video: $containsVideo');
      if(containsImage || containsVideo){
        return true;
      }else {
        ToastInfo('请插入图片或者视频'.tr);
        return false;
      }

  }



  String _getFileName() {
    DateTime dateTime = DateTime.now();
    String timeStr =
        "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
    return timeStr + getUUid();
  }

  __getImageScale(String imagePath) async {
    Rect aa = await WidgetUtil.getImageWH(image: Image.file(File(imagePath)));
    if (aa.width == 0 || aa.height == 0) {
      return 0;
    }
    return aa.height / aa.width;
  }

  setChannel(index){
    state.formData['channel'] = index;
    update();
  }

  ///录音相关
  ///
  ///麦克风权限
  Future<bool> getPermissionStatus() async {
    Permission permission = Permission.microphone;
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      requestPermission(permission);
    } else {}
    return false;
  }
  ///开始录音

  /// 判断文件是否存在
  Future<bool> fileExists() async {
    print('5566666');
    print(state.formData['recorderpath']);
    return await File(state.formData['recorderpath']).exists();
  }

  /// 释放录音和播放
  Future<void> releaseFlauto() async {
    try {
      await playerModule.closePlayer();
      await recorderModule.closeRecorder();
    } catch (e) {
      print('Released unsuccessful');
      print(e);
    }
  }

  /// 删除录音文件
  Future<void> releaseFlautosc() async {
    try {
      Directory dir = await getTemporaryDirectory();
      File file = File(state.formData['recorderpath']);
      await  file.delete();
      state.formData['recorderpath'] ='';
      state.formData['ossrecorderpath']='';
      state.formData['recordingtime']=0;
      update();
    } catch (e) {}
  }
}
