import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio2;
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
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

class PublishLogic extends GetxController {
  final PublishState state = PublishState();
  final publiDataLogic = Get.find<PublishDataLogic>();
  final provider = Get.put<PublishProvider>(PublishProvider());
  final ossProVider = Get.put(OssProvider());
  final homeLogic = Get.find<HomeLogic>();
  final userLogic = Get.put(UserLogic());

  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  ///初始化播放器
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();

  @override
  void onReady() async{
    if(Get.arguments['holduptank']!=null){
      state.id=Get.arguments['holduptank']['id'];
      state.formData=Get.arguments['holduptank']['formData'];
      if(Get.arguments['holduptank']['goodIds']!=null){
        state.goodIds=Get.arguments['holduptank']['goodIds'];
      }

      if (Get.arguments['holduptank']['type']==1) {
        state.type = PublishType.video ;
      }
      // 图片上传
      if (Get.arguments['holduptank']['type']==2) {
        state.type = PublishType.picture;
      }

      if(Get.arguments['holduptank']['thumbnail']!=null){
        state.thumbnailPath=Get.arguments['holduptank']['thumbnail'];
      }
      if(Get.arguments['holduptank']['videoPath']!=null){
        state.videoPath=Get.arguments['holduptank']['videoPath'];
      }

      List<File> acpicturefile = [];
      for(var item in Get.arguments['holduptank']['dataListFile'].split(',')){
        acpicturefile.add(File(item));
      }

      //Get.arguments['holduptank']['dataListFile'].split(',')
      state.dataListFile=acpicturefile;

      state.positioninformation=Get.arguments['holduptank']['positioninformation'];



      if(Get.arguments['holduptank']['position']!=null){
        state.position=Get.arguments['holduptank']['videoPath'];
      }
      if(Get.arguments['holduptank']['selectTopic'].length>0){
        state.selectTopic=Get.arguments['holduptank']['selectTopic'];
      }

      if(jsonDecode(Get.arguments['holduptank']['listItem']).length>0){



        state.listItem=commoditylistanalysisFromJson(Get.arguments['holduptank']['listItem']);

      }
      _initPosition();
      super.onReady();
      return;
    }
    var data = Get.arguments['asset'];
    var topicObject = Get.arguments['topic'];
    if(topicObject != null){
      state.selectTopic.add(topicObject);
    }
    var dladdress = Get.arguments['address'];
    if(dladdress != null){
      state.positioninformation=dladdress;
    }

    _initSource(data);
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
    if (state.formData['title'] == '' || state.formData['title'].trim().isEmpty) {
      ToastInfo('请选择标题'.tr);
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

  _initSource(data) async {
    // 从相册选择文件来的
    if (data is List<AssetEntity>) {
      // 遍历，查看是否为图片和视频混合.
      // 如果为混合则过滤掉视频，为图文上传
      var haveImage = false;
      var haveVideo = false;
      var count = 0;
      data.forEach((AssetEntity element) async {
        //var file = await element.file;
        if (element.type == AssetType.image) {
          haveImage = true;
          count++;
        } else if (element.type == AssetType.video) {
          haveVideo = true;
          count++;
        }
      });
      if (count == 0) {
        Get.back();

        // 没有东西
        return;
      }
      // 图片和视频混合和只有图片时，将视频删掉，只保留图片
      if (haveImage) {
        _setPicture(data);
      } else {
        _setVideo(data);
      }
      return;

      // logInfo('aaa');
      // logInfo(haveImage);
      // logInfo(haveVideo);
    } else if (data is AssetEntity) {
      if (data.type == AssetType.image) {
        _setPicture([data]);
        return;
      } else if (data.type == AssetType.video) {
        _setVideo([data]);
        return;
      }
    }

    Get.back();
  }





  ///申请权限
  void requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
  /**
   * 设置图集资源
   */
  _setPicture(List<AssetEntity> data) async {
    List<AssetEntity> newData = [];
    List<File> newDataFile = [];
    for (var i = 0; i < data.length; i++) {
      AssetEntity item = data[i];
      if (data[i].type == AssetType.image) {
        newData.add(item);
        File? file = await item.file;
        newDataFile.add(file!);
      }
    }
    state.dataList = newData;
    state.dataListFile = newDataFile;
    state.type = PublishType.picture;
    return update();
  }

  // 设置视频资源
  _setVideo(List<AssetEntity> dataSource) async {
    for (var i = 0; i < dataSource.length; i++) {
      if (dataSource[i].type == AssetType.video) {
        var data = dataSource[i];
        var file = await data.file;

        Directory dir = await getTemporaryDirectory();
        var thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: file!.path,
          thumbnailPath: "${"${dir.path}/" + getUUid()}.png",
          imageFormat: ImageFormat.PNG,
          maxWidth: 300,
          quality: 25,
        );
        state.type = PublishType.video;
        state.videoPath = file.path;
        state.thumbnailPath = thumbnailPath;
        state.dataList = [dataSource[i]];
        state.selectThumbnail = false;
        LogV([state.videoPath, state.thumbnailPath]);
        update();
        break;
      }
    }
  }

  /**
   * 更改排序
   */
  onReorder(int oldIndex, int newIndex) {
    // logInfo('打印 ${oldIndex} , ${newIndex}');
    //交换数据
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final item2 = state.dataList.removeAt(oldIndex);
    state.dataList.insert(newIndex, item2);

    final item = state.dataListFile.removeAt(oldIndex);
    state.dataListFile.insert(newIndex, item);
    update();
  }

  onRemove(index) {
    state.dataListFile.removeAt(index);
    state.dataList.removeAt(index);

    update();
  }

  // 添加图片
  addImages(context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(selectedAssets: state.dataList),
    );
    if (result != null && result.isNotEmpty) {
      _initSource(result);
    }
  }

