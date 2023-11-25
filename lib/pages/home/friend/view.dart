import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/pages/home/friend/ActivityZone.dart';
import 'package:lanla_flutter/pages/home/friend/ContentZoneList.dart';
import 'package:lanla_flutter/pages/home/friend/Planningpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/ConnectionStartViewPage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/Topicxqpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/newTopicXqPage.dart';
import 'package:lanla_flutter/pages/user/Loginmethod/view.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:share_plus/share_plus.dart';

import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/common/widgets/comment_list_diolog.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/followlist.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import '../../../ulits/image_cache.dart';
import '../start/detail_view/loading_widget.dart';
import 'package:video_player/video_player.dart';
import 'logic.dart';

enum FriendStateus { loading, noData, init, normal, empty }

class FriendPage extends StatefulWidget {
  @override
  createState() => _ListViewRefreshState();
  ContentProvider provider = Get.put(ContentProvider());
}

class _ListViewRefreshState extends State<FriendPage>with SingleTickerProviderStateMixin {

  final logic = Get.find<FriendLogic>();
  final userLogic = Get.find<UserLogic>();
  final state = Get.find<FriendLogic>().state;
  final WebSocketes = Get.find<StartDetailLogic>();
  late TabController channelTabController = TabController(length: 4, initialIndex: state.Initialselection,vsync: this);
  FriendStateus status = FriendStateus.init; // 正在加载
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  final ScrollController _scrollController = ScrollController(); //listview 的控制器
  @override
  void initState() {
    // 延迟1秒请求接口，防止渲染太多 引起卡顿
    Future.delayed(const Duration(milliseconds: 500), () {
      _fetch();
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置

        _fetch();
      }
    });
    super.initState();
  }

  /// 请求数据
  Future<void> _fetch() async {
    if (status == FriendStateus.loading) {
      // 防止重复请求
      return;
    }
    status = FriendStateus.loading;
    state.page++;
    logic.update();


    var result = await widget.provider.followlist(state.page.toString());

    // 延迟1秒请求，防止速率过快
    Future.delayed(const Duration(milliseconds: 1000), () {
      status = FriendStateus.normal;
    });
    if(result?.bodyString!='[]'){
      setState(() {
        state.followlist.addAll(homeDetailsFromJson(result?.bodyString ?? ""));
        logic.update();
      });
    }else{
      state.page--;
      logic.update();
    }
    setState(() {
      oneData = true;
    });

  }
  bool get wantKeepAlive => true; // 是否开启缓存
  @override
  void dispose() {
    super.dispose();
    state.followlist=[];
    state.page = 0;
    logic.update();
    _scrollController.dispose();
  }

  // 更新当前图片评论数
  updateCommentTotal(data) async {
    Future.delayed(const Duration(seconds: 1), () async {
      HomeDetails? newData = await widget.provider.Detail(data!.id);
      setState(() {
        data!.comments = newData!.comments;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          // title: Text('关注'.tr, style: TextStyle(fontSize: 20)),
          title: Row(children: [
            GestureDetector(
                onTap: () {
                  //关闭登录验证
                  if (userLogic.token != '') {
                    Get.to(const ConnectionStartPage());
                  } else {
                    Get.to(LoginmethodPage(), transition: Transition.downToUp);
                  }
                },
                child: Container(
                  child:
                  SvgPicture.asset(
                    'assets/icons/fuji.svg', width: 22, height: 22,),
                )
            ),
            const SizedBox(width: 15,),
            Expanded(child:
            Container(child: TabBar(
              ///取消指示器
              //  indicator: const BoxDecoration(),
              //
              //   //indicatorPadding: EdgeInsets.only(right: 10),
              //   ///分割线颜色
              //   dividerColor: Colors.transparent,
              //   ///指示器高度
              //   indicatorWeight: 1,
              //   ///指示器颜色
              //   indicatorColor: Colors.red,
              //   ///是否可以滚动
              //   isScrollable: true,
              //   ///选中字体样式
              //   labelStyle: TextStyle(
              //     fontSize: 14,
              //     fontWeight: FontWeight.w600,
              //     height: 1,
              //     fontFamily: 'DroidArabicKufi',
              //   ),
              //   ///选中颜色
              //   labelColor: Colors.black,
              //   ///未选中的选项卡文本的样式
              //   unselectedLabelStyle: TextStyle(
              //     fontSize: 14,
              //     height: 1,
              //     fontWeight: FontWeight.w400,
              //     fontFamily: 'DroidArabicKufi',
              //   ),
              //   ///未选中的选项卡文本的颜色
              //   unselectedLabelColor: HexColor('CCCCCC'),
                controller: channelTabController,
                //   //labelPadding: EdgeInsets.symmetric(horizontal: 0), // 设置左右间距为 16
                //   labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),

                labelColor: Colors.black,
                labelPadding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                isScrollable: true,
                indicator: CustomUnderlineTabIndicator(
                    borderSide: BorderSide(
                      width: 4,
                      color: HexColor('#D1FF34'),
                    )
                ),
                indicatorPadding: const EdgeInsets.only(bottom: 8),
                dividerColor: Colors.transparent,
                // labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                labelStyle: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'DroidArabicKufi',
                ),
                unselectedLabelColor: HexColor('CCCCCC'),
                unselectedLabelStyle:
                // const TextStyle(fontWeight: FontWeight.w400,fontSize: 15,),
                const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'DroidArabicKufi',
                ),
                ///关闭登录验证
                // onTap: (index){
                //   if (!userLogic.checkUserLogin()) {
                //     logic.state.channelTabController.index = logic.state.channelTabController.previousIndex;
                //     Get.toNamed('/public/loginmethod');
                //     return;
                //   }
                // },
                // tabs: logic.state.channelDataSource
                //     .map((item) => Tab(text: item.name))
                //     .toList(),
                tabs:[
                  // for(var i=0;i<4;i++)
                  //   i==0?Tab(child: Row(children: [Text('进行中'.tr),SizedBox(width: 10,),],),):
                  Tab(child: Row(children: [Text('关注'.tr),const SizedBox(width: 10,),],),),
                  Tab(child: Row(children: [Container(height: 14,width: 2,color: const Color(0x7Fffffff)),const SizedBox(width: 10,),Text('话题'.tr),const SizedBox(width: 10,),],),),
                  Tab(child: Row(children: [Container(height: 14,width: 2,color: const Color(0x7Fffffff)),const SizedBox(width: 10,),Text('内容专区'.tr),const SizedBox(width: 10,),],),),
                  Tab(child: Row(children: [Container(height: 14,width: 2,color: const Color(0x7Fffffff)),const SizedBox(width: 10,),Text('活动专区'.tr),const SizedBox(width: 10,),],),),
                  // Tab(child: Row(children: [Container(height: 14,width: 2,color: Color(0x7Fffffff)),SizedBox(width: 10,),Text('活动专区'.tr),SizedBox(width: 10,),],),),

                ]
            ),)
            ),
            const SizedBox(width: 15,),
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
            ),
          ],),
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          // actions: [
          //   // GestureDetector(
          //   //     onTap: () {
          //   //       if(userLogic.token!=''){
          //   //         if(!userLogic.Chatdisconnected){
          //   //           WebSocketes.WebSocketconnection();
          //   //         }
          //   //         Get.toNamed('/public/message');
          //   //       }else{
          //   //         Get.toNamed('/public/loginmethod');
          //   //       }
          //   //     },
          //   //     child:
          //   //     // Container(
          //   //     //   margin: const EdgeInsets.all(14),
          //   //     //   child:
          //   //     //   SvgPicture.asset('assets/icons/lingdang.svg',width: 22,height: 22,),
          //   //     //
          //   //     // )
          //   //     GetBuilder<UserLogic>(builder: (logic) {
          //   //       return Container(
          //   //           margin: const EdgeInsets.fromLTRB(16,0,0,6),
          //   //           child: Stack(clipBehavior: Clip.none, children: [
          //   //             if(userLogic.Chatrelated['${userLogic.userId}']!=null)
          //   //               if(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>0)Positioned(
          //   //                 top: -18 / 2,
          //   //                 right: -22 / 2,
          //   //                 child: Container(
          //   //                   alignment: Alignment.center,
          //   //                   decoration: BoxDecoration(
          //   //                       borderRadius: BorderRadius.all(
          //   //                           Radius.circular(50)),
          //   //                       color: Colors.red
          //   //                   ),
          //   //                   width: 16,
          //   //                   height: 16,
          //   //                   child: Text(userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']>99?'99':'${userLogic.NumberMessages+userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']}',
          //   //                     style: TextStyle(color: Colors.white,
          //   //                         fontSize: 8,
          //   //                         height: 1.0),),
          //   //                 ),
          //   //               ),
          //   //             if(userLogic.Chatrelated['${userLogic.userId}']==null)
          //   //               if(userLogic.NumberMessages>0)Positioned(
          //   //                 top: -18 / 2,
          //   //                 right: -22 / 2,
          //   //                 child: Container(
          //   //                   alignment: Alignment.center,
          //   //                   decoration: BoxDecoration(
          //   //                       borderRadius: BorderRadius.all(
          //   //                           Radius.circular(50)),
          //   //                       color: Colors.red
          //   //                   ),
          //   //                   width: 16,
          //   //                   height: 16,
          //   //                   child: Text(userLogic.NumberMessages.toString(),
          //   //                     style: TextStyle(color: Colors.white,
          //   //                         fontSize: 8,
          //   //                         height: 1.0),),
          //   //                 ),
          //   //               ),
          //   //             SvgPicture.asset(
          //   //               'assets/icons/lingdang.svg', width: 22, height: 22,),
          //   //           ]),
          //   //
          //   //           //
          //   //         );
          //   //     })
          //   //
          //   // ),
          //   // Text('123')
          //
          // ],
        ),
      ),
      body: !oneData
          ? StartDetailLoading()
          : Column(
        children: [
          Divider(
            height: 1.0,
            color: Colors.grey.shade200,
          ),
          Expanded(
              flex: 1,
              child:TabBarView( controller: channelTabController,children: [
                GetBuilder<FriendLogic>(builder: (logic) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    displacement: 10.0,
                    child:
                    state.followlist.isNotEmpty
                        ?  ListView.builder(
                        controller: _scrollController,
                        itemCount: state.followlist.length,
                        itemBuilder: (context, i) {
                          return Container(
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 20),
                                          GestureDetector(
                                            child: Container(
                                                width: 40,
                                                height: 40,
                                                clipBehavior:
                                                Clip.hardEdge,
                                                decoration:
                                                BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(50),
                                                ),
                                                child: CachedNetworkImage(
                                                  imageUrl: state.followlist[i].userAvatar,
                                                  placeholder: (context, url) => Image.asset('assets/images/txzhanwei.png'),
                                                  imageBuilder: (context, imageProvider) => Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                            ),
                                            onTap: () {
                                              Get.toNamed(
                                                  '/public/user',
                                                  arguments: state.followlist[i].userId);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          Container(constraints: const BoxConstraints(maxWidth: 150,),child: Text(
                                            state.followlist[i]
                                                .userName,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,

                                            style: const TextStyle(
                                              fontWeight:
                                              FontWeight.w600,
                                              fontSize: 13,
                                              //fontFamily: "PingFang SC",
                                            ),
                                          ),),
                                          const SizedBox(width: 12),
                                          Text(
                                            state.followlist[i].createdAt,
                                            style: const TextStyle(
                                              color: Color.fromRGBO(153, 153, 153, 1),
                                              fontWeight:
                                              FontWeight.w400,
                                              fontSize: 12,
                                              //fontFamily: "PingFang SC",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                        margin: const EdgeInsets.fromLTRB(20, 0, 15, 0),//pym_
                                        child: GestureDetector(
                                          child: Image.asset(
                                            'assets/images/gengduo.png',
                                            width: 20,
                                            height: 20,
                                          ),
                                          onTap: () {
                                            ReportDoglog(
                                                ReportType.content,
                                                state.followlist[i].id,state
                                                .followlist[i].videoPath!=''?2:1,state
                                                .followlist[i].videoPath!=''?state
                                                .followlist[i].videoPath:state
                                                .followlist[i].imagesPath,
                                                context,
                                                removeCallbak: () {
                                                  state.followlist
                                                      .removeAt(i);
                                                  logic.update();

                                                });
                                          },
                                        ))
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Stack(children: [
                                  //轮播图
                                  if(state.followlist[i].type == 2)_swiper(
                                      context,
                                      state.followlist[i].imagesPath.split(','),
                                      state.followlist[i].attaImageScale
                                  ),
                                  if(state.followlist[i].type == 1)_ButterFlyAssetVideo(data: state.followlist[i],),
                                  if(state.followlist[i].type == 3)CachedNetworkImage(
                                    imageUrl: state.followlist[i].thumbnail,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      width: MediaQuery.of(context).size.width,
                                      constraints: const BoxConstraints(minHeight: 100),
                                      child: const Center(
                                        child: CircularProgressIndicator(
                                          color: Color(0xffD1FF34),
                                          strokeWidth: 4,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 15,
                                      left: 10,
                                      child: state.followlist[i].type== 1
                                          ? const Icon(
                                        Icons.play_circle,
                                        color: Colors.white70,
                                        size: 22,
                                      )
                                          : Container()),
                                ],),
                                Offstage(
                                  offstage:
                                  state.followlist[i].type == 2,
                                  child: const SizedBox(
                                    height: 15,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          20, 0, 20, 0),//pym_
                                      child: Row(
                                        children: [
                                          //喜欢
                                          !userLogic.getLike(
                                              state.followlist[i].id)
                                              ? GestureDetector(
                                            child: Image.asset(
                                              'assets/images/noxin.png',
                                              width: 22,
                                              height: 22,
                                            ),
                                            onTap: () {
                                              logic.likeoperation(state.followlist[i].id, i);
                                            },
                                          )
                                              : GestureDetector(
                                            child: Image.asset(
                                              'assets/images/xin.png',
                                              width: 22,
                                              height: 22,
                                            ),
                                            onTap: () {
                                              logic.likeoperation(state.followlist[i].id, i);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            state.followlist[i].likes.toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              //fontFamily: "PingFang SC-Regular",
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          //收藏
                                          !userLogic.getCollect(
                                              state.followlist[i]
                                                  .id)
                                              ? GestureDetector(
                                            child: Image.asset(
                                              'assets/images/noshou.png',
                                              width: 22,
                                              height: 22,
                                            ),
                                            onTap: () {
                                              logic.Collectionoperation(state.followlist[i].id, i);
                                            },
                                          )
                                              : GestureDetector(
                                            child: Image.asset(
                                              'assets/images/shou.png',
                                              width: 22,
                                              height: 22,
                                            ),
                                            onTap: () {
                                              logic.Collectionoperation(state.followlist[i].id, i);
                                            },
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            state.followlist[i]
                                                .collects
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              //fontFamily: "PingFang SC-Regular",
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              CommentListDiolog(
                                                  state.followlist[i].id,state.followlist[i].title +
                                                  state.followlist[i].text, state.followlist[i].topics,
                                                  state.followlist[i].goodsList,
                                                  count: 0,
                                                  plus: () {
                                                    //Get.find<CommentLogic>().newParent(data);
                                                    updateCommentTotal(state.followlist[i]);
                                                  }
                                              );
                                            },
                                            child: Image.asset(
                                              'assets/images/pinglun.png',
                                              width: 21,
                                              height: 21,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            state.followlist[i]
                                                .comments
                                                .toString(),
                                            style: const TextStyle(
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        margin: const EdgeInsets.fromLTRB(
                                            20, 0, 20, 0),//pym_
                                        child: Image.asset(
                                          'assets/images/fenxiang.png',
                                          width: 23,
                                          height: 23,
                                        ),
                                      ),
                                      onTap: () {
                                        Share.share(
                                            'HI https://api.lanla.app/share?c=${state.followlist[i].id}');
                                      },
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 20,
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        state.followlist[i].type==3?state.followlist[i].title:state.followlist[i].title +
                                            state.followlist[i].text,
                                        overflow:
                                        TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    GestureDetector(child: Container(
                                      child: Text(
                                        '查看全文'.tr,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Color(0xff00366B),
                                          fontWeight: FontWeight.w400,
                                          //fontFamily: "PingFang SC-Regular",
                                        ),
                                      ),
                                    ),onTap: (){
                                      if(state.followlist[i].type==3){
                                        Get.toNamed('/public/xiumidata', preventDuplicates: false,arguments: {"data": state.followlist[i].id, "isEnd": false,'Detailed':state.followlist[i]});
                                      }else{
                                        CommentListDiolog(
                                            state.followlist[i]
                                                .id,state.followlist[i].title +
                                            state.followlist[i].text, state.followlist[i].topics,
                                            state.followlist[i].goodsList,
                                            count: 0);
                                      }
                                    },),
                                    const SizedBox(
                                      width: 20,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          );
                        }):
                    ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, i) {
                          return Container(
                            // decoration: BoxDecoration(border:Border.all(color: Colors.red,width:1)),
                            child: Column(
                              // mainAxisAlignment:MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  height: 100,
                                ),
                                Image.asset(
                                  'assets/images/noGuanzhuBg.png',
                                  width: 200,
                                  height: 200,
                                ),
                                const SizedBox(
                                  height: 40,
                                ),
                                Text(
                                  userLogic.follows.isNotEmpty?'你关注的人还没有发布内容哟'.tr:'还没有关注的人'.tr,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    //fontFamily: 'PingFang SC-Regular, PingFang SC'
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                if(userLogic.follows.isEmpty)Text(
                                  '关注后，可以在这里查看对方的最新动态'.tr,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      //fontFamily: 'PingFang SC-Regular, PingFang SC',
                                      color: Color(0xff999999)),
                                ),
                              ],
                            ),
                          );
                        }),
                  );
                }),
                TopicxqpagePage(),
                ContentZoneListPage(),
                ActivityZonePage(),
                // Container(
                //   padding: EdgeInsets.only(left: 20, right: 20),
                //   child: ListView.builder(
                //       controller: _scrollController,
                //       itemCount: 10,
                //       itemBuilder: (context, i) {
                //         return Container(padding:  EdgeInsets.only(top: 20, bottom: 20),decoration:BoxDecoration(border: Border(bottom: BorderSide(width: 1,color: Color.fromRGBO(241, 241, 241, 1)))),child: Row(children: [
                //           Container(width: 66,height: 45,color: Colors.red,),
                //           SizedBox(width: 12,),
                //           Column(children: [
                //             Row(
                //               children: [
                //                 ///图片和文字并排
                //                 Image.asset('assets/images/jinghao.png',fit: BoxFit.cover,width: 15,height: 15,),
                //                 const SizedBox(width: 7,),
                //                 Container(constraints: BoxConstraints(maxWidth: 250,),child:Text(
                //                   overflow: TextOverflow.ellipsis,
                //                   '123' ?? "---",
                //                   style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                //                 ),)
                //               ],
                //             ),
                //             SizedBox(height: 12,),
                //             Row(children: [
                //               Text(
                //                 ('123' ?? "0")+'浏览量'.tr,
                //                 style: const TextStyle(color: Color(0xFF999999),fontSize: 12,fontWeight: FontWeight.w400),
                //               )
                //             ]),
                //           ],)
                //         ],),);
                //       }
                //   ),
                // )
              ])

          ),
        ],
      ),
    );
  }


  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1), () {
      logic.FocusInterfaces();
    });
  }

  /**
   * 顶部轮播图
   */
  Widget _swiper(BuildContext context, imgs, attaImageScale) {
    double defultHeight = MediaQuery.of(context).size.width * attaImageScale;
    if (defultHeight > 500) {
      defultHeight = 500;
    }
    bool isOne = imgs.length == 1 ? true : false;
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
          MediaQuery.of(context).size.width, defultHeight + (isOne ? 0 : 32))),
      child: isOne
          ? Container(
        child: ImageCacheWidget(imgs[0],defultHeight + (isOne ? 0 : 32)),
        margin: const EdgeInsets.only(bottom: 15),
      )
          : Swiper(
        outer: true,
        itemBuilder: (c, i) {
          return ImageCacheWidget(imgs[i],defultHeight + (isOne ? 0 : 32));
          // Image.network(imgs[i]);
        },
        pagination: const SwiperPagination(
            margin: EdgeInsets.all(10),
            builder: DotSwiperPaginationBuilder(
              color: Colors.black12,
              activeColor: Colors.black,
              size: 4,
              activeSize: 5,
            )),
        itemCount: imgs.length,
      ),
      // constraints: BoxConstraints.loose(
      //     Size(MediaQuery.of(context).size.width, defultHeight))
    );
  }

  ///下拉加载
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            Text(
              '加载中...',
              style: TextStyle(fontSize: 16.0),
            ),
            CircularProgressIndicator(
              strokeWidth: 1.0,
            )
          ],
        ),
      ),
    );
  }
}



