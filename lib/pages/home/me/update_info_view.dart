import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../common/function.dart';
import '../../../ulits/aliyun_oss/client.dart';
import '../../../ulits/compress.dart';
import '../../../ulits/toast.dart';
import 'Introductionmodification.dart';
import 'ModifyGender.dart';
import 'Modifynickname.dart';

/// TODO 未接接口
class UserUpdateInfoPage extends StatelessWidget {
  final userLogic = Get.find<UserLogic>();
  final userProvider = Get.put<UserProvider>(UserProvider());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String avatar = '';
  // String username = '';
  String text = '';


  UserUpdateInfoPage({super.key}) {
    //ToastInfo('测试版提示：此页面未经设计');
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '修改资料'.tr,
          style: const TextStyle(fontSize: 16),
        ),
      ),
      body: GetBuilder<UserLogic>(builder: (logic) {
        return Column(
          children: [
            Divider(
              height: 1.0,
              color: Colors.grey.shade200,
            ),
            GestureDetector(
              onTap: () async {
                final List<AssetEntity>? result = await AssetPicker.pickAssets(
                  context,
                  pickerConfig:
                  const AssetPickerConfig(
                      requestType: RequestType.image, maxAssets: 1),
                );

                if (result != null && result.isNotEmpty) {
                  ToastInfo('Uploading...');
                  File? file = (await result[0].file);
                  if (file != null) {
                    // 设置oss
                    // AliOssClient.init(
                    //   //tokenGetter: _tokenGetterMethod,
                    //   stsUrl: BASE_DOMAIN+'sts/stsAvg',
                    //   ossEndpoint: "oss-accelerate.aliyuncs.com",
                    //   bucketName: "dayuhaichuang",
                    // );
                    ///谷歌存储桶设置
                    final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
                    File imageObj = await CompressImageFile(file);

                    final pictureName =  storageRef.child('user/img/head${_getFileName()}.png');
                    final pictureUpload = pictureName.putFile(File(imageObj.path));
                    await pictureUpload.whenComplete(() {});
                    String newThumbnailPath =  await pictureName.getDownloadURL();

                    // String newThumbnailPath = await AliOssClient()
                    //     .putObject(imageObj.path, 'thumb', _getFileName());
                    if (newThumbnailPath == '') {
                      ToastErr("上传失败了,请检图片是否存在");
                      return;
                    }

                    avatar = newThumbnailPath;
                    userLogic.update();
                    var isSuccess = userProvider.setUserInfo(
                        userLogic.userName, userLogic.slogan,
                        avatar == '' ? userLogic.userAvatar : avatar,
                        userLogic.userInfo?.sex, userLogic.userInfo?.birthday);
                    if (await isSuccess) {
                      ToastInfo('更新成功'.tr);
                      userLogic.getUserInfo();
                      //setState((){});
                      // Get.back();
                    } else {
                      ToastErr('更新失败'.tr);
                    }
                  }
                  //_initSource(result);
                }
              },
              child: SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 30,
                        left: MediaQuery
                            .of(context)
                            .size
                            .width / 2 - 52,
                        child: Container(
                          width: 105,
                          height: 105,
                          //超出部分，可裁剪
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(150),
                          ),
                          child: GetBuilder<UserLogic>(builder: (logic) {
                            return Image.network(
                              avatar != '' ? avatar : userLogic.userAvatar,
                              fit: BoxFit.cover,
                            );
                          }),
                        ),
                      ),
                      Positioned(
                          top: 110,
                          left: MediaQuery
                              .of(context)
                              .size
                              .width / 2 + 15,
                          child: Image.asset('assets/images/xiugaitoux.png',width: 30,height: 30,))
                    ],
                  )),
            ),
            // Form(
            //   key: _formKey,
            //   onChanged: () {
            //     print("form change");
            //   },
            //   child: Padding(
            //     padding: EdgeInsets.all(10),
            //     child: Column(
            //       children: [
            //         TextFormField(
            //           onSaved: (value) {
            //             if (value == '') {
            //               ToastInfo('名称不能为空'.tr);
            //               return;
            //             }
            //             username = value!;
            //           },
            //           decoration: InputDecoration(
            //               labelText: "名字".tr,
            //               labelStyle: TextStyle(fontSize: 20)),
            //           initialValue: userLogic.userName,
            //           validator: (value) {
            //             print(value);
            //             return null;
            //           },
            //         ),
            //         TextFormField(
            //           onSaved: (value) {
            //             if (value == '') {
            //               ToastInfo('简介不能为空'.tr);
            //               return;
            //             }
            //             text = value!;
            //           },
            //           decoration: InputDecoration(
            //               labelText: "简单介绍".tr,
            //               labelStyle: TextStyle(fontSize: 20)),
            //           initialValue: userLogic.slogan,
            //           maxLines: 3,
            //           validator: (value) {
            //             print(value);
            //             return null;
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
            GestureDetector(child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('昵称'.tr),
                  Row(
                    children: [
                      Text(userLogic.userName),
                      const Icon(Icons.chevron_right,)
                    ],
                  )

                ],
              ),
            ), onTap: () {
              Get.to(ModifynicknameWidget());
            },),
            const Divider(height: 1.0,
                color: Color(0xffF1F1F1),
                indent: 20,
                endIndent: 20),
            GestureDetector(child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('性别'.tr),
                  Row(
                    children: [
                      if(userLogic.Sex == 0)Text('保密'.tr),
                      if(userLogic.Sex == 1)Text('男'.tr),
                      if(userLogic.Sex == 2)Text('女'.tr),
                      const Icon(Icons.chevron_right,)
                    ],
                  )

                ],
              ),
            ), onTap: () {
              //print(userLogic.userInfo?.sex);
              Get.to(ModifyGenderWidget(), arguments: userLogic.Sex);
            },),
            const Divider(height: 1.0,
                color: Color(0xffF1F1F1),
                indent: 20,
                endIndent: 20),
            GestureDetector(child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('生日'.tr),
                  Row(
                    children: [
                      Text(userLogic.birthday),
                      const Icon(Icons.chevron_right,)
                    ],
                  )

                ],
              ),
            ), onTap: () {
              DateTime today = DateTime.now();
              // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
              print(int.parse(today.year.toString()) - 10);
              DatePicker.showDatePicker(context,
                  showTitleActions: true,
                  minTime: DateTime(
                      int.parse(today.year.toString()) - 60, 1, 1),
                  maxTime: DateTime(int.parse(today.year.toString()), 1, 1),
                  onChanged: (date) {
                    print('change $date');
                  },
                  onConfirm: (date) async {
                    var isSuccess = userProvider.setUserInfo(
                        userLogic.userName, userLogic.slogan,
                        avatar == '' ? userLogic.userAvatar : avatar,
                        userLogic.userInfo?.sex, date.toString().split(' ')[0]);
                    if (await isSuccess) {
                      ToastInfo('更新成功'.tr);
                      userLogic.getUserInfo();
                      //setState((){});
                      // Get.back();
                    } else {
                      ToastErr('更新失败'.tr);
                    }
                  },
                  currentTime: DateTime(
                      int.parse(today.year.toString()) - 10, 1, 1),
                  locale: LocaleType.ar);
            },),
            const Divider(height: 1.0,
                color: Color(0xffF1F1F1),
                indent: 20,
                endIndent: 20),
            GestureDetector(child: Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('简介'.tr),
                  Row(
                    children: [
                      Container(
                        constraints: const BoxConstraints(
                          maxWidth: 200, // 最大宽度
                        ),
                        child:
                        Text(
                          userLogic.slogan != ''
                              ? userLogic.slogan
                              : '快来填写你的个人简介吧'.tr,
                          // style: const TextStyle(
                          //   fontSize: 77,
                          // ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.chevron_right,)
                    ],
                  )

                ],
              ),
            ), onTap: () {
              Get.to(IntroductionmodificationWidget());
            },),
            const Divider(height: 1.0,
                color: Color(0xffF1F1F1),
                indent: 20,
                endIndent: 20),

          ],
        );
      }),
      // bottomNavigationBar: Padding(
      //   padding: EdgeInsets.all(50),
      //   child: ElevatedButton(
      //     onPressed: () async {
      //       _formKey.currentState?.save();
      //       //print('更新资料：${username}, ${text}, ${avatar== '' ?userLogic.userAvatar : avatar}, 1');
      //       bool isSuccess = await userProvider.setUserInfo(username, text, avatar== '' ?userLogic.userAvatar : avatar, 1);
      //       if(isSuccess){
      //         ToastInfo('更新成功'.tr);
      //         userLogic.getUserInfo();
      //         Get.back();
      //       }else{
      //         ToastErr('更新失败'.tr);
      //       }
      //     },
      //     child: Text('保存'.tr),
      //   ),
      // ),
    );
  }
}


String _getFileName() {
  DateTime dateTime = DateTime.now();
  String timeStr =
      "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime
      .hour}${dateTime.minute}${dateTime.second}";
  return timeStr + getUUid();
}