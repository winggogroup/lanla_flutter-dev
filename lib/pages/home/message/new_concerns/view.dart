import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';

import '../../../../common/controller/UserLogic.dart';
import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import '../../../../ulits/hex_color.dart';
import 'logic.dart';
enum NewConcernStatus { loading, noData, init, normal, empty }
class NewConcernsPage extends StatefulWidget {
  @override
  createState() => NewConcerns();
  final logic = Get.put(NewConcernsLogic());
  NewesProvider provider =  Get.put(NewesProvider());
}

class NewConcerns extends State<NewConcernsPage> {
  final userController = Get.find<UserLogic>();
  final state = Get.find<NewConcernsLogic>().state;
  final logictwo = Get.find<MessageLogic>();
  NewConcernStatus status = NewConcernStatus.init;
  ScrollController _scrollController = ScrollController();
  /// 请求数据

  @override
  void initState() {
    super.initState();
    widget.logic.NewConcerns();
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
    var result = await  widget.provider.Messageinterface(4,state.page);

    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 2000), () {
      status = NewConcernStatus.normal;
    });
    setState(() {
      if(MessageFromJson(result?.bodyString ?? "").toString()!='[]'){
        state.Newconcernslist.addAll(MessageFromJson(result?.bodyString ?? ""));
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
      logictwo.empty();
      state.page=1;
      widget.logic.update();
      _scrollController.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              "assets/icons/fanhui.svg",
              width: 22,
              height: 22,
            ),
          ),
          title: Text('新增关注'.tr, style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Divider(height: 1.0, color: Colors.grey.shade200,),
              Expanded(
                  flex: 1,
                  child: GetBuilder<NewConcernsLogic>(builder: (logic) {
                    return RefreshIndicator(onRefresh: _onRefresh,
                        child: !state.oneData
                            ? StartDetailLoading():state.Newconcernslist.length>0?ListView.builder(
                            itemCount: state.Newconcernslist.length,
                            controller: _scrollController,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                                margin: EdgeInsets.only(left: 15,right: 15),
                                decoration: BoxDecoration(border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF1F1F1)))),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(child:Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(state.Newconcernslist[i].userAvatar),
                                          ),
                                        )
                                    ),onTap: (){
                                      Get.toNamed('/public/user',
                                          arguments: state.Newconcernslist[i].userId);
                                    },),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(state.Newconcernslist[i].userName, style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                              ),),
                                            ],
                                          ),
                                          SizedBox(height: 12,),
                                          Row(
                                            children: [
                                              Text(state.Newconcernslist[i].message, style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                              ),),
                                              SizedBox(width: 15,),
                                              Text(state.Newconcernslist[i].createdAt, style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                              ),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    !userController.getFollow(state.Newconcernslist[i].userId)?
                                    GestureDetector(child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('关注'.tr, style: TextStyle(
                                          color: Colors.black, fontSize: 13,fontWeight: FontWeight.w400),),
                                      decoration: BoxDecoration(
                                        //     //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        border: Border.all(
                                            color: HexColor('#000000'),
                                            width: 1),
                                        color: HexColor('#FFFFFF'),
                                      ),
                                      //
                                    ), onTap: () {
                                      //关注
                                      userController.setFollow(state.Newconcernslist[i].userId);
                                      logic.update();
                                    },) :
                                    GestureDetector(child: Container(
                                      padding: EdgeInsets.fromLTRB(
                                          20, 6, 20, 6),
                                      child: Text('已关注'.tr, style: TextStyle(
                                          color: HexColor('#999999'),
                                          fontSize: 13,fontWeight: FontWeight.w400),),
                                      decoration: BoxDecoration(
                                        //     //设置四周圆角 角度
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        border: Border.all(
                                            color: HexColor('#F1F1F1'),
                                            width: 1),
                                      ),
                                      //
                                    ), onTap: () {
                                      //取消关注
                                      userController.setFollow(state.Newconcernslist[i].userId);
                                      logic.update();
                                    },)
                                  ],
                                ),
                              );
                            }):Container(
                          width: double.infinity,
                          // decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red),),
                          child:Column(
                            children: [
                              SizedBox(height: 120,),
                              Image.asset('assets/images/nobeijing.png',width: 200,height: 200,),
                              SizedBox(height: 40,),
                              Text('暂无内容'.tr,style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff999999)
                              ),),
                            ],
                          ),));
                  }))


            ],
          ),
        )
    );
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 1), () {
    widget.logic.NewConcerns();
    });
  }
}
