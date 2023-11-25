import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/controller/PublishDataLogic.dart';
import 'package:lanla_flutter/common/function.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/Evaluationdetails.dart';
import 'package:lanla_flutter/services/Pricecomparison.dart';
import 'package:lanla_flutter/ulits/aliyun_oss/client.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/compress.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class WritecommentsPage extends StatefulWidget{
  @override
  WritecommentsState createState() => WritecommentsState();
}
class WritecommentsState extends State<WritecommentsPage>{
  var score1=0;
  var score2=0;
  var score3=0;
  var score4=0;
  var score5=0;
  List<AssetEntity> imageList=[];
  var text='';
  final Pricemodules = Get.find<Pricemodule>();
  var imageListFile=[];
  int type=0;
  final publiDataLogic = Get.find<PublishDataLogic>();
  final FocusNode _nodeText1 = FocusNode();
  final FocusNode _nodeText2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
              tooltip: "Search",
              onPressed: () {
                //print('menu Pressed');
                Navigator.of(context).pop();
              }),
          title: Text('你的评价'.tr, style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            //fontFamily: ' PingFang SC-Semibold, PingFang SC',
          ),),
        ),
        body: KeyboardActions(
            autoScroll:false,
            config: KeyboardActionsConfig(
                keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                keyboardBarColor: Colors.white,
                nextFocus: true,
                defaultDoneWidget: Text("完成".tr),
                actions: [
                  KeyboardActionsItem(
                    focusNode: _nodeText1,
                  ),
                  KeyboardActionsItem(
                    focusNode: _nodeText2,
                  ),
                ]),
            child:Container(
                decoration: BoxDecoration(color: Colors.white),
                padding: EdgeInsets.only(left: 20,right: 20),
                child:
                ListView(children: [
                  Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15,),
                      Text('说说你对TA的评价'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
                      SizedBox(height: 15,),
                      ///质量
                      Row(children: [
                        SizedBox(width: 5,),
                        Container(width: 110,child:Text('质量'.tr ,),),
                        for(var i=1;i<6;i++)
                          GestureDetector(child: Row(children: [Icon(Icons.star, size: 20, color: score1>=i?Color(0xFF9BE400):Color(0xFFE4E4E4),),SizedBox(width: 5,)],),
                            onTap: (){
                              setState(() {
                                score1=i;
                              });
                            },
                          ),
                        SizedBox(width: 20,),
                        if(score1==5)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('超赞'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score1==4)Row(children: [
                          Image.asset('assets/images/manyi.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('满意'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score1==3)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('一般'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score1==2)Row(children: [
                          Image.asset('assets/images/tucao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('吐槽'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score1==1)Row(children: [
                          Image.asset('assets/images/zaogao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('糟糕'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),

                      ],),
                      SizedBox(height: 10,),
                      ///性价比
                      Row(children: [
                        SizedBox(width: 5,),
                        Container(width: 110,child:Text('性价比'.tr ,),),
                        for(var i=1;i<6;i++)
                          GestureDetector(child: Row(children: [Icon(Icons.star, size: 20, color: score2>=i?Color(0xFF9BE400):Color(0xFFE4E4E4),),SizedBox(width: 5,)],),
                            onTap: (){
                              setState(() {
                                score2=i;
                              });
                            },
                          ),
                        SizedBox(width: 20,),
                        if(score2==5)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('超赞'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score2==4)Row(children: [
                          Image.asset('assets/images/manyi.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('满意'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score2==3)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('一般'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score2==2)Row(children: [
                          Image.asset('assets/images/tucao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('吐槽'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score2==1)Row(children: [
                          Image.asset('assets/images/zaogao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('糟糕'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),

                      ],),
                      SizedBox(height: 10,),
                      ///品牌
                      Row(children: [
                        SizedBox(width: 5,),
                        Container(width: 110,child:Text('品牌'.tr ,),),
                        for(var i=1;i<6;i++)
                          GestureDetector(child: Row(children: [Icon(Icons.star, size: 20, color: score3>=i?Color(0xFF9BE400):Color(0xFFE4E4E4),),SizedBox(width: 5,)],),
                            onTap: (){
                              setState(() {
                                score3=i;
                              });
                            },
                          ),
                        SizedBox(width: 20,),

                        if(score3==5)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('超赞'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score3==4)Row(children: [
                          Image.asset('assets/images/manyi.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('满意'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score3==3)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('一般'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score3==2)Row(children: [
                          Image.asset('assets/images/tucao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('吐槽'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score3==1)Row(children: [
                          Image.asset('assets/images/zaogao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('糟糕'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),

                      ],),
                      SizedBox(height: 10,),
                      ///外观设计
                      Row(children: [
                        SizedBox(width: 5,),
                        Container(width: 110,child:Text('外观设计'.tr ,),),
                        for(var i=1;i<6;i++)
                          GestureDetector(child: Row(children: [Icon(Icons.star, size: 20, color: score4>=i?Color(0xFF9BE400):Color(0xFFE4E4E4),),SizedBox(width: 5,)],),
                            onTap: (){
                              setState(() {
                                score4=i;
                              });
                            },
                          ),
                        SizedBox(width: 20,),
                        if(score4==5)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('超赞'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score4==4)Row(children: [
                          Image.asset('assets/images/manyi.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('满意'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score4==3)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('一般'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score4==2)Row(children: [
                          Image.asset('assets/images/tucao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('吐槽'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score4==1)Row(children: [
                          Image.asset('assets/images/zaogao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('糟糕'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),

                      ],),
                      SizedBox(height: 10,),
                      ///会回购
                      Row(children: [
                        SizedBox(width: 5,),
                        Container(width: 110,child:Text('会回购'.tr ,),),
                        for(var i=1;i<6;i++)
                          GestureDetector(child: Row(children: [Icon(Icons.star, size: 20, color: score5>=i?Color(0xFF9BE400):Color(0xFFE4E4E4),),SizedBox(width: 5,)],),
                            onTap: (){
                              setState(() {
                                score5=i;
                              });
                            },
                          ),
                        SizedBox(width: 20,),
                        if(score5==5)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('超赞'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score5==4)Row(children: [
                          Image.asset('assets/images/manyi.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('满意'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score5==3)Row(children: [
                          Image.asset('assets/images/chaozan.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('一般'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score5==2)Row(children: [
                          Image.asset('assets/images/tucao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('吐槽'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                        if(score5==1)Row(children: [
                          Image.asset('assets/images/zaogao.png',width: 20,height: 20,),
                          SizedBox(width: 5,),
                          Text('糟糕'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),],),
                      ],),
                      SizedBox(height: 15,),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(20), //边角为5
                          ),
                          color: Color(0xffF5F5F5),
                        ),
                        child:Column(children: [
                          TextField(
                            maxLines: 7,
                            maxLength:500,
                            focusNode: _nodeText1,
                            // controller: _controller,
                            // cursorColor: Color(0xffffffff),
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              hintText: "来说说你对TA的使用感受，跟大家一起交流吧".tr,
                              hintStyle: TextStyle(color: Color(0xff666666)),
                              border: InputBorder.none, // 隐藏边框
                              fillColor: Color(0xffF5F5F5),
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
                            onChanged: (data) {
                              setState(() {
                                text=data;
                              });
                            },
                          ),
                          SizedBox(height: 20,),
                          Container(
                            margin: EdgeInsets.only(right: 20),
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                            decoration: BoxDecoration(
                              color: Color(0xffF5F5F5),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10), //边角为5
                              ),
                            ),
                            child: Row(
                              children: [
                                GestureDetector(child:Container(child: Image.asset('assets/images/tianjia.png',width: 70,height: 70,),) ,onTap: (){
                                  addImages(context);
                                },),
                                Expanded(child: Container(
                                  child: ListView(
                                    shrinkWrap: true,
                                    primary:false,
                                    scrollDirection: Axis.horizontal,
                                    children:[
                                      for(var i=0;i<imageListFile.length;i++)
                                        GestureDetector(child: Stack(children: [
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
                                              child: Container(
                                                child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(8),
                                                    child: Image.file(
                                                      imageListFile[i],
                                                      fit: BoxFit.cover,
                                                      width: 70,
                                                      height: 70,
                                                    )),
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black12),
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                              ),
                                            ),),
                                          Positioned(child: Image.asset('assets/images/cha.png',width: 15,height: 15,),top: -6,left: -6,)
                                        ],clipBehavior: Clip.none, alignment:Alignment.center),
                                          onTap: (){
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
                                        )
                                    ]),
                                  height: 70,
                                )
                                )
                              ],
                            ),
                          ),
                        ],),
                      ),
                    ],
                  )
                ],)
            )
        ),
      bottomNavigationBar: Container(
        //color: Color(0xffF5F5F5),
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Color(0xff000000)),
          ),
          onPressed: () async {
            if(score1==0 || score2==0|| score3==0|| score4==0|| score5==0){
              ToastInfo('评分都需要勾选'.tr);
              return;
            }
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

              final pictureName =  storageRef.child('user/img/'+_getFileName()+'.png');
              final pictureUpload = pictureName.putFile(File(imageObj.path));
              await pictureUpload.whenComplete(() {});
              String newThumbnailPath =  await pictureName.getDownloadURL();

              imagesPath.add(newThumbnailPath);
              await publiDataLogic.finishTask();
              print('publish:循环上传图文成功');
            }
            var res = await Pricemodules.parityRatiocommentadd({"goodsId":Get.arguments,"text":text,"score1":score1,"score2":score2,"score3":score3,"score4":score4,"score5":score5,"images":imagesPath.length>0? imagesPath.join(','):''});
            if(res.statusCode==200){
              EasyLoading.dismiss();
              Get.back(result: true);
              //Get.off(EvaluationdetailsPage());
              ToastInfo('评价成功，感谢你的测评'.tr);
            }
          },
          child: Text('发布'.tr,style: TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
  }

  // 添加图片
  addImages(context) async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(selectedAssets: imageList,maxAssets:6),
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

