import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/common/widgets/topic_format.dart';
import 'package:lanla_flutter/models/GetGiftAnalysis.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/analysisljlist.dart';
import 'package:lanla_flutter/pages/components/comment/logic.dart';
import 'package:lanla_flutter/pages/detail/Amountdetails/view.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/event.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';

import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/models/comment_parent.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:lanla_flutter/pages/components/comment/view.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as htmljx;
import 'package:html/parser.dart' as htmlParser;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';

class xiumidetailsPage extends StatefulWidget {
  var  dataSource;
  late bool isEnd;

  xiumidetailsPage(this.dataSource, this.isEnd, {super.key});

  @override
  xiumidetailsState createState() => xiumidetailsState();
}

class xiumidetailsState extends State<xiumidetailsPage> with WidgetsBindingObserver{
  //实例化
  GiftDetails provider = Get.put(GiftDetails());
  var dataSource;
  final userLogic = Get.find<UserLogic>();
  List<String> imageList = [];
  ContentProvider contentProvider = Get.put<ContentProvider>(ContentProvider());
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  ScrollController _scrollController = ScrollController();
  ///播放
  bool Startplaying=false;
  ///暂停
  bool suspendyp=false;
  int Receivinggiftspage=1;
  ///收到礼物数据
  var Receivinggiftsdata=[];

  ////
  var Giftlist=[];

  ///余额
  var Balancequery;
  ///选中的礼物
  var giftItem;

  ///防抖
  var jieliu=true;

