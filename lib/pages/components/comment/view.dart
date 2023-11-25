import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/common/widgets/topic_format.dart';
import 'package:lanla_flutter/models/comment_parent.dart';

import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/pages/detail/picture/picture_view.dart';
import 'package:lanla_flutter/services/comment.dart';
import 'child_view.dart';
import 'logic.dart';

/**
 * 评论组件
 * 使用ListView.builder按行渲染
 */
class CommentWidget extends StatelessWidget {
  late int id;
  final logic = Get.put<CommentLogic>(CommentLogic());
  final userLogic = Get.find<UserLogic>();
  final Function updateCommentCallbak;
  CommentWidget(id,text,topics, goodsList,{super.key, required this.updateCommentCallbak}) {
    //if (logic.contentId == 0 || logic.contentId != id) {
    if(logic.contentId == id){
      return ;
    }
    logic.contentId = id;
    logic.text = text;
    logic.topics = topics;
    logic.goodsList=goodsList;
    // print('sadasdsad');
    print(logic.goodsList);
    print("初始化评论view${id},${logic.contentId}");
    logic.Interfacerequest();
    // logic.init();
    //}
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CommentLogic>(builder: (logic) {
      return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(), //禁止滚动
        children: [
        if(logic.text!='')Container(
          padding: EdgeInsets.only(left: 0,right: 0),
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Container(
                  padding: EdgeInsets.only(left: 0,right: 20),
                  child: Text(logic.text,style: TextStyle(color: Color(0XFF666666),fontSize: 15),),
              ),
              SizedBox(height: 10,),
              TopicFormat(logic.topics),
              if(logic.goodsList.length>0)SizedBox(height: 15,),
              if(logic.goodsList.length>0)Container(height: 60,width: double.infinity,
                child: ListView(
                    shrinkWrap: true,
                    primary:false,
                    scrollDirection: Axis.horizontal,
                    children:[
                      for(var i=0;i<logic.goodsList.length;i++)
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
                              logic.goodsList[i].thumbnail,
                              fit: BoxFit.cover,
                              width: 40,
                              height: 40,
                            ),
                          ),
                          SizedBox(width: 8,),
                          Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children: [
                            Container(constraints: BoxConstraints(maxWidth: 250,),child:
                            Text(logic.goodsList[i].title,overflow: TextOverflow.ellipsis,
                              maxLines: 1,style: TextStyle(fontSize: 14),),),
                            SizedBox(height: 5,),
                            XMStartRatingtwo(rating: double.parse(logic.goodsList[i].score) ,showtext:true)
                          ],)
                        ],),),onTap: (){
                          Get.toNamed('/public/Evaluationdetails',arguments: {'data':logic.goodsList[i]} );
                        },)
                    ]),
              ),
              SizedBox(height: 10,),
              // Divider(
              //   color: Colors.black12,
              // ),
              Container(
                padding: EdgeInsets.only(right: 0),
                child: Container(
                  height: 0.1,
                  color: Colors.black38,
                  margin: EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ],
          ),
        ),

        ListView.builder(
          shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
          physics: const NeverScrollableScrollPhysics(), //禁止滚动
          itemCount: logic.parentDataSource.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index > logic.parentDataSource.length - 1) {
              return _more();
            }
            return _parentWrapper(
                logic.contentId, logic.parentDataSource[index], index,context);
          },
        )
      ],);
    });
  }

  _more() {
    if (logic.isLoding) {
      return Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.all(15),
          child: Center(child: Text('Loading')));
    }
    if (logic.isEmpyt && logic.parentDataSource.isEmpty) {
      return Container(
          margin: EdgeInsets.only(bottom: 30),
          padding: EdgeInsets.all(15),
          child: Center(child: Text('还没有评论哟'.tr)));
    }

    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(20),
      child: Center(
        child: logic.isMore
            ? GestureDetector(
                onTap: () {
                  print('558899999');
                  int page = ((logic.parentDataSource.length / 10) + 1).truncate();
                  print('558899999');
                  logic.fetch(page);
                },
                child: Text(
                  '加载更多评论'.tr,
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600),
                ),
              )
            : Text(
                '',
                //    '没有更多评论啦'.tr,
                style: TextStyle(color: Colors.black26),
              ),
      ),
    );
    return Text('加载更多');
  }

  /**
   * 父评论渲染组件
   */
  Widget _parentWrapper(int contentId, CommentParent data, int index,context) {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        child: (Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像部分
              GestureDetector(
                onTap: () {
                  Get.toNamed('/public/user', arguments: data.userId);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  margin: EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    color: Colors.black12,
                    image: DecorationImage(
                        image: NetworkImage(data.userAvatar),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              // 内容部分
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName,
                        style: TextStyle(fontSize: 12, color: Colors.black26),
                      ),
                      GestureDetector(
                        /// 回复主评论
                        onTap: () {
                          CommentDiolog(contentId,
                              baseId: data.id,
                              pid:data.id,
                              parentCallback: (CommentParent data) {},
                              childCallback: (CommentChild data) {
                            Get.find<CommentLogic>().newChild(data, 0, index);
                            print('添加一条回复主评论的子评论');
                            updateCommentCallbak();
                          });
                        },
                        onLongPress: () {
                          // 自己的评论为删除
                          if (data.userId == userLogic.userId) {
                            Get.defaultDialog(
                                title: '删除评论'.tr,
                                textConfirm: '删除'.tr,
                                onConfirm: () async {
                                  await logic.removeData(index);
                                  updateCommentCallbak();
                                  Get.back();
                                },
                                middleText: '是否要删除这条评论'.tr);
                          } else {
                            // 其他人的为举报
                            ReportDoglog(ReportType.comment, data.id,0,'', context,
                                removeCallbak: () {
                              print('删除评论');
                            });
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text.rich(TextSpan(children: [
                              // + "  " 间距
                              TextSpan(text: data.text + "  "),
                              TextSpan(
                                text: data.createdAt.month.toString() +
                                    '-' +
                                    data.createdAt.day.toString(),
                                style: TextStyle(color: Colors.black12),
                              ),
                            ]))),
                      ),
                    ],
                  ),
                ),
              ),
              // 点赞部分
              GestureDetector(
                onTap: () {
                  Get.put<CommentProvider>(CommentProvider()).setLike(data.id);
                  logic.parentDataSource[index].selfLike =
                      !logic.parentDataSource[index].selfLike;
                  logic.parentDataSource[index].likes =
                      logic.parentDataSource[index].selfLike
                          ? logic.parentDataSource[index].likes + 1
                          : logic.parentDataSource[index].likes - 1;
                  logic.update();
                },
                child: Container(
                  padding: EdgeInsets.only(left: 15),
                  width: 30,
                  child: Column(
                    children: [
                      Container(
                        width: 30,
                        alignment: Alignment.center,
                        child: data.selfLike == false
                            ?
                       SvgPicture.asset('assets/svg/pinglun_heart_nor_new.svg')
                            :
                        SvgPicture.asset('assets/svg/heart_sel_new.svg'),
                        // Icon(
                        //         Icons.favorite,
                        //         size: 22,
                        //         color: Colors.red,
                        //       ),
                      ),
                      Text(
                        data.likes.toString(),
                        style: TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          Container(
            child: CommentChildView(logic.contentId, index, updateCommentCallbak: () {
              print('添加一条回复主评论的子评论');
              updateCommentCallbak();
            }),
          ),
          // Divider(
          //   color: Colors.black12,
          // )
          Container(
            padding: EdgeInsets.only(right: 40),
            child: Container(
               height: 0.1,
               color: Colors.black38,
               margin: EdgeInsets.symmetric(vertical: 10),
             ),
          ),
        ])));
  }
}
