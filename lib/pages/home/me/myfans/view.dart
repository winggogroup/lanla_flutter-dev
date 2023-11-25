import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../models/UsersAndUser.dart';
import '../../../../services/newes.dart';
import '../../../../ulits/hex_color.dart';
import 'logic.dart';
enum NewConcernStatus { loading, noData, init, normal, empty }

class MyfansPage extends StatefulWidget {
  @override
  createState() => MyfansState();
  final logic = Get.put(MyfansLogic());
  NewesProvider provider =  Get.put(NewesProvider());
}

class MyfansState extends State<MyfansPage> {
  final userController = Get.find<UserLogic>();
  final state = Get.find<MyfansLogic>().state;
  NewConcernStatus status = NewConcernStatus.init;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.logic.Faninterface(Get.arguments);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置
        fetches();
      }
    });
  }
  Future<void> fetches() async {
    if (status == NewConcernStatus.loading) {
      // 防止重复请求
      return;
    }
    status = NewConcernStatus.loading;
    state.page++;
    widget.logic.update();
    var result = await  widget.provider.Myfansinterface(Get.arguments,state.page);

    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 2000), () {
      status = NewConcernStatus.normal;
    });
    setState(() {
      if(UserandUserFromJson(result?.bodyString ?? "").toString()!='[]'){
        state.Myfanslist
            .addAll(UserandUserFromJson(result?.bodyString ?? ""));
        widget.logic.update();
      }else{
        state.page--;
        widget.logic.update();
      }

    });
  }

  @override
  void dispose() {
    super.dispose();
    state.page=1;
    state.Myfanslist=[];
    widget.logic.update();
    _scrollController.dispose();
  }







  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
              color: Colors.black,
              icon: Icon(Icons.arrow_back_ios),
              tooltip: "Search",
              onPressed: () {
                //print('menu Pressed');
                Navigator.of(context).pop();
              }),
          title: Text('粉丝'.tr, style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            //fontFamily: ' PingFang SC-Semibold, PingFang SC',
          ),),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Divider(height: 1.0, color: Colors.grey.shade200,),
              Expanded(
                  flex: 1,
                  child: GetBuilder<MyfansLogic>(builder: (logic) {
                    return RefreshIndicator(onRefresh: _onRefresh,
                        child: ListView.builder(
                            itemCount: state.Myfanslist.length,
                            controller: _scrollController,
                            itemBuilder: (context, i) {
                              return
                                Container(
                                padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                decoration: BoxDecoration(border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF1F1F1)))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(child:
                                    Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(50),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl:state.Myfanslist[i].userAvatar,
                                          placeholder: (context, url) =>
                                              Image.asset(
                                                  'assets/images/zhanweitufont.png'),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                              Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                        )),
                                      onTap: (){
                                      Get.toNamed('/public/user',
                                          arguments: state.Myfanslist[i].userId);
                                    },),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(state.Myfanslist[i].userName, style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              ),),
                                              // Text('10:10',style: TextStyle(
                                              //     fontSize: 12,
                                              //     color: Color(0xff999999),
                                              //     fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              // ),),
                                            ],
                                          ),
                                          SizedBox(height: 12,),
                                          // Row(
                                          //   children: [
                                          //     Text(state.Myfanslist[i].message, style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: Color(0xff999999),
                                          //         fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                          //     ),),
                                          //     SizedBox(width: 15,),
                                          //     Text(state.Myfanslist[i].createdAt, style: TextStyle(
                                          //         fontSize: 12,
                                          //         color: Color(0xff999999),
                                          //         fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                          //     ),),
                                          //   ],
                                          // ),
                                          Row(
                                            children: [
                                              Text(
                                                '作品'.tr, style: TextStyle(
                                                fontSize: 12,
                                                color: HexColor(
                                                    '#999999'),
                                                //fontFamily: 'PingFang SC-Regular',
                                              ),),
                                              SizedBox(width: 5,),
                                              Text(
                                                state.Myfanslist[i].works
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: HexColor(
                                                      '#999999'),
                                                  //fontFamily: 'PingFang SC-Regular',
                                                ),),
                                              SizedBox(width: 10,),
                                              SizedBox(
                                                width: 1,
                                                height: 14,
                                                child: DecoratedBox(
                                                  decoration: BoxDecoration(
                                                      color: HexColor(
                                                          '#999999')),
                                                ),
                                              ),
                                              SizedBox(width: 10,),
                                              Text(
                                                '粉丝'.tr, style: TextStyle(
                                                fontSize: 12,
                                                color: HexColor(
                                                    '#999999'),
                                                //fontFamily: 'PingFang SC-Regular',
                                              ),),
                                              SizedBox(width: 5,),
                                              Text(
                                                state.Myfanslist[i].fans
                                                    .toString(),
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: HexColor(
                                                      '#999999'),
                                                  //fontFamily: 'PingFang SC-Regular',
                                                ),),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    if(state.Myfanslist[i].userId!=userController.userId)!userController.getFollow(state.Myfanslist[i].userId)?
                                    GestureDetector(child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('关注'.tr, style: TextStyle(
                                          color: Colors.white, fontSize: 15,fontWeight: FontWeight.w600,),),
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
                                      userController.setFollow(state.Myfanslist[i].userId);
                                      logic.update();
                                    },) :
                                    GestureDetector(child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('已关注'.tr, style: TextStyle(
                                          color: HexColor('#999999'),
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
                                      userController.setFollow(state.Myfanslist[i].userId);
                                      logic.update();
                                    },)
                                  ],
                                ),
                              );
                            }));
                  }))


            ],
          ),
        )
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
      //widget.logic.MyfansLogic();
    });
  }
}
