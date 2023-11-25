import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';

import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import '../../../detail/picture/view.dart';
import '../../../detail/video/view.dart';
import 'logic.dart';
enum LikeandCollect { loading, noData, init, normal, empty }
class LikeandCollectPage extends StatefulWidget {
  @override
  createState() => likeshouViewState();
  final logic = Get.put(LikeandCollectLogic());
  NewesProvider provider =  Get.put(NewesProvider());
}

class likeshouViewState extends State<LikeandCollectPage> {

  final state = Get.find<LikeandCollectLogic>().state;
  final logictwo = Get.find<MessageLogic>();
  LikeandCollect status = LikeandCollect.init;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    widget.logic.ZanheCollection();
     _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置
        _fetch();
      }
     });
  }
  /// 请求数据
  Future<void> _fetch() async {
    if (status == LikeandCollect.loading) {
      // 防止重复请求
      return;
    }
    status = LikeandCollect.loading;
    state.page++;
    widget.logic.update();
    var result = await  widget.provider.Messageinterface(2,state.page);

    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 1000), () {
      status = LikeandCollect.normal;
    });
    setState(() {
      if(MessageFromJson(result?.bodyString ?? "").toString()!='[]'){
        state.zanandshou.addAll(MessageFromJson(result?.bodyString ?? ""));
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
    return Scaffold(
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
          title: Text('赞和收藏'.tr, style: TextStyle(
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
                  child: GetBuilder<LikeandCollectLogic>(builder: (logic) {
                    return  !state.oneData
                        ? StartDetailLoading():state.zanandshou.length>0?
                    RefreshIndicator(onRefresh: _onRefresh,
                        child: ListView.builder(
                            controller: _scrollController,
                            itemCount: state.zanandshou.length,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
                                margin: EdgeInsets.only(left: 15,right: 15),
                                decoration: BoxDecoration(border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF1F1F1)))),
                                child: GestureDetector(child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(child:Container(
                                        width: 40,
                                        height: 40,
                                        //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              100),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                state.zanandshou[i].userAvatar),
                                          ),
                                        )
                                    ),onTap: (){
                                      Get.toNamed('/public/user',
                                          arguments: state.zanandshou[i].userId);
                                    },) ,
                                    SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Row(
                                                  children: [
                                                    Text(state.zanandshou[i]
                                                        .userName,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .w600,
                                                      ),),
                                                    SizedBox(width: 10,),
                                                    if(state.zanandshou[i]
                                                        .follows)
                                                      Container(
                                                        alignment: Alignment.center,
                                                        padding: EdgeInsets
                                                            .fromLTRB(8, 5, 8, 5),
                                                        decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color: Color(
                                                                  0xffE4E4E4),
                                                              width: 0.5),
                                                          borderRadius: BorderRadius
                                                              .circular(35),
                                                        ),
                                                        child: Text('你的好友'.tr,
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              color: Color(
                                                                  0xff999999),
                                                          ),),
                                                      )
                                                  ]),

                                              // Text('10:10',style: TextStyle(
                                              //     fontSize: 12,
                                              //     color: Color(0xff999999),
                                              //     fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                              // ),),
                                            ],
                                          ),
                                          SizedBox(height: 12,),
                                          Row(
                                            children: [
                                              Text(state.zanandshou[i].message, style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                              ),),
                                              SizedBox(width: 15,),
                                              Text(
                                                state.zanandshou[i].createdAt,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999),
                                                ),),
                                            ],
                                          ),
                                          SizedBox(height: 12,),
                                          if(state.zanandshou[i].commentContent!='')Row(
                                            children: [
                                              Container(width: 2,
                                                height: 12,
                                                color: Color(0xffE4E4E4),),
                                              SizedBox(width: 8,),
                                              Text(
                                                state.zanandshou[i].commentContent, style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                              ),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 15,),
                                    Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(state.zanandshou[i].thumbnail),
                                          ),
                                        )
                                    )
                                  ],
                                ),onTap: (){
                                  if(state.zanandshou[i].contentType==1){
                                    Get.toNamed('/public/video',arguments: {
                                      'data': state.zanandshou[i].targetId,
                                      'isEnd': false
                                    });
                                  }else if(state.zanandshou[i].contentType==2){
                                    Get.toNamed(
                                        '/public/picture', preventDuplicates: false,
                                        arguments: {
                                          "data": state.zanandshou[i].targetId,
                                          "isEnd": false
                                        });
                                  }
                                },)
                              );
                            })):Container(
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
                      ),);
                  }))


            ],
          ),
        )
    );
  }

  Future<void> _onRefresh() async {
    print('88999');

    await Future.delayed(Duration(seconds: 1), () {
      widget.logic.ZanheCollection();
    });
  }
}
