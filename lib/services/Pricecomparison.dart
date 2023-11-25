import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
class Pricemodule extends BaseProvider{
  ///商品列表
  Future<Response> parityRatiolist(data) => post('parityRatio/goods/list',data);
  ///商品频道列表
  Future<Response> parityRatiochannlelist(page) => post('parityRatio/channle/list', {'page':page});
  ///商品详情
  Future<Response> parityRatiodetail(id,show,page) => post('parityRatio/goods/detail', {'show':show,'id':id,'page':page});
  ///商品收藏
  Future<Response> parityRatiocollect(id) => post('parityRatio/goods/collect', {'id':id});

  ///商品评论
  Future<Response> parityRatiocommentadd(data) => post('parityRatio/comment/add', data);

  ///关联商品的作品
  Future<List<HomeItem>> Relatedworks(id,page) async {
    var res = await post('parityRatio/goods/contentList',{'goodsId':id,'page':page});

    if(res.statusCode == 200 && res.bodyString != null){
      return homeItemFromJson(res.bodyString!);
    }
    return [];
  }






}