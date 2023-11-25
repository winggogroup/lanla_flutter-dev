import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/TopItemModel.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/services/content.dart';

class TopPage extends StatefulWidget {
  @override
  _TopPageState createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> with AutomaticKeepAliveClientMixin {
  @override
  bool loading = true;
  bool empty = false;
  final userLogic = Get.find<UserLogic>();
  final WebSocketes = Get.find<StartDetailLogic>();

  List<TopItemModel>? dataSource;
  @override
  void initState() {
    super.initState();
    _fetch();
  }

  _fetch() async {
    dataSource = await Get.find<ContentProvider>().TopList();
    loading = false;
    if(dataSource == null || dataSource!.isEmpty){
      empty = true;
    }
    setState(() {});
  }
  @override
  bool get wantKeepAlive => true; // 是否开启缓存
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('榜单'.tr , style: const TextStyle(
        fontSize: 20)),
          actions: [
            GestureDetector(
                onTap: () {
                  //Get.to(SearchPage());
                  if(userLogic.token!=''){
                    if(!userLogic.Chatdisconnected){
                      WebSocketes.WebSocketconnection();
                    }
                    Get.toNamed('/public/message');
                  }else{
                    Get.toNamed('/public/loginmethod');
                  }
                },
                child:

                // Container(
                //   margin: const EdgeInsets.all(14),
                //   child:
                //   SvgPicture.asset('assets/icons/lingdang.svg',width: 22,height: 22,),
                //
                // )
                GetBuilder<UserLogic>(builder: (logic) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(16,0,0,6),
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
          ],
        ),
        body:  Container(
          padding: const EdgeInsets.only(top: 10),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Color(0x10000000),width: 0.3))
          ),
          child: loading ? SpinKitChasingDots(
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                    color: Colors.black,borderRadius: BorderRadius.circular(40)),
              );
            },
          ):RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 10.0,
            child:dataSource!=null&&dataSource!.isNotEmpty?
          ListView.builder(
              itemCount: dataSource!.length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: (){
                    //print(dataSource![index].url);
                    Get.toNamed('/public/webview',arguments: 'https://app.lanla.fun/share/invite/index');
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.width*dataSource![index].attaImageScale,
                    margin: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    child: CachedNetworkImage(
                      imageUrl: dataSource![index].banner,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.fill,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x50000000),
                              offset: Offset(0, 5),
                              blurRadius: 10,
                              spreadRadius: 0.5,
                            ),
                          ],
                        ),
                      ),
                    ),
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
                        'assets/images/Nocontent.png',
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
              }),),
        ));
  }
  Future<void> _onRefresh() async {
    _fetch();
  }
}
