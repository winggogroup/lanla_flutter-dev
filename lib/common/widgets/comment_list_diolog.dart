import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/models/comment_parent.dart';
import 'package:lanla_flutter/pages/components/comment/logic.dart';
import 'package:lanla_flutter/pages/components/comment/view.dart';
import 'comment_diolog.dart';

void CommentListDiolog(int contentId,text,topics,goodsList,
    {int count = 0, Function? plus, Function? updateCommentNumber}) {
  print('评论id：$goodsList');
  print(text);
  print(topics);
  print('$count');
  print('$plus');
  print('$updateCommentNumber');
  print('结束');

  Get.bottomSheet(Container(
    decoration:const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.horizontal(left: Radius.circular(25),right:Radius.circular(25)),
    ),
    child: Column(
      children: [
        Container(
          height: 50,
       decoration: BoxDecoration(
              border: text==''?const Border(bottom: BorderSide(color: Colors.black12)):const Border(bottom: BorderSide(color: Colors.white))
       ),
          child: Center(
            child: Text('评论'.tr),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(1, 0, 1, 20),
                child: CommentWidget(contentId,text,topics,goodsList,updateCommentCallbak: () {
                  if(updateCommentNumber != null){
                    updateCommentNumber();
                  }
                })),
          ),
        ),
        GestureDetector(
          onTap: () {
            // 插入一条父评论
            CommentDiolog(contentId, parentCallback: (CommentParent data) {
              Get.find<CommentLogic>().newParent(data);
              if (plus != null) {
                plus();
              }
            }, childCallback: (CommentChild datObj) {
              if (plus != null) {
                plus();
              }
            });
          },
          child: Container(
            height: 45,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 20),
            padding: const EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              color: const Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                // Icon(
                //   Icons.pending,
                //   color: Colors.black38,
                // ),
                SvgPicture.asset('assets/svg/bi.svg',width: 18,height: 18,),
                const SizedBox(width: 10,),
                // Text('欢迎说出你的评论'.tr)
                Text(
                  '${'说点什么'.tr}...',
                  style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xff999999)),
                )
              ],
            ),
          ),
        ),
      ],
    ),
  ));
}
