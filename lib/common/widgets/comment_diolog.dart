import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/services/comment.dart';
import 'package:lanla_flutter/ulits/toast.dart';

import 'package:lanla_flutter/models/comment_parent.dart';

/**
 * 拉起评论输入框
 */

bool Antishaking=true;
void CommentDiolog(contentId,
    {int parentUid = 0,
      int pid=0,
    int baseId = 0,
    required Function parentCallback,
    required Function childCallback}) {
  String Value = '';
  CommentProvider provider = Get.put<CommentProvider>(CommentProvider());
  print('拉起评论');
  Get.bottomSheet(
    Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(5, 8, 5, 8),
      child: Row(
        children: [
          Expanded(
              child: Container(
            color: Colors.white,
            child: TextField(
              onChanged: (value) {
                Value = value ?? '';
              },
              decoration: InputDecoration(
                hintText: '请填写评论内容'.tr,
                hintStyle: const TextStyle(color: Colors.black12),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.black, // 边框颜色
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(50),
                  ),
                ),

                ///设置内容内边距
                contentPadding:
                    EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
              ),
              autofocus: true,
            ),
          )),
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
                onPressed: () async {
                  if(Antishaking){
                    Antishaking=false;
                    print('评论了');
                    if (Value == '') {
                      ToastInfo('不能为空'.tr);
                      return;
                    }
                    final data = await provider.publish(
                        Value, contentId, parentUid, baseId,pid);
                    if (data == '') {
                      ToastInfo('评论失败，请检查您的网络'.tr);
                      return;
                    }
                    Map<String, dynamic> bodyString = json.decode(data);
                    print('评论');
                    print(baseId);
                    // 解析主评论
                    if (baseId == 0) {
                      CommentParent dataObj = CommentParent.fromJson(bodyString);
                      // 将主评论数据返回
                      parentCallback(dataObj);
                    } else {
                      CommentChild datObj = CommentChild.fromJson(bodyString);
                      childCallback(datObj);
                    }
                    Antishaking=true;
                    if (true) {
                      ToastInfo('评论成功'.tr);
                      //callback();
                      Get.back();
                    }
                  }

                },
                child: Text('发布'.tr)),
          ),
        ],
      ),
    ),
  );
}
