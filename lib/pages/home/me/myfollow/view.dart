import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../models/UsersAndUser.dart';
import '../../../../services/newes.dart';
import '../../../../ulits/hex_color.dart';
import 'logic.dart';
enum NewConcernStatus { loading, noData, init, normal, empty }
class MyfollowPage extends StatefulWidget {
  @override
  createState() => MyfollowState();
  final logic = Get.put(MyfollowLogic());
  NewesProvider provider =  Get.put(NewesProvider());
}

class MyfollowState extends State<MyfollowPage> {
  final userController = Get.find<UserLogic>();
  final state = Get.find<MyfollowLogic>().state;
  NewConcernStatus status = NewConcernStatus.init;
  final ScrollController _scrollController = ScrollController();
  /// 请求数据
  @override
  void initState() {
    super.initState();
    widget.logic.MyfollowList(Get.arguments);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
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
    var result = await  widget.provider.Myfollowinterface(Get.arguments,state.page);
    // 延迟1秒请求，防止速率过快
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = NewConcernStatus.normal;
    });
    setState(() {
      if(UserandUserFromJson(result?.bodyString ?? "").toString()!='[]'){
        state.Myfollowlist.addAll(UserandUserFromJson(result?.bodyString ?? ""));
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
    state.Myfollowlist=[];
    widget.logic.update();
    _scrollController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              tooltip: "Search",
              onPressed: () {
                Navigator.of(context).pop();
              }),
          title: Text('新增关注'.tr, style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),),
        ),
        body: Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Divider(height: 1.0, color: Colors.grey.shade200,),
              Expanded(
                  flex: 1,
                  child: GetBuilder<MyfollowLogic>(builder: (logic) {
                    return RefreshIndicator(onRefresh: _onRefresh,
                        child: ListView.builder(
                            itemCount: state.Myfollowlist.length,
                            controller: _scrollController,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: const EdgeInsets.fromLTRB(20, 25, 20, 25),
                                decoration: const BoxDecoration(border: Border(
                                    bottom: BorderSide(width: 1, color: Color(0xffF1F1F1)))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(child:
                                    Container(
                                        width: 40,
                                        height: 40,
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(50),
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: state
                                              .Myfollowlist[i].userAvatar,
                                          placeholder: (context, url) =>
                                              Image.asset('assets/images/txzhanwei.png'),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(decoration: BoxDecoration(image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),),),
                                        )), onTap: (){Get.toNamed('/public/user',
                                        arguments: state.Myfollowlist[i].userId);},),
                                    const SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(child: Text(state.Myfollowlist[i].userName, overflow: TextOverflow.ellipsis, style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              ),)),
                                              // Text('10:10',style: TextStyle(
                                              //     fontSize: 12,
                                              //     color: Color(0xff999999),
                                              //     fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              // ),),
                                            ],
                                          ),
                                          const SizedBox(height: 12,),
                                          Row(
                                            children: [
                                              Expanded(child: Text(state.Myfollowlist[i].slogan, style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xff999999),
                                                //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              ), overflow: TextOverflow.ellipsis,),),
                                              // SizedBox(width: 15,),
                                              // Text(state.Myfollowlist[i].createdAt, style: TextStyle(
                                              //     fontSize: 12,
                                              //     color: Color(0xff999999),
                                              //     fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              // ),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15,),
                                    if(state.Myfollowlist[i].userId!=userController.userId)!userController.getFollow(state.Myfollowlist[i].userId)?
                                    GestureDetector(child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('关注'.tr, style: const TextStyle(
                                          color: Colors.white, fontSize: 15,fontWeight: FontWeight.w600),),
                                      decoration: BoxDecoration(
                                        //设置四周圆角 角度
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0)),
                                        border: Border.all(
                                            color: HexColor('#000000'),
                                            width: 1),
                                        color: HexColor('#000000'),
                                      ),
                                    ), onTap: () {
                                      //关注
                                      userController.setFollow(state.Myfollowlist[i].userId);
                                      logic.update();
                                    },) :
                                    GestureDetector(child: Container(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('取消关注'.tr, style: TextStyle(
                                          color: HexColor('#999999'),
                                          fontSize: 15,),),
                                      decoration: BoxDecoration(
                                        //     //设置四周圆角 角度
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(30.0)),
                                        border: Border.all(
                                            color: HexColor('#E4E4E4'),
                                            width: 1),
                                      ),
                                      //
                                    ), onTap: () {
                                      //取消关注
                                      userController.setFollow(state.Myfollowlist[i].userId);
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
    await Future.delayed(const Duration(seconds: 1), () {
      widget.logic.MyfollowList(Get.arguments);
    });
  }
}
