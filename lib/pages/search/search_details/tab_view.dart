import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/user/login/view.dart';

import '../../../common/controller/UserLogic.dart';
import '../../../models/SearchUser.dart';
import '../../../services/search.dart';
import '../../../ulits/hex_color.dart';
import '../../detail/share/share.dart';
import '../../home/start/detail_view/view.dart';
import 'logic.dart';
class SearchTabView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchTabViewState();
  SearchProvider provider = Get.put(SearchProvider());
}
enum SearchDetails { loading, noData, init, normal, empty }

class _SearchTabViewState extends State<SearchTabView>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
//实例化

  final userController = Get.find<UserLogic>();
  final logic = Get.put(SearchDetailsLogic());
  final List<Tab> myTabs = <Tab>[
    Tab(text: '所有'.tr),
    Tab(text: '用户'.tr),
  ];
  final state = Get
      .find<SearchDetailsLogic>()
      .state;

  // SearchDetails status = SearchDetails.init;
  //ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
      //初始化controller并添加监听
      tabController = TabController(vsync: this,length: 2);
      tabController.addListener(() {
        if(tabController.index == tabController.animation?.value){
          print(tabController.index);
          // setState((){
          //   //state.keywords='12';
          // });
        }
      });
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels >
    //       _scrollController.position.maxScrollExtent - 50) {
    //     //达到最大滚动位置
    //     print('__________________________________');
    //     print('8888888888888888888888888888');
    //     Users();
    //   }
    // });
  }


  // ///用户接口
  // Future<void> Users() async {
  //   if (status == SearchDetails.loading) {
  //     // 防止重复请求
  //     return;
  //   }
  //   status = SearchDetails.loading;
  //   state.page++;
  //   var result = await widget.provider.Searchcontent(
  //       state.keywords, '2', state.page.toString());
  //
  //   // 延迟1秒请求，防止速率过快
  //   Future.delayed(Duration(milliseconds: 1000), () {
  //     status = SearchDetails.normal;
  //   });
  //   setState(() {
  //     state.UserContent.addAll(SearchUserFromJson(result?.bodyString ?? ""));
  //     logic.update();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      child: Column(
        children: [
          Container(
            child: TabBar(
              tabs: myTabs,
              labelPadding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
              indicatorPadding: EdgeInsets.fromLTRB(0, 0, 0, 8),
              isScrollable: true,
              indicatorColor: HexColor('#000000'),
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.label,
              labelColor: HexColor('#000000'),
              labelStyle: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelColor: HexColor('#999999'),
              unselectedLabelStyle: TextStyle(
                fontSize: 17,
                //fontFamily: 'PingFang SC-Regular',
              ),
              controller: tabController,
            ),
          ),
          Divider(height: 1.0, color: HexColor('#F1F1F1'),),
          Expanded(
              flex: 1,
              child: TabBarView(
                 controller: tabController,
                  children: [
                    GetBuilder<SearchDetailsLogic>(builder: (logic) {
                      return Container(
                        //color: Colors.black12,
                        child:worksList(),
                      );
                    }),
                    Container(
                      //               //color: Colors.black12,
                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: GetBuilder<SearchDetailsLogic>(builder: (logic) {
                          return RefreshIndicator(
                              onRefresh: _onRefresh,
                              child:UserList()
                              // ListView.builder(
                              //     controller: _scrollController,
                              //     itemCount: state.UserContent.length,
                              //     itemBuilder: (context, i) {
                              //       return
                              //         Container(
                              //         margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
                              //         child: Row(
                              //           mainAxisAlignment: MainAxisAlignment
                              //               .spaceBetween,
                              //           children: [
                              //             Container(
                              //                 width: 37,
                              //                 height: 37,
                              //                 decoration: BoxDecoration(
                              //                   borderRadius: BorderRadius
                              //                       .circular(100),
                              //                   image: DecorationImage(
                              //                     fit: BoxFit.cover,
                              //                     image: NetworkImage(
                              //                         state.UserContent[i]
                              //                             .userAvatar),
                              //                   ),
                              //                 )
                              //             ),
                              //
                              //             SizedBox(width: 15,),
                              //             Expanded(
                              //               flex: 1,
                              //               child: Column(
                              //                 crossAxisAlignment: CrossAxisAlignment
                              //                     .start,
                              //                 children: [
                              //                   Text(
                              //                     state.UserContent[i].userName,
                              //                     style: TextStyle(
                              //                       fontSize: 15,
                              //                       color: HexColor('#000000'),
                              //                       fontFamily: 'PingFang SC-Regular',
                              //                     ),),
                              //                   SizedBox(height: 10,),
                              //                   Row(
                              //                     children: [
                              //                       Text(
                              //                         '作品'.tr, style: TextStyle(
                              //                         fontSize: 12,
                              //                         color: HexColor(
                              //                             '#999999'),
                              //                         fontFamily: 'PingFang SC-Regular',
                              //                       ),),
                              //                       SizedBox(width: 5,),
                              //                       Text(
                              //                         state.UserContent[i].works
                              //                             .toString(),
                              //                         style: TextStyle(
                              //                           fontSize: 12,
                              //                           color: HexColor(
                              //                               '#999999'),
                              //                           fontFamily: 'PingFang SC-Regular',
                              //                         ),),
                              //                       SizedBox(width: 10,),
                              //                       SizedBox(
                              //                         width: 1,
                              //                         height: 14,
                              //                         child: DecoratedBox(
                              //                           decoration: BoxDecoration(
                              //                               color: HexColor(
                              //                                   '#999999')),
                              //                         ),
                              //                       ),
                              //                       SizedBox(width: 10,),
                              //                       Text(
                              //                         '粉丝'.tr, style: TextStyle(
                              //                         fontSize: 12,
                              //                         color: HexColor(
                              //                             '#999999'),
                              //                         fontFamily: 'PingFang SC-Regular',
                              //                       ),),
                              //                       SizedBox(width: 5,),
                              //                       Text(
                              //                         state.UserContent[i].fans
                              //                             .toString(),
                              //                         style: TextStyle(
                              //                           fontSize: 12,
                              //                           color: HexColor(
                              //                               '#999999'),
                              //                           fontFamily: 'PingFang SC-Regular',
                              //                         ),),
                              //                     ],
                              //                   )
                              //                 ],
                              //               ),
                              //             ),
                              //             SizedBox(width: 15,),
                              //             !userController.getFollow(
                              //                 state.UserContent[i].userId) ?
                              //             GestureDetector(child: Container(
                              //               padding: EdgeInsets.fromLTRB(
                              //                   24, 8, 24, 8),
                              //               child: Text('关注'.tr,
                              //                 style: TextStyle(
                              //                     color: Colors.white,
                              //                     fontSize: 15),),
                              //               decoration: BoxDecoration(
                              //                 //     //设置四周圆角 角度
                              //                 borderRadius: BorderRadius.all(
                              //                     Radius.circular(30.0)),
                              //                 border: Border.all(
                              //                     color: HexColor('#3E9900'),
                              //                     width: 1),
                              //                 color: HexColor('#3E9900'),
                              //               ),
                              //               //
                              //             ), onTap: () {
                              //               //关注
                              //               userController.setFollow(
                              //                   state.UserContent[i].userId);
                              //               logic.update();
                              //             },) :
                              //             GestureDetector(child: Container(
                              //               padding: EdgeInsets.fromLTRB(
                              //                   24, 8, 24, 8),
                              //               child: Text('已关注'.tr,
                              //                 style: TextStyle(
                              //                     color: HexColor('#999999'),
                              //                     fontSize: 15),),
                              //               decoration: BoxDecoration(
                              //                 //     //设置四周圆角 角度
                              //                 borderRadius: BorderRadius.all(
                              //                     Radius.circular(30.0)),
                              //                 border: Border.all(
                              //                     color: HexColor('#E4E4E4'),
                              //                     width: 1),
                              //               ),
                              //               //
                              //             ), onTap: () {
                              //               //取消关注
                              //               userController.setFollow(
                              //                   state.UserContent[i].userId);
                              //               logic.update();
                              //             },)
                              //           ],
                              //         ),
                              //       );
                              //     }
                              // )
                          );
                        })
                    )
                  ]))
        ],
      ),
      length: 2,
    );
    // 1. 使用 DefaultTabController 作为外层控制器
    return DefaultTabController(
      length: myTabs.length, // 定义tab数量
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(tabs: myTabs // 定义TabWeight,若数量和定义不一致会报错
          ),
        ),
        // 3. 使用 TabBarView
        body: TabBarView(children: <Widget>[

          /// 全部订单
          Center(child: Text('全部订222单')),

          /// 已完成订单
          Center(child: Text('已完成')),

          /// 未完成订单
          Center(child: Text('未完成'))
        ]),
      ),
    );
  }



  Future<void> _onRefresh() async {
    // await Future.delayed(Duration(seconds: 1), () {
    //   logic.FocusInterfaces();
    // });
  }
}

