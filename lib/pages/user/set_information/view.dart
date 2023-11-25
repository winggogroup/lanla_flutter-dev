import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/home/view.dart';
import 'package:lanla_flutter/pages/user/Invitationpage/index.dart';
import 'package:lanla_flutter/pages/user/chooseTopic/view.dart';
import 'package:lanla_flutter/pages/user/reference/index.dart';
import 'package:lanla_flutter/services/user_home.dart';

import 'logic.dart';
class SetInformationPage extends StatelessWidget {
  final logic = Get.put(SetInformationLogic());
  final state = Get.find<SetInformationLogic>().state;
  final FocusNode _nodeText1 = FocusNode();
  // UserHomeProvider InvitationCodeprovider =  Get.find<UserHomeProvider>();
  final InvitationCodeprovider = Get.put(UserHomeProvider());
  final userLogic =  Get.find<UserLogic>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body:
        Container(
            padding: EdgeInsets.fromLTRB(20, 88, 20, 0),
            child:
            KeyboardActions(
                autoScroll:false,

                config: KeyboardActionsConfig(
                    keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                    keyboardBarColor: Colors.white,
                    nextFocus: false,
                    //nextFocus: true,
                    defaultDoneWidget: Text("完成".tr),

                    actions: [
                      KeyboardActionsItem(
                        focusNode: _nodeText1,
                      ),

                    ]),
                child:
                ListView(
                    children:[
                      Row(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('欢迎你的到来'.tr,textAlign:TextAlign.center,style: TextStyle(
                              fontSize:30,
                              fontWeight: FontWeight.w700
                          )),
                          //
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Text('填写信息个性化你的内容'.tr,textAlign:TextAlign.center,style: TextStyle(
                              fontSize:14,
                            ))
                            //
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text('性别'.tr,style: TextStyle(fontWeight: FontWeight.w700),),
                      ),
                      //选择性别模块
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 25, 0, 0),

                        // height: 100,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Obx(
                                  () => Container(
                                padding: EdgeInsets.fromLTRB(40, 25, 40, 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xffffffff),
                                  border: Border.all(width: 2,color: state.OvertCovertwoMan.value?Colors.transparent:Colors.black),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      offset: Offset(0, 2),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  // height:50,
                                  children: [
                                    if (state.OvertCovertwoMan.value)
                                      Container(
                                          width: 80.0,
                                          height: 89.0,
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 9),
                                          child: GestureDetector(
                                            child: Image.asset('assets/images/woman.png',
                                                // width: 80.0,
                                                // height: 20.0,
                                                fit: BoxFit.fitWidth),
                                            onTap: () {
                                              print('12333');
                                              state.OvertCovertwoMan.value = false;
                                              state.OvertCovertMan.value = true;
                                              print(state.OvertCovertwoMan.value);
                                            },
                                          )),
                                    if (!state.OvertCovertwoMan.value)
                                      Container(
                                        margin: EdgeInsets.fromLTRB(0, 0, 0, 9),
                                        child: GestureDetector(
                                          child: Image.asset('assets/images/xuanwoman.png',
                                              // width: 80.0,
                                              // height: 89.0,
                                              fit: BoxFit.fitWidth),
                                          onTap: () {
                                            print('12333');
                                            if (!state.OvertCovertMan.value) {
                                              state.OvertCovertwoMan.value = true;
                                              state.OvertCovertMan.value = true;
                                            }
                                            print(state.OvertCovertwoMan.value);
                                          },
                                        ),
                                      ),
                                    Text('女'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            Obx(
                                  () => Container(
                                padding: EdgeInsets.fromLTRB(40, 25, 40, 25),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xffffffff),
                                  border: Border.all(width: 2,color: state.OvertCovertMan.value?Colors.transparent:Colors.black),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x19000000),
                                      offset: Offset(0, 2),
                                      blurRadius: 10,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    if (state.OvertCovertMan.value)
                                      Container(
                                          width: 80.0,
                                          height: 89.0,
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 9),
                                          child: GestureDetector(
                                            child: Image.asset('assets/images/man.png',
                                                // width: 80.0,
                                                // height: 80.0,
                                                fit: BoxFit.fitWidth),
                                            onTap: () {
                                              state.OvertCovertMan.value = false;
                                              state.OvertCovertwoMan.value = true;
                                            },
                                          )),
                                    if (!state.OvertCovertMan.value)
                                      Container(
                                          margin: EdgeInsets.fromLTRB(0, 0, 0, 9),
                                          // width: 80.0,
                                          // height: 80.0,
                                          child: GestureDetector(
                                            child: Image.asset('assets/images/xuanman.png',
                                                // width: 80.0,
                                                // height: 80.0,
                                                fit: BoxFit.fitWidth),
                                            onTap: () {
                                              if (!state.OvertCovertwoMan.value) {
                                                state.OvertCovertwoMan.value = true;
                                                state.OvertCovertMan.value = true;
                                              }
                                            },
                                          )),
                                    Text('男'.tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 14,
                                        ))
                                  ],
                                ),
                              ),
                            ),
                            //
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                        child: Text('年龄'.tr,style: TextStyle(fontWeight: FontWeight.w700),),
                      ),
                      //生日模块
                      GestureDetector(
                        child:  Container(
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 8),
                          padding: EdgeInsets.all(20),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(width: 2,color: Colors.black),
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x3347B000),
                                offset: Offset(0, 2),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                          child:Obx(()=>state.birthday.value==''?Text('选择你的生日'.tr,style:TextStyle(fontSize: 15,
                            color: Color(0xff999999),
                          )):Text(state.birthday.value ,style:TextStyle(fontSize: 15,fontWeight: FontWeight.w700
                          ))) ,
                        ),
                        onTap: (){
                          DateTime today = new DateTime.now();
                          // String dateSlug ="${today.year.toString()}-${today.month.toString().padLeft(2,'0')}-${today.day.toString().padLeft(2,'0')}";
                          print(int.parse(today.year.toString())-10);
                          DatePicker.showDatePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(int.parse(today.year.toString())-60, 1, 1),
                              maxTime: DateTime(int.parse(today.year.toString()), 1, 1), onChanged: (date) {
                                print('change $date');
                              }, onConfirm: (date) {
                                state.birthday.value=date.toString().split(' ')[0];
                                // print(date.toString().split(' ')[0]);
                              }, currentTime: DateTime(int.parse(today.year.toString())-10, 1, 1), locale: LocaleType.ar);
                        },
                      ),
                      ///邀请码
                      // Container(
                      //   alignment: Alignment.centerRight,
                      //   margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                      //   child: Text('邀请码'.tr,style: TextStyle(fontWeight: FontWeight.w700),),
                      // ),



                      // Container(
                      //     margin: EdgeInsets.fromLTRB(0, 20, 0, 8),
                      //     //padding: EdgeInsets.all(20),
                      //     width: double.infinity,
                      //     decoration: BoxDecoration(
                      //       border: Border.all(width: 2,color: Colors.black),
                      //       color: Colors.white,
                      //       borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       boxShadow: [
                      //         BoxShadow(
                      //           color: Color(0x3347B000),
                      //           offset: Offset(0, 2),
                      //           blurRadius: 5,
                      //           spreadRadius: 1,
                      //         ),
                      //       ],
                      //     ),
                      //     // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                      //     child:
                      //     // KeyboardActions(
                      //     //     autoScroll:false,
                      //     //
                      //     //     config: KeyboardActionsConfig(
                      //     //         keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
                      //     //         keyboardBarColor: Colors.white,
                      //     //         nextFocus: false,
                      //     //         //nextFocus: true,
                      //     //         defaultDoneWidget: Text("完成".tr),
                      //     //
                      //     //         actions: [
                      //     //           KeyboardActionsItem(
                      //     //             focusNode: _nodeText1,
                      //     //           ),
                      //     //
                      //     //         ]),
                      //     //     child:
                      //     //     TextField(
                      //     //       keyboardType: TextInputType.number,
                      //     //       focusNode: _nodeText1,
                      //     //       // inputFormatters: [
                      //     //       //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      //     //       // ],
                      //     //       //scrollPadding: EdgeInsets.fromLTRB(100, 10, 10, 10),
                      //     //       cursorColor: Color(0xFF999999),
                      //     //       decoration: InputDecoration(
                      //     //         // focusedBorder: OutlineInputBorder(
                      //     //         //   borderSide: BorderSide(color: Colors.blue)
                      //     //         // ),
                      //     //         //   filled: true,
                      //     //         //   fillColor: const Color(0xff000000),
                      //     //         border: InputBorder.none,
                      //     //         hintText: "填写好友邀请码（非必填项）".tr,
                      //     //         contentPadding: EdgeInsets.all(20),
                      //     //       ),
                      //     //       style: TextStyle(fontSize: 15),
                      //     //       onChanged: (text) {
                      //     //         state.Invitationcode.value=text;
                      //     //         // state.Verification = text;
                      //     //         // print(state.Verification);
                      //     //       },
                      //     //     )
                      //     //
                      //     // ),
                      //     TextField(
                      //       keyboardType: TextInputType.number,
                      //       focusNode: _nodeText1,
                      //       // inputFormatters: [
                      //       //   FilteringTextInputFormatter.allow(RegExp("[0-9]")),//数字
                      //       // ],
                      //       //scrollPadding: EdgeInsets.fromLTRB(100, 10, 10, 10),
                      //       cursorColor: Color(0xFF999999),
                      //       decoration: InputDecoration(
                      //         // focusedBorder: OutlineInputBorder(
                      //         //   borderSide: BorderSide(color: Colors.blue)
                      //         // ),
                      //         //   filled: true,
                      //         //   fillColor: const Color(0xff000000),
                      //         border: InputBorder.none,
                      //         hintText: "填写好友邀请码（非必填项）".tr,
                      //         contentPadding: EdgeInsets.all(20),
                      //       ),
                      //       style: TextStyle(fontSize: 15),
                      //       onChanged: (text) {
                      //         state.Invitationcode.value=text;
                      //         // state.Verification = text;
                      //         // print(state.Verification);
                      //       },
                      //     )
                      //
                      // ),

                      //Divider(height: 1.0,indent: 0,color: Color(0xffF1F1F1),),
                      //按钮
                      Container(
                          margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                          height: 46,
                          width: double.infinity,
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                          child:Obx(() =>(!state.OvertCovertwoMan.value||!state.OvertCovertMan.value)&&state.birthday.value!=''?  ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:MaterialStateProperty.all(Color(0xff000000)),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              // elevation: MaterialStateProperty.all(20),
                              shadowColor: MaterialStateProperty.all(Colors.black),
                              elevation: MaterialStateProperty.all(5),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(37))
                              ),
                            ),

                            child: Text('下一步'.tr,),
                            onPressed: () async {
                              // print(state.Invitationcode.value);
                              // return;
                              if(!state.OvertCovertMan.value){
                                state.sex='1';
                              }else if(!state.OvertCovertwoMan.value){
                                state.sex='2';
                              }
                              // if(state.Invitationcode.value!=''){
                              //   var result = await InvitationCodeprovider.getinviteCode(state.Invitationcode.value);
                              //   print('8888888888888');
                              //   if(result?.statusCode==200){
                              //     // Get.back();
                              //     Toast.toast(context,msg: "填写成功".tr,position: ToastPostion.bottom);
                              //   }
                              // }

                              logic.Completioninformation(context);

                              // Toast.toast(context,msg: "居中显示",position: ToastPostion.bottom);
                            },
                          ):ElevatedButton(
                            style: ButtonStyle(

                              backgroundColor:MaterialStateProperty.all(Color(0xffF9F9F9)),
                              foregroundColor: MaterialStateProperty.all(Colors.white),
                              elevation: MaterialStateProperty.all(5),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(37))
                              ),
                            ),

                            child: Text('请完善信息'.tr,style: TextStyle(color: Color(0xff999999),
                            ),),
                            onPressed: () {
                              // Get.to(ChooseTopicPage());
                              // Toast.toast(context,msg: "居中显示",position: ToastPostion.bottom);
                            },
                          ),)
                      ),
                      SizedBox(height: 20,),
                      GestureDetector(child: Container(alignment: Alignment.center,margin: EdgeInsets.only(bottom: 20),child:Text('跳过'.tr,style: TextStyle(
                        color: Color(0xff666666),

                      ),) ,),onTap: (){
                        // Get.offAll(InvitationPage());
                        userLogic.isshowFillincode=true;
                        Get.offAll(ReferencePage());

                        //Get.to(ChooseTopicPage());
                      },),
                    ]
                )

            ),

        )
    );
  }
}
