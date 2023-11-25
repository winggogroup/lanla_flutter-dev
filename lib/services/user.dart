import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lanla_flutter/models/UserInfo.dart';

import '../ulits/base_provider.dart';

class UserProvider extends BaseProvider {
  Future<Response> getUserFocusOnData() => post('users/recordsCenter', null);

  Future<Response> setLike(int id) => post('works/like', {'contentId': id});

  Future<Response> setFollow(int userId) =>
      post('users/isFocus', {'userId': userId});
  //批量关注
  Future<Response> batchFollow(userId) =>
      post('users/batchFollow', {'followingIds': userId});


  Future<Response> setCollect(int contentId) =>
      post('works/collect', {'contentId': contentId});

  ///话题列表
  Future<Response> conversation(int userId) =>
      post('topics/userCollectList', {'userId': userId});
  ///pushtoken
  Future<Response> pushtokentwo(deviceToken,String userFirebaseLink) async {
    return await post('users/updateDeviceToken',{"deviceToken":deviceToken,"userFirebaseLink":userFirebaseLink});
  }
  Future<Response> setBlack(int userId, int event) =>
      post('auth/disLike', {'contentId': userId, 'type': 2, 'even': event});

  Future<UserInfoMode?> getUserInfo(userId) async {
    var res = await post('users/info', {'userId': userId});
    if (res.statusCode == 200 && res.bodyString != null) {
      return userInfoModeFromJson(res.bodyString!);
    }
    return null;
  }
  ///收藏地点
  Future<Response> location(int userId) =>
      post('addressGrade/list', {'userId': userId});

  ///收藏好物
  Future<Response> getUserCollectGoodsList(int userId,page) => post('parityRatio/goods/getUserCollectGoodsList', {'userId': userId,'page':page});

  Future<bool> setUserInfo(userName, slogan, userAvatar, sex, birthday) async {
    var res = await post('users/update', {
      'userName': userName,
      'slogan': slogan,
      'userAvatar': userAvatar,
      'sex': sex,
      'birthday': birthday
    });
    return res.statusCode == 200;
  }

  Future<Response> cancelAccount() => post('users/logout', {});

  Future<Response> appRecord(int platform, String content) =>
      post('start.php', {'platform': platform, 'content': content});

  ///签到列表
  Future<Response> dailyCheckInTaskList()=>post('checkIn/dailyCheckInTaskList',{});
  ///签到
  Future<Response> signbutton()=>post('checkIn/sign',{});
  ///个人等级
  Future<Response> dailyTaskUserInfo()=>post('checkin/dailyTaskUserInfo',{});

  ///每日任务

  Future<Response> dailyTaskList()=>post('checkin/dailyTaskList',{});


}
