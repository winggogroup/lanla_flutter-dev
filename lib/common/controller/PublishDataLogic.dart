import 'dart:async';
import 'dart:io';

import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'package:lanla_flutter/ulits/toast.dart';

enum PublishDataStatus {
  none, // 正常状态
  picture, //  待发布图文
  video, // 待发布视频
}

class PublishDataLogic extends GetxController {
  final PublishDataStatus status = PublishDataStatus.none;
  final List<AssetEntity> images = []; // 当前图片列表
  final homeLogic = Get.find<HomeLogic>();

  // 是否正在发布
  bool isBeingPublished = false;

  // 发布任务数量
  int contentTotal = 0;

  // 已完成的数量
  int contentFinishTotal = 0;

  // 进度条,显示在页面上
  double progress = 0;

  // 缩略图文件
  String thumbnailPath = '';

  int contentId = 0;

  Timer? periodicTimer;

  startPublish(int taskTotal, String thumbnailPath) {
    // if(periodicTimer != null){
    //   periodicTimer!.cancel();
    // }
    // // 定时执行
    // periodicTimer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
    //   // 不能超过下次任务的进度
    //   if(progress > (contentFinishTotal+1)/contentTotal){
    //     return ;
    //   }
    //   progress = progress+0.01;
    //   print('发布进度条:${progress}');
    //   if(progress >=1){
    //     timer.cancel();
    //   }
    //   update();
    // });

    ToastInfo('正在发布您的作品'.tr);
    //homeLogic.setNowPage(3);
    contentTotal = taskTotal;
    isBeingPublished = true;
    this.thumbnailPath = thumbnailPath;
    update();
  }

  updatePro(double taskTotal) {
    if (taskTotal < 0.99) {
      progress = taskTotal;
      update();
    }
  }
  updateProlong(double taskTotal){

    if (progress + taskTotal < 0.99) {
      if(progress + taskTotal<0.15){
        progress = 0.15;
        update();
      }else{
        progress = progress + taskTotal;
        update();
      }

    }
  }

  // 完成一个任务
  finishTask() async {
    //sleep(Duration(milliseconds: 200));
    contentFinishTotal++;
    // progress = contentFinishTotal/contentTotal;
    print('完成一个任务,当前任务：${contentFinishTotal}/$contentTotal');
    // 完成发布
    if (contentFinishTotal > contentTotal - 1) {
      contentTotal = 0;
      contentFinishTotal = 0;
      isBeingPublished = false;
      progress = 0;
      return update();
    }
    update();
  }
  finishTasklong() async {
    //sleep(Duration(milliseconds: 200));
      contentTotal = 0;
      contentFinishTotal = 0;
      isBeingPublished = false;
      progress = 0;
      update();
  }

  // 本次任务失败了
  fail(String title, String message) {
    contentTotal = 0;
    contentFinishTotal = 0;
    isBeingPublished = false;
    Get.snackbar(title, message);
    progress = 0;
    update();
  }
}
