import 'dart:convert';

import 'package:card_swiper/card_swiper.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/ChannelList.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:reorderables/reorderables.dart';

import '../../../../../ulits/hex_color.dart';
import '../detail_view/view.dart';
import 'list_logic.dart';

/**
 * 组件负责渲染频道的tabview
 */

class ListViewWidget extends StatefulWidget {
  @override
  createState() => ListViewState();
}

class ListViewState extends State<ListViewWidget> with TickerProviderStateMixin{
  late TabController channelTabController;
  final logic = Get.find<StartListLogic>();
  final userLogic = Get.find<UserLogic>();// 是否正在请求接口
  final contentProvider = Get.find<ContentProvider>();
  bool isedit=false;
  bool uparrow=true;
  bool antishake=true;
  ///选择数组
  var Selecteddata=[];
  ///未选择数组
  var notselectedata=[];
  ///当前tab
  int currentindex=0;

  var henglist;
  //late TabController tabController;
  @override
  void initState() {
    ///获取频道列表
    channellist();
    channelTabController = TabController(length: Selecteddata.length, vsync: this);
    // channelTabController = TabController(length: 9, vsync: this)
    //   ..addListener(() async {
    //     // or (tabController.indexIsChanging)
    //     if (!channelTabController.indexIsChanging) {
    //       if (!logic.state.switchlist.contains(channelTabController.index)) {
    //         if (logic.state.switchlist.length < 3) {
    //           logic.state.switchlist.add(channelTabController.index);
    //         } else {
    //           logic.state.switchlist.removeAt(0);
    //           logic.state.switchlist.add(channelTabController.index);
    //         }
    //       }
    //       logic.update();
    //       print("监听切换tab ${logic.state.channelTabController.index} "); // 打印索引
    //       // print(logic.state.channelDataSource[logic.state.channelTabController.index].id);
    //       await FirebaseAnalytics.instance.logEvent(
    //         name: "select_channel",
    //         parameters: {
    //           "name": logic.state.channelDataSource[channelTabController.index].name,
    //           "id": logic.state.channelDataSource[channelTabController.index].id,
    //         },
    //       );
    //     }
    //   });
  }

  channellist() async {
    var res =await contentProvider.userChannellist();
    if(res.statusCode==200){

      channelTabController = TabController(vsync: this, length: res.body['selected_channel']!.length)..addListener(() async {

          // or (tabController.indexIsChanging)
          currentindex=channelTabController.index;
          uparrow=true;
          if (!logic.state.switchlist.contains(channelTabController.index)) {
            if (logic.state.switchlist.length < 3) {
              logic.state.switchlist.add(channelTabController.index);
            } else {
              logic.state.switchlist.removeAt(0);
              logic.state.switchlist.add(channelTabController.index);
            }
          }
          logic.update();
          await FirebaseAnalytics.instance.logEvent(
            name: "select_channel",
            parameters: {
              "name": logic.state.channelDataSource[channelTabController.index].name,
              "id": logic.state.channelDataSource[channelTabController.index].id,
            },
          );

      });
      Selecteddata=res.body['selected_channel'];
      // henglist=[
      //   for(var i=0;i<Selecteddata.length;i++)
      // GestureDetector(child: Stack(clipBehavior: Clip.none,children: [
      //   Container(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),child: Text(Selecteddata[i]['name'],style: TextStyle(color: Selecteddata[i]['id']!=0?Color.fromRGBO(102, 102, 102, 1): Color.fromRGBO(28, 28, 28, 1),height: 1),),decoration: BoxDecoration(color: Selecteddata[i]['id']!=0?Colors.white:Color.fromRGBO(249, 249, 249, 1,),borderRadius: BorderRadius.circular(5),border: Border.all(width: 1,color: Selecteddata[i]['id']!=0?Color.fromRGBO(228, 228, 228, 1):Color.fromRGBO(249, 249, 249, 1,)),)),
      //   if(isedit&&Selecteddata[i]['id']!=0)Positioned(right: -25/2.2,top:-25/2.2,child: GestureDetector(child:Container(alignment: Alignment.center,width: 25,height: 25,child: Image.asset('assets/images/chathree.png',width: 15,height: 15,),),onTap: (){
      //     if(isedit&&Selecteddata.length>3){
      //       notselectedata=[...notselectedata,Selecteddata[i]];
      //       Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
      //       setState(() {
      //
      //       });
      //     }else if(isedit&&Selecteddata.length<=3){
      //       ToastInfo('频道不能再少了');
      //     }
      //   },))
      // ],),onTap: () async {
      //   if(isedit && Selecteddata.length>3 && isedit&&Selecteddata[i]['id']!=0){
      //     notselectedata=[...notselectedata,Selecteddata[i]];
      //     Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
      //     setState(() {
      //
      //     });
      //   }else if(isedit&&Selecteddata.length<=3 && isedit&&Selecteddata[i]['id']!=0){
      //     ToastInfo('频道不能再少了');
      //   }
      //   if(!isedit){
      //     uparrow=!uparrow;
      //     // print('i是什么${i}');
      //     await updatepd(Selecteddata,i);
      //     // setState(() {
      //     //
      //     // });
      //
      //   }
      // },),];
      logic.state.channelDataSource = channelListFromJson(jsonEncode(res.body['selected_channel']) );
      notselectedata=res.body['unselected_channel'];

      setState(() {

      });
    }
  }

