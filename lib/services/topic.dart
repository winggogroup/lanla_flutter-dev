import 'dart:convert';

import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class TopicProvider extends BaseProvider{

  Future<List<TopicModel>> getHotList() async {
    var res = await post('topics/hot',null);
    if(res.statusCode == 200 && res.bodyString != null){
      // print('用户资料返回：${res.bodyString}');
      return topicModelFromJson(res.bodyString!);
    }
    return [];
  }
  /// 搜索
  Future<List<TopicModel>> getSearchList(String keyword) async {
    var res = await post('topics/searchs',{'keywords':keyword});
    if(res.statusCode == 200 && res.bodyString != null){
      // print('用户资料返回：${res.bodyString}');
      return topicModelFromJson(res.bodyString!);
    }
    return [];
  }

  /// 创建,并返回搜索列表
  Future<String> getCreated(String title) async {
    var res = await post('topics/adds',{'title':title});
    if(res.statusCode == 200 && res.bodyString != null){
      Map re = jsonDecode(res.bodyString!);
      return re["id"];
    }
    return "";
  }
  /// 创建,并返回搜索列表
  Future<TopicModel?> getDetail(int id) async {
    var res = await post('topics/details',{'topicId':id});
    if(res.statusCode == 200 && res.bodyString != null){
       return TopicModel.fromJson(jsonDecode(res.bodyString!));
    }
    return null;
  }


  // 获取最热的内容
  Future<List<HomeItem>> GetTopicContent(String type,id,page) async {
    var res = await post('topics/recommend$type',{'page':page,'topicId':id});

    if(res.statusCode == 200 && res.bodyString != null){
      return homeItemFromJson(res.bodyString!);
    }
    return [];
  }


  // 收藏话题
  Future<bool> setCollects(int topicId,bool isCollect) async {
    var res = await post('topics/collects',{'topicId':topicId,'isCollect':isCollect ?2:1});
    if(res.statusCode == 200 && res.bodyString != null){
      return true;
    }
    return false;
  }

}