import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/home/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/Topicxqpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/user/Loginmethod/view.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';

import 'package:lanla_flutter/pages/search/view.dart';
import '../../../common/widgets/round_underline_tabindicator.dart';
import 'detail_view/ConnectionStartViewPage.dart';
import 'detail_view/view.dart';
import 'list_widget/list_view.dart';

/**
 * app的起始页面，全部从这里走
 */
import 'logic.dart';

class StartPage extends StatelessWidget {
  final logic = Get.find<StartLogic>();
  final homelogic = Get.find<HomeLogic>();
  final WebSocketes = Get.put(StartDetailLogic());

  final FocusNode _focusNode = FocusNode();

  final userLogic = Get.find<UserLogic>();
  final state = Get
      .find<StartLogic>()
      .state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0.3,
            backgroundColor: Colors.white,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            title: GetBuilder<StartLogic>(builder: (logic) {
              return state.topTabController == null
                  ? const Text('loading')
                  : Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [GestureDetector(
                  onTap: () {
                    //关闭登录验证
                    if (userLogic.token != '') {
                      Get.to(const ConnectionStartPage());
                    } else {
                      Get.to(LoginmethodPage(), transition: Transition.downToUp);
                    }
                    // Get.to(StartDetailPage(
                    //   type: ApiType.loction,
                    //   parameter: '',
                    //   lasting:false,
                    // ));
                    // state.topTabController?.index = 2;

                    // Get.to(ConnectionStartPage());
                  },
                  child: Container(
                    // margin: const EdgeInsets.fromLTRB(0,0,0,0),
                    child:
                    SvgPicture.asset(
                      'assets/icons/fuji.svg', width: 22, height: 22,),
                  )
              ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 10,right: 10),
                    height: 36,
                    child: TextField(
                      style: const TextStyle(fontSize: 13),
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                            hintStyle: const TextStyle(color: Color(0xff999999)),
                            contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                            border: InputBorder.none,
                            hintText: '搜索内容'.tr,
                            fillColor: const Color(0xFF999999).withAlpha(20),
                            enabledBorder: const OutlineInputBorder(
                              /*边角*/
                              borderRadius: BorderRadius.all(
                                Radius.circular(20), //边角为5
                              ),
                              borderSide: BorderSide(
                                color: Colors.white, //边线颜色为白色
                                width: 0, //边线宽度为2
                              ),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              /*边角*/
                              borderRadius: BorderRadius.all(
                                Radius.circular(20), //边角为5
                              ),
                              borderSide: BorderSide(
                                color: Colors.white, //边线颜色为白色
                                width: 0, //边线宽度为2
                              ),

                            ),
                            filled: true,
                            prefixIcon:Padding(
                              padding: const EdgeInsets.only(top: 7,bottom: 7,right: 5),
                                child: SvgPicture.asset(
                                  'assets/icons/sousuo.svg',
                                  width: 20,
                                  height: 20,
                                    color: const Color(0xff999999)
                                ),
                            )
                          // SvgPicture.asset('assets/icons/sousuo.svg',width: 5,height: 5,color: Color(0xffe4e4e4),),
                        ),
                        onTap: (){
                           _focusNode.unfocus();
                          ///关闭登录验证
                          if (!userLogic.checkUserLogin()) {
                            Get.toNamed('/public/loginmethod');
                            return;
                          }

                          Get.to(SearchPage());
                        },
                        // onChanged: (v){
                          // state.SearchContent=v;
                          // logic.update();
                        // },onSubmitted: (value) {
                      // logic.Searchnr();
                    // }
                    ),
                  ),
                ),

