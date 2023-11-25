import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/Productlabellist.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/commoditylike.dart';
import 'package:lanla_flutter/pages/home/shoppingmall/sommoditysearch.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';
import 'package:tcard/tcard.dart';
import 'package:url_launcher/url_launcher.dart';

class shoppingPage extends StatefulWidget {
  createState() => _shoppingState();
}

class _shoppingState extends State<shoppingPage>  with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;
  final provider = Get.find<ContentProvider>();
  final userLogic = Get.find<UserLogic>();
  ScrollController _allscrollController = ScrollController();
  ScrollController _specialscrollController = ScrollController();
  ScrollController _personalscrollController = ScrollController();
  FocusNode _focusNode = FocusNode();
  TCardController SecretCollection = TCardController();
  int currentIndex = 0; // 当前轮播项索引
  bool oneData = false;
  var  cardData = [];

  var specialofferdata = [];

  var alllistdata = [];
  var PromptDescription ='';

  var allPage=1;
  var specialPage=1;
  var personalPage=1;

  var xunidata={};

  void initState() {
    super.initState();
    initial();
    _allscrollController.addListener((){
      if (_allscrollController.position.pixels ==
          _allscrollController.position.maxScrollExtent) {
        // 当滚动到底部时触发加载更多的操作
        alldatalist();
      }
    });
    _specialscrollController.addListener((){
      if (_specialscrollController.position.pixels ==
          _specialscrollController.position.maxScrollExtent) {
        // 当滚动到底部时触发加载更多的操作
        specialdatalist();
      }
    });
  }
  @override
  void dispose() {
    _allscrollController.dispose();
    _specialscrollController.dispose();
    super.dispose();
  }

  initial() async {
    alldatalist();
    specialdatalist();
    personaldatalist();
    await commoditybox();

    oneData=true;
    setState(() {

    });
  }
  alldatalist() async {
    var res=await provider.commoditylist(allPage,jsonEncode([]),0);
    if(res.statusCode==200){
      if(res.body['data'].length>0){
        allPage++;
        if(alllistdata.length==0){
          alllistdata=res.body['data'];
        }else{
          alllistdata=[...alllistdata,...res.body['data']];
        }
        setState(() {});
      }
    }
  }
  specialdatalist() async {
    var specialofferres=await provider.commoditylist(specialPage,jsonEncode([1]),0);
    if(specialofferres.statusCode==200){
      if(specialofferres.body['data'].length>0){
        specialPage++;
        if(specialofferdata.length==0){
          specialofferdata=specialofferres.body['data'];
        }else{
          specialofferdata=[...specialofferdata,...specialofferres.body['data']];
        }
        setState(() {});
      }
    }
  }
  personaldatalist() async {
    var privateres=await provider.commoditylist(personalPage,jsonEncode([2]),3);
    if(privateres.statusCode==200){
      if(privateres.body['data'].length>0){
         personalPage++;
        if(cardData.length==0){
          cardData=privateres.body['data'];
        }else{
          cardData=[...cardData,...privateres.body['data']];
        }
        setState(() {});
      }
    }
  }

  commoditybox() async {
    var boxdata=await provider.commoditybox();
    if(boxdata.statusCode==200){
      xunidata=boxdata.body;
    }
  }

  Future<void> _launchUniversalLinkIos(Uri url,Uri httpurl) async {
    try {
      print('启动成功:${url}');
      final bool nativeAppLaunchSucceeded = await launchUrl(
        url,
        mode: LaunchMode.externalNonBrowserApplication,
      );
      // 失败后使用浏览器打开,未捕捉到异常时
      if(!nativeAppLaunchSucceeded){
        bool isUrl = await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
        if(!isUrl){
          print('浏览器也失败了');
        }
      }
      print('是否成功');
      print(nativeAppLaunchSucceeded);
    } catch(e) {
      print('失败了');
      // 失败后使用浏览器打开,未捕捉到异常时
      await launchUrl(httpurl,mode: LaunchMode.externalApplication,);
    }
  }
  commoditylikeandno(id,is_like) async {
    var likestate=await provider.commoditylike({'id':id,'is_like':is_like});
    if(likestate.statusCode==200){

    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // GestureDetector(
              //     onTap: () {},
              //     child: Container(
              //       // margin: const EdgeInsets.fromLTRB(0,0,0,0),
              //       child: SvgPicture.asset(
              //         'assets/icons/fuji.svg',
              //         width: 22,
              //         height: 22,
              //       ),
              //     )),
              // Expanded(
              //   child: Container(
              //     margin: const EdgeInsets.only(left: 10, right: 0),
              //     height: 36,
              //     child: TextField(
              //       style: TextStyle(fontSize: 13),
              //       focusNode: _focusNode,
              //       decoration: InputDecoration(
              //           // enabled: false, // 禁止编辑和小键盘弹出
              //           hintStyle: const TextStyle(color: Color(0xff999999)),
              //           contentPadding:
              //               const EdgeInsets.only(top: 0, bottom: 0),
              //           border: InputBorder.none,
              //           hintText: '输入搜索内容'.tr,
              //           fillColor: const Color(0xFF999999).withAlpha(20),
              //           enabledBorder: const OutlineInputBorder(
              //             /*边角*/
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(20), //边角为5
              //             ),
              //             borderSide: BorderSide(
              //               color: Colors.white, //边线颜色为白色
              //               width: 0, //边线宽度为2
              //             ),
              //           ),
              //           focusedBorder: const OutlineInputBorder(
              //             /*边角*/
              //             borderRadius: BorderRadius.all(
              //               Radius.circular(20), //边角为5
              //             ),
              //             borderSide: BorderSide(
              //               color: Colors.white, //边线颜色为白色
              //               width: 0, //边线宽度为2
              //             ),
              //           ),
              //           filled: true,
              //           prefixIcon: Padding(
              //             padding: const EdgeInsets.only(
              //                 top: 7, bottom: 7, right: 5),
              //             child: SvgPicture.asset('assets/icons/sousuo.svg',
              //                 width: 20,
              //                 height: 20,
              //                 color: const Color(0xff999999)),
              //           )),
              //       onTap: () {
              //         Get.to(sommoditysearchPage());
              //         _focusNode.unfocus();
              //       },
              //     ),
              //   ),
              // ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(left: 10, right: 0),
                  height: 36,
                ),
              ),
              GestureDetector(
                  onTap: () {
                    Get.to(commoditylikePage());
                  },
                  child: Container(
                    child: Stack(clipBehavior: Clip.none, children: [
                      SvgPicture.asset(
                        'assets/svg/shoppingxiao.svg',
                        width: 35,
                        height: 35,
                      ),
                    ]),
                  ))
            ],
          ),
        ),
      ),
      body: Container(child: Column(children: [
        Expanded(child:
        !oneData
            ? StartDetailLoading():ListView(
          shrinkWrap: true,
          primary: false,
          controller: _allscrollController,
          scrollDirection: Axis.vertical,
          children: [
            Container(padding: EdgeInsets.only(left: 15,right: 15),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
              Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.width-30,),
                decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)),),
                child: _swiper(context, xunidata['box_1']['cover']),
              ),
              SizedBox(height: 10,),
              Row(mainAxisAlignment:MainAxisAlignment.spaceAround,children: [
                for(var items in xunidata['slogan'])
                GestureDetector(child:Row(children: [
                  Container(width: 20,height:20,child: CachedNetworkImage(
                    imageUrl: items['icon'],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Color(0xffF5F5F5),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child:
                      Image.asset('assets/images/LanLazhanwei.png'),
                    ),
                    errorWidget: (context, url, error) {
                      // 网络图片加载失败时显示本地图片
                      return Container(
                        color: Color(0xffF5F5F5),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        child:
                        Image.asset('assets/images/LanLazhanwei.png',),
                      );
                    },
                  ),),
                  SizedBox(width: 5,),
                  Text(items['title'],overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13,),)
                ],) ,onTap: (){
                  // PromptDescription=items['description'];
                  // setState(() {
                  //
                  // });
                  Get.bottomSheet(Container(
                    padding: EdgeInsets.only(bottom: 40),
                    decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20),),
                    child: Wrap(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 25,
                            height: 25,
                            child: CachedNetworkImage(
                              imageUrl: items['icon'],
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Color(0xffF5F5F5),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                width: double.infinity,
                                child:
                                Image.asset('assets/images/LanLazhanwei.png'),
                              ),
                              errorWidget: (context, url, error) {
                                // 网络图片加载失败时显示本地图片
                                return Container(
                                  color: Color(0xffF5F5F5),
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  width: double.infinity,
                                  child:
                                  Image.asset('assets/images/LanLazhanwei.png',),
                                );
                              },
                            ),
                          ),
                          title: Transform(
                              transform: Matrix4.translationValues(20, 0.0, 0.0),
                              child: Text(items['title'])),
                          onTap: () {
                          },
                        ),
                        Container(padding: EdgeInsets.fromLTRB(15, 0, 15, 0),width: double.infinity,child: Text(items['description'],style: TextStyle(
                            fontSize: 14,
                            color: Color.fromRGBO(153, 153, 153, 1),
                            height: 1.4
                        ),),)
                      ],
                    ),
                  ));
                },),
              ],),
              SizedBox(height: 40,),
              Text('今日特价'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Container(width: double.infinity,height: 80,child: ListView(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                controller: _specialscrollController,
                children: [
                  for(var item in specialofferdata)
                    GestureDetector(child: Container(decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(2)),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xfff8f8f8), Colors.white], // 渐变色的颜色列表
                      ),
                    ),width: 60,height: 80,margin: EdgeInsets.only(left: 15),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(width: 40,height: 40,child: CachedNetworkImage(
                        imageUrl: item['image'],
                        fit: BoxFit.contain,
                        placeholder: (context, url) => Container(
                          color: Color(0xffF5F5F5),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          child:
                          Image.asset('assets/images/LanLazhanwei.png'),
                        ),
                        errorWidget: (context, url, error) {
                          // 网络图片加载失败时显示本地图片
                          return Container(
                            color: Color(0xffF5F5F5),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            width: double.infinity,
                            child:
                            Image.asset('assets/images/LanLazhanwei.png',),
                          );
                        },
                      ),),
                      SizedBox(height: 10,),
                      // Text('123',style: TextStyle(fontSize: 13),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            double.parse(item['price']).toInt().toString(),
                            style: TextStyle(
                                fontSize: 13, height: 1),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            item['currency'],
                            style: TextStyle(
                                fontSize: 13,

                                height: 1),
                          ),
                        ],
                      )
                    ],),),onTap: () async {
                      await launchUrl(
                      Uri.parse(item['url']),
                      mode: LaunchMode.externalApplication,
                      );
                    },)
                ],
              ),),
              SizedBox(height: 40,),
              Text(xunidata['box_2']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                clipBehavior: Clip.hardEdge,
                height: MediaQuery.of(context).size.width-30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Stack(
                  children: [
                    Container(width: double.infinity, height: MediaQuery.of(context).size.width-30,child: GestureDetector(child: CachedNetworkImage(
                      imageUrl: xunidata['box_2']['cover'][0]['image'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Color(0xffF5F5F5),
                        padding: EdgeInsets.only(left: 20, right: 20),
                        width: double.infinity,
                        child:
                        Image.asset('assets/images/LanLazhanwei.png'),
                      ),
                      errorWidget: (context, url, error) {
                        // 网络图片加载失败时显示本地图片
                        return Container(
                          color: Color(0xffF5F5F5),
                          padding: EdgeInsets.only(left: 20, right: 20),
                          width: double.infinity,
                          child:
                          Image.asset('assets/images/LanLazhanwei.png',),
                        );
                      },
                    ),onTap: () async {
                      if(xunidata['box_2']['cover'][0]["target_type"]==11){
                        if(xunidata['box_2']['cover'][0]['target_other']=='/public/video'||xunidata['box_2']['cover'][0]['target_other']=='/public/picture'|| xunidata['box_2']['cover'][0]['target_other'] == '/public/xiumidata'){
                          Get.toNamed(xunidata['box_2']['cover'][0]['target_other'],arguments:  {
                            'data': int.parse(xunidata['box_2']['cover'][0]['target_id']),
                            'isEnd': false
                          });
                        }else if(xunidata['box_2']['cover'][0]['target_id']=='share/invite/index'){
                          FirebaseAnalytics.instance.logEvent(
                            name: "jumpwebh5",
                            parameters: {
                              "userid": userLogic.userId,
                              "uuid":userLogic.deviceData['uuid'],
                            },
                          );
                          Get.toNamed('/public/webview',arguments: BASE_DOMAIN+xunidata['box_2']['cover'][0]['target_id']+'?token='+userLogic.token+'&uuid='+userLogic.deviceData['uuid']);
                        }else if(xunidata['box_2']['cover'][0]['target_other']=='/public/Planningpage'){
                          Get.toNamed(xunidata['box_2']['cover'][0]['target_other'],arguments:  {
                            'id': int.parse(xunidata['box_2']['cover'][0]['target_id']),
                            'title': xunidata['box_2']['name']
                          });
                        }else{
                          Get.toNamed(xunidata['box_2']['cover'][0]['target_other'],arguments: int.parse(xunidata['box_2']['cover'][0]['target_id']),);
                        }
                      }else if(xunidata['box_2']['cover'][0]['target_id'] != ''&&xunidata['box_2']['cover'][0]['target_type'] == 5){
                        _launchUniversalLinkIos(Uri.parse(xunidata['box_2']['cover'][0]['target_other']),Uri.parse(xunidata['box_2']['cover'][0]['target_id']));
                      }else if(xunidata['box_2']['cover'][0]['target_other'] != ''&&xunidata['box_2']['cover'][0]['target_type'] ==12){
                        await launchUrl(Uri.parse(xunidata['box_2']['cover'][0]['target_other']), mode: LaunchMode.externalApplication,);
                      }else if(xunidata['box_2']['cover'][0]['target_other'] != ''&&xunidata['box_2']['cover'][0]['target_type'] ==14){
                        await launchUrl(Uri.parse(xunidata['box_2']['cover'][0]['target_other']), mode: LaunchMode.externalApplication,);
                      }
                      else if(xunidata['box_2']['cover'][0]['target_id'] != ''&&xunidata['box_2']['cover'][0]['target_type'] ==15){
                        Get.to(ProductlabelPage(),arguments:  {
                          'data': xunidata['box_2']['cover'][0]['target_id'],
                          "title":xunidata['box_2']['cover'][0]['title']
                        });
                      }
                    },),),
                    Positioned(
                      right: 0,
                      left: 0,
                      bottom: 15,
                      child: Container(
                        width: double.infinity,
                        height: 156,
                        child: ListView(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(
                              width: 15,
                            ),
                            for (var items in xunidata['box_2']['product'])
                              GestureDetector(child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xfff8f8f8),
                                      Colors.white
                                    ], // 渐变色的颜色列表
                                  ),
                                ),
                                width: 92,
                                height: 156,
                                margin: EdgeInsets.only(left: 15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 62,
                                      height: 62,
                                      child: CachedNetworkImage(
                                        imageUrl: items['image'],
                                        fit: BoxFit.contain,
                                        placeholder: (context, url) => Container(
                                          color: Color(0xffF5F5F5),
                                          padding: EdgeInsets.only(left: 20, right: 20),
                                          width: double.infinity,
                                          child:
                                          Image.asset('assets/images/LanLazhanwei.png'),
                                        ),
                                        errorWidget: (context, url, error) {
                                          // 网络图片加载失败时显示本地图片
                                          return Container(
                                            color: Color(0xffF5F5F5),
                                            padding: EdgeInsets.only(left: 20, right: 20),
                                            width: double.infinity,
                                            child:
                                            Image.asset('assets/images/LanLazhanwei.png',),
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(child: Text(
                                      items['short_title'],
                                      textAlign: TextAlign.center,
                                      style:
                                      TextStyle(fontSize: 13, height: 1.1,fontWeight: FontWeight.w600),
                                    ),),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          items['price'],
                                          style: TextStyle(
                                              fontSize: 13, height: 1),
                                        ),
                                        SizedBox(
                                          width: 3,
                                        ),
                                        Text(
                                          items['currency'],
                                          style: TextStyle(
                                              fontSize: 13,

                                              height: 1),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),onTap: () async {await launchUrl(
                              Uri.parse(items['url']),
                              mode: LaunchMode.externalApplication,
                              );},)
                          ],
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              if(cardData.length!=0||personalPage>1)SizedBox(height: 40,),
              if(cardData.length!=0||personalPage>1)GestureDetector(child:Text('心动私藏'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),) ,onTap: (){
                Get.to(commoditylikePage());
              },),
              if(cardData.length!=0||personalPage>1)SizedBox(height: 15,),
            ],),),
            if(cardData.length!=0)TCard(
              lockYAxis:true,
              size:Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
              cards: cardData.map((data) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8.0,
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 160,height: 160,child: CachedNetworkImage(
                          imageUrl: data['image'],
                          fit: BoxFit.contain,
                          placeholder: (context, url) => Container(
                            color: Color(0xffF5F5F5),
                            padding: EdgeInsets.only(left: 2, right: 2),
                            width: double.infinity,
                            child: Image.asset('assets/images/LanLazhanwei.png'),
                          ),
                          errorWidget: (context, url, error) {
                            // 网络图片加载失败时显示本地图片
                            return Container(
                              color: Color(0xffF5F5F5),
                              padding: EdgeInsets.only(left: 2, right: 2),
                              width: double.infinity,
                              child: Image.asset('assets/images/LanLazhanwei.png',),
                            );
                          },
                        ),),
                        SizedBox(height: 20.0),
                        Container(padding:EdgeInsets.fromLTRB(20, 0, 20, 0),child: Text(data['title'],
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                          maxLines: 2,style: TextStyle(fontSize: 15,height: 1.5),),),
                        SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(child: Container(width: 50,height: 50,child: Image.asset('assets/images/sahangpxh.png',fit: BoxFit.cover,),),onTap: (){
                              SecretCollection.forward(direction: SwipDirection.Right);
                              ///喜欢
                              commoditylikeandno(cardData[0]['id'],1);
                              cardData.remove(cardData[0]);
                              setState(() {});
                            },),
                            SizedBox(width: 60,),
                            GestureDetector(child: Container(width: 50,height: 50,child: Image.asset('assets/images/shangpbxh.png',fit: BoxFit.cover,),),onTap: (){
                              SecretCollection.forward(direction: SwipDirection.Left);
                              ///不喜欢
                              commoditylikeandno(cardData[0]['id'],2);
                              cardData.remove(cardData[0]);
                              setState(() {});
                            },),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              controller: SecretCollection,
              onForward: (index, info) {
                // 当卡片被滑动时触发的回调
                if (info.direction == SwipDirection.Left) {
                  ///不喜欢
                  commoditylikeandno(cardData[0]['id'],2);
                  cardData.remove(cardData[0]);
                  setState(() {});
                } else if (info.direction == SwipDirection.Right) {
                  ///喜欢
                  commoditylikeandno(cardData[0]['id'],1);
                  cardData.remove(cardData[0]);
                  setState(() {});
                }
              },
            ),
            if(cardData.length==0&&personalPage>1)Container(padding:EdgeInsets.all(20),width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.width,child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8.0,
                    spreadRadius: 0.0,
                  ),
                ],
              ),
              // decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red),),
              child:Center(child: Column(
                mainAxisAlignment:MainAxisAlignment.center,
                children: [

                  Image.asset('assets/images/noshujua.png',width: 200,height: 200,),
                  SizedBox(height: 40,),
                  Text('今日暂无更多推荐'.tr,textAlign:TextAlign.center ,style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff999999)
                  ),),
                  SizedBox(height: 5,),
                  Text('往下滑滑发现更多精彩吧'.tr,textAlign:TextAlign.center ,style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff999999)
                  ),)
                  ,
                ],
              ),)
              ,),),
            SizedBox(height: 40,),
            Container(padding: EdgeInsets.only(left: 15,right: 15),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
              Text(xunidata['box_3']['name'],style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),
              Container(
                clipBehavior: Clip.hardEdge,
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.width - 30,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: GestureDetector(child: CachedNetworkImage(
                  imageUrl: xunidata['box_3']['cover'][0]['image'],
                  fit: BoxFit.contain,
                  placeholder: (context, url) => Container(
                    color: Color(0xffF5F5F5),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    child:
                    Image.asset('assets/images/LanLazhanwei.png'),
                  ),
                  errorWidget: (context, url, error) {
                    // 网络图片加载失败时显示本地图片
                    return Container(
                      color: Color(0xffF5F5F5),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child:
                      Image.asset('assets/images/LanLazhanwei.png',),
                    );
                  },
                ),onTap: () async {
                  if(xunidata['box_3']['cover'][0]["target_type"]==11){
                    if(xunidata['box_3']['cover'][0]['target_other']=='/public/video'||xunidata['box_3']['cover'][0]['target_other']=='/public/picture'|| xunidata['box_3']['cover'][0]['target_other'] == '/public/xiumidata'){
                      Get.toNamed(xunidata['box_3']['cover'][0]['target_other'],arguments:  {
                        'data': int.parse(xunidata['box_3']['cover'][0]['target_id']),
                        'isEnd': false
                      });
                    }else if(xunidata['box_3']['cover'][0]['target_id']=='share/invite/index'){
                      FirebaseAnalytics.instance.logEvent(
                        name: "jumpwebh5",
                        parameters: {
                          "userid": userLogic.userId,
                          "uuid":userLogic.deviceData['uuid'],
                        },
                      );
                      Get.toNamed('/public/webview',arguments: BASE_DOMAIN+xunidata['box_3']['cover'][0]['target_id']+'?token='+userLogic.token+'&uuid='+userLogic.deviceData['uuid']);
                    }else if(xunidata['box_3']['cover'][0]['target_other']=='/public/Planningpage'){
                      Get.toNamed(xunidata['box_3']['cover'][0]['target_other'],arguments:  {
                        'id': int.parse(xunidata['box_3']['cover'][0]['target_id']),
                        'title': xunidata['box_3']['name']
                      });
                    }else{
                      Get.toNamed(xunidata['box_3']['cover'][0]['target_other'],arguments: int.parse(xunidata['box_3']['cover'][0]['target_id']),);
                    }
                  }else if(xunidata['box_3']['cover'][0]['target_id'] != ''&&xunidata['box_3']['cover'][0]['target_type'] == 5){
                    _launchUniversalLinkIos(Uri.parse(xunidata['box_3']['cover'][0]['target_other']),Uri.parse(xunidata['box_3']['cover'][0]['target_id']));
                  }else if(xunidata['box_3']['cover'][0]['target_other'] != ''&&xunidata['box_3']['cover'][0]['target_type'] ==12){
                    await launchUrl(Uri.parse(xunidata['box_3']['cover'][0]['target_other']), mode: LaunchMode.externalApplication,);
                  }else if(xunidata['box_3']['cover'][0]['target_other'] != ''&&xunidata['box_3']['cover'][0]['target_type'] ==14){
                    await launchUrl(Uri.parse(xunidata['box_3']['cover'][0]['target_other']), mode: LaunchMode.externalApplication,);
                  }else if(xunidata['box_3']['cover'][0]['target_id'] != ''&&xunidata['box_3']['cover'][0]['target_type'] ==15){
                    Get.to(ProductlabelPage(),arguments:  {
                      'data': xunidata['box_3']['cover'][0]['target_id'],
                      "title":xunidata['box_3']['cover'][0]['title']
                    });
                  }
                },),
              ),
              SizedBox(height: 40,),
              Text('好物甄选'.tr,style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              SizedBox(height: 15,),

            ],),),
            MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              //禁止滚动
              crossAxisCount: 2,
              mainAxisSpacing: 0,
              // 上下间隔
              crossAxisSpacing: 0,
              //左右间隔
              padding: const EdgeInsets.all(0),
              // 总数
              itemCount: alllistdata.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.all(15),
                        height: 244,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 0.5,
                                color: Color.fromRGBO(
                                    245, 245, 245, 1))),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              child: CachedNetworkImage(
                                imageUrl: alllistdata[index]['image'],
                                fit: BoxFit.contain,
                                placeholder: (context, url) =>
                                    Container(
                                      color: Color(0xffF5F5F5),
                                      padding: EdgeInsets.only(left: 20, right: 20),
                                      width: double.infinity,
                                      child: Image.asset('assets/images/LanLazhanwei.png'),
                                    ),
                                errorWidget:
                                    (context, url, error) {
                                  // 网络图片加载失败时显示本地图片
                                      return Container(
                                        color: Color(0xffF5F5F5),
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.infinity,
                                        child: Image.asset(
                                          'assets/images/LanLazhanwei.png',
                                        ),
                                      );
                                      },
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              alignment: Alignment.centerRight,
                              child: Text(
                                alllistdata[index]['title'],
                                overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                                maxLines: 2,
                                style: TextStyle(fontSize: 13),
                              ),
                            ),
                            // SizedBox(height: 8,),
                            Row(
                              children: [
                                Text(
                                  alllistdata[index]['price']
                                      .toString(),
                                  style: TextStyle(),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(alllistdata[index]['currency']),
                              ],
                            )
                          ],
                        ),
                      ),
                      // Positioned(
                      //     top: 15,
                      //     right: 15,
                      //     child: GestureDetector(
                      //       child: Image.asset(
                      //         alllistdata[index]['is_like'] == 1
                      //             ? 'assets/images/sahangpxh.png'
                      //             : 'assets/images/shangpbxh.png',
                      //         fit: BoxFit.cover,
                      //         width: 20,
                      //         height: 20,
                      //       ),
                      //       onTap: () {
                      //         setState(() {
                      //           if(alllistdata[index]['is_like']==1){
                      //             alllistdata[index]['is_like']=2;
                      //           }else{
                      //             alllistdata[index]['is_like']=1;
                      //           }
                      //           commoditylikeandno(alllistdata[index]['id'],alllistdata[index]['is_like']);
                      //
                      //         });
                      //       },
                      //     ))
                    ],
                  ),
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(alllistdata[index]['url']),
                      mode: LaunchMode.externalApplication,
                    );
                    },
                );
                },
            ),
            SizedBox(height: 20,),
          ],
        )

        )

      ],),),
    );
  }
  /**
   * 顶部轮播图
   */
  Widget _swiper(BuildContext context, imageList,) {
    // return Container();
    bool isOne = imageList.length == 1 ? true : false;
    return isOne
        ? GestureDetector(
            child: CachedNetworkImage(
              imageUrl: imageList[0]['image'],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width-30,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffD1FF34),
                    strokeWidth: 4,
                  ),
                ),
              ),
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                color: Color(0xffF5F5F5),
                padding: EdgeInsets.only(left: 20, right: 20),
                width: double.infinity,
                child: Image.asset(
                  'assets/images/LanLazhanwei.png',
                ),
              ),
            ),
            onTap: () async {
              if(imageList[0]["target_type"]==11){
                if(imageList[0]['target_other']=='/public/video'||imageList[0]['target_other']=='/public/picture'|| imageList[0]['target_other'] == '/public/xiumidata'){
                  Get.toNamed(imageList[0]['target_other'],arguments:  {
                    'data': int.parse(imageList[0]['target_id']),
                    'isEnd': false
                  });
                }else if(imageList[0]['target_id']=='share/invite/index'){
                  FirebaseAnalytics.instance.logEvent(
                    name: "jumpwebh5",
                    parameters: {
                      "userid": userLogic.userId,
                      "uuid":userLogic.deviceData['uuid'],
                    },
                  );
                  Get.toNamed('/public/webview',arguments: BASE_DOMAIN+imageList[0]['target_id']+'?token='+userLogic.token+'&uuid='+userLogic.deviceData['uuid']);
                }else if(imageList[0]['target_other']=='/public/Planningpage'){
                  Get.toNamed(imageList[0]['target_other'],arguments:  {
                    'id': int.parse(imageList[0]['target_id']),
                    'title': imageList[0]['title']
                  });
                }else{
                  Get.toNamed(imageList[0]['target_other'],arguments: int.parse(imageList[0]['target_id']),);
                }
              }else if(imageList[0]['target_id'] != ''&&imageList[0]['target_type'] == 5){
                _launchUniversalLinkIos(Uri.parse(imageList[0]['target_other']),Uri.parse(imageList[0]['target_id']));
              }else if(imageList[0]['target_other'] != ''&&imageList[0]['target_type'] ==12){
                await launchUrl(Uri.parse(imageList[0]['target_other']), mode: LaunchMode.externalApplication,);
              }else if(imageList[0]['target_other'] != ''&&imageList[0]['target_type'] ==14){
                await launchUrl(Uri.parse(imageList[0]['target_other']), mode: LaunchMode.externalApplication,);
              }else if(imageList[0]['target_id'] != ''&&imageList[0]['target_type'] ==15){
                Get.to(ProductlabelPage(),arguments:  {
                  'data': imageList[0]['target_id'],
                  "title":imageList[0]['title']
                });
              }
            },
          )
        : Container(
            width: double.infinity,
           height: 200,
            child:Stack(children: [Swiper(
              outer: true,
              autoplay: true, // 启用自动轮播
              autoplayDelay: 3000, // 自动轮播的间隔时间（以毫秒为单位）
              itemBuilder: (c, i) {
                return GestureDetector(
                  child: CachedNetworkImage(
                    imageUrl: imageList[i]['image'],
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Container(
                      width: double.infinity,
                      height: 100,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xffD1FF34),
                          strokeWidth: 4,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Color(0xffF5F5F5),
                      padding: EdgeInsets.only(left: 20, right: 20),
                      width: double.infinity,
                      child: Image.asset(
                        'assets/images/LanLazhanwei.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  onTap: () async {
                    if(imageList[i]["target_type"]==11){
                      if(imageList[i]['target_other']=='/public/video'||imageList[i]['target_other']=='/public/picture'|| imageList[i]['target_other'] == '/public/xiumidata'){
                        Get.toNamed(imageList[i]['target_other'],arguments:  {
                          'data': int.parse(imageList[i]['target_id']),
                          'isEnd': false
                        });
                      }else if(imageList[i]['target_id']=='share/invite/index'){
                        FirebaseAnalytics.instance.logEvent(
                          name: "jumpwebh5",
                          parameters: {
                            "userid": userLogic.userId,
                            "uuid":userLogic.deviceData['uuid'],
                          },
                        );
                        Get.toNamed('/public/webview',arguments: BASE_DOMAIN+imageList[i]['target_id']+'?token='+userLogic.token+'&uuid='+userLogic.deviceData['uuid']);
                      }else if(imageList[i]['target_other']=='/public/Planningpage'){
                        Get.toNamed(imageList[i]['target_other'],arguments:  {
                          'id': int.parse(imageList[i]['target_id']),
                          'title': imageList[i]['title']
                        });
                      }else{
                        Get.toNamed(imageList[i]['target_other'],arguments: int.parse(imageList[i]['target_id']),);
                      }
                    }else if(imageList[i]['target_id'] != ''&&imageList[i]['target_type'] == 5){
                      _launchUniversalLinkIos(Uri.parse(imageList[i]['target_other']),Uri.parse(imageList[i]['target_id']));
                    }else if(imageList[i]['target_other'] != ''&&imageList[i]['target_type'] ==12){
                      await launchUrl(Uri.parse(imageList[i]['target_other']), mode: LaunchMode.externalApplication,);
                    }else if(imageList[i]['target_other'] != ''&&imageList[i]['target_type'] ==14){
                      await launchUrl(Uri.parse(imageList[i]['target_other']), mode: LaunchMode.externalApplication,);
                    }else if(imageList[i]['target_id'] != ''&&imageList[i]['target_type'] ==15){
                      Get.to(ProductlabelPage(),arguments:  {
                        'data': imageList[i]['target_id'],
                        "title":imageList[i]['title']
                      });
                    }
                  },
                );
              },
              onIndexChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              // pagination: const SwiperPagination(
              //     margin: EdgeInsets.all(10),
              //     builder: DotSwiperPaginationBuilder(
              //       color: Colors.black12,
              //       activeColor: Colors.black,
              //       size: 5,
              //       activeSize: 6,
              //     )),
              itemCount: imageList.length,
            ),Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  imageList.length, // 轮播项数量
                      (index) {
                    return Padding(
                      padding: EdgeInsets.fromLTRB(4, 4, 4, 10),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: index == currentIndex?Colors.white:Color.fromRGBO(255, 255, 255, 0.4),
                        ),
                        width: index == currentIndex ? 15.0 : 7.0, // 当前项使用长线，其他项使用短线
                        height: 4.0,
                      ),
                    );
                  },
                ),
              ),
            ),],)
            ,
          );
  }
}
