import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/DailyTasks.dart';
import 'package:lanla_flutter/models/userGiftDetail.dart';
import 'package:lanla_flutter/pages/detail/Amountdetails/view.dart';
import 'package:lanla_flutter/pages/detail/FlowDetails/view.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/me/LevelDescription/index.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/ConnectionTopicViewPage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/services/user.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/ulits/language/camera_picker_text_delegate.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';
class TaskCenterPage extends StatefulWidget  {
  @override
  TaskCenterState createState() => TaskCenterState();
}
class TaskCenterState extends State<TaskCenterPage>with SingleTickerProviderStateMixin {
  final userLogic = Get.find<UserLogic>();
  final UserProvideres = Get.find<UserProvider>();
  late final UserProvider userprovider=Get.find<UserProvider>();
  var taskdata;
  var oneData=false;
  bool antishake = true;
  @override
  void initState() {
    super.initState();
    userLogic.Personallevel();
    initial();
   // print('等级数据${userLogic.gradedata['userCurrLevelExp']/userLogic.gradedata['currLevelExp']}');
    print('等级数据${userLogic.gradedata['userCurrLevelExp']/userLogic.gradedata['currLevelExp']}');
  }

  initial() async {
    var res =  await UserProvideres.dailyTaskList();
    if(res.statusCode==200){
      taskdata=dailyTasksFromJson(res.bodyString!);
      oneData=true;
      setState(() {

      });
    }
  }