  // 修改封面图
  editThumbnail(context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig:
      const AssetPickerConfig(requestType: RequestType.image, maxAssets: 1),
    );

    if (result != null && result.isNotEmpty) {
      File? file = await result[0].file;
      if (file != null) {
        state.thumbnailPath = file.path;
        state.selectThumbnail = true;
        update();
      }
      //_initSource(result);
    }
  }

  Future<String> _getOssToken() async {
    var token = await ossProVider.StsAvg();

    return token.bodyString ?? "";
  }

  /// 发布内容
  onPublish() async {
    // 检测表单
    if (!_checkForm()) {
      return false;
    }
    ///开启登录验证
    if (!userLogic.checkUserLogin()) {
      Get.toNamed('/public/loginmethod');
      return;
    }

    // 设置oss
    // Util.Client.init(
    //   //tokenGetter: _tokenGetterMethod,
    //   stsUrl: BASE_DOMAIN+'sts/stsAvg',
    //   ossEndpoint: "oss-accelerate.aliyuncs.com",
    //   bucketName: "dayuhaichuang",
    // );
    //
    // AliOssClient.init(
    //   //tokenGetter: _tokenGetterMethod,
    //   stsUrl: BASE_DOMAIN+'sts/stsAvg',
    //   ossEndpoint: "oss-accelerate.aliyuncs.com",
    //   bucketName: "dayuhaichuang",
    // );

    ///谷歌存储桶设置
    final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();


    // 视频上传
    if (state.type == PublishType.video) {
      _uploadVideo(storageRef);
    }
    // 图片上传
    if (state.type == PublishType.picture) {
      _uploadPicture(storageRef);
    }
    //Get.back();
     Get.offAll(HomePage());
    Timer.periodic(const Duration(milliseconds: 500), (timer) {
      homeLogic.setNowPage(3);
      timer.cancel(); //取消定时器
    });
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

    if(state.id!=null){
      for(var i=0;i<bendidata.length;i++){

        if(bendidata[i]['id']==state.id){
          bendidata.fillRange(i, i+1, Stagingdata);
        }
      }
    }else{
      bendidata?.add(Stagingdata);
    }

    var chucundata=jsonDecode(sp.getString("holduptank")!);
    chucundata['${userLogic.userId}']=bendidata;

    // return;
    sp.setString("holduptank", jsonEncode(chucundata));
    //
    Get.back();
    Get.back();
    // Get.offAll(HomePage());
    // Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   homeLogic.setNowPage(3);
    //   timer.cancel(); //取消定时器
    // });
  }

  /**
   * 上传视频
   */
  _uploadVideo(storageRef) async {
    var nowTime=DateTime.now().millisecondsSinceEpoch;
    var fileName = _getFileName();
    // 发布视频打点
    FirebaseAnalytics.instance.logEvent(
      name: "upload_video_start",
      parameters: {
        "vodioName": fileName
      },
    );

    publiDataLogic.startPublish(3, state.thumbnailPath!);
    // ---任务1-上传缩略图--
    File imageObj = await CompressImageFile(File(state.thumbnailPath!));
    // String newThumbnailPath = await AliOssClient()
    //     .putObject(imageObj.path!, 'thumb', _getFileName());

    ///谷歌上传缩略图
    final spaceRef =  storageRef.child("user/img/v${_getFileName()}.png");
    final uploadTask = spaceRef.putFile(File(imageObj.path));
    uploadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          // print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');

          if(progress==100.0){
            publiDataLogic.updatePro(0.1);
          }
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
    String newThumbnailPath =  await spaceRef.getDownloadURL();


    await publiDataLogic.finishTask();
    if (newThumbnailPath == '') {
      publiDataLogic.fail("操作失败".tr, "上传封面失败了,请检图片是否存在".tr);
      return;
    }
    var fileq = File(state.videoPath!);
    // 压缩前文件大小打点

    FirebaseAnalytics.instance.logEvent(
      name: "upload_video_pre_compression_size",
      parameters: {
        "fileSize": fileq.lengthSync(),
        "vodioName": _getFileName()
      },
    );

    // print('文件名称1:${fileName}');
    // print('压缩前大小:${fileq.lengthSync()}');
    //压缩视频
    // Future<void> runFlutterVideoCompressMethods(videoFile) async {
    //   final mediaInfo = await VideoCompress.compressVideo(
    //     videoFile,
    //     quality: VideoQuality.MediumQuality,
    //     deleteOrigin: false,
    //   );
    //   print('压缩后：${mediaInfo}');
    //   // setState(() {
    //   //   _compressedVideoInfo = mediaInfo;
    //   // });
    // }
    // runFlutterVideoCompressMethods(state.videoPath!);
    MediaInfo? mediaInfo;
    if(fileq.lengthSync()>40000000){
      mediaInfo = await VideoCompress.compressVideo(
        state.videoPath!,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false, // It's false by default
      );
      var file = File(mediaInfo!.path!);
      // 压缩后文件大小打点
      FirebaseAnalytics.instance.logEvent(
        name: "upload_video_after_compression_size",
        parameters: {
          "fileSize": file.lengthSync(),
          "vodioName": _getFileName()
        },
      );
      // print('压缩后：${mediaInfo?.path}');
    }
    // ---任务2-上传视频--
    // var newVideoPath = await AliOssClient()
    //     .putObject(mediaInfo!=null?mediaInfo.path!:state.videoPath!, 'video', _getFileName());
    // final String newFileName = "user/video/" + _getFileName()+'.mp4';
    // final dio2.Response<dynamic> newVideoPath = await Util.Client().putObjectFile(
    //   //mediaInfo != null ? File(mediaInfo.path!) : File(state.videoPath!),
    //   mediaInfo != null ? mediaInfo.path! : state.videoPath!,
    //   fileKey: newFileName,
    //   option: Util.PutRequestOption(
    //     onSendProgress: (count, total) {
    //
    //       var percent = count / total;
    //       print("send: count = $percent");
    //       publiDataLogic.updatePro(percent);
    //     },
    //     onReceiveProgress: (count, total) {
    //       print("receive: count = $count, and total = $total");
    //     },
    //     override: false,
    //     aclModel: Util.AclMode.publicRead,
    //     storageType: Util.StorageType.ia,
    //     headers: {"cache-control": "no-cache"},
    //   ),
    // );
    // if (newVideoPath.statusCode != null && newVideoPath.statusCode! < 200 && newVideoPath.statusCode! >= 300) {
    //   publiDataLogic.fail("操作失败".tr, "上传视频失败了,请检查视频是否存在".tr);
    //   return;
    // }

    final pictureName =  storageRef.child("user/video/" + _getFileName()+'.mp4');
    final pictureUpload = pictureName.putFile(mediaInfo != null ? File(mediaInfo.path!) : File(state.videoPath!),);
    pictureUpload.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          // print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
          if(progress>10.0){
            publiDataLogic.updatePro(taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          }
          break;
        case TaskState.paused:
        // ...
          break;
        case TaskState.success:
        // ...
          break;
        case TaskState.canceled:
          publiDataLogic.fail("操作失败".tr, "上传视频失败了,请检查视频是否存在".tr);
          break;
        case TaskState.error:
        // ...
          break;
      }
    });
    await pictureUpload.whenComplete(() {});
    String newVideoPath =  await pictureName.getDownloadURL();

    await publiDataLogic.finishTask();
    // ---任务3-请求接口---
    publiDataLogic.contentId = await provider.push(
        title: state.formData['title'],
        text: state.formData['text'],
        goodsId: state.goodIds,
        thumbnail: newThumbnailPath,
        type: 1,
        lat: state.position?.latitude??0,
        lng: state.position?.longitude??0,
        channel: state.formData['channel'],
        topics:state.selectTopic.map((e) => e["id"]).toList(),
        videoPath: newVideoPath,
        attaImageScale: await __getImageScale(state.thumbnailPath!),
        placeId:state.positioninformation['placeId'] ?? ''
    );

    if (publiDataLogic.contentId == 0) {
      publiDataLogic.fail("操作失败".tr, "视频上传失败，请检查您的网络后重新上传".tr);
      FirebaseAnalytics.instance.logEvent(
        name: "publish_video_over_time_error",
        parameters: {
          "sec": DateTime.now().millisecondsSinceEpoch-nowTime,
        },
      );
      return;
    }
    FirebaseAnalytics.instance.logEvent(
      name: "publish_video_over_time",
      parameters: {
        "sec": DateTime.now().millisecondsSinceEpoch-nowTime,
      },
    );
    // 发布视频成功打点
    FirebaseAnalytics.instance.logEvent(
      name: "upload_video_success",
      parameters: {
        "fileSize": File(newVideoPath.toString()).lengthSync,
        "vodioName": _getFileName()
      },
    );
    // print('文件名称3:${fileName}');

    await publiDataLogic.finishTask();
    // ---任务4-生成分享---
    // 发送成功事件
    eventBus.fire(PublishEvent());
    // ---任务4-生成分享---
    ToastInfo('🌟 发布成功,快去分享给你好朋友吧'.tr);
    await Future.delayed(const Duration(seconds: 2), (){});

    Get.to(SharePage(), transition: Transition.downToUp, arguments: {
      "thumbnailPath": state.thumbnailPath,
      "id": publiDataLogic.contentId
    });
    // 发送成功事件
    eventBus.fire(PublishEvent());
  }

  /// 发布图文
  _uploadPicture(storageRef) async {
    var nowTime=DateTime.now().millisecondsSinceEpoch;
    // print('publish:提取缩略图');
    String thumbnailPath = state.dataListFile[0].path;
    publiDataLogic.startPublish(
        state.dataListFile.length + 2, thumbnailPath);
    // ---任务1-上传缩略图--
    // print('publish:开始压缩缩略图');
    File imageObj = await CompressImageFile(File(thumbnailPath));
    // print('publish:开始上传缩略图');
    // String newThumbnailPath = await AliOssClient()
    //     .putObject(imageObj.path, 'thumb', _getFileName());
    //String newThumbnailPath='';
    ///谷歌上传缩略图
    final spaceRef =  storageRef.child('user/img/p${_getFileName()}.png');
    final uploadTask = spaceRef.putFile(File(imageObj.path));
    uploadTask.snapshotEvents.listen((taskSnapshot) {
      switch (taskSnapshot.state) {
        case TaskState.running:
          final progress =
              100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
          // print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
          if(progress==100.0){
            publiDataLogic.updatePro(0.1);
          }
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
    String newThumbnailPath =  await spaceRef.getDownloadURL();
    // print('谷歌上传${newThumbnailPath}');
    await publiDataLogic.finishTask();
    if ( newThumbnailPath == '') {
      publiDataLogic.fail("操作失败", "上传封面失败了,请检图片是否存在".tr);
      return;
    }
    // print('publish:缩略图上传完成');
    List<String> imagesPath = [];
    // 循环上传图片
    for (var i=0; i<state.dataListFile.length;i++) {
      File imageObj = await CompressImageFile(state.dataListFile[i]);
      // String newThumbnailPath =
      // await AliOssClient().putObject(imageObj.path, 'thumb', _getFileName());
      final pictureName =  storageRef.child("user/img/${_getFileName()}.png");
      final pictureUpload = pictureName.putFile(File(imageObj.path));
      pictureUpload.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            final progress =
                100.0 * (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
            print('上传进度${taskSnapshot.bytesTransferred / taskSnapshot.totalBytes}');
            if(progress==100.0){
              publiDataLogic.updatePro(1/state.dataListFile.length*(i+1));
            }
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
      await pictureUpload.whenComplete(() {});
      String newThumbnailPath =  await pictureName.getDownloadURL();

      imagesPath.add(newThumbnailPath);
      await publiDataLogic.finishTask();
      print('publish:循环上传图文成功');
    }
    if (imagesPath.length<0) {
      publiDataLogic.fail("操作失败", "上传图片失败了,请检图片是否存在".tr);
      return;
    }

    print('fdsfds');
    print(state.formData);

    // ---最后任务-请求接口---
    publiDataLogic.contentId = await provider.push(
        title: state.formData['title'],
        text: state.formData['text'],
        goodsId: state.goodIds,
        // goodsId: '15075',
        thumbnail: newThumbnailPath,
        type: 2,
        lat: state.position?.latitude??0,
        lng: state.position?.longitude??0,
        channel: state.formData['channel'],
        imagesPath: imagesPath.join(','),
        topics:state.selectTopic.map((e) => e["id"]).toList(),
        recordingTime:state.formData['recordingtime'],
        recordingPath:state.formData['ossrecorderpath'],
        attaImageScale: await __getImageScale(thumbnailPath),
        placeId:state.positioninformation['placeId'] ?? ''
    );
    if (publiDataLogic.contentId == 0) {
      publiDataLogic.fail("操作失败".tr, "发布失败，请检查您的网络后重新上传".tr);
      FirebaseAnalytics.instance.logEvent(
        name: "publish_picture_over_time_error",
        parameters: {
          "sec": DateTime.now().millisecondsSinceEpoch-nowTime,
        },
      );
      return;
    }
    FirebaseAnalytics.instance.logEvent(
      name: "publish_picture_over_time",
      parameters: {
        "sec": DateTime.now().millisecondsSinceEpoch-nowTime,
      },
    );

    await publiDataLogic.finishTask();
    // 发送成功事件
    eventBus.fire(PublishEvent());
    // ---任务4-生成分享---
    ToastInfo('🌟 发布成功,快去分享给你好朋友吧'.tr);
    await Future.delayed(const Duration(seconds: 2), (){});
    Get.to(SharePage(), transition: Transition.downToUp, arguments: {
      "thumbnailPath": thumbnailPath,
      "id": publiDataLogic.contentId
    });
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
