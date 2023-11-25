import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
//import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/detail/user/Reportuser.dart';
import 'package:lanla_flutter/pages/publish/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

enum ReportType { content, user, comment }

ReportDoglog(ReportType type, int id,int downloadtype,url,context,{Function? removeCallbak = null}) {


  /// 下载图片
  void _save(context) async {
    print('图片地址${url}');
    if (await Permission.storage.request().isGranted) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return  LoadingDialog(text: '下载中'.tr,);
          });
      await Dio().get(url, options: Options(responseType: ResponseType.bytes)).then(  (value)  async{
        final result =  await ImageGallerySaver.saveImage(
            Uint8List.fromList(value.data)
        );
        Get.back();
        // 判断ios还是android,故需要引入 import 'dart:io';
        if (Platform.isIOS) {
          if (result) {
            ToastInfo('下载成功'.tr);
          } else {
            ToastInfo('下载失败'.tr);
          }
        } else {
          if (result != null) {
            ToastInfo('下载成功'.tr);
          } else {
            ToastInfo('下载失败'.tr);
          }
        }
      }).catchError(() {
        Navigator.pop(context);
        ToastInfo('下载失败'.tr);
      });;

    }else{
      Navigator.pop(context);
      ToastInfo("未获取存储权限".tr);
    }
  }
  /// 下载视频
  void downloadFile() async {
    if (await Permission.storage.request().isGranted) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return  Stack(children: [
              LoadingDialog(text: '下载中'.tr,),
            ],) ;
          });
      var appDocDir = await getTemporaryDirectory();
      String savePath = appDocDir.path + "/temp.mp4";
      await Dio().download(url, savePath);
      final result = await ImageGallerySaver.saveFile(savePath);
      print(result);
      Get.back();
      // Navigator.pop(context);
      if (result["isSuccess"]) {
        ToastInfo("下载成功".tr);
      } else {
        ToastInfo("下载失败".tr);
      }
    }else{
      Navigator.pop(context);
      ToastInfo("未获取存储权限".tr);
    }
  }
  Get.bottomSheet(Container(
    padding: EdgeInsets.only(bottom: 20),
    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),),
    child: Wrap(
      children: [
        // type == ReportType.comment ? Container() : ListTile(
        //   onTap: () {
        //     ToastInfo(type == ReportType.user
        //         ? '我们不会再向您推送此用户的内容'.tr
        //         : '我们会减少向您推送此类内容'.tr);
        //     Get.back();
        //     Get.put<ContentProvider>(ContentProvider()).Notlike(id, (type == ReportType.content ? 1 : (type == ReportType.user ? 2 : 3)),1);
        //     if(removeCallbak != null){
        //       removeCallbak();
        //     }
        //   },
        //   leading: Container(
        //     width: 25,
        //     height: 25,
        //     child: SvgPicture.asset(
        //       "assets/svg/buxihuan.svg",
        //     ),
        //   ),
        //   title: Text(type == ReportType.user ? '不喜欢这名用户'.tr : '不喜欢此内容'.tr),
        // ),
        if(downloadtype==1||downloadtype==2)ListTile(
          leading: Container(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              "assets/svg/xiazai.svg",
              color: Colors.black,
            ),
          ),
          title: Transform(
              transform: Matrix4.translationValues(20, 0.0, 0.0),
              child:Text('下载'.tr)),
          onTap: () async {
            if(downloadtype==1){
              _save(context);
            }
            if(downloadtype==2){
              downloadFile();
            }

            // var response = await Dio().get("http://pic3.zhimg.com/2d41a1d1ebf37fb699795e78db76b5c2.jpg", options: Options(responseType: ResponseType.bytes));
            // final result = await ImageGallerySaver.saveImage(
            //     Uint8List.fromList(response.data)
            // );
            // Get.back();
            // // 判断ios还是android,故需要引入 import 'dart:io';
            // if(Platform.isIOS){
            //   if(result){
            //     ToastInfo('成功保存到相册中');
            //   }else{
            //     ToastInfo('保存失败');
            //   }
            // }else{
            //   if(result != null){
            //     ToastInfo('成功保存到相册中');
            //   }else{
            //     ToastInfo('保存失败');
            //   }
            // }
          },
        ),
        ListTile(
          leading: Container(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              "assets/svg/jubao.svg",
              color: Colors.black,
            ),
          ),
          title: Transform(
              transform: Matrix4.translationValues(20, 0.0, 0.0),
              child: Text(type == ReportType.user ? '举报'.tr : "举报违规内容".tr)),
          onTap: () {
            Get.back();
            Get.to(ReportuserPage(),arguments:{'id':id,"type":(type == ReportType.content ? 1 : (type == ReportType.user ? 2 : 3))});
          },
        ),
        ListTile(
          leading: Container(
            width: 25,
            height: 25,
            child: SvgPicture.asset(
              "assets/svg/lahei.svg",
              color: Colors.black,
            ),
          ),
          title: Transform(
              transform: Matrix4.translationValues(20, 0.0, 0.0),
              child: Text('拉黑'.tr)),
          onTap: () {
            ToastInfo('我们将不会再向您推此用户的内容'.tr);
            Get.back();
            Get.put<ContentProvider>(ContentProvider()).Notlike(id,2,1);
            if(removeCallbak != null){
              removeCallbak();
            }
          },
        )
      ],
    ),
  ));



}
