import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/services/comment.dart';

import 'package:lanla_flutter/common/widgets/comment_diolog.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/models/comment_parent.dart';
import 'logic.dart';

/// 子评论组件
class CommentChildView extends StatelessWidget {
  final logic = Get.find<CommentLogic>();
  late final int parentIndex;
  late int id;
  late Function updateCommentCallbak;
  bool antishake =true;

  CommentChildView(this.id, this.parentIndex, {super.key,required this.updateCommentCallbak});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: ListView.builder(
          shrinkWrap: true, //范围内进行包裹（内容多高ListView就多高）
          physics: const NeverScrollableScrollPhysics(), //禁止滚动
          itemCount: logic.parentDataSource[parentIndex].children.length + 1,
          itemBuilder: (BuildContext context, int index) {
            if (index >
                logic.parentDataSource[parentIndex].children.length - 1) {
              // 判断评论是否拉取完，没用拉取完则继续拉取
              return _more(logic.parentDataSource[parentIndex].childrenCount,
                  logic.parentDataSource[parentIndex].children.length);
            }
            //print(logic.parentDataSource[parentIndex].children[index].text);
            return _bulid(
                id,
                logic.parentDataSource[parentIndex].children[index],
                logic.parentDataSource[parentIndex].id,
                parentIndex,
                index,context);
            return const Text('s');
          }),
    );
  }

  /// 判断是否显示加载更多
  _more(int count, int nowChild) {
    if (count > nowChild) {
      return GestureDetector(
        onTap: () async {
          if(antishake){
            antishake=false;
            print('总数$count,当前$nowChild');

            /// 请求子评论
            int page = (((nowChild - 1) / 10) + 1).truncate();
            List<CommentChild> data = await Get.find<CommentProvider>()
                .getChild(logic.parentDataSource[parentIndex].id, page);
            print('吐回来:${data.length}');
            if (data.isNotEmpty) {
              logic.parentDataSource[parentIndex].children.addAll(data);
              logic.update();
            } else {
              print('没有更多评论了');
            }
          }

        },
        child: Padding(
          padding: const EdgeInsets.only(right: 60),
          child: Text(
            '加载更多评论'.tr,
            style: const TextStyle(color: Colors.blueGrey),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  _bulid(int contentId, CommentChild data, int parentId, int parentIndex,
      int index,context) {
    return Container(
        margin: const EdgeInsets.only(right: 30),
        child: (Column(children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 头像部分
              GestureDetector(
                onTap: () {
                  // 进入个人主页
                  Get.toNamed('/public/user',
                      arguments: data.userId);
                  },
                child: Container(
                  width: 26,
                  height: 26,
                  margin: const EdgeInsets.only(top: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
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
                  padding: const EdgeInsets.only(right: 10, left: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.userName,
                        style: const TextStyle(fontSize: 12, color: Colors.black26),
                      ),
                      GestureDetector(
                        /// 回复子评论
                        onTap: () {
                          CommentDiolog(contentId,
                              baseId: parentId,
                              pid:data.id,
                              parentUid: data.userId,
                              parentCallback: (CommentParent data) {},
                              childCallback: (CommentChild data) {
                            Get.find<CommentLogic>()
                                .newChild(data, index, parentIndex);
                            updateCommentCallbak();
                          });
                        },
                        // 删除子评论
                        onLongPress: (){
                          // 自己的评论为删除
                          if (data.userId == Get.find<UserLogic>().userId) {
                            Get.defaultDialog(
                                title: '删除评论'.tr,
                                textConfirm: '删除'.tr,
                                onConfirm: () async {
                                  await logic.removeChildData(parentIndex,index);
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
                        child:
                        Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text.rich(TextSpan(children: [
                              if(data.targetUserName != '')TextSpan(text: '回复'.tr),
                              if(data.targetUserName != '')const TextSpan(text: ' '),
                              data.targetUserName == ''
                                  ? const TextSpan(text: '')
                                  : TextSpan(
                                      text: data.targetUserName,
                                      style: const TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.w600),
                                    ),
                              const TextSpan(text: ' '),
                              TextSpan(text: data.text),
                              const TextSpan(text: ' '),
                              TextSpan(
                                style: const TextStyle(color: Colors.black12),
                                text: '${data.createdAt.month}-${data.createdAt.day}',
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
                  logic.parentDataSource[parentIndex].children[index].selfLike =
                      !logic.parentDataSource[parentIndex].children[index]
                          .selfLike;
                  logic.parentDataSource[parentIndex].children[index].likes =
                      logic.parentDataSource[parentIndex].children[index]
                              .selfLike
                          ? logic.parentDataSource[parentIndex].children[index]
                                  .likes +
                              1
                          : logic.parentDataSource[parentIndex].children[index]
                                  .likes -
                              1;
                  print(logic
                      .parentDataSource[parentIndex].children[index].likes);
                  logic.update();
                },
                child: Container(
                  width: 30,
                  padding: const EdgeInsets.only(left: 15),
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
                      ),
                      Text(
                        data.likes.toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.black45),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          const Padding(padding: EdgeInsets.only(top: 4, bottom: 4))
        ])));
  }
}
