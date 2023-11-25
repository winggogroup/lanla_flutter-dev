import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class NewesProvider extends BaseProvider{
  ///消息接口
  Future<Response> Messageinterface(type,page) => post('notice/commentAndCollect',
      {"type":type,'page':page});
  ///粉丝接口
  Future<Response> Myfansinterface(userId,page) => post('users/fansList',
      {"userId":userId,'page':page});

  ///关注列表接口
  Future<Response> Myfollowinterface(userId,page) => post('users/focusList',
      {"userId":userId,'page':page});

  ///收到礼物
  Future<Response> userGiftDetail(type,page) => post('balance/userGiftDetail',
      {"type":type,'page':page});
  ///贝壳兑换礼物
  Future<Response> getRedemptionDetails(page) => post('shellsGoods/getRedemptionDetails',
      {'page':page});
}