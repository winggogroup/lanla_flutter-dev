import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/newes.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/pages/home/message/Chatpage/view.dart';
import 'package:lanla_flutter/pages/home/message/Systemnotification/view.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';

import 'Aomment@/view.dart';
import 'likeand_collect/view.dart';
import 'logic.dart';
import 'new_concerns/view.dart';
enum NewConcernStatus { loading, noData, init, normal, empty }
class MessagePage extends StatefulWidget {
  @override
  createState() => MessageState();
  final logic = Get.put(MessageLogic());
  NewesProvider provider = Get.put(NewesProvider());
}

class MessageState extends State<MessagePage> {

  final state = Get
      .find<MessageLogic>()
      .state;
  final xiaoxi = Get.find<ContentProvider>();
  final WebSocketes = Get.find<StartDetailLogic>();

  final userLogicone = Get.find<UserLogic>(); // 基础数据
  final ScrollController _scrollController = ScrollController();
  NewConcernStatus status = NewConcernStatus.init;
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  void initState() {
    super.initState();
    Firstdata(1);
    Newsquantity();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >
          _scrollController.position.maxScrollExtent - 50) {
        //达到最大滚动位置

        // fetches();
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
    var result = await widget.provider.Messageinterface(1, state.page);


    // 延迟1秒请求，防止速率过快
    Future.delayed(const Duration(milliseconds: 2000), () {
      status = NewConcernStatus.normal;
    });
    if (result.statusCode == 200) {
      if(MessageFromJson(result?.bodyString ?? "").toString()!='[]'){
        state.System.addAll(MessageFromJson(result?.bodyString ?? ""));
        widget.logic.update();
      }else{
        state.page--;
        widget.logic.update();
      }
      // userLogicone.emptyNews();
    }
  }
  deactivate() async {
    var result = await xiaoxi.Newsquantity();
    if (result.statusCode == 200) {
      if (userLogicone.NumberMessages != result.body['total']) {
        userLogicone.operatioNews(result.body['total']);
      }
    }
  }
  @override
  void dispose() {
    super.dispose();
    state.page=1;
    state.System=[];
    widget.logic.update();
    _scrollController.dispose();
  }

  Newsquantity() async {

    var result = await xiaoxi.Newsquantity();
    if (result.statusCode == 200) {
      state.likeCollect = result.body['likeCollect'];
      state.concern = result.body['concern'];
      state.likeComment = result.body['likeComment'];
      state.systemnum = result.body['system'];
      widget.logic.update();
    }
  }