              //   TabBar(
              //   controller: state.topTabController,
              //   tabs: state.topTabs,
              //   labelColor: Colors.black,
              //   labelPadding: const EdgeInsets.fromLTRB(9, 4, 9, 0),
              //   isScrollable: true,
              //   indicator: CustomUnderlineTabIndicator(
              //     borderSide: BorderSide(
              //       width: 4,
              //       color: HexColor('#9BE400'),
              //     )
              //   ),
              //   indicatorPadding: const EdgeInsets.only(bottom: 4,left: 0,right: 0),
              //   labelStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400,fontFamily: 'DroidArabicKufi',),
              //   unselectedLabelColor: HexColor('#CCCCCC'),
              //   unselectedLabelStyle:
              //   const TextStyle(fontWeight: FontWeight.w400,fontSize: 15,fontFamily: 'DroidArabicKufi',),
              //   ///关闭登录验证
              //   // onTap: (index){
              //   //   if (!userLogic.checkUserLogin()) {
              //   //     state.topTabController?.index = state.topTabController!.previousIndex;
              //   //     Get.toNamed('/public/loginmethod');
              //   //     return;
              //   //   }
              //   // },
              // ),
                GestureDetector(
                  onTap: () {
                    //Get.to(SearchPage());
                    if (userLogic.token != '') {
                      if(!userLogic.Chatdisconnected){
                        WebSocketes.WebSocketconnection();
                      }
                      Get.toNamed('/public/message');
                    } else {
                      Get.toNamed('/public/loginmethod');
                    }
                  },
                  child:
                  GetBuilder<UserLogic>(builder: (logic) {
                    return Container(
                      //margin: const EdgeInsets.fromLTRB(14,14,14,14),
                      child: Stack(clipBehavior: Clip.none, children: [
                        if(userLogic.Chatrelated['${userLogic.userId}']!=null)
                          if(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>0)Positioned(
                            top: -18 / 2,
                            right: -22 / 2,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50)),
                                  color: Colors.red
                              ),
                              width: 16,
                              height: 16,
                              child: Text(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>99?'99':'${userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']}',
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 8,
                                    height: 1.0),),
                            ),
                          ),
                        if(userLogic.Chatrelated['${userLogic.userId}']==null)
                          if(userLogic.NumberMessages>0)Positioned(
                            top: -18 / 2,
                            right: -22 / 2,
                            child: Container(
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(50)),
                                  color: Colors.red
                              ),
                              width: 16,
                              height: 16,
                              child: Text(userLogic.NumberMessages.toString(),
                                style: const TextStyle(color: Colors.white,
                                    fontSize: 8,
                                    height: 1.0),),
                            ),
                          ),
                        SvgPicture.asset(
                          'assets/icons/lingdang.svg', width: 22, height: 22,),
                      ]),

                      //
                    );
                  })
              )],);
            }),
            //centerTitle: true,
            //  leading: GestureDetector(
            //      onTap: () {
            //        ///关闭登录验证
            //        //if (userLogic.token != '') {
            //          Get.to(SearchPage(), transition: Transition.leftToRight);
            //        // } else {
            //        //   Get.to(LoginmethodPage(), transition: Transition.downToUp);
            //        // }
            //      },
            //      child: Container(
            //        margin: const EdgeInsets.all(14),
            //        child:
            //        SvgPicture.asset(
            //          'assets/icons/sousuo.svg', width: 22, height: 22,),
            //      )
            //  ),
            //  actions: [
            //    GestureDetector(
            //        onTap: () {
            //          //Get.to(SearchPage());
            //          if (userLogic.token != '') {
            //            if(!userLogic.Chatdisconnected){
            //              WebSocketes.WebSocketconnection();
            //            }
            //            Get.toNamed('/public/message');
            //          } else {
            //            Get.toNamed('/public/loginmethod');
            //          }
            //        },
            //        child:
            //        GetBuilder<UserLogic>(builder: (logic) {
            //          return Container(
            //            margin: const EdgeInsets.all(14),
            //            child: Stack(clipBehavior: Clip.none, children: [
            //              if(userLogic.Chatrelated['${userLogic.userId}']!=null)
            //                if(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>0)Positioned(
            //                  top: -18 / 2,
            //                  right: -22 / 2,
            //                  child: Container(
            //                    alignment: Alignment.center,
            //                    decoration: BoxDecoration(
            //                        borderRadius: BorderRadius.all(
            //                            Radius.circular(50)),
            //                        color: Colors.red
            //                    ),
            //                    width: 16,
            //                    height: 16,
            //                    child: Text(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>99?'99':'${userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']}',
            //                      style: TextStyle(color: Colors.white,
            //                          fontSize: 8,
            //                          height: 1.0),),
            //                  ),
            //                ),
            //              if(userLogic.Chatrelated['${userLogic.userId}']==null)
            //                if(userLogic.NumberMessages>0)Positioned(
            //                  top: -18 / 2,
            //                  right: -22 / 2,
            //                  child: Container(
            //                    alignment: Alignment.center,
            //                    decoration: BoxDecoration(
            //                        borderRadius: BorderRadius.all(
            //                            Radius.circular(50)),
            //                        color: Colors.red
            //                    ),
            //                    width: 16,
            //                    height: 16,
            //                    child: Text(userLogic.NumberMessages.toString(),
            //                      style: TextStyle(color: Colors.white,
            //                          fontSize: 8,
            //                          height: 1.0),),
            //                  ),
            //                ),
            //              SvgPicture.asset(
            //                'assets/icons/lingdang.svg', width: 22, height: 22,),
            //            ]),
            //
            //            //
            //          );
            //        })
            //    ),
            //  ],
          ),

        ),
        // ),
        body: GetBuilder<StartLogic>(builder: (logic) {
          return state.topTabController == null
              ? const Text('loading')
              // : Container(color: const Color(0xfff5f5f5),child:
              : Container(color: const Color(0xffffffff),child:
          // !userLogic.checkUserLogin()?ExtendedTabBarView(
          //   controller: state.topTabController,
          //   physics: NeverScrollableScrollPhysics(),
          //   children: [
          //
          //     Center(child: ListViewWidget()),
          //     Center(child: TopicxqpagePage()),
          //     Center(
          //         child: StartDetailPage(
          //           type: ApiType.loction,
          //           parameter: '',
          //           lasting:false,
          //         ))
          //
          //   ],
          // ):ExtendedTabBarView(
          //   controller: state.topTabController,
          //   children: [
          //
          //     Center(child: ListViewWidget()),
          //     Center(child: TopicxqpagePage()),
          //     Center(
          //         child: StartDetailPage(
          //           type: ApiType.loction,
          //           parameter: '',
          //           lasting:false,
          //         ))
          //
          //   ],
          // )
          Column(children: [
            Expanded(child:
            // TabBarView(
            //   controller: state.topTabController,
            //   //physics: !userLogic.checkUserLogin()?NeverScrollableScrollPhysics():ScrollPhysics(),
            //   children: [
            //
            //     Center(child: ListViewWidget()),
            //     // Center(child: TopicxqpagePage()),
            //     // Center(
            //     //     child: StartDetailPage(
            //     //       type: ApiType.loction,
            //     //       parameter: '',
            //     //       lasting:false,
            //     //     ))
            //   ],
            // ),
            ListViewWidget()
            )
          ],),);
        }));
  }
}
