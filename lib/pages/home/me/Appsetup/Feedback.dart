import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/function.dart';
import 'package:lanla_flutter/pages/publish/state.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../../common/toast/view.dart';
import '../../../../services/SetUp.dart';
import '../../../../ulits/toast.dart';


class FeedbackWidget extends StatefulWidget {
  @override
  createState() => FeedbackState();
  SetUpProvider Feedbackjkprovider =  Get.put(SetUpProvider());
}
class FeedbackState extends State<FeedbackWidget> {
  final userLogic = Get.find<UserLogic>();
  final userProvider = Get.put<UserProvider>(UserProvider());
  String opiniontext = '';
  late TextEditingController _controller;
  List<AssetEntity> imageList=[];
  var imageListFile=[];

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: userLogic.slogan);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '意见反馈'.tr,
          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,),
        ),

      ),
      body: Column(
        children: [
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:Row(
              children: [


                Text('反馈与建议'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                SizedBox(width: 10,),
                Text('*',style: TextStyle(color: Colors.red,fontSize: 16),textAlign: TextAlign.center,),
              ],
          ) ,),
          SizedBox(height: 20,),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:TextField(
              maxLines: 7,
              maxLength:100,
              controller: _controller,
              // cursorColor: Color(0xffffffff),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                hintText: "说说你的建议或者问题，以便我们更好的服务".tr,
                hintStyle: TextStyle(color: Color(0xff666666)),
                border: InputBorder.none, // 隐藏边框
                fillColor: Colors.white,
                filled: true,
                enabledBorder: OutlineInputBorder(
                  /*边角*/
                  borderRadius: BorderRadius.all(
                    Radius.circular(20), //边角为5
                  ),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
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
          SizedBox(height: 50,),
          Container(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child:Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Text('图片描述'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,),),
                Text('最多三张'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 12),textAlign: TextAlign.center,),
              ],
            ) ,),
          SizedBox(height: 20,),
          Container(
            margin: EdgeInsets.only(left: 20,right: 20),
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            decoration: BoxDecoration(
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
                  margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  key: ValueKey(imageListFile[i]),
                  width: 70,height: 70,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed('/verify/publishImagePreview',
                          arguments: imageListFile[i]);
                      print('预览图片');
                    },
                    onDoubleTap: () {
                      print('删除');
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
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        //color: Color(0xffF5F5F5),
        padding: EdgeInsets.all(50),
        child: opiniontext!=''?ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff000000)),
          ),
          onPressed: () async {
            EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
            ///谷歌存储桶设置
            final storageRef   = FirebaseStorage.instanceFor(bucket: "gs://lanla").ref();
            List<String> imagesPath = [];
            for (File file in imageListFile) {
              File imageObj = await CompressImageFile(file);
              // String newThumbnailPath =
              // await AliOssClient().putObject(imageObj.path, 'thumb', _getFileName());
              final pictureName =  storageRef.child('user/img/'+_getFileName()+'.png');
              final pictureUpload = pictureName.putFile(File(imageObj.path));
              await pictureUpload.whenComplete(() {});
              String newThumbnailPath =  await pictureName.getDownloadURL();
              imagesPath.add(newThumbnailPath);
            }
            print(opiniontext);
            var result = await widget.Feedbackjkprovider.Feedbackjk(opiniontext,imagesPath.length>0?imagesPath.join(','):'');
            EasyLoading.dismiss();
            if(result.statusCode==200){
              Toast.toast(context,msg: "反馈成功，感谢您的反馈".tr,position: ToastPostion.center);
              Get.back();
            }
          },
          child: Text('提交反馈'.tr,style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ):ElevatedButton(
          style: ButtonStyle(
            splashFactory: NoSplash.splashFactory,
            backgroundColor: MaterialStateProperty.all(Color(0xffffffff)),
          ),
          onPressed: () async {
            null;
          },
          child: Text('提交反馈'.tr,style: TextStyle(
            fontSize: 17,
            color: Color(0xff666666),
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
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
  //mingzi
  String _getFileName() {
    DateTime dateTime = DateTime.now();
    String timeStr =
        "${dateTime.year}${dateTime.month}${dateTime.day}${dateTime.hour}${dateTime.minute}${dateTime.second}";
    return timeStr + getUUid();
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
        print('没有选择内容'.tr);
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
    print('啥都没有');
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
        if (File != null) {
          newDataFile.add(file!);
        }
      }
    }
    print('tupian');
    print(newData);
    print(newDataFile[0]);
    setState(() {
      imageList = newData;
      imageListFile = newDataFile;
    });

    // state.imageList = newData;
    // state.imageListFile = newDataFile;
    // state.type = PublishType.picture;
    // return update();
  }

  onRemove(index) {
    setState(() {
      imageListFile.removeAt(index);
      imageList.removeAt(index);
    });
  }



}