  Firstdata(page) async {

    print('chufalema');
    var result = await widget.provider.Messageinterface(1, page);
    if (result.statusCode == 200) {
      state.System = MessageFromJson(result?.bodyString ?? "");
      widget.logic.update();
      // userLogicone.emptyNews();
    }
    setState(() {oneData = true;});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
        child:
        Column(
            children: [
              Container(
                height: 50,
                alignment: const FractionalOffset(0.5, 0.5),
                decoration: BoxDecoration( // 边色与边宽度
                  // color: Colors.white,
                  color: const Color(0xffffffff),
                  boxShadow: [
                    BoxShadow(
                      // blurRadius: 5, //阴影范围
                      spreadRadius: 0.1, //阴影浓度
                      color: Colors.grey.withOpacity(0.2), //阴影颜色
                    ),
                  ],),
                child: ConstrainedBox(
                  constraints: const BoxConstraints.expand(),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text('我的消息'.tr, style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                      Positioned(
                        right: 20,
                        child: GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Divider(height: 1.0, color: Colors.grey.shade200,),
              const SizedBox(height: 20,),
              Expanded(child:
              RefreshIndicator(onRefresh: _onRefresh,
                  child:ListView(
                      shrinkWrap: true,
                      controller: _scrollController,
                      children: [
                        GetBuilder<MessageLogic>(builder: (logic) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(child: Container(
                                width: 120,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      alignment: const FractionalOffset(1, 0),
                                      decoration: const BoxDecoration(
                                        //color: Colors.red,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/zhanheshou.png'),
                                          fit: BoxFit.fill, // 完全填充
                                        ),
                                      ),
                                      child: state.likeComment>0?Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(50)),
                                            color: Colors.red,
                                            border: Border.all(color: Colors.white,width: 2)
                                        ),
                                        width: 20,
                                        height: 20,
                                        child: Text(state.likeComment.toString(),
                                          style: const TextStyle(color: Colors.white,
                                              fontSize: 8,
                                              height: 1.0),),
                                      ):Container(),
                                    ),
                                    const SizedBox(height: 12,),
                                    Text('评论和@'.tr, style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff000000),
                                    ))
                                  ],
                                ),
                              ), onTap: () {
                               Get.to(AommentandPage(),
                                   //transition: Transition.leftToRight
                               );
                              },),
                              GestureDetector(child: Container(
                                width: 120,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      alignment: const FractionalOffset(1, 0),
                                      decoration: const BoxDecoration(
                                        //color: Colors.red,
                                        image: DecorationImage(
                                          image: AssetImage(
                                              'assets/images/xinguanzhu.png'),
                                          fit: BoxFit.fill, // 完全填充
                                        ),
                                      ),
                                      child: state.concern>0?Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(50)),
                                            color: Colors.red,
                                            border: Border.all(color: Colors.white,width: 2)
                                        ),
                                        width: 20,
                                        height:20,
                                        child: Text(state.concern.toString(),
                                          style: const TextStyle(color: Colors.white,
                                              fontSize: 8,
                                              height: 1.0),),
                                      ):Container(),
                                    ),
                                    const SizedBox(height: 12),
                                    Text('新增关注'.tr, style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff000000),
                                    ),)
                                  ],
                                ),
                              ), onTap: () {
                                Get.to(
                                    NewConcernsPage(),
                                    //transition: Transition.leftToRight
                                    );

                              },),
                              GestureDetector(child: Container(
                                width: 120,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 55,
                                      height: 55,
                                      alignment: const FractionalOffset(1, 0),
                                      decoration: const BoxDecoration(
                                        //color: Colors.red,
                                        image: DecorationImage(
                                          image: AssetImage('assets/images/zan@.png'),
                                          fit: BoxFit.fill, // 完全填充
                                        ),
                                      ),
                                      child: state.likeCollect>0?Container(
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(50)),
                                            color: Colors.red,
                                            border: Border.all(color: Colors.white,width: 2)
                                        ),
                                        width: 20,
                                        height: 20,
                                        child: Text(state.likeCollect.toString(),
                                          style: const TextStyle(color: Colors.white,
                                              fontSize: 8,
                                              height: 1.0),),
                                      ):Container(),
                                    ),
                                    const SizedBox(height: 12,),
                                    Text('赞和收藏'.tr, style: const TextStyle(
                                        fontSize: 13,
                                        color: Color(0xff000000),
                                    ))
                                  ],
                                ),
                              ), onTap: () {
                                Get.to(LikeandCollectPage(),
                                    //transition: Transition.leftToRight
                                );
                              },),
                            ],
                          );
                        }),
                        const SizedBox(height: 10),
                        // Container(
                        //   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        //   decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                        // ),
                        !oneData
                            ? StartDetailLoading():
                        Column(children: [
                          GetBuilder<MessageLogic>(builder: (logic) {
                            return GestureDetector(child: Container(
                              padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                              margin: const EdgeInsets.only(left: 15,right: 15),
                              decoration: const BoxDecoration(border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Color(0xffF1F1F1)))),
                              child: Row(
                                children: [
                                  if(state.System.length>0) Stack(clipBehavior: Clip.none,children: [
                                    Container(
                                      width: 45,
                                      height: 45,
                                      child:
                                      state.System[0].userAvatar == ''
                                          ? Image.asset('assets/images/xtxiaox.png')
                                          : Image.network(
                                          state.System[0].userAvatar),
                                      // decoration: BoxDecoration(
                                      //     border: Border.all(
                                      //         color: Colors.red, width: 1)),
                                      // decoration: BoxDecoration(
                                      //   borderRadius: BorderRadius.circular(100),
                                      //   image: DecorationImage(
                                      //     fit: BoxFit.cover,
                                      //     //image: NetworkImage(state.UserContent[i].userAvatar),
                                      //   ),
                                      // )
                                    ),
                                    Positioned(top: -5,right: -5,child: state.systemnum>0?Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(50)),
                                          color: Colors.red,
                                          border: Border.all(color: Colors.white,width: 2)
                                      ),
                                      width: 20,
                                      height: 20,
                                      child: Text(state.systemnum.toString(),
                                        style: const TextStyle(color: Colors.white,
                                            fontSize: 8,
                                            height: 1.0),),
                                    ):Container())
                                  ],),
                                  if(state.System.length>0) const SizedBox(width: 15,),
                                  if(state.System.length>0) Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceBetween,
                                          children: [
                                            Expanded(child: Text(
                                              state.System[0].title,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                              ),)),
                                            const SizedBox(width: 18,),
                                            Text(state.System[0].createdAt,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xff999999),
                                              ),),
                                          ],
                                        ),
                                        const SizedBox(height: 10,),
                                        Text(state.System[0].text,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2, style: const TextStyle(
                                              fontSize: 14,
                                              color: Color(0xff666666),
                                          ),),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ), onTap: () async {
                              Get.to(SystemtzPage());
                            },);
                          }),
                          GetBuilder<UserLogic>(builder: (logic) {
                            return ListView.builder(
                                shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
                                physics: const NeverScrollableScrollPhysics(), //禁止滚动
                                itemCount: userLogicone.Chatrelated['${userLogicone.userId}']!=null?userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'].length:0,
                                //   itemCount: 2,
                                itemBuilder: (context, i) {
                                  return GestureDetector(child: Container(
                                    padding: const EdgeInsets.fromLTRB(0, 25, 0, 25),
                                    margin: const EdgeInsets.only(left: 15,right: 15),
                                    decoration: const BoxDecoration(border: Border(
                                        bottom: BorderSide(
                                            width: 1, color: Color(0xffF1F1F1)))),
                                    child: Row(
                                      children: [
                                        GestureDetector(child: Container(
                                          width: 45,
                                          height: 45,
                                          alignment: const FractionalOffset(1, 0),
                                          decoration: BoxDecoration(
                                            //color: Colors.red,
                                              image: DecorationImage(
                                                image: NetworkImage(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Avatar']),
                                                fit: BoxFit.fill, // 完全填充
                                              ),
                                              borderRadius: const BorderRadius.all(Radius.circular(100))
                                          ),
                                          child: userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Messagesnum']!=null&&userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Messagesnum']>0?Container(
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: const BorderRadius.all(
                                                    Radius.circular(50)),
                                                border: Border.all(color: Colors.white,width: 2)
                                            ),
                                            width: 20,
                                            height: 20,
                                            child: Text(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Messagesnum'].toString(),
                                              style: const TextStyle(color: Colors.white,
                                                  fontSize: 8,
                                                  height: 1.0),),
                                          ):Container(),
                                        ),onTap: (){
                                          Get.toNamed('/public/user', arguments: userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Uid']);
                                        },),
                                        const SizedBox(width: 15,),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Expanded(child: Text(
                                                    userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Name'],
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                    ),)),
                                                  const SizedBox(width: 10,),
                                                  Text(messageTime(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]["Message"]["Times"]).toString(),
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Color(0xff999999),
                                                    ),),
                                                ],
                                              ),
                                              const SizedBox(height: 10,),
                                              if(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]["Message"]['MessageType']==1)Text(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]["Message"]["message"],
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2, style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff666666),
                                                ),),
                                              if(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]["Message"]['MessageType']==2)Text('视频'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2, style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff666666),
                                                ),),
                                              if(userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]["Message"]['MessageType']==3)Text('图片'.tr,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2, style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xff666666),
                                                ),),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ), onTap: () async {
                                    WebSocketes.channel.sink.add(jsonEncode({'Code':10006,'Target': userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Uid'], 'Send': userLogicone.userId,}));
                                    Get.to(ChatPage(),arguments: {'uid':userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Uid'],'id':userLogicone.userId,'uname':userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Name'],'Avatar':userLogicone.Chatrelated['${userLogicone.userId}']['Chatlist'][i]['Avatar']});
                                    userLogicone.Clearunread(i);
                                  },);
                                }
                            );
                          })
                        ],),

                      ]))
              ),
            ]
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    Firstdata(1);
    Newsquantity();
  }

  static String messageTime(timeStamp){
    // 当前时间
    int time = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    // 对比
    num _distance = time - timeStamp;
    if(_distance <= 180){
      print('刚刚');
      return '刚刚'.tr;
    }else if(_distance <= 3600){
      print('前分钟');
      return '${'前'.tr}${(_distance / 60).floor()}${'分钟'.tr}';
    }else if(_distance <= 43200){
      print('前小时');
      return '${'前'.tr}${(_distance / 60 / 60).floor()}${'小时'.tr}';
    }else if(DateTime.fromMillisecondsSinceEpoch(time*1000).year == DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).year){
      //return '${CustomStamp_str(Timestamp: timeStamp, Date: 'MM/DD hh:mm', toInt: false)}';
      return '${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).hour}:${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).minute} ${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).day}/${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).month}';
    }else{
      return '${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).hour}:${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).minute} ${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).day}/${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).month}/${DateTime.fromMillisecondsSinceEpoch(timeStamp*1000).year}';
    }
  }
}
