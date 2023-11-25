import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/LocationDetails.dart';
import 'package:lanla_flutter/models/positionlist.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
import 'package:lanla_flutter/ulits/get_location.dart';

class positioninformation extends BaseProvider{

  Future<List<Object>> getLocationList(String keyword) async {
    print('jianlema');
    Position position = await GetLocation();
    print(position);
    var res = await post('map/nearbyBuilding',{"lat":position.latitude,"lng":position.longitude,"keyword":keyword});
    if(res.statusCode == 200 && res.bodyString != null){
      print('用户资料返回：${res.bodyString}');
      return positionlistFromJson(res.bodyString!);
    }
    return [];
  }
  ///位置详情
  Future<Object> LocationDetails(String id) async {
    print('jianlema');
    // Position position = await GetLocation();
    // print(position);
    var res = await post('map/detail',{"placeId":id});
    if(res.statusCode == 200 && res.bodyString != null){
      print('用户资料返回：${res.bodyString}');
      return LocationDetailsFromJson(res.bodyString!);
    }
    return {};
  }
  ///添加关注状态
  Future<Response> Addressevaluation(String id,type,grade)=> post('addressGrade/add',{"type": type,"grade":grade,"placeId":id});


  ///删除状态
  Future<Response> delressevaluation(int id)=> post('addressGrade/del',{"id":id});


  // /// 搜索
  // Future<List<TopicModel>> getSearchList(String keyword) async {
  //   var res = await post('topics/searchs',{'keywords':keyword});
  //   if(res.statusCode == 200 && res.bodyString != null){
  //     print('用户资料返回：${res.bodyString}');
  //     return topicModelFromJson(res.bodyString!);
  //   }
  //   return [];
  // }
  //
  // /// 创建,并返回搜索列表
  // Future<String> getCreated(String title) async {
  //   var res = await post('topics/adds',{'title':title});
  //   if(res.statusCode == 200 && res.bodyString != null){
  //     Map re = jsonDecode(res.bodyString!);
  //     return re["id"];
  //   }
  //   return "";
  // }
  // /// 创建,并返回搜索列表
  // Future<TopicModel?> getDetail(int id) async {
  //   var res = await post('topics/details',{'topicId':id});
  //   if(res.statusCode == 200 && res.bodyString != null){
  //     return TopicModel.fromJson(jsonDecode(res.bodyString!));
  //   }
  //   return null;
  // }
  //
  //
  // 获取最热的内容
  Future<List<HomeItem>> MapGetTopicContent(String type,id,page) async {
    var res = await post('map/recommend$type',{'page':page,'placeId':id});

    if(res.statusCode == 200 && res.bodyString != null){
      return homeItemFromJson(res.bodyString!);
    }
    return [];
  }
  //
  //
  // // 收藏话题
  // Future<bool> setCollects(int topicId,bool isCollect) async {
  //   var res = await post('topics/collects',{'topicId':topicId,'isCollect':isCollect ?2:1});
  //   if(res.statusCode == 200 && res.bodyString != null){
  //     return true;
  //   }
  //   return false;
  // }

}