  ///当前图片下标
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _initData();
    init();
    shoulilist();
    //_scrollController.addListener(_scrollListener);
    if(userLogic.checkUserLogin()){
      giftlistes();
    }

  }
  ///初始化音频插件
  init() async {
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));

  }

  ///收到礼物列表
  shoulilist() async {
    var res= await contentProvider.contentGiftDetail(Receivinggiftspage,widget.dataSource.id);
    if(res.statusCode==200){
      var st =(getGiftAnalysisFromJson(res?.bodyString ?? ""));
      if(st.length>0){
        setState(() {
          Receivinggiftspage++;
          Receivinggiftsdata.addAll(st);
        });
        // setBottomSheetState(() {
        //   giftItem=item[i];
        // });
      }



      // print(result.statusCode);
      // update();
    }
  }

  ///礼物列表接口
  giftlistes() async {
    if(jieliu){
      setState(() {
        jieliu=false;
      });
      var result = await provider.giftList();
      var Goldcoindetails = await provider.Balancequery();
      setState(() {
        Giftlist=analysislwListFromJson(result.bodyString!);
        Balancequery=Goldcoindetails.body;
        giftItem=Giftlist[0][0];
        jieliu=true;
      });
      setState(() {
        jieliu=true;
      });
      //giftshowBottomSheet(context);
    }
  }
  _initData() async {
    //请求当前数据
    HomeDetails? defalutData = await _fetchDefalutData(widget.dataSource.id);
    FirebaseAnalytics.instance.logEvent(
      name: "picture_view",
      parameters: {
        "id": widget.dataSource.id
      },
    );
    if (defalutData == null) {
      ToastInfo('内容已经被删除'.tr);
      Get.back();
      return;
    }
    setState(() {
      dataSource = defalutData;
      imageList = dataSource!.imagesPath.split(',');
    });
  }

  ///开始播放，这里做了一个播放状态的回调
  void startPlayer(path) async {
    try {
      if (path.contains('http')) {
        await playerModule.startPlayer(
            fromURI: path,
            codec: Codec.mp3,
            sampleRate: 44000,
            whenFinished: () {
              stopPlayer();
              setState(() {});
            });
      }
    } catch (err) {}
  }

  /// 结束播放
  void stopPlayer() async {
    try {
      await playerModule.stopPlayer();
      setState((){
        Startplaying=false;
      });
      // cancelPlayerSubscriptions();
    } catch (err) {}
  }
  /// 取消播放监听
  // void cancelPlayerSubscriptions() {
  //   if (_playerSubscription != null) {
  //     _playerSubscription!.cancel();
  //     _playerSubscription = null;
  //   }
  // }
  /// 暂停/继续播放
  void pauseResumePlayer() {
    if (playerModule.isPlaying) {
      playerModule.pausePlayer();
      suspendyp=true;
      // _state = RecordPlayState.play;
    } else {
      playerModule.resumePlayer();
      suspendyp=false;
      // _state = RecordPlayState.playing;
    }
    setState(() {});
  }
  ///获取播放状态
  Future<PlayerState> getPlayState() async {
    return await playerModule.getPlayerState();
  }
  /// 释放播放器
  void releaseFlauto() async {
    try {
      await playerModule.closePlayer();
    } catch (e) {

    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();

    stopPlayer();
  }
  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {

      shoulilist();
      // Reach the bottom of the list - Load more data here
      //_loadMoreData();
    }
  }
  ///页面进入后台
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        stopPlayer();
        break;
    }
  }

  Future<HomeDetails?> _fetchDefalutData(int contentId) async {
    return await Get.put<ContentProvider>(ContentProvider()).Detail(contentId);
  }

  @override
  Widget build(BuildContext context) {
    // if (dataSource == null) {
    //   return Text("");
    // }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          titleTextStyle: const TextStyle(color: Colors.black),
          foregroundColor: Colors.black,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          leadingWidth: 25,
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  // if (widget.isEnd) {
                  //   Get.back();
                  //   return;
                  // }
                  Get.toNamed('/public/user', arguments: widget.dataSource!.userId);
                },
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(36),
                    color: Colors.black12,
                    image: DecorationImage(
                        image: NetworkImage(widget.dataSource!.userAvatar),
                        fit: BoxFit.cover),
                  ),
                  margin: const EdgeInsets.only(left: 10),
                  //child: Image.network(data.userAvatar,fit:BoxFit.cover),
                ),
              ),
              Container(
                height: 45,
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                  children: [
                    Text(widget.dataSource!.userName,),
                    if(dataSource!=null&&dataSource!.placeId!='')Row(
                      children: [
                        Container(
                          width: 10,
                          height: 12,
                          child: SvgPicture.asset(
                            "assets/icons/publish/position.svg",
                            color: Color(0xff999999),
                          ),
                        ),
                        SizedBox(width: 5,),
                        GestureDetector(child: Container(child: Text(dataSource!.placeName,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),constraints: BoxConstraints(maxWidth: 160,),),onTap:(){
                          Get.toNamed('/public/geographical',arguments: dataSource!.placeId);
                        },)
                      ],
                    )

                  ],
                ),
              )

            ],
          ),
          actions: [
            (dataSource!=null&&dataSource!.userId != userLogic.userId)?
            Center(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: userLogic.getFollow(dataSource!.userId)
                      ? Colors.white
                      : Colors.white,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  //设置四周边框
                  border: Border.all(
                      width: 1,
                      color: userLogic.getFollow(dataSource!.userId)
                          ? Color(0xfff1f1f1)
                          : Color(0xff000000)),
                ),
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                child: GestureDetector(
                    child: userLogic.getFollow(dataSource!.userId)
                        ? Text('已关注'.tr,
                        style: const TextStyle(
                            fontSize: 12, color: Color.fromRGBO(153, 153, 153, 1),fontWeight: FontWeight.w400))
                        : Text('关注'.tr,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.black,fontWeight: FontWeight.w700)),
                    onTap: () {
                      userLogic.setFollow(dataSource!.userId);
                      setState(() {});
                    }),
              ),
            ):Center(
              child: Container(
                margin: const EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
              ),
            ),
            GestureDetector(
              onTap: () {
                if (!userLogic.checkUserLogin()) {
                  if (playerModule.isPlaying) {
                    playerModule.pausePlayer();
                    suspendyp=true;
                    // _state = RecordPlayState.play;
                    setState(() {});
                  }
                  Get.toNamed('/public/loginmethod');
                  return;
                }
                AppLog('share',event: 'pic',targetid: widget.dataSource!.id);
                Get.put<ContentProvider>(ContentProvider()).ForWard(widget.dataSource!.id,1);
                Share.share('https://api.lanla.app/share?c=${widget.dataSource!.id}');
              },
              child: Container(
                alignment: Alignment.center,//pym_
                width: 40,
                child:
                Image.asset(
                  'assets/images/fenxiang.png',
                  width: 22,
                  height: 22,
                ),
                // const Icon(
                //   Icons.ios_share,
                //   size: 22,
                // ),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Container(color: Colors.white,child: Column(
          crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            //音频
            // if(dataSource!=null&&dataSource?.recordingPath!='')Container(
            //   margin: EdgeInsets.only(top: 20,left: 20,right: 20),
            //   width: MediaQuery.of(context).size.width / 2,
            //   height: 36,
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(40),
            //     color: Colors.red,
            //     gradient: new LinearGradient(
            //         begin: Alignment.centerRight,
            //         end: Alignment.centerLeft,
            //         colors: [
            //           Color(0xff474747),
            //           Color(0xff171717),
            //           Color(0xff0B0000),
            //         ]),
            //   ),
            //   // width: double.infinity,
            //   child: Row(children: [
            //     SizedBox(width: 20,),
            //     GestureDetector(child:Container(height: 36,child:
            //     !Startplaying || suspendyp?Image.asset('assets/images/kaily.png',width: 16,height: 16,)
            //         :Icon(
            //       Icons.pause_circle,
            //       color: Colors.white70,
            //       size: 22,
            //     )
            //       ,),onTap: (){
            //       if(!Startplaying){
            //         setState((){
            //           Startplaying=true;
            //         });
            //         startPlayer(dataSource?.recordingPath);
            //       }else if(Startplaying){
            //         pauseResumePlayer();
            //       }
            //
            //     },),
            //     SizedBox(width: 15,),
            //     Expanded(flex:1,child:
            //     Container(
            //       height: 16,
            //       decoration: BoxDecoration(
            //           image: DecorationImage(
            //             image: AssetImage('assets/images/yinbotwo.png',),
            //             fit: BoxFit.fill,
            //           )
            //       ),
            //       //assets/svg/yinbo.svg
            //     ),
            //     ),
            //     SizedBox(width: 15,),
            //     Text("${dataSource?.recordingTime}s",style: TextStyle(fontSize: 15,color: Colors.white,fontWeight: FontWeight.w600),),
            //     SizedBox(width: 20,),
            //   ],),
            //
            // ),
            // 标题和内容
            Container(
              margin: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              alignment: Alignment.topRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //     padding: const EdgeInsets.only(bottom: 5, right: 20),
                  //     child: Text(
                  //       widget.dataSource!.title.trim(),
                  //       style: const TextStyle(
                  //           fontSize: 16, fontWeight: FontWeight.w600),
                  //     )
                  //
                  // ),

                  Container(
                      // color: Colors.cyan,
                      width: double.infinity,
                      padding: const EdgeInsets.only(bottom: 5, right: 10,left: 10),
                      child:
                      // Text(
                      //   widget.dataSource!.text.trim(),
                      //   style: const TextStyle(
                      //       fontSize: 16, fontWeight: FontWeight.w400),
                      // ),
                      SingleChildScrollView(
                        child:
                          htmljx.HtmlWidget(
                              widget.dataSource!.text.trim(),
                              //"<section style=\"font-size: 16px; box-sizing: border-box; text-align: justify;\" class=\"ng-scope\"><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f89958876_1693907097.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: unset; line-height: 2; font-size: 20px; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 1px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"text-align: right; margin-top: 0px; margin-bottom: 1px; padding: 0px; box-sizing: border-box;\"><span style=\"font-size: 16px; box-sizing: border-box;\">في عالم اليوم، كثيرًا ما يُطلب منا شراء منتجات باهظة الثمن للعناية بالبشرة، ولكن هناك في الواقع العديد من خيارات العناية بالبشرة الطبيعية وبأسعار معقولة والتي تتمتع بالفعالية نفسها.</span></p><p style=\"margin-top: 0px; margin-bottom: 1px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 1px; padding: 0px; box-sizing: border-box;\"><span style=\"font-size: 18px; box-sizing: border-box;\">سأشارككم اليوم بعض النصائح للعناية بالبشرة والتي لا تكلفك المال.</span></p><p style=\"margin-top: 0px; margin-bottom: 1px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"text-align: right; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\">▌أطعمة لها تأثير إيجابي على صحة الجلد</strong></p></section><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f89c2e8a8_1693907100.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">1. الخضار والفواكه: غنية بالفيتامينات والمعادن ومضادات الأكسدة التي تساعد على حماية البشرة من أضرار الجذور الحرة. الفواكه الغنية بفيتامين C، مثل البرتقال والليمون والفراولة وغيرها، والخضروات الورقية الخضراء مثل السبانخ واللفت، مفيدة لصحة الجلد.</p></section><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\" powered-by=\"xiumi.us\"><br style=\"box-sizing: border-box;\"/></p><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f89e2e46b_1693907102.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">2. المكسرات: تحتوي على الأحماض الدهنية الصحية وفيتامين E ومضادات الأكسدة التي تساعد في الحفاظ على مرونة البشرة ونعومتها. على سبيل المثال، اللوز والجوز وبذور الكتان وبذور اليقطين كلها جيدة.</p></section><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\" powered-by=\"xiumi.us\"><br style=\"box-sizing: border-box;\"/></p><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f89f9c599_1693907103.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">3. الأسماك: تساعد الأسماك الغنية بأحماض أوميجا 3 الدهنية، مثل السلمون وسمك القد والسلمون، على تقليل التهاب الجلد والحفاظ على رطوبة البشرة وصحتها.</p></section><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\" powered-by=\"xiumi.us\"><br style=\"box-sizing: border-box;\"/></p><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f8a17485d_1693907105.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">4. مستخلص بذور العنب: إنه غني بمضادات الأكسدة، فهو يساعد على حماية البشرة من أضرار الجذور الحرة مع تعزيز إنتاج الكولاجين للمساعدة في الحفاظ على مرونة الجلد.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p></section><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f8a2c92de_1693907106.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">5. الشاي الأخضر: يحتوي على مضادات الأكسدة والمواد المضادة للالتهابات التي تساعد على حماية الجلد من التلف و تقليل الالتهابات.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">بالإضافة إلى ذلك، فإن الحفاظ على كمية جيدة من الترطيب، وتجنب السكر الزائد والأطعمة المصنعة، والحد من تناول الكافيين والكحول يمكن أن يساعد أيضًا في صحة الجلد.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p></section><section style=\"text-align: right; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">إن النظام الغذائي ليس سوى جزء من الحفاظ على صحة البشرة، كما أن الحفاظ على عادات جيدة للعناية بالبشرة مهم جدًا أيضًا.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\">▌العادات الجيدة للعناية بالبشرة</strong></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">1. التنظيف اللطيف: استخدمي منتجات تنظيف خفيفة لتنظيف البشرة، وتجنبي استخدام المنظفات المهيجة للغاية أو التي تحتوي على مكونات قلوية قوية. دلكيه بلطف على البشرة، ثم اشطفيه بالماء الفاتر، مع تجنب الماء الساخن.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">2. حافظ على الرطوبة: من المهم الحفاظ على رطوبة الجلد. استخدمي مرطبًا مناسبًا لنوع بشرتك وضعيه على بشرة نظيفة، خاصة بعد غسل الوجه والاستحمام. تأكدي أيضًا من حصولك على كمية كافية من الماء في نظامك الغذائي للحفاظ على رطوبة جسمك.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p></section><section style=\"text-align: unset; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">3. واقي الشمس: عندما تكوني بالخارج، استخدمي واقي الشمس لحماية بشرتك من الأشعة فوق البنفسجية. يمكنك اختيار واقي شمسي واسع النطاق يحمي من الأشعة فوق البنفسجية فئة A والأشعة فوق البنفسجية فئة B، واستخدامي عامل حماية من الشمس المناسب (30 على الأقل).</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">4. النوم الكافي: يساعد على إصلاح وتجديد خلايا الجلد. حاولي الحصول على 7-8 ساعات من النوم الجيد كل ليلة.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">5. تقليل التوتر: يمكن أن يؤثر التوتر طويل الأمد سلبًا على البشرة. يمكنك تجربة تقنيات فعالة لإدارة التوتر مثل التأمل وممارسة الرياضة وإدارة الوقت بشكل جيد.</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">6. لا تضغطي على البثور: تجنبي الضغط على البثور أو كسرها، مما قد يؤدي إلى الالتهاب والعدوى، ويترك ندبات وفرط تصبغ.</p></section><p style=\"white-space: normal; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\" powered-by=\"xiumi.us\"><br style=\"box-sizing: border-box;\"/></p><section class=\"V5\" style=\"position: static; box-sizing: border-box;\" powered-by=\"xiumi.us\"><section class=\"\" style=\"text-align: center; margin-top: 10px; margin-bottom: 10px; position: static; box-sizing: border-box;\"><img style=\"max-width: 100%; vertical-align: middle; box-sizing: border-box;\" class=\"\" src=\"https://cdn.lanla.app/uploadsPhp/admin_log_xiumiUpload/64f6f8a44b706_1693907108.jpg\"/>\n &nbsp;</section></section><section style=\"text-align: unset; line-height: 2; direction: rtl; box-sizing: border-box;\" powered-by=\"xiumi.us\"><p style=\"text-align: right; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">إذا كنت تعتقد أن هذا الموضوع مفيد ، فيرجى مشاركة هذه المقالة مع أصدقائك! دعهم يستفيدون أيضًا من المعرفة المهنية حول العناية بالبشرة منخفضة التكلفة😁✌🏻😁✌🏻</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">هل لديك أي طرق جيدة للعناية بالبشرة؟</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">مرحبًا بالجميع لنشر أو ترك رسالة للمناقشة✉️</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\">سنختار 3 مستخدمين محظوظين</strong></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\">200 عملة&nbsp;</strong><strong style=\"box-sizing: border-box;\">صدفة من LanLa لكل شخص&nbsp;╰(*°▽°*)╯</strong></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\"><span style=\"color: rgb(249, 110, 87); box-sizing: border-box;\">ويمكنك أيضًا الدخول مباشرة إلى قروب LanLa الرسمي</span></strong></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><strong style=\"box-sizing: border-box;\"><span style=\"color: rgb(249, 110, 87); box-sizing: border-box;\">ستكون هناك فرصة لطرح الأسئلة مباشرة على المشاهير 👍🏻💯</span></strong><br style=\"box-sizing: border-box;\"/></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><span style=\"color: rgb(95, 156, 239); box-sizing: border-box;\">https://chat.whatsapp.com/JOkTwPHR1OvIgRu2uUjokW</span></p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">دعونا نراكم في المرة القادمة ~ مع السلامة ~</p><p style=\"margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\">شكرا لكم على متابعتكم ودعمكم! 💓</p><p style=\"text-align: right; margin-top: 0px; margin-bottom: 0px; padding: 0px; box-sizing: border-box;\"><br style=\"box-sizing: border-box;\"/></p></section></section><p><br/></p>",
                              customWidgetBuilder: (element) {
                              if (element.localName == 'iframe') {
                                final videoUrl = element.attributes['src'];
                                if (videoUrl != null) {
                                  return _ButterFlyAssetVideo(
                                    data: videoUrl,
                                  );
                                }
                              }
                              if (element.localName == 'img'&&widget.dataSource!.text.trim().startsWith("<html>")) {
                                final pictureUrl = element.attributes['src'];
                                if (pictureUrl != null) {

                                    return Container(padding:EdgeInsets.only(top: 10,bottom: 10),width: double.infinity,alignment:Alignment.center,child: Container(
                                      width: element.attributes['style']!.contains('width:50%;')?MediaQuery.of(context).size.width*0.5:double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: pictureUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          width: MediaQuery.of(context).size.width,
                                          constraints: BoxConstraints(minHeight: 100),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              color: Color(0xffD1FF34),
                                              strokeWidth: 4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),);
                                }
                              }

                              if(element.localName == 'span'&&element.attributes['style']!.contains('color: rgb(95, 156, 239);')){

                                if (element.text.startsWith("https")) {
                                  return GestureDetector(child: Text(element.text,style: TextStyle(color:Color.fromRGBO(95, 156, 239,1) ),),onTap: () async {
                                    await launchUrl(
                                      Uri.parse(element.text),
                                      mode: LaunchMode.externalApplication,
                                    );
                                    // _launchUniversalLinkIos(Uri.parse('https://baidu.com/'),);
                                  },);
                                }
                                // else {
                                //   return Text('不是是连接');
                                // }

                              }

                              ///

                              // if(element.localName == 'section'&&element.attributes['style']!.contains('color: rgb(95, 156, 239);')){
                              //
                              //   var parsedHtml = htmlParser.parse(element.innerHtml);
                              //   // Find the <p> tag and get its text
                              //   var paragraphElement = parsedHtml.querySelector('p');
                              //   if (paragraphElement != null) {
                              //     var paragraphText = paragraphElement.text;
                              //     RegExp regex = RegExp(r'<app>(.*?)<app>');
                              //     Iterable<Match> matches = regex.allMatches(paragraphText);
                              //     String? extractedContent;
                              //     for (Match match in matches) {
                              //       extractedContent = match.group(1);
                              //       print('p标签里面的内容${extractedContent!.split(';')[0]}');
                              //     }
                              //     return extractedContent!=null?GestureDetector(child: Container(padding:EdgeInsets.only(top: 10,bottom: 10),width: double.infinity,alignment:Alignment.center,child: Container(
                              //       width: double.infinity,
                              //       child: CachedNetworkImage(
                              //         imageUrl: extractedContent!.split(';')[0]!,
                              //         fit: BoxFit.cover,
                              //         placeholder: (context, url) => Container(
                              //           width: MediaQuery.of(context).size.width,
                              //           constraints: BoxConstraints(minHeight: 100),
                              //           child: Center(
                              //             child: CircularProgressIndicator(
                              //               color: Color(0xffD1FF34),
                              //               strokeWidth: 4,
                              //             ),
                              //           ),
                              //         ),
                              //       ),
                              //     ),),onTap: (){
                              //       if (extractedContent!.split(';')[1] == '/public/video' ||
                              //           extractedContent!.split(';')[1] == '/public/picture') {
                              //         Get.toNamed(extractedContent!.split(';')[1],
                              //             arguments: {'data': int.parse(extractedContent!.split(';')[2]), 'isEnd': false});
                              //       } else {
                              //         Get.toNamed(
                              //           extractedContent!.split(';')[1],
                              //           arguments: int.parse(extractedContent!.split(';')[2]),
                              //         );
                              //       }
                              //     },):null;
                              //   }
                              //
                              // }
                              return null;
                            },

                          )
                        // webviewold.WebView(
                        //   initialUrl: 'https://jass.im/test',
                        //   javascriptMode: webviewold.JavascriptMode.unrestricted,
                        // )
                        // Container(height: 100,child: InAppWebView(
                        //   initialUrlRequest: URLRequest(url: Uri.parse('https://jass.im/test')),
                        // ),)

                      )

                  ),
                  if(dataSource!=null)TopicFormat(dataSource!.topics),
                  ///图文绑定礼物的位置
                  if(dataSource!=null && dataSource.goodsList.length>0)SizedBox(height: 15,),
                  if(dataSource!=null && dataSource.goodsList.length>0)Container(height: 60,width: double.infinity,
                    child: ListView(
                        shrinkWrap: true,
                        primary:false,
                        scrollDirection: Axis.horizontal,
                        children:[
                          for(var i=0;i<dataSource.goodsList.length;i++)
                            GestureDetector(child:Container(margin: EdgeInsets.only(left: 10),height: 60,padding: EdgeInsets.all(10),decoration: BoxDecoration(
                              color: Color(0xffFAFAFA),
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                            ),child: Row(children: [
                              Container(
                                width: 40,
                                height: 40,
                                //超出部分，可裁剪
                                clipBehavior: Clip.hardEdge,
                                //padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 0.5,color: Color(0xfff5f5f5))
                                ),
                                child: Image.network(
                                  dataSource.goodsList[i].thumbnail,
                                  fit: BoxFit.cover,
                                  width: 40,
                                  height: 40,
                                ),
                              ),
                              SizedBox(width: 8,),
                              Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children: [
                                Container(constraints: BoxConstraints(maxWidth: 250,),child:
                                Text(dataSource.goodsList[i].title,overflow: TextOverflow.ellipsis,
                                  maxLines: 1,style: TextStyle(fontSize: 14),),),
                                SizedBox(height: 5,),
                                XMStartRatingtwo(rating: double.parse(dataSource.goodsList[i].score) ,showtext:true)
                              ],)
                            ],),),onTap: (){
                              if (!userLogic.checkUserLogin()) {
                                Get.toNamed('/public/loginmethod');
                                return;
                              }
                              Get.toNamed('/public/Evaluationdetails',arguments: {'data':dataSource.goodsList[i]} );
                            },)
                        ]),
                  ),
                  SizedBox(height: 15,),
                  if(dataSource!=null)Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataSource!.createdAt ?? "today",
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black38),
                        ),
                        GestureDetector(
                          onTap: () {
                            if (!userLogic.checkUserLogin()) {
                              if (playerModule.isPlaying) {
                                playerModule.pausePlayer();
                                suspendyp=true;
                                // _state = RecordPlayState.play;
                                setState(() {});
                              }
                              Get.toNamed('/public/loginmethod');
                              return;
                            }
                            ReportDoglog(ReportType.content, dataSource!.id,1,dataSource!.imagesPath, context,removeCallbak: (){
                              eventBus.fire(UploadContentListEvent());
                              Get.back();
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 20),
                            height: 29,
                            width: 38,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              //设置四周圆角 角度
                              borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                              //设置四周边框
                              border:
                              Border.all(width: 0.2, color: Colors.black38),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // const Icon(
                                //   Icons.sentiment_very_dissatisfied,
                                //   size: 10,
                                //   color: Colors.black38,
                                // ),
                                Container(
                                  width: 16,
                                  height: 16,
                                  child: SvgPicture.asset(
                                    "assets/svg/buxihuan.svg",
                                  ),
                                ),
                                SizedBox(width: 0,),
                                // Text(
                                //   '举报'.tr,
                                //   style: const TextStyle(
                                //       fontSize: 10,
                                //       color: Colors.black38,
                                //       height: 1.4),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if(dataSource!=null)Container(
                    margin: const EdgeInsets.only(left: 0, right: 0, top: 25, bottom: 25),
                    color: Colors.black38,
                    height: 0.1,
                  ),
                  if(dataSource!=null)Container(
                    margin: const EdgeInsets.only(left: 20,bottom: 15, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          dataSource!.comments.toString() + ' ' + '条评论'.tr,
                          style: TextStyle(
                              color: HexColor('727272'), fontSize: 14),
                        ),
                        GestureDetector(child: Image.asset('assets/images/luwulist.png',width: 32,height: 32,),onTap: (){


                          giftlist(context);
                        },)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 0),
                    child: Container(),
                  ),
                  //CommentWidget.ListRender(state.commentList),
                ],
              ),
            ),
            // 评论
            if(dataSource!=null)CommentWidget(dataSource!.id,'',[],[],updateCommentCallbak: () {
              updateCommentTotal();
            })
          ],
        ),),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(width: 0.3, color: Colors.black12),
            )),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (!userLogic.checkUserLogin()) {
                    if (playerModule.isPlaying) {
                      playerModule.pausePlayer();
                      suspendyp=true;
                      // _state = RecordPlayState.play;
                      setState(() {});
                    }
                    Get.toNamed('/public/loginmethod');
                    return;
                  }
                  CommentDiolog(widget.dataSource!.id,
                      parentCallback: (CommentParent data) {
                        Get.find<CommentLogic>().newParent(data);
                        updateCommentTotal();
                      }, childCallback: (CommentChild datObj) {
                        updateCommentTotal();
                      });
                },
                child: Container(
                  height: 44,
                  margin: EdgeInsets.only(left: 20,right: 20),
                  padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
                  decoration: BoxDecoration(
                    color: HexColor('#F5F5F5'),
                    //设置四周圆角 角度
                    borderRadius: const BorderRadius.all(Radius.circular(40)),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/svg/bi.svg',width: 18,height: 18,),
                      SizedBox(width: 8,),
                      Text(
                        '${'说点什么'.tr}...',
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xff999999)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Container(
              //change
              // padding: const EdgeInsets.only(left: 10),
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (!userLogic.checkUserLogin()) {
                        if (playerModule.isPlaying) {
                          playerModule.pausePlayer();
                          suspendyp=true;
                          // _state = RecordPlayState.play;
                          setState(() {});
                        }
                        Get.toNamed('/public/loginmethod');
                        return;
                      }
                      bool status = userLogic.setLike(widget.dataSource!.id);
                      // widget.dataSource!.likes = status
                      //     ? widget.dataSource!.likes + 1
                      //     : widget.dataSource!.likes - 1;
                      widget.dataSource!.likes = status
                          ? widget.dataSource!.likes
                          : widget.dataSource!.likes;
                      setState(() {});
                      eventBus.fire(UpdateHomeItemList(status, widget.dataSource!.id));
                    },
                    child:Container(color: Colors.transparent,margin:EdgeInsets.only(left: 20),child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        userLogic.getLike(widget.dataSource!.id)
                            ?
                        // SvgPicture.asset('assets/svg/heart_sel_new.svg', width: 24, height: 24)
                        Image.asset(
                          'assets/images/xin.png',
                          width: 24,
                          height: 24,
                        )
                            :
                        // SvgPicture.asset('assets/svg/pinglun_heart_nor_new.svg', width: 24, height: 24),
                        Image.asset(
                          'assets/images/noxin.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 5,),//pym_
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Text(
                            widget.dataSource!.likes.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff999999)),
                          ),
                        )
                      ],
                    ) ,) ,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!userLogic.checkUserLogin()) {
                        if (playerModule.isPlaying) {
                          playerModule.pausePlayer();
                          suspendyp=true;
                          // _state = RecordPlayState.play;
                          setState(() {});
                        }
                        Get.toNamed('/public/loginmethod');
                        return;
                      }
                      widget.dataSource!.collects =
                      userLogic.setCollect(widget.dataSource!.id)
                          ? widget.dataSource!.collects + 1
                          : widget.dataSource!.collects - 1;
                      setState(() {});
                    },
                    child: Container(
                      color: Colors.transparent,margin:EdgeInsets.only(left: 20),child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        userLogic.getCollect(widget.dataSource!.id)
                            ? Image.asset(
                          'assets/images/shou.png',
                          width: 24,
                          height: 24,
                        )
                            : Image.asset(
                          'assets/images/noshou.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 5,),//pym_
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Text(
                            widget.dataSource!.collects.toString(),
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff999999)),
                          ),
                        )
                      ],
                    ),),
                  ),
                  GestureDetector(
                    onTap: (){
                      if (!userLogic.checkUserLogin()) {
                        if (playerModule.isPlaying) {
                          playerModule.pausePlayer();
                          suspendyp=true;
                          // _state = RecordPlayState.play;
                          setState(() {});
                        }
                        Get.toNamed('/public/loginmethod');
                        return;
                      }
                      CommentDiolog(widget.dataSource!.id,
                          parentCallback: (CommentParent data) {
                            Get.find<CommentLogic>().newParent(data);
                            updateCommentTotal();
                          }, childCallback: (CommentChild datObj) {
                            updateCommentTotal();
                          });
                    },
                    child:Container(color: Colors.transparent,margin:EdgeInsets.only(left: 0),child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/pinglun.png',
                          width: 24,
                          height: 24,
                        ),
                        const SizedBox(height: 5,),//pym_
                        Padding(
                          padding: const EdgeInsets.only(left: 0, right: 0),
                          child: Text(
                            dataSource!=null?dataSource!.comments.toString():'0',
                            style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff999999)),
                          ),
                        )
                      ],
                    ),),
                  ),
                  ///礼物
                  GestureDetector(
                    onTap: ()  {
                      if (!userLogic.checkUserLogin()) {
                        if (playerModule.isPlaying) {
                          playerModule.pausePlayer();
                          suspendyp=true;
                          // _state = RecordPlayState.play;
                          setState(() {});
                        }
                        Get.toNamed('/public/loginmethod');
                        return;
                      }
                      if(Giftlist.length>0){
                        giftshowBottomSheet(context);
                      }
                    },
                    child:Container(
                      color: Colors.transparent,
                      margin: const EdgeInsets.only(left: 20,right: 20),//pym_
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
            ),
          ],
        ),
      ),
    );
  }



  ///礼物弹窗
  ///底部弹窗
  void giftshowBottomSheet(context) {
    // if(Platform.isAndroid){
    int _current = 0;
    final CarouselController _controller = CarouselController();
    //用于在底部打开弹框的效果
    showModalBottomSheet(
        isScrollControlled: false,
        enableDrag:false,
        // isDismissible:false,
        builder: (BuildContext context) {
          //构建弹框中的内容
          return StatefulBuilder(
              builder: (context1, setBottomSheetState) {
                return Container(

                  height: MediaQuery.of(context).size.height/2 + 40,
                  decoration: new BoxDecoration(
                      color: Colors.white,
                      borderRadius: new BorderRadius.only(
                          topLeft: const Radius.circular(10.0),
                          topRight: const Radius.circular(10.0))
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
                    SizedBox(height: 10,),
                    Container(
                      width: 25,
                      height: 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10),),
                          color: Color(0xffe4e4e4)
                      ),
                    ),
                    SizedBox(height: 15,),
                    Container(padding: EdgeInsets.only(left: 20,right: 20),alignment: Alignment.centerRight,child:Text('礼物'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),) ,),
                    SizedBox(height: 22,),
                    Container(child: CarouselSlider(
                      options: CarouselOptions(
                          height: 200,
                          viewportFraction:1,
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
                          .map((item) => Container(
                        padding: EdgeInsets.only(left: 12,right: 12),
                        width: double.infinity,
                        child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            children: [
                              for(var i=0;i<item.length;i++)
                                GestureDetector(child:Container(decoration:BoxDecoration(
                                    border: Border.all(width: 1,color: giftItem.id==item[i].id?Colors.black:Colors.white),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                                ),width: (MediaQuery.of(context).size.width - 54) / 4,height: 100,
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Column(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      // Container(width: 50,height: 50,color: Colors.red,),
                                      Image.network(item[i].imagePath,width: 50,height: 50,),
                                      Row(children: [
                                        Image.asset(item[i].type==1?'assets/images/jinbi.png':'assets/images/beike.png',width: 15,height: 15,),
                                        SizedBox(width: 5,),
                                        Text(item[i].price.toString(),style: TextStyle(fontSize: 12),)
                                      ],)
                                    ],),
                                ),onTap: (){
                                  setBottomSheetState(() {
                                    giftItem=item[i];
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
                      children: Giftlist.asMap().entries.map((entry) {
                        return GestureDetector(
                          onTap: (){},
                          child: Container(
                            width: 5.0,
                            height: 5.0,
                            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                    .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 20,),
                    Container(child: Row(
                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(child:
                        Container(padding: EdgeInsets.fromLTRB(30, 8, 30, 8),
                          child: Text('赠送'.tr,style: TextStyle(color: Colors.white),),decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),color: Colors.black,
                          ),),onTap: () async {
                          if(jieliu){
                            setBottomSheetState(() {
                              jieliu=false;
                            });
                            if(giftItem.type==1){
                              if(giftItem.price>int.parse(Balancequery['laGold'])){
                                ToastInfo("余额不足".tr);
                                setBottomSheetState(() {
                                  jieliu=true;
                                });
                                return;
                              }
                            }else if(giftItem.type==3){
                              if(giftItem.price>int.parse(Balancequery['nacre'])){
                                ToastInfo("余额不足".tr);
                                setBottomSheetState(() {
                                  jieliu=true;
                                });
                                return;
                              }
                            }
                            var givingifts = await provider.Givingifts(widget.dataSource.id,giftItem.id);
                            if(givingifts.statusCode==200){
                              setBottomSheetState(() {
                                if(giftItem.type==1){
                                  Balancequery['laGold']=givingifts.body['balance'].toString();
                                }else if(giftItem.type==3){
                                  Balancequery['nacre']=givingifts.body['balance'].toString();
                                }
                              });
                              shoulilist();
                              songift(context,givingifts.body['imagePath']);
                              Timer.periodic(
                                  Duration(milliseconds: 2000),(timer){
                                Navigator.pop(context);
                                timer.cancel();//取消定时器
                              }
                              );
                            }
                            setBottomSheetState(() {
                              jieliu=true;
                            });

                          }

                        },),
                        Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50.0)),color: Color(0xfff5f5f5),
                        ),padding: EdgeInsets.fromLTRB(15, 0, 15, 0),height: 35,child: Row(children: [
                          Image.asset(giftItem.type==1?'assets/images/jinbi.png':'assets/images/beike.png',width: 15,height: 15,),
                          SizedBox(width: 5,),
                          Container(child: Text(giftItem.type==1?Balancequery['laGold'].toString():Balancequery['nacre'].toString(),style: TextStyle(
                              color: giftItem.type==1?Color(0xffFFA800):Color(0xffFFA8C7),fontWeight: FontWeight.w600
                          ),),),
                          SizedBox(width: 10,),
                          GestureDetector(child:Text(giftItem.type==1?'充值la币'.tr:'贝壳'.tr,style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600),),onTap: (){
                            Navigator.pop(context);
                            if(giftItem.type==1){
                              Get.to(AmountPage(),arguments: 1);
                            }else{
                              Get.to(AmountPage(),arguments: 2);
                            }
                          },),
                          SizedBox(width: 10,),
                          SvgPicture.asset(
                            "assets/icons/publish/arrow.svg",
                            width: 10,
                            height: 10,
                          ),
                        ],)),
                      ],
                    ),padding: EdgeInsets.only(left: 20,right: 20)),
                    SizedBox(height: 20,),
                  ]),

                );
              }
          );
        },
        backgroundColor: Colors.transparent, //重要
        context: context).then((value){
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
    //             height: MediaQuery.of(context).size.height/2 + 40,
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
  /**
   * 顶部轮播图
   */
  Widget _swiper(BuildContext context, imageList, attaImageScale) {
    double defultHeight = MediaQuery.of(context).size.width * attaImageScale;
    if (defultHeight > 500) {
      defultHeight = 500;
    }
    bool isOne = imageList.length == 1 ? true : false;
    return ConstrainedBox(
        constraints: BoxConstraints.loose(Size(
            MediaQuery.of(context).size.width,
            defultHeight + (isOne ? 0 : 32))),
        child: isOne
            ? ImageCacheWidget(imageList[0],defultHeight + (isOne ? 0 : 32))
            : Swiper(
          outer: true,
          itemBuilder: (c, i) {
            return CachedNetworkImage(imageUrl: imageList[i],progressIndicatorBuilder: (context, url, downloadProgress) =>
                Container(
                  width:  MediaQuery.of(context).size.width,
                  //height: height,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffD1FF34),
                      strokeWidth: 4,
                    ),
                  ),
                ),);
            // return ImageCacheWidget(imageList[i]);
          },

          onIndexChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          pagination: const SwiperPagination(
              margin: EdgeInsets.all(10),
              builder: DotSwiperPaginationBuilder(
                color: Colors.black12,
                activeColor: Colors.black,
                size: 5,
                activeSize: 6,
              )),
          itemCount: imageList.length,
        ));
  }

  // 更新当前图片评论数
  updateCommentTotal() async {
    Future.delayed(Duration(seconds: 1), () async {
      HomeDetails? newData = await contentProvider.Detail(dataSource!.id);
      setState(() {
        dataSource!.comments = newData!.comments;
      });
    });
  }

  ///送出的礼物
  Future<void> songift(context,image) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.transparent,

                  width: 270,
                  height: 270,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(children: [
                    SizedBox(height: 40,),
                    Image.network(image,width: 150,height: 150,),
                    SizedBox(height: 22,),
                    Text('赠送成功'.tr,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),)
                  ],),
                ),
              ]),
        );
      },
    );
  }



  ///收到礼物的列表
  Future<void>giftlist (context) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {

        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              Future<void> _updateList() async {
                if(jieliu){

                  jieliu=false;

                  var res= await contentProvider.contentGiftDetail(Receivinggiftspage,widget.dataSource.id);
                  if(res.statusCode==200){
                    var st =(getGiftAnalysisFromJson(res?.bodyString ?? ""));
                    if(st.length>0){
                      setState(() {
                        Receivinggiftspage++;
                        Receivinggiftsdata.addAll(st);
                      });
                      // setBottomSheetState(() {
                      //   giftItem=item[i];
                      // });
                    }
                    // print(result.statusCode);
                    // update();
                  }
                  jieliu=true;
                }
              }
              _scrollController.addListener(()=>{
                if(_scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent){
                  // print('下一页了'),
                  // print('进来了'),
                  _updateList()
                }
              });
              return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(width: MediaQuery.of(context).size.width-100,
                      // constraints: BoxConstraints(
                      //   maxHeight: 436,
                      // ),
                      height: 436,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.white, borderRadius:BorderRadius.all(Radius.circular(20))
                      ),
                      // decoration: BoxDecoration(
                      //   image: DecorationImage(
                      //     image: AssetImage('assets/images/gengxtc.png'),
                      //     fit: BoxFit.fill, // 完全填充
                      //   ),
                      // ),
                      child: Column(
                        children: [
                          GestureDetector(child: Container(alignment: Alignment.centerRight,child: SvgPicture.asset("assets/svg/cha.svg", color: Colors.black, width:12, height: 12,),),onTap: (){
                            Navigator.pop(context);
                          },),
                          SizedBox(height: 5,),
                          Text('收到'.tr,style: TextStyle(fontWeight: FontWeight.w700),),
                          SizedBox(height: 5,),
                          Expanded(child:

                          Receivinggiftsdata.length>0?ListView(controller: _scrollController,physics: BouncingScrollPhysics(),children: [
                            for(var i=0;i<Receivinggiftsdata.length;i++)
                              Container(margin: EdgeInsets.only(top: 20),child:  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                                //Image.network('',width: 40,height: 40,),
                                Row(children: [
                                  Container(clipBehavior: Clip.hardEdge,width: 40,height: 40,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50))),child: Image.network(Receivinggiftsdata[i].headimg,fit: BoxFit.cover,),),
                                  SizedBox(width: 10,),
                                  Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                    Text(Receivinggiftsdata[i].nickname,style: TextStyle(),),
                                    SizedBox(height: 5,),
                                    Row(children: [
                                      if (Receivinggiftsdata[i].sex == 1)
                                        Container(
                                          alignment: Alignment.center,
                                          width: 24,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      20)),
                                              color: Color(0xfff5f5f5)),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            child: Image.asset(
                                                'assets/images/nanIcon.png',
                                                width: 10.0,
                                                height: 10.0),
                                          ),
                                        ),
                                      if (Receivinggiftsdata[i].sex == 2)
                                        Container(
                                          alignment: Alignment.center,
                                          width: 24,
                                          height: 16,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.all(
                                                  Radius.circular(
                                                      20)),
                                              color: Color(0xfff5f5f5)),
                                          child: Container(
                                            width: 10,
                                            height: 10,
                                            child: Image.asset(
                                                'assets/images/nvIcon.png',
                                                width: 10.0,
                                                height: 10.0),
                                          ),
                                        ),
                                      SizedBox(width: 5,),
                                      if(Receivinggiftsdata[i].level == 1)Container(alignment: Alignment.center,width: 50,height: 16,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/lv1.png',width: 10,height: 10,),SizedBox(width: 4,),Text('1',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                      ),),
                                      if(Receivinggiftsdata[i].level == 2)Container(alignment: Alignment.center,width: 50,height: 16,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/lv2.png',width: 10,height: 10,),SizedBox(width: 4,),Text('2',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                      ),),
                                      if(Receivinggiftsdata[i].level == 3)Container(alignment: Alignment.center,width: 50,height: 16,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/lv3.png',width: 10,height: 10,),SizedBox(width: 4,),Text('3',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],

                                      ),),
                                      if(Receivinggiftsdata[i].level == 4)Container(alignment: Alignment.center,width: 50,height: 16,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/lv4.png',width: 10,height: 10,),SizedBox(width: 4,),Text('4',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],
                                      ),),
                                      if(Receivinggiftsdata[i].level == 5)Container(alignment: Alignment.center,width: 50,height: 16,decoration:BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20)),color: Color(0xfff5f5f5)),child: Row(mainAxisAlignment:MainAxisAlignment.center,
                                        children: [
                                          Image.asset('assets/images/lv5.png',width: 10,height: 10,),SizedBox(width: 4,),Text('5',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),),Text('Lv',style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,fontFamily: 'Baloo Bhai 2',color: Color(0xffd9d9d9)),)],
                                      ),),

                                    ],)
                                  ],)
                                ],),
                                Row(
                                  children: [
                                    Text(Receivinggiftsdata[i].giftCount.toString(),style: TextStyle(fontFamily: 'Droid Arabic Kufi',fontSize: 15),),
                                    SizedBox(width: 6,),
                                    Text('x',style: TextStyle(fontFamily: 'Droid Arabic Kufi',fontSize: 15,fontWeight: FontWeight.w700),),
                                    SizedBox(width: 6,),
                                    Image.network(Receivinggiftsdata[i].imagePath,width: 38,height: 38,)
                                  ],
                                )
                              ],),),
                          ],):Column(children: [
                            SizedBox(height: 45,),
                            Image.asset('assets/images/nodatashuju.png',width: 148,height: 148,),
                            SizedBox(height: 30,),
                            Text('暂无好友送礼'.tr,style: TextStyle(fontSize: 12),),
                            SizedBox(height: 15,),
                            Text('快去给她的作品进行打赏吧'.tr,style: TextStyle(fontSize: 12)),
                          ],)
                          )
                        ],
                      ),)
                  ]);
            },
          ),
        );
      },
    );


    // return showDialog<void>(
    //   context: context,
    //   barrierDismissible: true, // user must tap button!
    //   builder: (BuildContext context) {
    //
    //     return AlertDialog(
    //       backgroundColor: Colors.transparent,
    //       contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
    //       shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
    //       content: Column(
    //           mainAxisSize: MainAxisSize.min,
    //           children: [
    //             Container(
    //               //color: Colors.transparent,
    //               //color: Colors.red,
    //               // height: 280,
    //               child:Column(
    //                 mainAxisAlignment:MainAxisAlignment.center,
    //                 children: [
    //                   Container(
    //                       width: MediaQuery.of(context).size.width-100,
    //                       //height: 311,
    //                       // decoration: BoxDecoration(
    //                       //   image: DecorationImage(
    //                       //     image: AssetImage('assets/images/gengxtc.png'),
    //                       //     fit: BoxFit.fill, // 完全填充
    //                       //   ),
    //                       // ),
    //                       child: Stack(children: [
    //                         Image.asset('assets/images/dianzanbj.png',width: MediaQuery.of(context).size.width-100,),
    //                         Positioned(
    //                           bottom: 10,
    //                           left: 0,
    //                           right: 0,
    //                           child: Column(
    //                             children: [
    //                               Text('喜欢LanLa吗？'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
    //                               Container(
    //                                 width: MediaQuery.of(context).size.width-140,
    //                                 margin: EdgeInsets.fromLTRB(40, 15, 40, 0),
    //                                 child: Text('LanLa的成长需要你的支持，我们诚恳希望能得到你的鼓励与评价，因为你的每一次鼓励能让我们做得更好。'.tr,maxLines: 4,style: TextStyle(
    //                                     fontSize: 12,
    //                                     color: Color(0xff999999)
    //                                 )),
    //                               ),
    //
    //                               GestureDetector(child:Container(
    //                                 alignment: Alignment.center,
    //                                 padding: EdgeInsets.only(top: 12,bottom: 12),
    //                                 width: MediaQuery.of(context).size.width-180,
    //                                 margin: EdgeInsets.fromLTRB(40, 10, 40, 10),
    //                                 decoration: BoxDecoration(
    //                                   borderRadius: BorderRadius.circular(40),
    //                                   color: Colors.black,
    //                                   boxShadow: [
    //                                     BoxShadow(
    //                                       color: Color(0xFF55D200),
    //                                       offset: Offset(0, 1),
    //                                       blurRadius: 1,
    //                                       spreadRadius: 0,
    //                                     ),
    //                                   ],
    //                                 ),
    //
    //                                 child: Text('五星好评'.tr,style: TextStyle(color: Colors.white,),),
    //                               ),onTap: () async {
    //                                 var shuju = await SharedPreferences.getInstance();
    //                                 shuju.setBool("isevaluate", true);
    //                                 Navigator.pop(context);
    //                                 if (Platform.isAndroid) {
    //                                   _launchUniversalLinkIos(Uri.parse("market://details?id=lanla.app"));
    //                                 } else if (Platform.isIOS) {
    //                                   _launchUniversalLinkIos(Uri.parse("itms-apps://apps.apple.com/tr/app/times-tables-lets-learn/id6443484359?l=tr"));
    //                                 }
    //
    //                               },),
    //                               GestureDetector(child:Text('我要反馈与建议'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 12),),onTap: () async {
    //                                 var shuju = await SharedPreferences.getInstance();
    //                                 shuju.setBool("isevaluate", true);
    //                                 Navigator.pop(context);
    //                                 //Get.toNamed('/public/loginmethod');
    //                                 Get.to(FeedbackWidget());
    //                               },),
    //                               SizedBox(height: 25,),
    //                             ],
    //                           ),
    //                         )
    //                       ],)
    //                   )
    //                 ],),),
    //           ]),
    //     );
    //   },
    // );
  }

  Future<void> _launchUniversalLinkIos(Uri url) async {
    //启动APP 功能。可以带参数，如果启动原生的app 失败
    final bool nativeAppLaunchSucceeded = await launchUrl(
      url,
      //mode: LaunchMode.externalNonBrowserApplication,
    );
    //启动失败的话就使用应用内的webview 打开
    if (!nativeAppLaunchSucceeded) {
      await launchUrl(
        url,
        //mode: LaunchMode.inAppWebView,
      );
    }
  }

}

