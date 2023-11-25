import 'dart:io';
import 'dart:ui';

/**
 * 分享页 - 发布内容完成后的页面
 */
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/button_black.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:share_plus/share_plus.dart';

class SharePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dataSource = Get.arguments;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Image.file(
                File(dataSource['thumbnailPath']),
                fit: BoxFit.cover,
              )),
          Center(
            child: ClipRect(
              // 可裁切矩形
              child: BackdropFilter(
                // 背景过滤器
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Opacity(
                  opacity: 0.1,
                  child: Container(
                    alignment: Alignment.center,
                    height: double.infinity,
                    width: double.infinity,
                    decoration: BoxDecoration(color: Colors.grey.shade500),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
              left: 0,
              right: 0,
              top: MediaQuery.of(context).size.height - 180,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Center(
                    child: blackButton("快去分享吧".tr,(){
                      AppLog('share', event: 'publish',targetid: dataSource['id']);
                      Get.put<ContentProvider>(ContentProvider()).ForWard(dataSource['id'],1);
                      Share.share('${'快来看我发布的'.tr} https://api.lanla.app/share?c=${dataSource['id']}');
                    })
                ),
              )),

          Positioned(
            top: 130,
            left: 25,
            right: 25,
            bottom: 280,
            child: Container(
              padding: EdgeInsets.only(top:20,left:20,right: 20,bottom: 60),
              decoration: const BoxDecoration(
                color: Colors.white,
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(18)),
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child:  Image.file(
                      File(dataSource['thumbnailPath']),
                      fit: BoxFit.cover,
                    ),
                )
              ),
            ),
          ),

          Positioned(
            bottom: 310,
            right: 40,
            child: Container(
              width: 50,
              height: 50,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    //头像图片 -> NetworkImage网络图片，AssetImage项目资源包图片, FileImage本地存储图片
                    backgroundImage: NetworkImage(
                        Get.find<UserLogic>().userAvatar
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 300,
            right: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(Get.find<UserLogic>().userName,style: TextStyle(fontWeight: FontWeight.w600),),
                Text('我发布了一片新动态'.tr,style: TextStyle(color: Colors.black38),)
              ],),
          ),
          Positioned(
            top: 50,
            left: 25,
            height: 40,
            width: 40,
            child: GestureDetector(
              onTap: (){
                Get.back();
              },
              child: Container(
                child: Icon(Icons.highlight_off, size: 28,color: Colors.white,),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
