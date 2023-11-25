import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/TopItemModel.dart';
import 'package:lanla_flutter/ulits/toast.dart';

import '../models/ChannelList.dart';
import '../ulits/base_provider.dart';
import '../ulits/get_location.dart';

class ContentProvider extends BaseProvider {
  // 获取首页栏目内容
  Future<Response> GetHomeList(int id, String channel) async {
    return await post('works/list',{"page":id,"channel":channel,"isConcern":0});
  }

  // 获取用户发布的内容列表
  Future<Response> GetUserPublishList(int id, String userId) async {
    return await post('users/workslist',{"page":id,"userId":userId});
  }
  // 获取用户收藏的内容列表
  Future<Response> GetUserLikeList(int id, String userId) async {
    return await post('users/likeWorksList',{"page":id,"userId":userId});
  }
  // 获取用户收藏的内容列表
  Future<Response> GetSearch(keyword,page) async {
    return await post('searchs/searchHot',{"keywords":keyword,"isType":1,'page':page});
  }

  ///pushtoken
  Future<Response> pushtoken(deviceToken,String userFirebaseLink) async {
    return await post('users/updateDeviceToken',{"deviceToken":deviceToken,"userFirebaseLink":userFirebaseLink});
  }
  ///消息数量
  Future<Response> Newsquantity() async {
    return await post('notice/noticeTotal',{});
  }
  ///检测活跃
  Future<Response> dailyOnlineDurationTracker() async {
    return await post('checkin/dailyOnlineDurationTracker',{});
  }


  // 获取最热的内容
  Future<Response> GetTopicHot(parameter,page) async {
    return await post('topics/recommendHot',{'page':page,'topicId':parameter});
  }
  // 获取最新的内容
  Future<Response> GetTopicNew(parameter,page) async {
    return await post('topics/recommendNew',{'page':page,'topicId':parameter});
  }


  // 获取附近的信息
  Future<Response> GetLoction(page) async {
    Position position = await GetLocation();
    return await post('works/thereEarby',{"lat":position.latitude,"lng":position.longitude,'page':page});
  }
  // 获取用户点赞的内容列表
  Future<Response> GetUserCollectList(int id, String userId) async {
    return await post('users/collectWorksList',{"page":id,"userId":userId});
  }

  // 获取栏目列表
  Future<List<ChannelList>?> GetChannel() async {
    Response res = await post('topics/nominal',{});
    if(res.statusCode != null && res.statusCode == 200 && res.bodyString != null){
      return channelListFromJson(res.bodyString!);
    }
    //ToastInfo('请求频道列表出错'.tr);

    ToastInfo('请检查网络连接'.tr);
    await Future.delayed(const Duration(seconds: 2), (){});
    return GetChannel();
  }
  // 获取话题页面
  Future<Response> Topicpage(page) => post('topics/list',{"page":page});

  Future<void> Delete(int contentId) async{
    Response res = await post('works/delete',{'contentId':contentId});
    if(res.statusCode != null && res.statusCode == 200 && res.bodyString != null){
      ToastInfo('成功'.tr);
    }else{
      ToastInfo('失败'.tr);
    }
  }
  Future<HomeDetails?> Detail(int contentId) async{
    Response res = await post('works/detail',{'id':contentId});
    if(res.statusCode == 200 && res.statusCode != null && res.bodyString != null){
      return HomeDetails.fromJson(json.decode(res.bodyString!));
    }

  }
  Future<List<TopItemModel>?> TopList() async{
    Response res = await post('best/list',{});
    if(res.statusCode == 200 && res.statusCode != null && res.bodyString != null){
       return topItemModelFromJson(res.bodyString!);
    }
    return null;
  }


  //判断新老用户
  Future<Response> isUpgrade() => post('auth/isUpgrade',{});