  _publish(context) {

    // Map<String, String> topicObject = {
    //   "name": _dataSource!.title,
    //   "id": _dataSource!.id.toString()
    // };

    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-camera');
              Get.back();
              final AssetEntity? result = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: const CameraPickerConfig(
                    textDelegate: ArabCameraPickerTextDelegate(),
                    enableRecording: true,
                    shouldAutoPreviewVideo: true),
              );
              // 选择图片后跳转到发布页
              if (result != null) {
                Get.toNamed('/verify/publish', arguments: {"asset": result});
              }
              print('退出页面');
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '拍摄'.tr,
                    style: const TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-picker');
              Get.back();
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                    textDelegate: ArabicAssetPickerTextDelegate()),
              );
              // 选择图片后跳转到发布页
              if (result != null && result.isNotEmpty) {
                Get.toNamed('/verify/publish',
                    arguments: {"asset": result,});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                '从相册选择'.tr,
                style: const TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          Container(
            color: Colors.black12,
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              height: 70,
              color: Colors.white,
              child: Center(
                child: Text(
                  '取消'.tr,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }


  ///签到弹窗
  Future<void> Signinpopup(context) async {
    // assets/images/qdtanc.png
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                height: 375,
                child: Column(
                  children: [
                    Image.asset('assets/images/qdtanc.png', fit: BoxFit.cover,),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(15, 16, 15, 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  ///第一天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==1?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==1?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [

                                        Image.network(
                                          userLogic.signindata.task[0].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=1&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>1)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '1',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第四天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==4?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==4?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[3].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=4&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>4)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '4',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  ///第二天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==2?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==2?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[1].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),

                                        if((userLogic.signindata.userIndex>=2&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>2)
                                          Positioned(top: 0,left: 0,right: 0,bottom:0,child:
                                          Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),
                                            child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '2',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),


                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第五天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment.topCenter, //渐变开始于上面的中间开始
                                            end: Alignment.bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==5?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==5?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[4].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),

                                        if((userLogic.signindata.userIndex>=5&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>5)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '5',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              Column(
                                children: [
                                  ///第三天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==3?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==3?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[2].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=3&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>3)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '3',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 15,),
                                  ///第六天
                                  Container(
                                    width: 60,
                                    height: 60,
                                    clipBehavior: Clip.hardEdge,
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                            begin: Alignment
                                                .topCenter, //渐变开始于上面的中间开始
                                            end: Alignment
                                                .bottomCenter, //渐变结束于下面的中间
                                            colors: [
                                              userLogic.signindata.userIndex==6?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                              userLogic.signindata.userIndex==6?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                            ]),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(8))),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Image.network(
                                          userLogic.signindata.task[5].imagePath,
                                          width: 32,
                                          height: 30,
                                        ),
                                        if((userLogic.signindata.userIndex>=6&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>6)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                        Positioned(
                                            left: 0,
                                            top: 0,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: 20,
                                              height: 20,
                                              decoration: const BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                  BorderRadius.only(
                                                      bottomRight:
                                                      Radius.circular(
                                                          50))),
                                              child: const Text(
                                                '6',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                    fontWeight:
                                                    FontWeight.w700),
                                              ),
                                            )),

                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              ///第七天
                              Container(
                                height: 130,
                                width: 60,
                                clipBehavior: Clip.hardEdge,
                                decoration: BoxDecoration(gradient: LinearGradient(
                                    begin: Alignment
                                        .topCenter, //渐变开始于上面的中间开始
                                    end: Alignment
                                        .bottomCenter, //渐变结束于下面的中间
                                    colors: [
                                      userLogic.signindata.userIndex==7?const Color(0x00FFFFFF):const Color(0xFFF5F5F5),
                                      userLogic.signindata.userIndex==7?const Color(0xFFD1FF34):const Color(0xFFF5F5F5)
                                    ]), borderRadius: const BorderRadius.all(Radius.circular(8))),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                      Image.network(
                                        userLogic.signindata.task[6].imagePath,
                                        width: 54,
                                        height: 51,
                                      ),
                                      const SizedBox(height: 5,),
                                      Text('惊喜'.tr,style: const TextStyle(fontSize: 10,color: Color(0xff666666)),)
                                    ],),
                                    if((userLogic.signindata.userIndex>=7&&userLogic.signindata.userDailySignIn)||userLogic.signindata.userIndex>7)Positioned(top: 0,left: 0,right: 0,bottom:0,child: Container( alignment: Alignment.center, color: const Color.fromRGBO(0, 0, 0, 0.30),child: Image.asset('assets/images/sigindg.png',width: 30,height: 30,),)),
                                    Positioned(
                                        left: 0,
                                        top: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 20,
                                          height: 20,
                                          decoration: const BoxDecoration(
                                              color: Colors.black,
                                              borderRadius:
                                              BorderRadius.only(
                                                  bottomRight:
                                                  Radius.circular(
                                                      50))),
                                          child: const Text(
                                            '7',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                fontWeight:
                                                FontWeight.w700),
                                          ),
                                        )),
                                  ],
                                ),
                              )
                            ],
                          ),
                          Expanded(child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              userLogic.signindata.userIndex>1 || userLogic.signindata.userDailySignIn?Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                                Text(
                                  '连续签到'.tr,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xff999999)),
                                ),
                                Text(
                                  userLogic.signindata.userIndex.toString(),
                                  style: const TextStyle(
                                      fontSize: 20, fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  '天得贝壳'.tr,
                                  style: const TextStyle(
                                      fontSize: 12, color: Color(0xff999999)),
                                ),
                              ],):Text(
                                '连续签到7天得贝壳'.tr,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xff999999)),
                              ),

                              GestureDetector(child: Container(
                                decoration: const BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                                  color: Colors.black,
                                ),
                                width: 166,
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  userLogic.signindata.userDailySignIn?'签到成功'.tr:'签到'.tr,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),onTap: (){
                                if(!userLogic.signindata.userDailySignIn){
                                  signbutton();
                                }else{
                                  Navigator.pop(context);
                                }

                              },)
                            ],
                          ))
                        ],
                      ),
                    ))
                  ],
                ))
        );
      },
    );
  }
  ///签到奖励弹窗
  Signinreward(context) async{
    // assets/images/qdtanc.png
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
                width: double.infinity,
                height: 375,
                child: Column(
                  children: [
                    Image.asset('assets/images/qdtanc.png', fit: BoxFit.cover,),
                    Expanded(child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20)),
                      ),
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                      child: Column(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset('assets/images/jinglibk.png',width: 165,),

                          Row(mainAxisAlignment:MainAxisAlignment.center,children: [ Text('你获得了'.tr,), Text(Rewardamount(userLogic.signindata.task[userLogic.signindata.userIndex-1].taskRewards),style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w700,color: Color(0xffFF789B)),), Text('个贝币'.tr)],)
                        ],
                      ),
                    ))
                  ],
                ))
        );
      },
    );
  }

  ///奖励金额
  Rewardamount(data){
    for(var i=0;i<data.length;i++){
      if(data[i].rewardType==1&&data[i].showType==1){
        return data[i].rewardAmount;
      }
    }

  }

  ///签到
  signbutton() async{
    if(antishake){
      antishake=false;
      print('点击了${userLogic.signindata.task[userLogic.signindata.userIndex-1].taskRewards}');
      var res = await userprovider.signbutton();
      if(res.statusCode==200){
        Navigator.pop(context);
        Signinreward(context);
        userLogic.Personallevel();
        userLogic.signinlist();

      }
      setState(() {

      });
      antishake=true;
    }

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            title: Row(
              children: [
                GestureDetector(child: Container(
                  width: 19,
                  height: 22,
                  child: SvgPicture.asset(
                    "assets/svg/youjiantou.svg",
                  ),
                ), onTap: (){
                  Get.back();
                },),
                Expanded(
                    child: Center(
                      child: Text(
                        '任务中心'.tr,
                        style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                      ),
                    )),
                Container(
                  width: 19,
                ),
              ],
            ),
          ),
          body:
          Column(children: [
            Container(width: double.infinity,height: 1,color: const Color(0x0c000000),),
            Expanded(child: Container(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
              child: ListView(physics: const BouncingScrollPhysics(),children: [

                const SizedBox(height: 25,),
                if(userLogic.gradedata['currLevel']==1)Image.asset('assets/images/ZXLV1.png',width: 82,height: 99,),
                if(userLogic.gradedata['currLevel']==2)Image.asset('assets/images/ZXLV2.png',width: 82,height: 99,),
                if(userLogic.gradedata['currLevel']==3)Image.asset('assets/images/ZXLV3.png',width: 82,height: 99,),
                if(userLogic.gradedata['currLevel']==4)Image.asset('assets/images/ZXLV4.png',width: 82,height: 99,),
                if(userLogic.gradedata['currLevel']==5)Image.asset('assets/images/ZXLV5.png',width: 82,height: 99,),
                const SizedBox(height: 25,),
                Container(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),child: Row(children: [
                  Expanded(child: Container(height: 64,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                    Text('LanLa等级'.tr,style: const TextStyle(fontSize: 12),),
                    const SizedBox(height: 10,),
                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                      Text('Lv${userLogic.gradedata['currLevel']}',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 12),),
                      if(userLogic.gradedata['currLevel']<5)Text('Lv${userLogic.gradedata['currLevel']+1}',style: const TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Color(0xffA8F600)),),
                    ],),
                    const SizedBox(height: 5,),
                    Container(
                      height: 4, // 进度条高度
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(5), // 圆角边框
                      ),
                      child: LayoutBuilder(builder:
                          (BuildContext context,
                          BoxConstraints constraints) {
                        double boxWidth = constraints.maxWidth;
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (userLogic.gradedata['userCurrLevelExp']/userLogic.gradedata['currLevelExp']),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xffD1FF34), // 进度条颜色
                                  borderRadius:
                                  BorderRadius.circular(5), // 圆角边框
                                ),
                              ),
                            ),

                          ],
                        );
                      }),
                    ),
                  ],),)),
                  const SizedBox(width: 15,),
                  Container(height: 64,width: 2,decoration: const BoxDecoration(color: Color(0xffF1F1F1),borderRadius: BorderRadius.all(Radius.circular(20))),),
                  const SizedBox(width: 15,),
                  Expanded(child: GestureDetector(child: Container(height: 64,child: Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                    Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                      Text('la货币'.tr,style: const TextStyle(fontSize: 12),),
                      Row(children: [Text('明细'.tr,style: const TextStyle(fontSize: 12,color: Color(0xffA8F600)),),
                        const SizedBox(width: 8,),
                        Container(
                            width: 6,
                            height: 11,
                            child: SvgPicture.asset(
                              color: const Color(0xffA8F600),
                              "assets/svg/zuojiantou.svg",
                            ))
                      ],)
                    ],),
                    // SizedBox(height: 10,),
                    Text(userLogic.gradedata['balance'].toString(),style: const TextStyle(fontSize: 30,fontWeight: FontWeight.w600),)
                  ],),),onTap: (){
                    Get.toNamed('/verify/flowing',arguments: 1);
                    },)),
                ],),),
                const SizedBox(height: 12,),
                Container(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),child: Row(
                  children: [
                    Expanded(
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(

                                    ///颜色百分比
                                      color: Color.fromRGBO(0, 0, 0, 0.08),
                                      //color:Colors.black,
                                      offset: Offset(0.0, 1), //阴影xy轴偏移量
                                      blurRadius: 4, //阴影模糊程度
                                      spreadRadius: 1 //阴影扩散程度
                                  )
                                ]),
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/images/dengjishuoming.png',
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
                                    width: 7,
                                  ),
                                  Text(
                                    '等级说明'.tr,
                                    style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700),
                                  )
                                ],
                              ),
                              onTap: () {
                                Get.to(LevelDescriptionPage());
                              },
                            ))),
                    const SizedBox(
                      width: 22,
                    ),
                    Expanded(
                        child: GestureDetector(child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(

                                  ///颜色百分比
                                    color: Color.fromRGBO(0, 0, 0, 0.08),
                                    //color:Colors.black,
                                    offset: Offset(0.0, 1), //阴影xy轴偏移量
                                    blurRadius: 4, //阴影模糊程度
                                    spreadRadius: 1 //阴影扩散程度
                                )
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/duihuanlw.png',
                                width: 30,
                                height: 30,
                              ),
                              const SizedBox(
                                width: 7,
                              ),
                              Text(
                                '兑换礼物'.tr,
                                style: const TextStyle(
                                    fontSize: 11, fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),onTap: (){
                          Get.to(AmountPage(),arguments: 2);
                        },)),
                  ],
                ),),
                const SizedBox(height: 20,),
                Container(color: const Color(0xffF5F5F5),height: 10,),
                Container(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                  const SizedBox(height: 20,),
                  GestureDetector(child:
                    Container(clipBehavior: Clip.hardEdge,decoration: const BoxDecoration(color: Colors.white,boxShadow: [
                    BoxShadow(
                      ///颜色百分比
                        color: Color.fromRGBO(0, 0, 0, 0.2),
                        //color:Colors.black,
                        offset: Offset(0.0, 1), //阴影xy轴偏移量
                        blurRadius: 4, //阴影模糊程度
                        spreadRadius: 1 //阴影扩散程度
                    )
                  ],borderRadius: BorderRadius.all(Radius.circular(10))),width: double.infinity,height: 86,child: Image.asset('assets/images/renwutp.png',fit: BoxFit.cover,),),
                  onTap: (){
                    Signinpopup(context);
                  },),
                  !oneData ? StartDetailLoading():Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                    const SizedBox(height: 36,),
                    if(taskdata.newData.length>0)Text('新手任务'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                    for(var i=0;i<taskdata.newData.length;i++)
                      Container(padding: const EdgeInsets.fromLTRB(0, 17, 0, 17),child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(width: 30,height: 30,child: Image.network(taskdata.newData[i].image,width: 30,height: 30,),),
                            const SizedBox(width: 15,),
                            Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                              Text(taskdata.newData[i].summary,style: const TextStyle(fontSize: 14),),
                              const SizedBox(height: 10,),

                              Row(children: [Image.asset('assets/images/beiketwo.png',width: 16,height: 16,),const SizedBox(width: 5,),
                                Text('${taskdata.newData[i].rewardBeans}+',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontWeight: FontWeight.w700,color: Color(0xffFF789B)),),
                                const SizedBox(width: 10,),
                                if(taskdata.newData[i].beansCap!=0)Row(children: [
                                  Text('任务完成'.tr,
                                    strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),
                                    style: const TextStyle(fontSize: 14,color: Color(0xff999999)),
                                  ),
                                  Text('(${taskdata.newData[i].num}/${taskdata.newData[i].beansCap})',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontSize: 14,color: Color(0xff999999))),
                                  Text('完成次数'.tr,strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontSize: 14,color: Color(0xff999999)),)],)
                              ],)

                            ],)],),
                          GestureDetector(child:Container(alignment: Alignment.center,decoration: BoxDecoration(color: taskdata.newData[i].beansCap==0||taskdata.newData[i].num<taskdata.newData[i].beansCap?Colors.black:const Color(0xffF5F5F5),borderRadius: const BorderRadius.all(Radius.circular(50))),width: 64,height: 28,child: const Text('إكمال',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),)
                            ,onTap: (){
                            if(taskdata.newData[i].beansCap!=0&&taskdata.newData[i].num<taskdata.newData[i].beansCap){
                              if(taskdata.newData[i].jumpType==1){
                                _publish(context);
                            }
                              if(taskdata.newData[i].jumpType==2){
                                Get.find<HomeLogic>().setNowPage(0);
                                Get.offAll(HomePage());
                              }
                            }

                          },)],
                      ),),
                    if(taskdata.newData.length>0)const SizedBox(height: 30,),
                    Text('日常任务'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
                    for(var i=0;i<taskdata.data.length;i++)
                      Container(padding: const EdgeInsets.fromLTRB(0, 17, 0, 17),child: Row(
                        mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                            Container(width: 30,height: 30,child: Image.network(taskdata.data[i].image,width: 30,height: 30,),),
                            const SizedBox(width: 15,),
                            Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                              Text(taskdata.data[i].summary,style: const TextStyle(fontSize: 14),),
                              const SizedBox(height: 10,),
                              Row(children: [
                                Row(children: [Image.asset('assets/images/beiketwo.png',width: 16,height: 16,),const SizedBox(width: 5,),Text('${taskdata.data[i].rewardBeans}+',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontWeight: FontWeight.w700,color: Color(0xffFF789B)),)],),
                                const SizedBox(width: 10,),
                                if(taskdata.data[i].beansCap!=0)Row(children: [
                                  Text('任务完成'.tr,
                                    strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),
                                    style: const TextStyle(fontSize: 14,color: Color(0xff999999)),
                                  ),
                                  Text('(${taskdata.data[i].num}/${taskdata.data[i].beansCap})',strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontSize: 14,color: Color(0xff999999))),
                                  Text('完成次数'.tr,strutStyle: const StrutStyle(forceStrutHeight: true, leading: 0.5,),style: const TextStyle(fontSize: 14,color: Color(0xff999999)),)],)
                              ],)
                            ],)],),
                          GestureDetector(child: Container(alignment: Alignment.center,decoration: BoxDecoration(color: taskdata.data[i].beansCap==0||taskdata.data[i].num<taskdata.data[i].beansCap?Colors.black:const Color(0xffF5F5F5),borderRadius: const BorderRadius.all(Radius.circular(50))),width: 64,height: 28,child: const Text('إكمال',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12,color: Colors.white),),)
                            ,onTap: (){
                              if(taskdata.data[i].beansCap==0||taskdata.data[i].num<taskdata.data[i].beansCap){
                                 if(taskdata.data[i].jumpType==1){
                                _publish(context);
                            }
                                if(taskdata.data[i].jumpType==2){
                                  Get.find<HomeLogic>().setNowPage(0);
                                  Get.offAll(HomePage());
                                }
                                if(taskdata.data[i].jumpType==3){
                                  Get.to(const ConnectionTopicPage());
                                }

                              }
                          },) ],
                      ),)
                  ],)

                ],),)
              ],),
            ))

          ],)

      );
  }
}