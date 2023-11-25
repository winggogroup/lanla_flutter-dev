import 'dart:convert';
import 'dart:core';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/PublishDataLogic.dart';
import 'package:lanla_flutter/common/function.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/models/Reportypelist.dart';
import 'package:lanla_flutter/pages/detail/FlowDetails/ListDetails.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/aliyun_oss/client.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ReportuserPage extends StatefulWidget {
  @override
  createState() => _ReportuserState();

}

class _ReportuserState extends State<ReportuserPage>  {
  final publiDataLogic = Get.find<PublishDataLogic>();
  late TextEditingController _controller;
  List<AssetEntity> imageList=[];
   final ContentProviders = Get.find<ContentProvider>();
  //
  var imageListFile=[];
  var Reporttypelist=[];
  var opiniontext='';
  int type=1;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '提供更多信息有助于举报被快速处理');
    //print(Get.put<ContentProvider>(ContentProvider()).reportTip().);
    reportTiplist();
  }
  ///
  reportTiplist() async {
    var result = await ContentProviders.reportTip();
    if (result.statusCode == 200) {
      if (ReportypeFromJson(result.bodyString!).isNotEmpty) {
        setState(() {
          Reporttypelist=ReportypeFromJson(result.bodyString!);
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color:Color(0xffffffff)),
        child: Column(
          children: [
            Expanded(child: ListView(children: [
              const Divider(height: 1.0,color: Color(0x1A000000),),
              const SizedBox(height: 25,),
              Container(padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),child: Column(
                children: [
                  Row(
                    children: [
                      const Text(
                        '*',
                        style: TextStyle(color: Color(0xffE33535)),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        '请选择你想要举报的类型'.tr,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                  for(var item in Reporttypelist)
                  Container(
                    decoration: const BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: Color(0xffF1F1F1)))),
                    padding: const EdgeInsets.only(bottom: 20,top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.text,
                          style: const TextStyle(fontSize: 14),
                        ),
                        item.id==type?Container(
                          width: 25,
                          height: 25,
                          child: SvgPicture.asset(
                            "assets/svg/xuanzhong.svg",
                          ),
                        ):GestureDetector(child: Container(
                          width: 25,
                          height: 25,
                          child: SvgPicture.asset(
                            "assets/svg/weixuanzhong.svg",
                          ),
                        ),onTap: (){
                          setState(() {
                            type=item.id;
                          });
                        },)
                      ],
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border(
                  //           bottom: BorderSide(color: Color(0xffF1F1F1)))),
                  //   padding: EdgeInsets.only(bottom: 20,top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         '违法规范',
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //       Container(
                  //         width: 25,
                  //         height: 25,
                  //         child: SvgPicture.asset(
                  //           "assets/svg/xuanzhong.svg",
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border(
                  //           bottom: BorderSide(color: Color(0xffF1F1F1)))),
                  //   padding: EdgeInsets.only(bottom: 20,top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         '违法规范',
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //       Container(
                  //         width: 25,
                  //         height: 25,
                  //         child: SvgPicture.asset(
                  //           "assets/svg/xuanzhong.svg",
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  // Container(
                  //   decoration: BoxDecoration(
                  //       border: Border(
                  //           bottom: BorderSide(color: Color(0xffF1F1F1)))),
                  //   padding: EdgeInsets.only(bottom: 20,top: 20),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: [
                  //       Text(
                  //         '违法规范',
                  //         style: TextStyle(fontSize: 14),
                  //       ),
                  //       Container(
                  //         width: 25,
                  //         height: 25,
                  //         child: SvgPicture.asset(
                  //           "assets/svg/weixuanzhong.svg",
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  const SizedBox(height: 50,),
                  Container(
                    child:Row(
                      children: [

                        const Text('*',style: TextStyle(color: Colors.red,fontSize: 16),textAlign: TextAlign.center,),
                        const SizedBox(width: 10,),
                        Text('反馈与建议'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),

                      ],
                    ) ,),
                  const SizedBox(height: 20,),
                  Container(
                    child:TextField(
                      maxLines: 7,
                      maxLength:100,
                      // controller: _controller,
                      // cursorColor: Color(0xffffffff),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                        hintText: "提供更多信息有助于举报被快速处理".tr,
                        hintStyle: const TextStyle(color: Color(0xff666666)),
                        border: InputBorder.none, // 隐藏边框
                        fillColor: const Color(0xffF9F9F9),
                        filled: true,
                        enabledBorder: const OutlineInputBorder(
                          /*边角*/
                          borderRadius: BorderRadius.all(
                            Radius.circular(20), //边角为5
                          ),
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                      ),

                      onChanged: (text) {
                        setState(() {
                          opiniontext=text;
                        });

                      },
                    ),
                  ),
                  const SizedBox(height: 50,),
                  Container(
                    // padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child:Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        Text('图片描述'.tr,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                        Text('最多三张'.tr,style: const TextStyle(color: Color(0xff999999),fontSize: 12),textAlign: TextAlign.center,),
                      ],
                    ) ,),
                  const SizedBox(height: 20,),
                  Container(
                    margin: const EdgeInsets.only(left: 20,right: 20),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10), //边角为5
                      ),
                    ),
                    child: Row(
                      children: [
                        GestureDetector(child:Container(child: Image.asset('assets/images/tianjia.png',width: 70,height: 70,),) ,onTap: (){
                          addImages(context);
                        },),
                        for(var i=0;i<imageListFile.length;i++)
                          Container(
                            margin: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                            key: ValueKey(imageListFile[i]),
                            width: 70,height: 70,
                            child: GestureDetector(
                              onTap: () {
                                Get.toNamed('/verify/publishImagePreview',
                                    arguments: imageListFile[i]);
                              },
                              onDoubleTap: () {
                                // if (imageList.length < 2) {
                                //   Get.snackbar("无法删除", '仅剩一张图片');
                                //   return;
                                // }
                                Get.defaultDialog(
                                  title: '提示'.tr,
                                  middleText: '是否要删除该照片'.tr,
                                  textConfirm: '删除'.tr,
                                  textCancel: '取消'.tr,
                                  onConfirm: () {
                                    onRemove(i);
                                    Get.back();
                                  },
                                );
                              },
                              child: Container(

                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      imageListFile[i],
                                      fit: BoxFit.cover,
                                    )),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                            ),
                          )


                      ],
                    ),
                  ),
                ],
              )),
              const SizedBox(height: 30,),
            ],))

          ],
        ),
      ),
      bottomNavigationBar:
      Container(
        //color: Color(0xffF5F5F5),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: type!=0?ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(const Color(0xff000000)),
          ),
          onPressed: () async {
            EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
            // 设置oss
            // AliOssClient.init(
            //   //tokenGetter: _tokenGetterMethod,
            //   stsUrl: BASE_DOMAIN+'sts/stsAvg',
            //   ossEndpoint: "oss-accelerate.aliyuncs.com",
            //   bucketName: "dayuhaichuang",
            // );

            ///谷歌存储桶设置
            final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
            List<String> imagesPath = [];
            // 循环上传图片
            for (File file in imageListFile) {
              File imageObj = await CompressImageFile(file);
              // String newThumbnailPath =
              // await AliOssClient().putObject(imageObj.path, 'thumb', _getFileName());

              final pictureName =  storageRef.child('user/img/${_getFileName()}.png');
              final pictureUpload = pictureName.putFile(File(imageObj.path));
              await pictureUpload.whenComplete(() {});
              String newThumbnailPath =  await pictureName.getDownloadURL();
              imagesPath.add(newThumbnailPath);
              await publiDataLogic.finishTask();
            }





            ToastInfo('感谢您的举报,我们核实后会此内容处理!'.tr);

            Get.put<ContentProvider>(ContentProvider()).Report(Get.arguments['id'], Get.arguments['type'],type,opiniontext!=''?opiniontext:'',imagesPath.isNotEmpty? imagesPath.join(','):'');
            EasyLoading.dismiss();
            Get.back();
            //var result = await widget.Feedbackjkprovider.Feedbackjk(opiniontext,imageListFile.length>0?imageListFile.join(','):'');
            // if(result.statusCode==200){
            //   Toast.toast(context,msg: "反馈成功，感谢您的反馈".tr,position: ToastPostion.center);
            //   Get.back();
            // }
          },
          child: Text('提交反馈'.tr,style: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ):ElevatedButton(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(const Color(0xffffffff)),
          ),
          onPressed: () async {
            null;
          },
          child: Text('提交反馈'.tr,style: const TextStyle(
            fontSize: 17,
            color: Color(0xff666666),
          ),textAlign: TextAlign.center,),
        ),
      ),
      appBar: AppBar(
        elevation: 0, //消除阴影
        title: Text('举报'.tr,style: const TextStyle(fontSize: 17,fontWeight: FontWeight.w600),),
        backgroundColor: Colors.white,//设置背景颜色为白色
        leading: IconButton(
            color: Colors.black,
            icon: const Icon(Icons.arrow_back_ios),
            tooltip: "Search",
            onPressed: () {
              //print('menu Pressed');
              Get.back();
            }),
      ),
    );
  }

  deactivate() {
    super.dispose();

  }

  // 添加图片
  addImages(context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(selectedAssets: imageList),
    );
    if (result != null && result.isNotEmpty) {
      _initSource(result);
    }
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
        // if (element.type == AssetType.image) {
        haveImage = true;
        count++;
        // } else if (element.type == AssetType.video) {
        //   haveVideo = true;
        //   count++;
        // }
      });
      if (count == 0) {
        Get.back();
        // 没有东西
        return;
      }
      // 图片和视频混合和只有图片时，将视频删掉，只保留图片

      _setPicture(data);

      return;

      // logInfo('aaa');
      // logInfo(haveImage);
      // logInfo(haveVideo);
    } else if (data is AssetEntity) {
      _setPicture([data]);
      return;
    }
    Get.back();
  }

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
    setState(() {
      imageList = newData;
      imageListFile = newDataFile;
    });


  }
  String _getFileName() {
    DateTime dateTime = DateTime.now();
    String timeStr =
        "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
    return timeStr + getUUid();
  }

  onRemove(index) {
    setState(() {
      imageListFile.removeAt(index);
      imageList.removeAt(index);
    });
  }


}
//定义弹窗