//作品列表缓存
class worksList extends StatefulWidget {
  // final String title;

  // worksList({Key key, this.title}): super(key: key);

  @override
  worksListState createState() => worksListState();
}
class worksListState extends State<worksList> with AutomaticKeepAliveClientMixin {
  final statetwo = Get
      .find<SearchDetailsLogic>()
      .state;
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      //color: Colors.black12,
      child: StartDetailPage(type: ApiType.search, parameter: statetwo.keywords, key: childKey,lasting:false),
    );
  }
}

//用户列表缓存


class UserList extends StatefulWidget {
  // final String title;

  // UserList({Key key, this.title}): super(key: key);

  @override
  UserListState createState() => UserListState();
  SearchProvider provideruser = Get.put(SearchProvider());
}
class UserListState extends State<UserList> with AutomaticKeepAliveClientMixin {




  final stateUser = Get
      .find<SearchDetailsLogic>()
      .state;
  final userControlleruser = Get.find<UserLogic>();
  final logicuser = Get.put(SearchDetailsLogic());
  @override
  bool get wantKeepAlive => true;
  SearchDetails status = SearchDetails.init;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    //初始化controller并添加监听
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置

        Users();
      }
    });
  }


  ///用户接口
  Future<void> Users() async {
    if (status == SearchDetails.loading) {
      // 防止重复请求
      return;
    }
    status = SearchDetails.loading;
    stateUser.page++;
    var result = await widget.provideruser.Searchcontent(
        stateUser.keywords, '2', stateUser.page.toString());

    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 1000), () {
      status = SearchDetails.normal;
    });
    if(SearchUserFromJson(result?.bodyString ?? "").length==0){
      stateUser.page--;
    }
    setState(() {
      stateUser.UserContent.addAll(SearchUserFromJson(result?.bodyString ?? ""));
      logicuser.update();
    });
  }
  @override
  void dispose() {
    super.dispose();
    stateUser.page = 1;
    logicuser.update();
    _scrollController.dispose();
  }



  @override
  Widget build(BuildContext context) {
    super.build(context);
    return stateUser.oneData?StartDetailLoading():stateUser.UserContent.length>0?
    ListView.builder(
        controller: _scrollController,
        itemCount: stateUser.UserContent.length,
        itemBuilder: (context, i) {
          return
            GestureDetector(child: Container(
              margin: EdgeInsets.fromLTRB(0, 25, 0, 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween,
                children: [
                  Container(
                      width: 37,
                      height: 37,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius
                            .circular(100),
                        border: Border.all(width: 1,color: Color(0xfff5f5f5),),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              stateUser.UserContent[i]
                                  .userAvatar),
                        ),
                      )
                  ),

                  SizedBox(width: 15,),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment
                          .start,
                      children: [
                        Text(
                          stateUser.UserContent[i].userName,
                          style: TextStyle(
                            fontSize: 15,
                            color: HexColor('#000000'),
                          ),),
                        SizedBox(height: 10,),
                        Row(
                          children: [
                            Text(
                              '作品'.tr, style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                  '#999999'),
                            ),),
                            SizedBox(width: 5,),
                            Text(
                              stateUser.UserContent[i].works
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                    '#999999'),
                              ),),
                            SizedBox(width: 10,),
                            SizedBox(
                              width: 1,
                              height: 14,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                    color: HexColor(
                                        '#e4e4e4')),
                              ),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              '粉丝'.tr, style: TextStyle(
                              fontSize: 12,
                              color: HexColor(
                                  '#999999'),
                            ),),
                            SizedBox(width: 5,),
                            Text(
                              stateUser.UserContent[i].fans
                                  .toString(),
                              style: TextStyle(
                                fontSize: 12,
                                color: HexColor(
                                    '#999999'),
                              ),),
                          ],
                        )
                      ],
                    ),
                  ),
                  SizedBox(width: 15,),
                  !userControlleruser.getFollow(
                      stateUser.UserContent[i].userId) ?
                  GestureDetector(child: Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 6, 20, 6),
                    child: Text('关注'.tr,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 15),),
                    decoration: BoxDecoration(
                      //     //设置四周圆角 角度
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0)),
                      border: Border.all(
                          color: HexColor('#000000'),
                          width: 1),
                      color: HexColor('#000000'),
                    ),
                    //
                  ), onTap: () {
                    //关注
                    userControlleruser.setFollow(
                        stateUser.UserContent[i].userId);
                    logicuser.update();
                  },) :
                  GestureDetector(child: Container(
                    padding: EdgeInsets.fromLTRB(
                        20, 6, 20, 6),
                    child: Text('已关注'.tr,
                      style: TextStyle(
                          color: HexColor('#999999'),
                          fontWeight: FontWeight.w600,
                          fontSize: 15),),
                    decoration: BoxDecoration(
                      //     //设置四周圆角 角度
                      borderRadius: BorderRadius.all(
                          Radius.circular(30.0)),
                      border: Border.all(
                          color: HexColor('#E4E4E4'),
                          width: 1),
                    ),
                    //
                  ), onTap: () {
                    //取消关注
                    userControlleruser.setFollow(
                        stateUser.UserContent[i].userId);
                    logicuser.update();
                  },)
                ],
              ),
            ),onTap: (){
              Get.toNamed('/public/user',
                  arguments: stateUser.UserContent[i].userId);
            },);
        }
    ):Container(
      width: double.infinity,
      // decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red),),
      child:Column(
      children: [
        SizedBox(height: 120,),
        Image.asset('assets/images/nobeijing.png',width: 200,height: 200,),
        SizedBox(height: 40,),
        Text('暂无搜索结果'.tr,style: TextStyle(
          fontSize: 16,
          color: Color(0xff999999)
        ),),
      ],
    ),);

  }
}