  //判断新老用户
  //Future<Response> Newandoldusers(String phonenumber,String area_code) => get('user/user?phone='+phonenumber+'&area_code='+area_code);
  //发送验证码
  Future<Response> SendVerificationCode(String account,String area_code) => post('auth/sendCode',{"account":account,"type":1,"areaCode":area_code});
  //验证码验证
  Future<Response> VerificationCode(String phone,String area_code,String code,String sourcePlatform) => post('auth/login',{"account":phone,"code":code,"areaCode":area_code,'sourcePlatform':sourcePlatform});
  //firebase验证码验证
  Future<Response> firebaseVerificationCode(String phone,String area_code,String sourcePlatform,idToken) => post('auth/registerUser',{"account":phone,"areaCode":area_code,"sourcePlatform":sourcePlatform,'idToken':idToken});
  //设置密码
  //Future<Response> SetPassword(String phone,String area_code,String password) => post(baseHttp+'user/user',{ "phone": phone,"password": password,"area_code": area_code});
  //获取位置
  Future<Response> positions() => otherGet('http://ip-api.com/json');
  //完善个人信息
  Future<Response> wansinformation(String sex,String birthday) => post('auth/basics',{'sex':sex,"birthday":birthday});
  //选择话题


  //选择话题
  Future<Response> ChooseTopic(String topicId) => post('auth/basics',{'topicId':topicId});
  //选择话题
  Future<Response> Topiclist() => post('topics/nominal',{});
  //添加话题
  Future<Response> determineht(topicId) => post('auth/topics',{'topicId':topicId});
  //列表
  Future<Response> followlist(String page) => post('works/list',{'page':page,"channel":0,"isConcern":1});
  //关注
  Future<Response> follow(String userId) => post('users/isFocus',{'userId':userId});
  //点赞
  Future<Response> give(String contentId) => post('works/like',{'contentId':contentId});
  //收藏
  Future<Response> Collection(String contentId)=>post('works/collect',{'contentId':contentId});

  //举报
  Future<Response> Report(int contentId, int type,tip,text,imagePath)=>post('auth/report',{'contentId':contentId,'type':type,'tip':tip,'imagePath':imagePath,'text':text});

  ///举报列表
  Future<Response> reportTip()=>post('auth/reportTip',{});
  
  //不喜欢
  Future<Response> Notlike(int contentId, int type, int event)=>post('auth/disLike',{'contentId':contentId,'type':type,'even':event});

  //分享
  Future<Response> ForWard(int targetId, int type)=>post('works/forward',{'targetId':targetId,'type':type});

  ///全部话题
  Future<Response> Topicslist(page)=>post('topics/hot',{'page':page});

  ///图文礼物列表
  Future<Response> contentGiftDetail(page,contentId)=>post('balance/contentGiftDetail',{'page':page,'contentId':contentId});

  ///动态弹窗
  Future<Response> DynamicPopup()=>post('window',{});

  ///验证手机号
  Future<Response> checkStatus(phone,areaCode)=>post('phoneLogin/checkStatus',{'phone':phone,'area_code':areaCode});

  ///验证数据
  Future<Response> makeSecurityAuth(phone,areaCode)=>post('phoneLogin/makeSecurityAuth',{'phone':phone,'area_code':areaCode});

  ///账号验证
  Future<Response> checkSecurityAuth(phone,areaCode,type,sec_val_token)=>post('phoneLogin/checkSecurityAuth',{'phone':phone,'area_code':areaCode,'sec_val_token':sec_val_token,'type':type});

  ///设置密码
  Future<Response> setPassword(phone,areaCode,type,sec_val_token,password)=>post('phoneLogin/setPassword',{'phone':phone,'area_code':areaCode,'sec_val_token':sec_val_token,'type':type,'password':password});

  ///修改频道
  Future<Response> userChannel(user_channel)=>post('topics/userChannel',{'user_channel':user_channel});

  ///获取新频道列表
  Future<Response> userChannellist()=>get('topics/userChannel');

  ///内容专区列表
  Future<Response> contentArealist(page)=>get('contentArea/list?page=$page');

  ///内容专区详情
  Future<Response> contentAreadetail(id)=>get('contentArea/detail?id=$id');

  ///内容专区详情作品列表
  Future<Response> contentAreacontents(id,page)=>get('contentArea/contents?id=$id&page=$page');

  ///活动专区列表
  Future<Response> eventlist(page)=>get('event/list?page=$page');

  ///商品页面信息
  Future<Response> commoditylist(page,mark_type,is_like)=>get('item/list?page=$page&mark_type=$mark_type&is_like=$is_like&approval_status=1');

  ///商品页面配置盒子
  Future<Response> commoditybox()=>get('item/box');

  ///商品喜欢
  Future<Response> commoditylike(data)=>post('item/like',data);

}