/**
 * 这个页面需要优化！当前使用了全局getx渲染，应按照单独widget渲染
 */

/// 5星评分的展示的小组件 -- 支持不同数量的星星、颜色、大小等
class XMStartRatingtwo extends StatelessWidget {
  final int count; // 星星的数量，默认是5个
  final double rating; // 获得的分数
  final double totalRating; // 总分数
  final Color unSelectColor; // 未选中的颜色
  final Color selectColor; // 选中的颜色
  final double size; // 星星的大小
  final double spacing; // 星星间的间隙
  final bool showtext; // 星星间的间隙
  // 自定义构造函数
  XMStartRatingtwo({
    required this.rating,
    required this.showtext,
    this.totalRating = 5,
    this.unSelectColor = Colors.blue,
    this.selectColor = Colors.red,
    this.size = 12,
    this.count = 5,
    this.spacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 12,
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        children: [
          if(this.showtext)Text("${this.rating}",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w600,color: Color(0xff9BE400),height: 1.2),),
          if(this.showtext)SizedBox(width: 5,),
          Stack(
            children: [
              getUnSelectStarWidget(),
              getSelectStarWidget(),
            ],
          ),

        ],
      ),
    );
  }

  // 获取背景：未填充的星星
  List<Widget> _getUnSelectStars() {
    return List<Widget>.generate(this.count, (index) {
      return Icon(Icons.star_outline_rounded,size: size,color: Color(0xffD9D9D9),);
    });
  }

  // 填充星星
  List<Widget> _getSelectStars() {
    return List<Widget>.generate(this.count, (index) {
      return Icon(Icons.star, size: size, color: Color(0xFF9BE400),);
    });
  }

  // 获取背景星星的组件
  Widget getUnSelectStarWidget() {
    return  Wrap(
      spacing: this.spacing,
      alignment: WrapAlignment.spaceBetween,
      children: _getUnSelectStars(),
    );
  }

  // 获取针对整个选中的星星裁剪的组件
  Widget getSelectStarWidget() {
    // 应该展示几个星星 --- 例如：4.6个星星
    final double showStarCount = this.count * (this.rating/this.totalRating);
    final int fillStarCount = showStarCount.floor();// 满星的数量

    final double halfStarCount = showStarCount - fillStarCount; // 半星的数量
    // 最终需要裁剪的宽度
    final double clipWith = fillStarCount*(this.size + this.spacing) + halfStarCount*this.size;
    return ClipRect(
      clipper: XMStarClippertwo(clipWith),
      child: Container(
        child: Wrap(
          textDirection: TextDirection.ltr,
          spacing: this.spacing,
          //alignment: WrapAlignment.center,
          children: _getSelectStars(),
        ),
      ),
    );
  }
}
// 获取裁剪过的星星
class XMStarClippertwo extends CustomClipper<Rect> {
  double clipWidth;
  XMStarClippertwo(this.clipWidth);
  @override
  Rect getClip(Size size) {
    return Rect.fromLTRB(size.width-clipWidth, 0, size.width, size.height);
    //return Rect.fromLTRB(0, 0, clipWidth, size.height);
  }
  @override
  bool shouldReclip(XMStarClippertwo oldClipper) {
    // TODO: implement shouldReclip
    return clipWidth != oldClipper.clipWidth;
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
    _controller = VideoPlayerController.network(widget.data);
    _controller.initialize().then((_) => setState(() {}));
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
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(0),
            ), clipBehavior: Clip.hardEdge,
            child: Column(
              children: <Widget>[
                Container(
                  // width: 200,
                  width: MediaQuery.of(context).size.width,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        _controller.value.isInitialized
                            ? VideoPlayer(_controller)
                            : Container(),
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
            )
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
      },)
      ,
    );
  }

}