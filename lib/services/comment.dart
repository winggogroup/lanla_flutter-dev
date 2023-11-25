
import 'dart:convert';

import 'package:get/get.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/models/comment_parent.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class CommentProvider extends BaseProvider {
  // 获取评论列表
  Future<Response> getParent(contentId, page) async {
    return await post('comment/list', {'contentId': contentId, 'page': page});
  }
  // 获取子评论列表
  Future<List<CommentChild>> getChild(int commentId, int page) async {
    Response res = await post('comment/childList', {'commentId': commentId, 'page': page});
    if(res.statusCode == 200 && res.bodyString != null){
      List<CommentChild> dataList = commentChildFromJson(res.bodyString!);
      return dataList;
    }
    return [];
  }

  // 发布评论
  Future<String> publish(text, contentId, parentUid, baseId,pid) async {
    Response data =  await post('comment/add', {
      'text': text,
      'contentId': contentId,
      'parentUid': parentUid,
      'baseId': baseId,
      'pid':pid,
    });
    print('aaa');
    print(data.bodyString);
    if(data.statusCode == 200){
      return data.bodyString??'';
    }
    return '';
  }

  /// 点赞
  Future<bool> setLike(id) async {
    Response data = await post('comment/likeComment', {'commentId': id});
    if(data.statusCode == 200){
      return true;
    }
    ToastInfo('Like error');
    return false;
  }

  Future<bool> del(commentId) async{
    Response data = await post('comment/delete', {'commentId': commentId});
    if(data.statusCode == 200){
      return true;
    }
    ToastInfo('Like error');
    return false;
  }
}
