import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fijkplayer/fijkplayer.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/widgets/report.dart';

import 'package:lanla_flutter/models/HomeDetails.dart';

import 'package:lanla_flutter/common/widgets/topic_format.dart';

import 'package:lanla_flutter/models/HomeItem.dart';

import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/avatar.dart';
import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/common/widgets/comment_list_diolog.dart';
import 'package:lanla_flutter/models/analysisljlist.dart';
import 'package:lanla_flutter/pages/detail/Amountdetails/view.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class VideoScreen extends StatefulWidget {
  final HomeDetails dataSource;
  final int index;
  final double page;
  final Function setLike;
  final Function setCollect;
  final Function setFollow;
  final Function remove;
  final Function updateCommentNumber;
  bool isEnd = false;

  VideoScreen({
    required this.dataSource,
    required this.index,
    required this.page,
    required this.setLike,
    required this.setCollect,
    required this.setFollow,
    required this.isEnd,
    required this.remove,
    required this.updateCommentNumber,
  });

  @override
  State createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> with WidgetsBindingObserver {
  final FijkPlayer player = FijkPlayer();
  final userLogic = Get.find<UserLogic>();
//实例化
  GiftDetails provider = Get.put(GiftDetails());
  //final logic = Get.find<VideoLogic>();
  bool videoIsReady = false;

  // 当前播放状态
  bool _playing = false;

  // 视频总时长
  double maxDurations = 0.0;

  // 当前进度条
  double sliderValue = 0.0;
  bool playReady = false;
  bool playReadyLib = false;
  double slideheight = 2;

  ///礼物列表
  var Giftlist=[];
  ///余额
  var Balancequery;
  ///选中的礼物
  var giftItem;


  /// 流监听器
  late StreamSubscription _currentPosSubs;

  // 监控是否暂停
  bool isPause = false;

  // 播放时长，用于统计时间
  int playTime = 0;

  var eventObj;
  ///防抖
  var jieliu=true;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    FirebaseAnalytics.instance.logEvent(
      name: "video_view_list",
      parameters: {
        "id": widget.dataSource.id,
        "number" : widget.index+1
      },
    );

    player.setDataSource(widget.dataSource.videoPath, autoPlay: true);
    player.setLoop(0);
    player.addListener(addListener);
    // 监听暂停视频的广播
    eventObj = stopVideoEvent!.on<VideoStop>().listen((event) {

      if (player.state == FijkState.started) {
        player.pause();
        setState(() {
          isPause = true;
        });
      }
    });
    _currentPosSubs = player.onCurrentPosUpdate.listen((v) {
      /// 实时获取当前播放进度（进度条）
      if (v.inMilliseconds > playTime) {
        playTime = v.inMilliseconds;
      }
      //playTime = v.inMilliseconds > playTime ? v.inMilliseconds : v.inMilliseconds + playTime;
      setState(() {
        sliderValue = v.inMilliseconds.toDouble();
      });

      /// 实时获取当前播放进度（数字展示）
      //durrentPos = v.toString().substring(0,v.toString().indexOf("."));
    });
    if(userLogic.checkUserLogin()){
      giftlistes();
    }
    super.initState();
  }


  giftlistes() async {
    if(jieliu){
      setState(() {
        jieliu=false;
      });
      var result = await provider.giftList();
      var Goldcoindetails = await provider.Balancequery();

      // setState(() {
      //
      // });
      Giftlist=analysislwListFromJson(result.bodyString!);
      Balancequery=Goldcoindetails.body;
      giftItem=Giftlist[0][0];
      jieliu=true;
      // giftshowBottomSheet(context);
    }
  }

  void addListener() {
    FijkValue value = player.value;
    // 视频总时长
    maxDurations = value.duration.inMilliseconds.toDouble();
    bool playing = (value.state == FijkState.started);
    if (playing != _playing && playing != false)
      setState(() => _playing = playing);
    // TODO:暂时解决，在playing=true时，视频未加载出来，所以会有一帧的黑屏，延迟隐藏图片
    if (!playReadyLib && playing) {
      playReadyLib = true;
      Future.delayed(const Duration(milliseconds: 100), () {
        setState(() => playReady = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //print('当前页 ${widget.page}');
    //final logic = Get.find<VideoLogic>();
    return GestureDetector(
      onTap: () {
        if (player.state == FijkState.paused) {
          player.start();
          setState(() {
            isPause = false;
          });
        }
        if (player.state == FijkState.started) {
          player.pause();
          setState(() {
            isPause = true;
          });
        }
      },
      onDoubleTap: () {
        widget.setLike(widget.index);
      },
      onLongPress: () {
        if (player.state == FijkState.started) {
          player.pause();
          setState(() {
            isPause = true;
          });
        }
        ReportDoglog(ReportType.content, widget.dataSource.id,2,widget.dataSource.videoPath, context,
            removeCallbak: () {
              widget.remove();
            });
      },
      child: Container(
        alignment: Alignment.center,
        child: Stack(children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 70,
            child: FijkView(
              player: player,
              fit: widget.dataSource.attaImageScale > 1
                  ? FijkFit.cover
                  : FijkFit.contain,
              color: Colors.black,
              panelBuilder: (FijkPlayer player, FijkData data, BuildContext context, Size viewSize, Rect texturePos) {
                return playReady
                    ? Container()
                    : Container(
                    width: viewSize.width,
                    height: viewSize.height,
                    // color: Colors.red,
                    child:
                    // CachedNetworkImage(
                    //   imageUrl: widget.dataSource.thumbnail,
                    //   fit: widget.dataSource.attaImageScale > 1? BoxFit.cover
                    //       : BoxFit.fitWidth,
                    //   placeholder: (context, url) => Container(color: Color(0xffF5F5F5),padding: EdgeInsets.only(left: 20,right: 20),width: double.infinity,child:Image.asset('assets/images/LanLazhanwei.png') ,),
                    // )

                    Image.network(
                      widget.dataSource.thumbnail,
                      fit: widget.dataSource.attaImageScale > 1
                          ? BoxFit.cover
                          : BoxFit.fitWidth,
                    )
                );
              },

              // cover: NetworkImage(widget.dataSource.thumbnail,),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width,
              height: 400,
              //color: Colors.red,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if(widget.dataSource.goodsList.isNotEmpty)GestureDetector(
                    onTap: () {
                      Get.bottomSheet(Container(
                        padding: const EdgeInsets.all(20),
                        decoration:const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.horizontal(left: Radius.circular(10),right:Radius.circular(10)),
                        ),
                        child: Column(children: [
                          Row(children: [
                            Image.asset('assets/images/spcommoditytwo.png',width: 30,height: 30,),
                            const SizedBox(width: 10,),
                            Text('关联的商品'.tr,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)
                          ],),
                          const SizedBox(height: 10,),
                          Expanded(child: Container(child: ListView.builder(shrinkWrap: true,primary:false,padding:EdgeInsets.zero,itemCount: widget.dataSource.goodsList.length,itemBuilder: (context, i) {
                            return GestureDetector(onTap: (){
                              if (!userLogic.checkUserLogin()) {
                                Get.toNamed('/public/loginmethod');
                                return;
                              }
                              Get.toNamed('/public/Evaluationdetails',arguments: {'data':widget.dataSource.goodsList[i]} );
                            },child: Column(children: [
                              // Container(width: double.infinity,height: 10,color: Color(0xfff9f9f9),),
                              // SizedBox(height: 15,),
                              Row(children: [const SizedBox(width: 20,),
                                Container(width: 50, height: 50,
                                  //超出部分，可裁剪
                                  clipBehavior: Clip.hardEdge,
                                  decoration: BoxDecoration(
                                    color:const Color(0xfff5f5f5),
                                    borderRadius: BorderRadius.circular(5),
                                      border: Border.all(width: 0.5,color: const Color(0xfff5f5f5))
                                  ),
                                  child: Image.network(
                                    widget.dataSource.goodsList[i].thumbnail,
                                    //fit: BoxFit.cover,
                                    fit: BoxFit.cover,
                                    width: 50, height: 50,
                                  ),
                                ),
                                const SizedBox(width: 8,),
                                Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                  Container(constraints: const BoxConstraints(maxWidth: 250,),child:
                                  Text(widget.dataSource.goodsList[i].title,overflow: TextOverflow.ellipsis,
                                    maxLines: 1,style: const TextStyle(fontSize: 16),),),
                                  Row(children: [
                                    Container(height: 25,child: Text('评估'.tr,style: const TextStyle(color: Color(0xff999999)),),),
                                    const SizedBox(width: 5,),
                                    XMStartRating(rating: double.parse(widget.dataSource.goodsList[i].score) ,showtext:true)
                                  ],),
                                ],)],),
                              Container(height: 56,alignment: Alignment.centerRight,
                                padding: const EdgeInsets.fromLTRB(0, 10, 0,0),
                                child: ListView(
                                    shrinkWrap: true,
                                    primary:false,
                                    scrollDirection: Axis.horizontal,
                                    children:[
                                      for(var j=0;j<jsonDecode(widget.dataSource.goodsList[i].priceOther).length;j++)
                                        GestureDetector(child:Container(margin:const EdgeInsets.only(right: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width: 0.5,color: const Color((0xffF5F5F5))),
                                            color: const Color(0xfff5f5f5),
                                            borderRadius: const BorderRadius.all(Radius.circular(5))
                                        ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                          Row(mainAxisAlignment:MainAxisAlignment.center,children: [
                                            // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                                            // SizedBox(width: 2,),
                                            Text(jsonDecode(widget.dataSource.goodsList[i].priceOther)[j]['price'].split(' ')[0],style: const TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                                            const SizedBox(width: 4,),
                                            Text(jsonDecode(widget.dataSource.goodsList[i].priceOther)[j]['price'].split(' ')[1],style: const TextStyle(height: 1.3,fontSize: 12),)
                                          ],),
                                          Text(jsonDecode(widget.dataSource.goodsList[i].priceOther)[j]['platform'],style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)
                                        ],),) ,onTap: () async {
                                          if (!userLogic.checkUserLogin()) {
                                            Get.toNamed('/public/loginmethod');
                                            return;
                                          }
                                          await launchUrl(Uri.parse(jsonDecode(widget.dataSource.goodsList[i].priceOther)[j]['detailPath']), mode: LaunchMode.externalApplication,);
                                        },)
                                    ]),
                              ),
                              const SizedBox(height: 15,),
                              ///分割线
                              Container(
                                height: 1.0,
                                decoration: const BoxDecoration(
                                  color: Color(0xfff1f1f1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x0c00000),
                                      offset: Offset(0, 2),
                                      blurRadius: 5,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 15,),
                            ]),);
                          })),)
                        ],),
                      ));
                    },
                    child: Container(
                      height: 35,
                      width: 35,
                      margin: const EdgeInsets.only(right: 10,left: 10,bottom: 10),
                      child: Image.asset(
                        'assets/images/spcommodity.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  _userInfoBar(),
                  const SizedBox(height: 10,),
                  _bottomBar(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 68,
            right: 3,
            left: 3,
            child: GestureDetector(onLongPress:(){},child: Container(
              height: 10,
              child:
              // LinearProgressIndicator(
              //   backgroundColor: Colors.black54,
              //   color: Colors.white30,
              //   value: maxDurations > 0 ? sliderValue / maxDurations : 0,
              // ),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: slideheight,
                  //已拖动的颜色
                  activeTrackColor: Colors.white70,
                  //未拖动的颜色
                  inactiveTrackColor: Colors.white30,
                  //提示进度的气泡的背景色
                  valueIndicatorColor: Colors.green,
                  //提示进度的气泡文本的颜色
                  valueIndicatorTextStyle: const TextStyle(
                    color:Colors.white,
                  ),
                  thumbShape: RoundSliderThumbShape( //  滑块形状，可以自定义
                      enabledThumbRadius: slideheight  // 滑块大小
                  ),
                  overlayShape: const RoundSliderOverlayShape(  // 滑块外圈形状，可以自定义
                    overlayRadius: 6, // 滑块外圈大小
                  ),
                  //滑块中心的颜色
                  thumbColor: Colors.white,
                  //滑块边缘的颜色
                  overlayColor: Colors.white,
                  //对进度线分割后，断续线中间间隔的颜色
                  inactiveTickMarkColor: Colors.white,
                ),
                child: Slider(
                  value: sliderValue,
                  label: '${int.parse((sliderValue  / 3600000).toStringAsFixed(0))<10?'0${(sliderValue  / 3600000).toStringAsFixed(0)}':(sliderValue  / 3600000).toStringAsFixed(0)}:${int.parse(((sliderValue  % 3600000) /  60000).toStringAsFixed(0))<10?'0${((sliderValue  % 3600000) /  60000).toStringAsFixed(0)}':((sliderValue  % 3600000) /  60000).toStringAsFixed(0)}:${int.parse(((sliderValue  % 60000) /  1000).toStringAsFixed(0))<10?'0${((sliderValue % 60000) /  1000).toStringAsFixed(0)}':((sliderValue  % 60000) /  1000).toStringAsFixed(0)}',
                  min: 0.0,
                  max: maxDurations,
                  divisions: 1000,
                  onChangeEnd:(val){
                    Timer.periodic(
                        const Duration(seconds : 2),(timer){

                      setState(() {
                        slideheight=1;
                      });
                      timer.cancel();//取消定时器
                    }
                    );

                    },
                  onChanged: (val){
                    setState(() {
                      slideheight=5;
                    });

                    ///转化成double
                    setState(() => sliderValue = val.floorToDouble());

                    /// 设置进度
                    player.seekTo(sliderValue.toInt());
//
                  },
                ),
              ),
            ),),
          ),
          Positioned(
            top: 20,
            right: 0,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                height: 50,
                width: 50,
                child: const Center(
                  child: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white70,
                    size: 22,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 50,
            child: GestureDetector(
              onTap: () {
                if (!userLogic.checkUserLogin()) {
                  if (player.state == FijkState.started) {
                    player.pause();
                    setState(() {
                      isPause = true;
                    });
                  }
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                AppLog('share', event: 'video',targetid: widget.dataSource.id );
                Get.put<ContentProvider>(ContentProvider()).ForWard(widget.dataSource.id,1);
                Share.share('https://api.lanla.app/share?c=${widget.dataSource.id}');
              },
              child: Container(
                //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                height: 50,
                width: 50,
                child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      child: Image.asset(
                        'assets/images/fenxiang.png',
                        color: Colors.white,
                      ),//pym_
                      // child: SvgPicture.asset(
                      //   "assets/svg/fenxiang.svg",
                      // ),
                    )
                ),
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 10,
            child: GestureDetector(
              onTap: () {
                if (!userLogic.checkUserLogin()) {
                  if (player.state == FijkState.started) {
                    player.pause();
                    setState(() {
                      isPause = true;
                    });
                  }
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                if (player.state == FijkState.started) {
                  player.pause();
                  setState(() {
                    isPause = true;
                  });
                }
                ReportDoglog(ReportType.content, widget.dataSource.id,2,widget.dataSource.videoPath, context,
                    removeCallbak: () {
                      widget.remove();
                      eventBus.fire(UploadContentListEvent());
                    });
              },
              child: Container(
                //decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red)),
                height: 50,
                width: 50,
                child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      child: Image.asset('assets/images/shitan.png',),
                    )
                ),
              ),
            ),
          ),
          isPause
              ? Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            child: Container(
              color: Colors.white10,
              width: 70,
              height: 70,
              child: Image.asset('assets/images/zanting.png',width: 18,height: 18,),
            ),
              // Icon(
              //   Icons.play_circle_outline,
              //   size: 120,
              //   color: Colors.white54,
              // )
          )
              : Container()
        ]),
      ),
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 70,
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              onTap: () {
                if (!userLogic.checkUserLogin()) {
                  if (player.state == FijkState.started) {
                    player.pause();
                    setState(() {
                      isPause = true;
                    });
                  }
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                AppLog('tap', event: 'comment', data: "video");
                //logic.addCount();
                CommentDiolog(widget.dataSource.id, parentCallback: (value) {
                  widget.updateCommentNumber();
                }, childCallback: () {
                  widget.updateCommentNumber();
                });
              },
              child:
                  Container(
                    padding: const EdgeInsets.fromLTRB(25, 3, 5, 3),
                    child:
                    Container(
                      height: 44,
                      padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                      decoration: const BoxDecoration(
                        // color: HexColor('#efefef'),
                        color: Color(0x4cffffff),
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset('assets/svg/bi_drak.svg',width: 18,height: 18,),
                          const SizedBox(width: 8,),
                          Text(
                            '${'说点什么'.tr}...',

                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                // color: Color(0xff999999)),
                                color: Colors.white.withAlpha(50)),

                          )
                        ],
                      ),
                    ),

                  ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(right: 0),
            // padding: EdgeInsets.only(left: 10),
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (!userLogic.checkUserLogin()) {
                      if (player.state == FijkState.started) {
                        player.pause();
                        setState(() {
                          isPause = true;
                        });
                      }
                      Get.toNamed('/public/loginmethod');
                      return;
                    }
                    AppLog('tap', event: 'collect', data: "video");
                    widget.setCollect(widget.index);
                  },
                  child:Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        child: userLogic.getCollect(widget.dataSource.id)
                            ? SvgPicture.asset(
                          "assets/svg/shoucang.svg",
                        )
                            : SvgPicture.asset(
                          "assets/svg/noshoucang.svg",
                        ),
                      ),
                      const SizedBox(height: 5,),//pym_
                      Text(
                        widget.dataSource.collects.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),
                    ],
                  ) ,) ,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (!userLogic.checkUserLogin()) {
                          if (player.state == FijkState.started) {
                            player.pause();
                            setState(() {
                              isPause = true;
                            });
                          }
                          Get.toNamed('/public/loginmethod');
                          return;
                        }
                        AppLog('tap', event: 'like', data: "video");
                        widget.setLike(widget.index);
                      },
                      child: Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                        mainAxisAlignment:MainAxisAlignment.center,
                        children: [
                          userLogic.getLike(widget.dataSource.id)
                              ? Container(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              "assets/svg/yeslive.svg",
                            ),
                          )
                              : Container(
                            width: 24,
                            height: 24,
                            child: SvgPicture.asset(
                              "assets/svg/live.svg",
                            ),
                          ),
                          const SizedBox(height: 5,),//pym_
                          Text(
                            widget.dataSource.likes.toString(),
                            //userLogic.getLike(widget.dataSource.id),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white),
                          ),
                        ],
                      ),),
                    )
                  ],
                ),
                ///消息
                GestureDetector(
                  onTap: () {
                    if (!userLogic.checkUserLogin()) {
                      if (player.state == FijkState.started) {
                        player.pause();
                        setState(() {
                          isPause = true;
                        });
                      }
                      Get.toNamed('/public/loginmethod');
                      return;
                    }
                    AppLog('tap', event: 'comment', data: "video");
                    CommentListDiolog(widget.dataSource.id,'',[],[],
                        count: widget.dataSource.comments,
                        // 增加一个
                        plus: () {
                          widget.updateCommentNumber();
                        },
                        // 减少一个
                        updateCommentNumber: () {
                          widget.updateCommentNumber();
                        });
                  },
                  child: Container(color: Colors.transparent,margin:const EdgeInsets.only(left: 20),child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 22,
                        height: 22,
                        child: SvgPicture.asset(
                          'assets/svg/pinglun_new.svg',
                        ),
                      ),
                      const SizedBox(height: 5,),//pym_
                      Text(
                        widget.dataSource.comments.toString(),
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white),
                      ),

                    ],
                  ) ,),
                ),
                ///礼物
                GestureDetector(
                  onTap: (){
                    if (!userLogic.checkUserLogin()) {
                      if (player.state == FijkState.started) {
                        player.pause();
                        setState(() {
                          isPause = true;
                        });
                      }
                      Get.toNamed('/public/loginmethod');
                      return;
                    }
                    if(Giftlist.isNotEmpty){
                      giftshowBottomSheet(context);
                    }
                  },
                  child:Container(
                    color: Colors.transparent,
                    margin: const EdgeInsets.only(left: 0),//pym_
                    child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/liwuicon.png',
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(height: 0,),
                      Text(
                        '礼物'.tr,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xff999999)),
                      ),
                    ],
                  ),),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _userInfoBar() {
    return GetBuilder<UserLogic>(builder: (logic) {
      return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // 头像
                GestureDetector(
                  onTap: () {
                    if (player.state == FijkState.started) {
                      player.pause();
                      setState(() {
                        isPause = true;
                      });
                    }
                    if (widget.isEnd) {
                      Get.back();
                      return;
                    }
                    // 进入个人主页
                    Get.toNamed('/public/user',
                        arguments: widget.dataSource.userId);
                  },
                  child: Row(
                    children: [
                    Stack(clipBehavior: Clip.none, alignment:Alignment.center ,children: [
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(width: 1,color: userLogic.getFollow(widget.dataSource.userId)?Colors.transparent:Colors.white),
                          color: Colors.black12,
                          image: DecorationImage(
                              image: NetworkImage(widget.dataSource.userAvatar ??
                                  'https://dyhc-dev.oss-cn-beijing.aliyuncs.com/topic/topic-9.png'),
                              fit: BoxFit.cover),
                        ),
                        //child: Image.network(data.userAvatar,fit:BoxFit.cover),
                      ),
                      if(!userLogic.getFollow(widget.dataSource.userId))Positioned(bottom: -6,left: 40/2-9,child: GestureDetector(onTap: (){
                        AppLog('tap', event: 'follow',
                            targetid: widget.dataSource.userId);
                        userLogic.setFollow(widget.dataSource.userId);
                        userLogic.update();
                        followPopup(context);
                        Timer.periodic(
                            const Duration(milliseconds: 1000), (timer) {
                            timer.cancel(); //取消定时器
                            Navigator.pop(context);
                        }
                        );
                      },child: Image.asset('assets/images/shiguanzhu.png',width: 18,height: 18,),))
                    ]),

                      Padding(
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          widget.dataSource.userName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     AppLog('tap', event: 'follow',
                //         targetid: widget.dataSource.userId);
                //     userLogic.setFollow(widget.dataSource.userId);
                //     userLogic.update();
                //     print("11111111");
                //   },
                //   child: userLogic.getFollow(widget.dataSource.userId)
                //       ? Container(
                //       width: 70,
                //       height: 30,
                //       decoration: BoxDecoration(
                //         border: Border.all(color: Colors.white60),
                //         borderRadius: BorderRadius.circular(18),
                //         //color: Colors.white,
                //       ),
                //       child: Center(
                //         child: Text(
                //           '已关注',
                //           style: const TextStyle(
                //               color: Colors.white60, fontSize: 12),
                //         ),
                //       ))
                //       : Container(
                //       width: 70,
                //       height: 30,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(18),
                //         border: Border.all(color: Colors.white70),
                //         color: Colors.white,
                //       ),
                //       child: Center(
                //         child: Text(
                //           '关注',
                //           style: const TextStyle(
                //               color: Colors.black,
                //               fontSize: 13,
                //               fontWeight: FontWeight.w600),
                //         ),
                //       )),
                // )
              ],
            ),
            Container(
              height: 15,
            ),
            Container(
              alignment: Alignment.bottomRight,
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                widget.dataSource.title,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            widget.dataSource.text == ''
                ? Container()
                : Container(
              alignment: Alignment.topRight,
              margin: const EdgeInsets.only(bottom: 20),
              child: Text(
                widget.dataSource.text ?? '',
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            TopicFormat(widget.dataSource.topics,isVideo:true)
          ],
        ),
      );
    });
  }

  @override
  dispose()  async {
    super.dispose();
    // print('注销视频页');
    await AppLog('playover',
        videoplaytime: playTime.toString(),
        targetid: widget.dataSource.id,
        videoplayproportion: (playTime / player.value.duration.inMilliseconds)
            .toStringAsFixed(2));
    await WidgetsBinding.instance.removeObserver(this);
    await _currentPosSubs?.cancel();
    await eventObj.cancel();
    player.release();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        player.pause();
        // print('在视频页面进入后台');
        break;
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        player.start();
        // print('在视频页面进来了');
        break;
    }
  }

  ///礼物弹窗
  @override
  void giftshowBottomSheet(context) {
    // if (Platform.isAndroid) {
      int _current = 0;
      final CarouselController _controller = CarouselController();
      //用于在底部打开弹框的效果
      showModalBottomSheet(
          isScrollControlled: false,
          enableDrag: false,
          // isDismissible:false,
          builder: (BuildContext context) {
            //构建弹框中的内容
            return StatefulBuilder(
                builder: (context1, setBottomSheetState) {
                  return Container(

                    height: MediaQuery
                        .of(context)
                        .size
                        .height / 2 - 20,
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0))
                    ),
                    child:
                    // Column(
                    //   children: [
                    //     SizedBox(height: 55,),
                    //     Container(width:MediaQuery.of(context).size.width-120 ,child:Text('赠礼功能尚未开放，敬请期待哟'.tr,
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //         fontSize: 17,
                    //         color: Color(0xff666666),
                    //         fontWeight: FontWeight.w600,
                    //
                    //     ),) ,),
                    //     SizedBox(height: 50,),
                    //     Image.asset('assets/images/lwzhanwt.png',width: MediaQuery.of(context).size.width-100,)
                    //   ],
                    // )
                    Column(children: [
                      const SizedBox(height: 10,),
                      Container(
                        width: 25,
                        height: 3,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(
                                10),),
                            color: Color(0xffe4e4e4)
                        ),
                      ),
                      const SizedBox(height: 15,),
                      Container(padding: const EdgeInsets.only(left: 20, right: 20),
                        alignment: Alignment.centerRight,
                        child: Text('礼物'.tr, style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),),),
                      const SizedBox(height: 22,),
                      Container(child: CarouselSlider(
                        options: CarouselOptions(
                            height: 210,
                            viewportFraction: 1,
                            // autoPlay: true,
                            // enlargeCenterPage: true,
                            // aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              setBottomSheetState(() {
                                _current = index;
                              });
                            }),
                        // carouselController: _controller,
                        items: Giftlist
                            .map((item) =>
                            Container(
                              padding: const EdgeInsets.only(left: 12, right: 12),
                              width: double.infinity,
                              child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  runAlignment: WrapAlignment.spaceBetween,
                                  children: [
                                    for(var i = 0; i < item.length; i++)
                                      GestureDetector(child: Container(
                                        decoration: BoxDecoration(
                                            border: Border.all(width: 1,
                                                color: giftItem.id == item[i].id
                                                    ? Colors.black
                                                    : Colors.white),
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10.0))
                                        ),
                                        width: (MediaQuery
                                            .of(context)
                                            .size
                                            .width - 54) / 4,
                                        height: 100,
                                        padding: const EdgeInsets.fromLTRB(
                                            15, 10, 15, 10),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            // Container(width: 50,height: 50,color: Colors.red,),
                                            Image.network(
                                              item[i].imagePath, width: 50,
                                              height: 50,),
                                            Row(children: [
                                              Image.asset(item[i].type == 1
                                                  ? 'assets/images/jinbi.png'
                                                  : 'assets/images/beike.png',
                                                width: 15, height: 15,),
                                              const SizedBox(width: 5,),
                                              Text(item[i].price.toString(),
                                                style: const TextStyle(fontSize: 12),)
                                            ],)
                                          ],),
                                      ), onTap: () {
                                        setBottomSheetState(() {
                                          giftItem = item[i];
                                        });
                                      },),

                                  ]),
                              // Center(child:Container(width: 50,height: 50,color: Colors.red,),),
                              // color: Colors.white,
                            ))
                            .toList(),
                      ),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: Giftlist
                            .asMap()
                            .entries
                            .map((entry) {
                          return GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: 5.0,
                              height: 5.0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 4.0),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: (Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                      .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 20,),
                      Container(child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(child: Container(
                            padding: const EdgeInsets.fromLTRB(30, 8, 30, 8),
                            child: Text(
                              '赠送'.tr, style: const TextStyle(color: Colors.white),),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(50.0)), color: Colors.black,
                            ),), onTap: () async {
                            if (jieliu) {
                              setBottomSheetState(() {
                                jieliu = false;
                              });
                              if (giftItem.type == 1) {
                                if (giftItem.price >
                                    int.parse(Balancequery['laGold'])) {
                                  ToastInfo("余额不足".tr);
                                  setBottomSheetState(() {
                                    jieliu = true;
                                  });
                                  return;
                                }
                              } else if (giftItem.type == 3) {
                                if (giftItem.price >
                                    int.parse(Balancequery['nacre'])) {
                                  ToastInfo("余额不足".tr);
                                  setBottomSheetState(() {
                                    jieliu = true;
                                  });
                                  return;
                                }
                              }
                              var givingifts = await provider.Givingifts(
                                  widget.dataSource.id, giftItem.id);
                              if (givingifts.statusCode == 200) {
                                setBottomSheetState(() {
                                  if (giftItem.type == 1) {
                                    Balancequery['laGold'] =
                                        givingifts.body['balance'].toString();
                                  } else if (giftItem.type == 3) {
                                    Balancequery['nacre'] =
                                        givingifts.body['balance'].toString();
                                  }
                                });
                                songift(context, givingifts.body['imagePath']);
                                Timer.periodic(
                                    const Duration(milliseconds: 2000), (timer) {

                                  timer.cancel(); //取消定时器
                                  Navigator.pop(context);
                                }
                                );
                              }
                              setBottomSheetState(() {
                                jieliu = true;
                              });
                            }
                          },),
                          Container(decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(50.0)),
                            color: Color(0xfff5f5f5),
                          ),
                              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                              height: 35,
                              child: Row(children: [
                                Image.asset(giftItem.type == 1
                                    ? 'assets/images/jinbi.png'
                                    : 'assets/images/beike.png', width: 15,
                                  height: 15,),
                                const SizedBox(width: 5,),
                                Container(
                                  child: Text(
                                    giftItem.type == 1 ? Balancequery['laGold']
                                        .toString() : Balancequery['nacre']
                                        .toString(), style: TextStyle(
                                      color: giftItem.type == 1 ? const Color(
                                          0xffFFA800) : const Color(0xffFFA8C7),
                                      fontWeight: FontWeight.w600
                                  ),),),
                                const SizedBox(width: 10,),
                                GestureDetector(child: Text(
                                  giftItem.type == 1 ? '充值la币'.tr : '贝壳'.tr,
                                  style: const TextStyle(fontSize: 12,
                                      fontWeight: FontWeight.w600),),
                                  onTap: () {
                                    if (player.state == FijkState.started) {
                                      player.pause();
                                      setState(() {
                                        isPause = true;
                                      });
                                    }
                                    Navigator.pop(context);
                                    if (giftItem.type == 1) {
                                      Get.to(AmountPage(), arguments: 1);
                                    } else if (giftItem.type == 3) {
                                      Get.to(AmountPage(), arguments: 2);
                                    }
                                  },),

                                const SizedBox(width: 10,),
                                SvgPicture.asset(
                                  "assets/icons/publish/arrow.svg",
                                  width: 10,
                                  height: 10,
                                ),
                              ],)),
                        ],
                      ), padding: const EdgeInsets.only(left: 20, right: 20))

                    ]),

                  );
                }
            );
          },
          backgroundColor: Colors.transparent,
          //重要
          context: context).then((value) {
      });
    // }else{
    //   //用于在底部打开弹框的效果
    //   showModalBottomSheet(
    //       isScrollControlled: false,
    //       enableDrag:false,
    //       // isDismissible:false,
    //       builder: (BuildContext context) {
    //         //构建弹框中的内容
    //         return Container(
    //             height: MediaQuery.of(context).size.height/2 - 20,
    //             decoration: new BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: new BorderRadius.only(
    //                     topLeft: const Radius.circular(10.0),
    //                     topRight: const Radius.circular(10.0))
    //             ),
    //             child: Column(
    //               children: [
    //                 SizedBox(height: 55,),
    //                 Container(width:MediaQuery.of(context).size.width-120 ,child:Text('赠礼功能尚未开放，敬请期待哟'.tr,
    //                   textAlign: TextAlign.center,
    //                   style: TextStyle(
    //                     fontSize: 17,
    //                     color: Color(0xff666666),
    //                     fontWeight: FontWeight.w600,
    //
    //                   ),) ,),
    //                 SizedBox(height: 50,),
    //                 Image.asset('assets/images/lwzhanwt.png',width: MediaQuery.of(context).size.width-100,)
    //               ],
    //             )
    //
    //         );
    //       },
    //       backgroundColor: Colors.transparent, //重要
    //       context: context).then((value){
    //     print('5566600');
    //   });
    // }
  }

  ///送出的礼物
  Future<void> songift(context,image) async {

    return showDialog<void>(
      context: context,
      // barrierDismissible: true, // user must tap button!
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.transparent,

                  width: 270,
                  height: 270,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(children: [
                    const SizedBox(height: 40,),
                    Image.network(image,width: 150,height: 150,),
                    const SizedBox(height: 22,),
                    Text('赠送成功'.tr,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                  ],),
                ),
              ]),
        );
      },
    );
  }

  ///关注弹窗
  Future<void> followPopup(context) async {

    return showDialog<void>(
      context: context,
      // barrierDismissible: true, // user must tap button!
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15,bottom: 15),
                  //color: Colors.transparent,
                  width: 200,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))
                  ),
                  child: Column(children: [
                    Image.asset('assets/images/guanzhusahng.png',width: 49,height: 55,),
                    const SizedBox(height: 15,),
                    Text('关注成功'.tr,style: const TextStyle(fontWeight: FontWeight.w600,fontSize: 17),)
                  ],),
                ),
              ]),
        );
      },
    );
  }
}