class _ButterFlyAssetVideo extends StatefulWidget {
  final  data;
  const _ButterFlyAssetVideo({super.key, required this.data});
  @override
  _ButterFlyAssetVideoState createState() => _ButterFlyAssetVideoState();
}

class _ButterFlyAssetVideoState extends State<_ButterFlyAssetVideo> {
  late VideoPlayerController _controller;
// 监控是否暂停
  bool  isPause = true;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.data.videoPath);

    // _controller.addListener(() {
    //   setState(() {});
    // });
    // _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {

    }));
    // _controller.play();

  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();

  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child:
      GestureDetector(child: Stack(alignment: Alignment.bottomCenter, children: [
        Container(
            child: Column(
              children: <Widget>[
                Container(
                  // width: 200,
                  // width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width *
                      widget.data.attaImageScale <
                      500
                      ? MediaQuery.of(context).size.width *
                      widget.data.attaImageScale
                      : 500,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : Container(
                            child: Image.network(widget.data.thumbnail,fit:BoxFit.cover ,)
                        ),
                        isPause&&_controller.value.isInitialized?Positioned(
                          top: 10,
                          right: 10,
                          left: 10,
                          bottom: 10,
                          // child: Icon(
                          //   Icons.play_circle_outline,
                          //   size: 90,
                          //   color: Colors.white54,
                          // )
                          child: Container(
                              color: Colors.white10,
                              width: 70,
                              height: 70,
                              child: Image.asset('assets/images/zanting.png',width: 18,height: 18,)
                          ),
                        ):Container()
                      ],
                    ),
                  ),
                  // width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(0),
            ), clipBehavior: Clip.hardEdge
        ),

        ///倍速
        //_ControlsOverlay(controller: _controller),
        ///进度条
        VideoProgressIndicator(_controller, allowScrubbing: true,
          // colors: VideoProgressColors(playedColor: Colors.cyan),
        ),
      ]),onTap: (){
        VideoPlayerValue videoPlayerValue = _controller.value;
        if (videoPlayerValue.isInitialized) {
          // 视频已初始化
          if (videoPlayerValue.isPlaying) {
            // 正播放 --- 暂停
            _controller.pause();
            setState(() {
              isPause = true;
            });
          } else {
            //暂停 ----播放
            _controller.play();
            setState(() {
              isPause = false;
            });
          }
          setState(() {});
        } else {
          // //未初始化
          // videoPlayerValue.isInitialized().then((_) {
          //   // videoPlayerController.play();
          //   // setState(() {});
          // });
        }
      },),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
            color: Colors.black26,
            child: const Center(
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 100.0,
                semanticLabel: 'Play',
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}