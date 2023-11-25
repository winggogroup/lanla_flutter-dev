import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class SearchProvider extends BaseProvider{
  ///本周排行
  Future<Response> Weeklyranking() => post('searchs/rankingList', {"isType":1});
  ///本月排行
  Future<Response> Monthlyranking() => post('searchs/rankingList', {"isType":2});
  ///热度排行
  Future<Response> Heatranking() => post('searchs/rankingList', {"isType":3});
  ///搜索
  Future<Response> Searchcontent(String keywords,String isType,String page) => post('searchs/searchHot'
      ,{"keywords":keywords,"isType":isType,"page":page});
  ///关注
  Future<Response> Follow(String userId) => post('users/isFocus'
      ,{"userId":userId});
}