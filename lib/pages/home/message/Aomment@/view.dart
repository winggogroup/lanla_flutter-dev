import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/models/comment_parent.dart';
import 'package:lanla_flutter/pages/components/comment/logic.dart';
import 'package:lanla_flutter/pages/home/message/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';

import '../../../../models/newes.dart';
import '../../../../services/newes.dart';
import 'logic.dart';

// class CommentPage extends StatefulWidget {
//   final logic = Get.put(CommentLogic());
//   final state = Get.find<CommentLogic>().state;
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
enum AommentStatus { loading, noData, init, normal, empty }

class AommentandPage extends StatefulWidget {
  @override
  createState() => AommentViewState();
  final logic = Get.put(AommentLogic());
  NewesProvider provider = Get.put(NewesProvider());
}

class AommentViewState extends State<AommentandPage> {
  final logictwo = Get.find<MessageLogic>();
  final state = Get
      .find<AommentLogic>()
      .state;
  AommentStatus status = AommentStatus.init;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.logic.Aommentandai();
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
    if (status == AommentStatus.loading) {
      // 防止重复请求
      return;
    }
    status = AommentStatus.loading;
    state.page++;
    widget.logic.update();
    var result = await widget.provider.Messageinterface(5, state.page);

    // 延迟1秒请求，防止速率过快
    Future.delayed(Duration(milliseconds: 1000), () {
      status = AommentStatus.normal;
    });
    setState(() {
      if (MessageFromJson(result?.bodyString ?? "").toString() != '[]') {
        state.zanandai.addAll(MessageFromJson(result?.bodyString ?? ""));
        widget.logic.update();
      } else {
        state.page--;
        widget.logic.update();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    logictwo.empty();
    state.page = 1;
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
          // leading: IconButton(
          //     color: Colors.black,
          //     icon: Icon(Icons.arrow_back_ios),
          //     tooltip: "Search",
          //     onPressed: () {
          //       //print('menu Pressed');
          //       Navigator.of(context).pop();
          //     }),
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
          title: Text('评论和@'.tr, style: TextStyle(
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
                  child: GetBuilder<AommentLogic>(builder: (logic) {
                    return RefreshIndicator(onRefresh: _onRefresh,
                        child: !state.oneData
                            ? StartDetailLoading():state.zanandai.length>0?
                        ListView.builder(
                            itemCount: state.zanandai.length,
                            controller: _scrollController,
                            itemBuilder: (context, i) {
                              return Container(
                                padding: EdgeInsets.fromLTRB(20, 25, 20, 25),
                                decoration: BoxDecoration(border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffF1F1F1)))),
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    GestureDetector(child:Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              100),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                state.zanandai[i].userAvatar),
                                          ),
                                        )
                                    ) ,onTap: (){
                                      Get.toNamed('/public/user',
                                          arguments: state.zanandai[i].userId);
                                    },),
                                    SizedBox(width: 15,),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(state.zanandai[i]
                                                  .userName, style: TextStyle(
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
                                          Row(
                                            children: [
                                              Text(state.zanandai[i].message,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999),
                                                    //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                                ),),
                                              SizedBox(width: 15,),
                                              Text(state.zanandai[i].createdAt,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: Color(0xff999999),
                                                    //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                                ),),
                                            ],
                                          ),

                                          ///评论
                                          SizedBox(height: 12,),
                                          if(state.zanandai[i].commentContent != '')Row(
                                            children: [
                                              Text(state.zanandai[i]
                                                  .commentContent,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    //fontFamily: 'PingFang SC-Semibold, PingFang SC'
                                                ),),
                                            ],
                                          ),
                                          ///回复评论
                                          SizedBox(height: 12,),

                                          GestureDetector(child: Container(padding: EdgeInsets.fromLTRB(13, 8, 13, 8),decoration: BoxDecoration(
                                              color: Color(0xfff5f5f5),
                                              borderRadius: BorderRadius.all(Radius.circular(20))
                                          ),child: Text('回复评论'.tr,style: TextStyle(fontSize: 12,height: 1),),),onTap: (){
                                            print(state.zanandai[i].contentUserId);
                                            CommentDiolog(state.zanandai[i].contentId,
                                                parentUid:state.zanandai[i].contentUserId,
                                                pid: state.zanandai[i].commentId,
                                                baseId: state.zanandai[i].baseId,
                                                parentCallback: (CommentParent data) {},
                                                childCallback: (CommentChild data) {}
                                            );
                                          },),

                                          ///子评论
                                          if(state.zanandai[i].commentChildContent!='')SizedBox(height: 12,),
                                          if(state.zanandai[i].commentChildContent!='')Row(
                                            children: [
                                              Container(width: 2,height: 12,color: Color(0xffE4E4E4),),
                                              SizedBox(width: 8,),
                                              Text(state.zanandai[i].commentChildContent,style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                                  fontFamily: 'PingFang SC-Semibold, PingFang SC'
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
                                        //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              5),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                                state.zanandai[i].thumbnail),
                                          ),
                                        )
                                    ),
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
      widget.logic.Aommentandai();
    });
  }
}