  void dispose() {
    // 在小部件被销毁时记得释放控制器
    channelTabController.dispose();
    super.dispose();
  }


  ///修改频道
  updatepd(user_channel,i) async {
    isedit=false;
    if(antishake){
      antishake=false;
      var newuser_channel = user_channel.map((data) => data['id']).toList();
      var res=await contentProvider.userChannel(jsonEncode(newuser_channel));
      if(res.statusCode==200){
        await channellist();
        channelTabController.animateTo(i);
      }
      antishake=true;
    }

  }
  void _onReorder(int oldIndex, int newIndex) {
    if(oldIndex!=0&&newIndex!=0){
      var row = Selecteddata.removeAt(oldIndex);
      Selecteddata.insert(newIndex, row);
      setState(() {

      });
    }

  }

  ///

  @override
  Widget build(BuildContext context) {
    return Selecteddata.isEmpty
        ? StartDetailLoading()
        : Column(
        children: [
          Container(
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.05),
                      //color:Colors.black,
                      offset: Offset(0.0, 1), //阴影xy轴偏移量
                      blurRadius: 1, //阴影模糊程度
                      spreadRadius: 0 //阴影扩散程度
                  )
                ]
            ),
            child: Row(
              children: [
                Expanded(
                    child: uparrow?ShaderMask(
                      shaderCallback: (rect) {
                        return const LinearGradient(
                          begin: Alignment.centerRight,
                          end: Alignment.center,
                          colors: [Colors.black, Colors.transparent],
                        ).createShader(const Rect.fromLTRB(0, 0, 20, 0));
                      },
                      blendMode: BlendMode.dstIn,
                      child: GetBuilder<StartListLogic>(builder: (logic) {
                        return Selecteddata.isEmpty
                            ? GestureDetector(child: const Icon(Icons.downloading),onTap: (){
                              logic.initChannelData();
                            },) : TabBar(
                          // indicatorWeight: 3,
                          // indicatorColor: HexColor('D4FB50'),
                          dividerColor: Colors.transparent,
                          indicator: CustomUnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4,
                                color: HexColor('#D1FF34'),
                              )
                          ),
                          isScrollable: true,
                          labelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'DroidArabicKufi',
                          ),
                          labelColor: Colors.black,
                          unselectedLabelStyle: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'DroidArabicKufi',
                          ),
                          unselectedLabelColor: HexColor('CCCCCC'),
                          controller: channelTabController,
                          ///关闭登录验证
                          onTap: (index){
                            // print('频道点击${logic.state.channelDataSource[index].id}');
                            FirebaseAnalytics.instance.logEvent(
                              name: "Channel_click",
                              parameters: {
                                'ChannelId':logic.state.channelDataSource[index].id,
                                'userId':userLogic.userId,
                                'deviceId':userLogic.deviceId,
                              },
                            );
                            // if (!userLogic.checkUserLogin()) {
                            //   logic.state.channelTabController.index = logic.state.channelTabController.previousIndex;
                            //   Get.toNamed('/public/loginmethod');
                            //   return;
                            // }
                          },
                          tabs: Selecteddata
                              .map((item) => Tab(text: item['name']))
                              .toList(),
                        );
                      }),
                    ):Row(children: [const SizedBox(width: 15,),Text('我的频道'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),const SizedBox(width: 10,),Text('点击进入频道'.tr,style: const TextStyle(fontSize: 12,color: Color.fromRGBO(153, 153, 153, 1)),)],)),
                ///编辑按钮
                if(!uparrow)GestureDetector(
                  onTap: (){
                    isedit=!isedit;
                    setState(() {});
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),color: const Color.fromRGBO(249, 249, 249, 1)),
                    child:Text(!isedit?'进入编辑'.tr:'完成编辑'.tr,style: const TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color.fromRGBO(0, 54, 107, 1),height: 1),),
                  ),
                ),
                const SizedBox(width: 5,),
                ///下拉按钮
                GestureDetector(
                  onTap: (){
                    setState(() {
                      uparrow=!uparrow;
                    });
                    // // ToastInfo('没有更多了'.tr);
                    if(uparrow){
                      updatepd(Selecteddata,currentindex);
                      setState(() {

                      });
                    }
                    // else{
                    //   setState(() {
                    //
                    //   });
                    // }
                    //

                  },
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Icon(
                      uparrow?Icons.expand_more:Icons.expand_less,
                      color: const Color.fromRGBO(153, 153, 153, 1),
                      size: 28,
                    ),
                    width: 40,
                  ),
                ),
              ],
            ),
          ),
          // Expanded(flex: 1,child:NestedScrollView(
          //     headerSliverBuilder: (contex, _) {
          //       return [
          //         //sliver
          //         SliverToBoxAdapter(
          //           child:
          //           Container(
          //             height: 260,
          //             width: 100,
          //             decoration: BoxDecoration(color: Colors.red,),
          //
          //           ),
          //         ),
          //       ];
          //     },
          //     body:GetBuilder<StartListLogic>(builder: (logic) {
          //       return logic.state.channelDataSource.length == 0
          //           ? Text('')
          //           : Expanded(
          //           child: ExtendedTabBarView(
          //             controller: logic.state.channelTabController,
          //             children: logic.state.channelDataSource
          //                 .map((item) => StartDetailPage(type: ApiType.home, parameter: item.id.toString(),))
          //                 .toList(),
          //           ));
          //     }),
          //   // Center(
          //   //     child: StartDetailPage(
          //   //       type: ApiType.loction,
          //   //       parameter: '',
          //   //     ))
          // ),),


          // Expanded(flex: 1,child:
          //     // Container(child:,height: 500,),
          // ListView(scrollDirection: Axis.vertical,
          //
          //     children:[
          //       Container(height: 100,width: 100,color: Colors.green,),
          //       ListView.builder(
          //           itemCount: 1,
          //
          //           itemBuilder: (context, i) {
          //             return  Container(height: 2000,child:
          //             GetBuilder<StartListLogic>(builder: (logic) {
          //               return logic.state.channelDataSource.length == 0
          //                   ? Text('')
          //                   : Expanded(
          //                   child: ExtendedTabBarView(
          //                     controller: logic.state.channelTabController,
          //                     children: logic.state.channelDataSource
          //                         .map((item) => StartDetailPage(type: ApiType.home, parameter: item.id.toString(),))
          //                         .toList(),
          //                   ));
          //             }),)
          //             ;}
          //       )])
          // ),


          GetBuilder<StartListLogic>(builder: (logic) {
            return Selecteddata.isEmpty
                ? const Text('')
                : Expanded(
                  child: Stack(children: [
                    if(uparrow)TabBarView(
                      controller: channelTabController,
                      //physics: !userLogic.checkUserLogin()?NeverScrollableScrollPhysics():ScrollPhysics(),
                      children: Selecteddata
                          .asMap()
                          .keys
                          .
                      map((index) {
                        return GetBuilder<StartListLogic>(builder: (logic) {
                          return StartDetailPage(type: ApiType.home,
                              parameter: Selecteddata[index]['id']
                                  .toString(),
                              lasting: logic.state.switchlist.contains(index));
                        });
                      }).toList(),
                    ),
                    if(!uparrow)Positioned(top: 0,left: 0,right: 0,bottom:0,

                        child: GestureDetector(child: Container(color: const Color.fromRGBO(0, 0, 0, 0.5,),child:Column(children: [
                          GestureDetector(
                            child: Container(padding:const EdgeInsets.all(15),width: double.infinity,color: Colors.white,child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                            // Wrap(
                            //   spacing: 15.0, // 子组件之间的水平间距
                            //   runSpacing: 15.0, // 子组件之间的垂直间距
                            //   children: <Widget>[
                            //     // 在这里添加子组件
                            //
                            //     // GestureDetector(child: Container(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),child: Text('推荐'.tr,style: TextStyle(color: Color.fromRGBO(28, 28, 28, 1),height: 1),),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(249, 249, 249, 1,),border: Border.all(width: 1,color: Color.fromRGBO(249, 249, 249, 1,)))),onTap: (){
                            //     //   // uparrow=!uparrow;
                            //     //   setState(() {
                            //     //
                            //     //   });
                            //     // },),
                            //     // GestureDetector(child: Container(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),child: Text('附近'.tr,style: TextStyle(color: Color.fromRGBO(28, 28, 28, 1),height: 1),),decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),color: Color.fromRGBO(249, 249, 249, 1,),border: Border.all(width: 1,color: Color.fromRGBO(249, 249, 249, 1,)))),onTap: (){
                            //     //   uparrow=!uparrow;
                            //     //   setState(() {
                            //     //
                            //     //   });
                            //     // },),
                            //     for(var i=0;i<Selecteddata.length;i++)
                            //       GestureDetector(child: Stack(clipBehavior: Clip.none,children: [
                            //         Container(padding: EdgeInsets.fromLTRB(20, 10, 20, 10),child: Text(Selecteddata[i]['name'],style: TextStyle(color: Selecteddata[i]['id']!=0?Color.fromRGBO(102, 102, 102, 1): Color.fromRGBO(28, 28, 28, 1),height: 1),),decoration: BoxDecoration(color: Selecteddata[i]['id']!=0?Colors.white:Color.fromRGBO(249, 249, 249, 1,),borderRadius: BorderRadius.circular(5),border: Border.all(width: 1,color: Selecteddata[i]['id']!=0?Color.fromRGBO(228, 228, 228, 1):Color.fromRGBO(249, 249, 249, 1,)),)),
                            //         if(isedit&&Selecteddata[i]['id']!=0)Positioned(right: -25/2.2,top:-25/2.2,child: GestureDetector(child:Container(alignment: Alignment.center,width: 25,height: 25,child: Image.asset('assets/images/chathree.png',width: 15,height: 15,),),onTap: (){
                            //           if(isedit&&Selecteddata.length>3){
                            //             notselectedata=[...notselectedata,Selecteddata[i]];
                            //             Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
                            //             setState(() {
                            //
                            //             });
                            //           }else if(isedit&&Selecteddata.length<=3){
                            //             ToastInfo('频道不能再少了');
                            //           }
                            //         },))
                            //       ],),onTap: () async {
                            //         if(isedit && Selecteddata.length>3 && isedit&&Selecteddata[i]['id']!=0){
                            //           notselectedata=[...notselectedata,Selecteddata[i]];
                            //           Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
                            //           setState(() {
                            //
                            //           });
                            //         }else if(isedit&&Selecteddata.length<=3 && isedit&&Selecteddata[i]['id']!=0){
                            //           ToastInfo('频道不能再少了');
                            //         }
                            //         if(!isedit){
                            //           uparrow=!uparrow;
                            //           // print('i是什么${i}');
                            //           await updatepd(Selecteddata,i);
                            //           // setState(() {
                            //           //
                            //           // });
                            //
                            //         }
                            //       },),
                            //     // ...
                            //   ],
                            // ),

                            ReorderableWrap(
                                    spacing: 15,
                                    runSpacing: 15,
                                    // padding: const EdgeInsets.all(8),
                                    children:
                                    [
                                      for(var i=0;i<Selecteddata.length;i++)
                                        GestureDetector(child: Stack(clipBehavior: Clip.none,children: [
                                          Container(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),child: Text(Selecteddata[i]['name'],style: TextStyle(color: Selecteddata[i]['id']!=0?const Color.fromRGBO(102, 102, 102, 1): const Color.fromRGBO(28, 28, 28, 1),height: 1),),decoration: BoxDecoration(color: Selecteddata[i]['id']!=0?Colors.white:const Color.fromRGBO(249, 249, 249, 1,),borderRadius: BorderRadius.circular(5),border: Border.all(width: 1,color: Selecteddata[i]['id']!=0?const Color.fromRGBO(228, 228, 228, 1):const Color.fromRGBO(249, 249, 249, 1,)),)),
                                          if(isedit&&Selecteddata[i]['id']!=0)Positioned(right: -25/2.2,top:-25/2.2,child: GestureDetector(child:Container(alignment: Alignment.center,width: 25,height: 25,child: Image.asset('assets/images/chathree.png',width: 15,height: 15,),),onTap: (){
                                            if(isedit&&Selecteddata.length>3){
                                              notselectedata=[...notselectedata,Selecteddata[i]];
                                              Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
                                              setState(() {

                                              });
                                            }else if(isedit&&Selecteddata.length<=3){
                                              ToastInfo('频道不能再少了'.tr);
                                            }
                                          },))
                                        ],),onTap: () async {
                                          if(isedit && Selecteddata.length>3 && isedit&&Selecteddata[i]['id']!=0){
                                            notselectedata=[...notselectedata,Selecteddata[i]];
                                            Selecteddata.removeWhere((element) => element['id'] == Selecteddata[i]['id']);
                                            setState(() {

                                            });
                                          }else if(isedit&&Selecteddata.length<=3 && isedit&&Selecteddata[i]['id']!=0){
                                            ToastInfo('频道不能再少了'.tr);
                                          }
                                          if(!isedit){

                                            // print('i是什么${i}');
                                            await updatepd(Selecteddata,i);
                                            // setState(() {
                                            //
                                            // });

                                          }
                                        },),
                                    ],
                                    onReorder: _onReorder,
                                    onNoReorder: (int index) {
                                      //this callback is optional
                                    },
                                    onReorderStarted: (int index) {
                                      //this callback is optional

                                    }
                                ),

                            const SizedBox(height: 60,),
                            Row(children: [Text('其他频道'.tr,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),const SizedBox(width: 15,),Text('点击添加频道'.tr,style: const TextStyle(fontSize: 12,color: Color.fromRGBO(153, 153, 153, 1)),)],),
                            const SizedBox(height: 15,),
                            Wrap(
                              spacing: 15.0, // 子组件之间的水平间距
                              runSpacing: 15.0, // 子组件之间的垂直间距
                              children: <Widget>[
                                // 在这里添加子组件
                                for(var i=0; i<notselectedata.length;i++)
                                  GestureDetector(child: Container(padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                      child: Wrap(children: [Container(alignment: Alignment.center,width: 14,height: 14,child: Image.asset('assets/images/jiahao.png',width: 11,height: 11,),),const SizedBox(width: 3,),Text('${notselectedata[i]['name']}',style: const TextStyle(color: Color.fromRGBO(102, 102, 102, 1),height: 1),),],),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5),border: Border.all(width: 1,color: const Color.fromRGBO(228, 228, 228, 1)),)
                                  ),onTap: (){
                                    Selecteddata=[...Selecteddata,notselectedata[i]];
                                    notselectedata.removeWhere((element) => element['id'] == notselectedata[i]['id']);
                                    setState(() {

                                    });
                                  },)

                                // ...
                              ],
                            ),
                            const SizedBox(height: 30,),
                          ],),),
                            onTap: (){},
                          )
                        ],),),
                          onTap: (){
                          uparrow=true;
                          updatepd(Selecteddata,currentindex);
                          // setState(() {
                          //
                          // });
                        },),

                    )
                  ],),
                );
          })

        ],
      );

    ///自定义更新弹窗
    // Positioned(
    //   left: 0,
    //   top: 0,
    //   right: 0,
    //   bottom: 0,
    //   child:
    //   Container(
    //     color: Colors.transparent,
    //     child:Column(
    //     mainAxisAlignment:MainAxisAlignment.center,
    //     children: [
    //       Container(width: MediaQuery.of(context).size.width-100,
    //           // height: 311,
    //           // decoration: BoxDecoration(
    //           //   image: DecorationImage(
    //           //     image: AssetImage('assets/images/gengxtc.png'),
    //           //     fit: BoxFit.fill, // 完全填充
    //           //   ),
    //           // ),
    //           child: Stack(children: [
    //             Image.asset('assets/images/gengxtc.png',width: MediaQuery.of(context).size.width-100,),
    //             Positioned(
    //               bottom: 0,
    //               child: Column(
    //                 children: [
    //                   Text('新版本优化啦，快来体验吧'),
    //                   Container(
    //                     alignment: Alignment.center,
    //                     padding: EdgeInsets.only(top: 12,bottom: 12),
    //                     width: MediaQuery.of(context).size.width-180,
    //                     margin: EdgeInsets.fromLTRB(40, 32, 40, 13),
    //                     decoration: BoxDecoration(
    //                       borderRadius: BorderRadius.circular(40),
    //                       color: Colors.black,
    //                       boxShadow: [
    //                         BoxShadow(
    //                           color: Color(0xFF55D200),
    //                           offset: Offset(0, 1),
    //                           blurRadius: 1,
    //                           spreadRadius: 0,
    //                         ),
    //                       ],
    //                     ),
    //
    //                     child: Text('立刻升级'.tr,style: TextStyle(color: Colors.white),),
    //                   ),
    //                   Text('以后再说'),
    //                   SizedBox(height: 18,),
    //                 ],
    //               ),
    //             )
    //           ],)
    //       )
    //     ],),)
    //   ,
    // )

  }


///app更新版本弹窗
}
