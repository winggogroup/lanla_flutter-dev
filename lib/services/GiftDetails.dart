
import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';
class GiftDetails extends BaseProvider{
  ///礼物列表
  Future<Response> giftList() => post('gift/list',{});
  ///余额查询
  Future<Response> Balancequery() => post('balance/detail',{});
  ///送礼物
  Future<Response> Givingifts(contentId,giftId) => post('gift/sendGift',{'contentId':contentId,"giftId":giftId});
  ///充值列表
  Future<Response> Rechargelist() => post('balance/goodsList',{});
  ///明细
  Future<Response> detailedlist(type,searchTime,page) => post('balance/detailLogList',{'type':type,'searchTime':searchTime,'page':page});
  ///礼物明细
  Future<Response> detailLog(id) => post('balance/detailLog',{'id':id});
  ///兑换列表
  Future<Response> goodsShellsList(page) => post('balance/goodsShellsList',{'page':1});
  ///充值
  Future<Response> Paymentinterface(orderId,token,localOrderId) => post('balance/googlePay',{'orderId':orderId,'googlePayInfo':token,'localOrderId':localOrderId});
  ///苹果充值
  Future<Response> ApplePaymentinterface(orderId,token,localOrderId) => post('balance/applePay',{'orderId':orderId,'applePayInfo':token,'localOrderId':localOrderId});

  ///预充值
  Future<Response> Precharge(orderId) => post('order/createOrder',{'orderId':orderId});
  ///兑换某个商品的用户信息
  Future<Response> exchangeProductUserInfo(shellsGoodId) => post('shellsGoods/exchangeProductUserInfo',{'shellsGoodId':shellsGoodId});
  ///贝壳兑换
  Future<Response> exchangeShellsGift(shellsGoodId) => post('shellsGoods/exchangeShellsGift',{'shellsGoodId':shellsGoodId});

}