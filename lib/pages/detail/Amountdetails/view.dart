import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/FlowDetails.dart';
import 'package:lanla_flutter/models/RechargeList.dart';
import 'package:lanla_flutter/models/exchangelist.dart';
import 'package:lanla_flutter/pages/detail/GiftDetails/view.dart';
import 'package:lanla_flutter/pages/detail/Prizedetails/index.dart';
import 'package:lanla_flutter/services/GiftDetails.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:lanla_flutter/ulits/toast.dart';

class AmountPage extends StatefulWidget {

  @override
  AmountPageState createState() => AmountPageState();
}
class AmountPageState extends State<AmountPage>{
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final Interface = Get.put(GiftDetails());
  List<Rechargelist> Rechargeamountlist=[];
  ScrollController _scrollControllerls = ScrollController(); //listview 的控制器
  int CurrentPageType=1;
  var  Balancequery={};
  var profitlist=[];
  var exchange=[];
  var localOrderId='';
  String dateTime= DateTime.now().toString().substring(0,19);
  int page=0;
  var Antishake=true;
  var Paymentauthority=false;
  final bool _kAutoConsume = Platform.isIOS || true;
  List<ProductDetails> _products = <ProductDetails>[];

  static const String _kConsumableId = 'lanla_goldcoin_01';
  static const String _kUpgradeId = 'lanla_goldcoin_10';
  static const String _kGoldSubscriptionId = 'lanla_goldcoin_30';
  static const String _kfiftySubscriptionId = 'lanla_goldcoin_50';
  static const String _kSilverSubscriptionId = 'lanla_goldcoin_100.00';

  static const String _kConsumableId_iOS = '10001';
  static const String _kUpgradeId_iOS = '10002';
  static const String _kGoldSubscriptionId_iOS = '10003';
  static const String _kfiftySubscriptionId_iOS = '10004';
  static const String _kSilverSubscriptionId_iOS = '10005';

  static const List<String> _kProductIds = <String>[
    _kfiftySubscriptionId,
    _kConsumableId,
    _kGoldSubscriptionId,
    _kUpgradeId,
    _kSilverSubscriptionId,
    // iOS
    _kConsumableId_iOS,
    _kUpgradeId_iOS,
    _kGoldSubscriptionId_iOS,
    _kfiftySubscriptionId_iOS,
    _kSilverSubscriptionId_iOS,
  ];

  void initState() {
    setState(() {
      CurrentPageType=Get.arguments;
    });

    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
          _listenToPurchaseUpdated(purchaseDetailsList);
        }, onDone: () {
          print('chengg');
          _subscription.cancel();
        }, onError: (Object error) {
          // handle error here.
          print('bai');
        });
    initStoreInfo();
    super.initState();
    Rechargelb();
    profit();
    exchangelist();
    _scrollControllerls.addListener(() {
      if (_scrollControllerls.position.pixels >
          _scrollControllerls.position.maxScrollExtent - 50) {
        //达到最大滚动位置
        profit();
      }
    });

    // 加载列表
    EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
    // 延迟消失
    Future.delayed(Duration(seconds: 3), () {
      EasyLoading.dismiss();
    });

  }
  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    //if (purchaseDetails.productID == _kConsumableId) {
    // print('shuju1${purchaseDetails.purchaseID}');
    // print('shuju2${purchaseDetails.verificationData}');
    //
    // print('shuju3zuiyouyong${purchaseDetails.verificationData.serverVerificationData}');
    // print('shuju4${purchaseDetails.verificationData.localVerificationData}');
    // print('shuju5${purchaseDetails.verificationData.source}');

    if (Platform.isIOS) {
      var Paymentresults = await Interface.ApplePaymentinterface(
          purchaseDetails.productID,
          purchaseDetails.verificationData.localVerificationData, localOrderId);
      print('applezifuchuan');
      print(Paymentresults.body['laGoldBalance'] is int);
      if (Paymentresults.statusCode == 200) {
        setState(() {
          Balancequery['laGold'] =
              Paymentresults.body['laGoldBalance'].toString();
        });
        if (Paymentresults.body['purchaseState'] == 0 &&
            Paymentresults.body['consumptionState'] == 0) {
          await _inAppPurchase.completePurchase(purchaseDetails).then((
              value) async {
            await Interface.Paymentinterface(purchaseDetails.productID,
                json.encode(
                    purchaseDetails.verificationData.localVerificationData),
                localOrderId);
          }).catchError(() {
            ToastInfo('支付失败，将在3个工作日退款'.tr);
          });
        }
      } else {

      }
    } else {
      var Paymentresults = await Interface.Paymentinterface(
          purchaseDetails.productID,
          purchaseDetails.verificationData.localVerificationData, localOrderId);
      print('zifuchuan');
      print(Paymentresults.body['laGoldBalance'] is int);
      if (Paymentresults.statusCode == 200) {
        setState(() {
          Balancequery['laGold'] =
              Paymentresults.body['laGoldBalance'].toString();
        });
        if (Paymentresults.body['purchaseState'] == 0 &&
            Paymentresults.body['consumptionState'] == 0) {
          await _inAppPurchase.completePurchase(purchaseDetails).then((
              value) async {
            await Interface.Paymentinterface(purchaseDetails.productID,
                json.encode(
                    purchaseDetails.verificationData.localVerificationData),
                localOrderId);
          }).catchError(() {
            ToastInfo('支付失败，将在3个工作日退款'.tr);
          });
        }
      } else {

      }
    }
    EasyLoading.dismiss();
    //await ConsumableStore.save(purchaseDetails.purchaseID!);
    // final List<String> consumables = await ConsumableStore.load();
    // setState(() {
    //   _purchasePending = false;
    //   _consumables = consumables;
    // });
    // } else {
    //   // setState(() {
    //   //   _purchases.add(purchaseDetails);
    //   //   _purchasePending = false;
    //   // });
    // }
  }


  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {

    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // showPendingUI();
        print('daole1');
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('daole2');
          //handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
            deliverProduct(purchaseDetails);
          } else {
            print('daole4');
            ///如果_verifyPurchase`失败，请在此处处理无效购买。
            // _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
        // if (Platform.isAndroid) {
        //   if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        //     final InAppPurchaseAndroidPlatformAddition androidAddition =
        //     _inAppPurchase.getPlatformAddition<
        //         InAppPurchaseAndroidPlatformAddition>();
        //     await androidAddition.consumePurchase(purchaseDetails);
        //   }
        // }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }
  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        Paymentauthority=true;
        //   _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        //   _purchases = <PurchaseDetails>[];
        //   _notFoundIds = <String>[];
        //   _consumables = <String>[];
        //   _purchasePending = false;
        //   _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
      _inAppPurchase
          .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse = await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    print('55886699885666${productDetailResponse.productDetails}');

// Set literals require Dart 2.2. Alternatively, use
// `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
    const Set<String> _kIds = <String>{
      '10001',
      '10002',
      '10003',
      '10004',
      '10005',
    };
    final ProductDetailsResponse response =
    await InAppPurchase.instance.queryProductDetails(_kIds);
    if (response.notFoundIDs.isNotEmpty) {
      // Handle the error.
    }
    List<ProductDetails> products = response.productDetails;
    for(var item in  products) {
      print('afd132132 item.title:${item.title}');
      print('fsa132132 item.id:${item.id}');
    }

    if (productDetailResponse.error != null) {
      setState(() {
        //   _queryProductError = productDetailResponse.error!.message;
        //   _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        //   _purchases = <PurchaseDetails>[];
        //   _notFoundIds = productDetailResponse.notFoundIDs;
        //   _consumables = <String>[];
        //   _purchasePending = false;
        //   _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        //   _queryProductError = null;
        //   _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        //   _purchases = <PurchaseDetails>[];
        //   _notFoundIds = productDetailResponse.notFoundIDs;
        //   _consumables = <String>[];
        //   _purchasePending = false;
        //   _loading = false;
      });
      return;
    }
    setState(() {
      // print(productDetailResponse.error);
      // // _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      // _notFoundIds = productDetailResponse.notFoundIDs;
      // //_consumables = consumables;
      // _purchasePending = false;
      // _loading = false;
    });


    //final List<String> consumables = await ConsumableStore.load();

  }


  // GooglePlayPurchaseDetails? _getOldSubscription(
  //     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
  //   // This is just to demonstrate a subscription upgrade or downgrade.
  //   // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
  //   // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
  //   // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
  //   // Please remember to replace the logic of finding the old subscription Id as per your app.
  //   // The old subscription is only required on Android since Apple handles this internally
  //   // by using the subscription group feature in iTunesConnect.
  //   GooglePlayPurchaseDetails? oldSubscription;
  //   if (productDetails.id == _kSilverSubscriptionId &&
  //       purchases[_kGoldSubscriptionId] != null) {
  //     oldSubscription =
  //     purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
  //   } else if (productDetails.id == _kGoldSubscriptionId &&
  //       purchases[_kSilverSubscriptionId] != null) {
  //     oldSubscription =
  //     purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
  //   }
  //   return oldSubscription;
  // }


  profit() async {
    print('yeshu${page}');
    if (Antishake) {
      page++;
      Antishake=false;
      var result = await Interface.detailedlist(2, dateTime, page);
      // 延迟1秒请求，防止速率过快
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          Antishake=true;
        });
      });
      if (result.statusCode == 200) {
        if (FlowDetailsFromJson(result.bodyString!).length > 0) {
          if(profitlist.length==0){
            setState(() {
              profitlist = FlowDetailsFromJson(result.bodyString!);
            });
          }else{
            profitlist.addAll(FlowDetailsFromJson(result.bodyString!));
          }
        } else {
          page--;
        }
      } else {
        page--;
      }
    }
  }
  profittwo() async {
    if (Antishake) {

      Antishake=false;
      var result = await Interface.detailedlist(2, dateTime, 1);
      // 延迟1秒请求，防止速率过快
      Future.delayed(Duration(milliseconds: 1000), () {
        setState(() {
          Antishake=true;
        });
      });
      if (result.statusCode == 200) {
        setState(() {
          profitlist = FlowDetailsFromJson(result.bodyString!);
        });
      }
    }
  }

  exchangelist() async {
    var result = await Interface.goodsShellsList(1);
    // 延迟1秒请求，防止速率过快

    if (result.statusCode == 200) {
      setState(() {
        exchange = exchangelistFromJson(result.bodyString!).data;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    profitlist=[];
    page = 0;
    _scrollControllerls.dispose();
  }


  Future<void> Rechargelb() async {
    var result = await Interface.Rechargelist();
    var Goldcoindetails = await Interface.Balancequery();
    print('请求接口');
    if(result.statusCode==200){
      setState(() {
        Balancequery=Goldcoindetails.body;
        Rechargeamountlist=RechargelistFromJson(result.bodyString!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      Container(
        color: Color(0xffF5F5F5),
        width: double.infinity,
        child: Column(
          children: [
            Stack(clipBehavior: Clip.none, alignment:Alignment.center ,children: [
              if(CurrentPageType==1)Container(width: double.infinity,constraints: BoxConstraints(minHeight: 180,),child:Image.asset('assets/images/jinbitc.png',fit: BoxFit.cover,),),
              if(CurrentPageType==2)Container(width: double.infinity,constraints: BoxConstraints(minHeight: 180,),child:Image.asset('assets/images/beikebj.png',fit: BoxFit.cover,) ,),
              if(CurrentPageType==3)Container(width: double.infinity,constraints: BoxConstraints(minHeight: 180,),child:Image.asset('assets/images/shouyibj.png',fit: BoxFit.cover,) ,),
              if(CurrentPageType==1)Positioned(
                bottom: - (85 / 2),
                child: Container(
                  child: Image.asset(
                    'assets/images/jinbixiang.png',
                    width: 85,
                    height: 85,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x0D000000),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                ),
              ),
              if(CurrentPageType==2)Positioned(
                bottom: - (85 / 2),
                child:Image.asset('assets/images/beikexiang.png',width: 85,height: 85,) ,
              ),
              if(CurrentPageType==2)Positioned(
                right: 20,
                bottom: 145/2,
                child:GestureDetector(child: Image.asset('assets/images/tishiwh.png',width: 21,height: 21,),onTap: (){
                  ShellDescription(context);
                },) ,
              ),

              if(CurrentPageType==3)Positioned(
                bottom: - (85 / 2),
                child:Image.asset('assets/images/shouyixiang.png',width: 85,height: 85,) ,
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top+20,
                left: 0,
                right: 0,
                child:Container(child: Stack(children: [
                  Container(child: Row(
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      // TabBar(
                      //   tabs: myTabs,
                      //   labelColor: Colors.white,
                      //   unselectedLabelColor: Colors.white60,
                      //   // indicatorPadding:EdgeInsets.only(bottom: 2),
                      //   labelPadding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                      //   isScrollable: true,
                      //   indicatorColor: HexColor('#ffffff'),
                      //   labelStyle:TextStyle(fontWeight: FontWeight.w600,fontSize: 17),
                      //   unselectedLabelStyle:TextStyle(fontWeight: FontWeight.w600,fontSize: 17),
                      //   indicatorWeight: 3,
                      //   indicatorSize: TabBarIndicatorSize.label,
                      // ),
                      GestureDetector(child: Container(child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        Text('La币'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: CurrentPageType==1?Colors.white:Colors.white60),),

                        CurrentPageType==1?Container(height: 3,width: 30,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),):Container()
                      ],),height: 32,),onTap: (){
                        setState(() {
                          CurrentPageType=1;
                        });
                      },),
                      GestureDetector(child:Container(child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        Text('贝壳'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: CurrentPageType==2?Colors.white:Colors.white60),),

                        CurrentPageType==2?Container(height: 3,width: 30,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),):Container()
                      ],),height: 32,) ,onTap: (){
                        setState(() {
                          CurrentPageType=2;
                        });

                      },),
                      GestureDetector(child: Container(child: Column(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                        Text('收益'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16,color: CurrentPageType==3?Colors.white:Colors.white60),),

                        CurrentPageType==3?Container(height: 3,width: 30,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white),):Container()
                      ],),height: 32,),onTap: (){
                        setState(() {
                          CurrentPageType=3;
                        });
                      },),
                    ],),height: 40,),

                  Positioned(
                    right: 20,
                    top:40/2-16 ,
                    child: GestureDetector(child: SvgPicture.asset(
                      "assets/svg/youjiantou.svg",
                      width: 20,
                      height: 20,
                      color: Colors.white,
                    ),onTap: (){
                      Get.back();
                    },),
                  )
                ],),height: 40,),
              ),
              // Positioned(top: 0,left: 0,right: 0,bottom: 0,child: Row(
              //   mainAxisAlignment:MainAxisAlignment.center,
              //   children: [Container(width: 20,height: 20,color: Colors.red,)],
              // ),),
              if(CurrentPageType==1)Container(width: double.infinity,alignment: Alignment.center,margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20),child: Text(Balancequery['laGold']!=null?Balancequery['laGold']:'0.00',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800),),),
              if(CurrentPageType==2)Container(width: double.infinity,alignment: Alignment.center,margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20),child: Text(Balancequery['nacre']!=null?Balancequery['nacre']:'0.00',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800),),),
              if(CurrentPageType==3)Container(width: double.infinity,alignment: Alignment.center,margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top+20),child: Text(Balancequery['laJewel']!=null?Balancequery['laJewel']:'0.00',style: TextStyle(color: Colors.white,fontSize: 30,fontWeight: FontWeight.w800),),)
            ],),
            SizedBox(height: 10,),
            if(CurrentPageType==2||CurrentPageType==1)Expanded(child: Container(padding: EdgeInsets.only(left: 20,right: 20),child:
            Column(
              children: [
                Row(children: [
                  SvgPicture.asset(
                    "assets/svg/youjiantou.svg",
                    width: 15,
                    height: 15,
                  ),
                  SizedBox(width: 10,),
                  GestureDetector(child: Text('明细'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),onTap: (){
                    Get.toNamed('/verify/flowing',arguments: CurrentPageType==1?0:1);
                  },)
                ],),
                SizedBox(height: 30,),
                if(Rechargeamountlist.length>0&&CurrentPageType==1)Container(width: double.infinity,alignment:Alignment.center, constraints: BoxConstraints(minHeight: 50),decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white,boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                    spreadRadius: 0,
                  ),
                ],),
                  padding:EdgeInsets.only(left: 20,right: 20),child: !Paymentauthority?Column(
                    children: [
                      for(var item in  _products)
                        if(item.id!='lanla_goldcoin_100.00')Container(margin: EdgeInsets.only(top: 30),width:double.infinity,child:Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [Image.asset('assets/images/jinbixiang.png',width: 25,height: 25,),SizedBox(width: 10,),
                              Text(item.description.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xff666666)),)],),
                            GestureDetector(child: Container(width: 128,height: 40,decoration: BoxDecoration(color: Color(0xffFF8301),borderRadius: BorderRadius.all(Radius.circular(50)),boxShadow: [
                              BoxShadow(
                                color: Color(0x0D000000),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],),
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [Text('${item.title.split(' ')[0]}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.white),),SizedBox(width: 10,),Text('USD',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.white),)],
                              ),
                            ),onTap: () async {
                              if (Antishake) {
                                setState(() {
                                  Antishake=false;
                                });
                                Timer.periodic(Duration(milliseconds: 1000), (timer) {
                                  Antishake=true;
                                  timer.cancel(); //取消定时器
                                });
                                var Interfacereturn = await Interface
                                    .Precharge(item.id);
                                if (Interfacereturn.statusCode == 200) {
                                  setState(() {
                                    localOrderId =
                                    Interfacereturn.body['localOrderId'];
                                  });
                                  late PurchaseParam purchaseParam;
                                  // final PurchaseDetails? previousPurchase = purchases[item.id];
                                  if (Platform.isAndroid) {
                                    // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                                    // verify the latest status of you your subscription by using server side receipt validation
                                    // and update the UI accordingly. The subscription purchase status shown
                                    // inside the app may not be accurate.
                                    final GooglePlayPurchaseDetails? oldSubscription = null;
                                    // _getOldSubscription(item, purchases);

                                    purchaseParam = GooglePlayPurchaseParam(
                                        productDetails: item,
                                        changeSubscriptionParam: (oldSubscription !=
                                            null)
                                            ? ChangeSubscriptionParam(
                                          oldPurchaseDetails: oldSubscription,
                                          prorationMode:
                                          ProrationMode
                                              .immediateWithTimeProration,
                                        )
                                            : null);
                                  } else {
                                    purchaseParam = PurchaseParam(
                                      productDetails: item,
                                    );
                                    await _inAppPurchase.buyConsumable(
                                        purchaseParam: purchaseParam);
                                  }
                                  //
                                  // if (productDetails.id == _kConsumableId) {
                                  var liaye = await _inAppPurchase
                                      .buyConsumable(
                                    purchaseParam: purchaseParam,
                                  );
                                }
                                //var Paymentresults = await Interface.Paymentinterface('lanla_goldcoin_01', jsonEncode({"orderId":"GPA.3336-8114-3997-37890","packageName":"lanla.app","productId":"lanla_goldcoin_01","purchaseTime":1673576908943,"purchaseState":0,"purchaseToken":"lmfcfeppaolkohknnmnocfoe.AO-J1OxY6vQKoQJxVS1_YapHx4GReTUDEFzRzOxy_KRuMA3at_xPyTx37KRv-QaSoqnLIxFINJLxhkT2B_JmSS7ViLT5RnKeqg","quantity":1,"acknowledged":false}));
                              }


                            },)
                          ],
                        ) ,),
                      for(var item in  _products)
                        if(item.id=='lanla_goldcoin_100.00')Container(margin: EdgeInsets.only(top: 30),width:double.infinity,child:Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [Image.asset('assets/images/jinbixiang.png',width: 25,height: 25,),SizedBox(width: 10,),
                              Text(item.description.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: Color(0xff666666)),)],),
                            GestureDetector(child: Container(width: 128,height: 40,decoration: BoxDecoration(color: Color(0xffF7BF36),borderRadius: BorderRadius.all(Radius.circular(50)),boxShadow: [
                              BoxShadow(
                                color: Color(0x0D000000),
                                offset: Offset(0, 4),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],),
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.center,
                                children: [Text('${item.title.split(' ')[0]}',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.white),),SizedBox(width: 10,),Text('USD',style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15,color: Colors.white),)],
                              ),
                            ),onTap: () async {
                              if (Antishake) {
                                setState(() {
                                  Antishake=false;
                                });
                                Timer.periodic(Duration(milliseconds: 1000), (timer) {
                                  Antishake=true;
                                  timer.cancel(); //取消定时器
                                });
                                var Interfacereturn = await Interface
                                    .Precharge(item.id);
                                if (Interfacereturn.statusCode == 200) {
                                  setState(() {
                                    localOrderId =
                                    Interfacereturn.body['localOrderId'];
                                  });
                                  late PurchaseParam purchaseParam;
                                  // final PurchaseDetails? previousPurchase = purchases[item.id];
                                  if (Platform.isAndroid) {
                                    // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
                                    // verify the latest status of you your subscription by using server side receipt validation
                                    // and update the UI accordingly. The subscription purchase status shown
                                    // inside the app may not be accurate.
                                    final GooglePlayPurchaseDetails? oldSubscription = null;
                                    // _getOldSubscription(item, purchases);

                                    purchaseParam = GooglePlayPurchaseParam(
                                        productDetails: item,
                                        changeSubscriptionParam: (oldSubscription !=
                                            null)
                                            ? ChangeSubscriptionParam(
                                          oldPurchaseDetails: oldSubscription,
                                          prorationMode:
                                          ProrationMode
                                              .immediateWithTimeProration,
                                        )
                                            : null);
                                  } else {
                                    purchaseParam = PurchaseParam(
                                      productDetails: item,
                                    );
                                    await _inAppPurchase.buyConsumable(
                                        purchaseParam: purchaseParam);
                                  }
                                  //
                                  // if (productDetails.id == _kConsumableId) {
                                  var liaye = await _inAppPurchase
                                      .buyConsumable(
                                    purchaseParam: purchaseParam,
                                  );
                                }
                                //var Paymentresults = await Interface.Paymentinterface('lanla_goldcoin_01', jsonEncode({"orderId":"GPA.3336-8114-3997-37890","packageName":"lanla.app","productId":"lanla_goldcoin_01","purchaseTime":1673576908943,"purchaseState":0,"purchaseToken":"lmfcfeppaolkohknnmnocfoe.AO-J1OxY6vQKoQJxVS1_YapHx4GReTUDEFzRzOxy_KRuMA3at_xPyTx37KRv-QaSoqnLIxFINJLxhkT2B_JmSS7ViLT5RnKeqg","quantity":1,"acknowledged":false}));
                              }


                            },)
                          ],
                        ) ,),
                      SizedBox(height: 30,),
                    ],
                  ):Text('您没有google支付功能暂时无法充值'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xff999999),height: 1.5),),
                ),
                // if(CurrentPageType==2)Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white,boxShadow: [
                //   BoxShadow(
                //     color: Color(0x0D000000),
                //     offset: Offset(0, 4),
                //     blurRadius: 4,
                //     spreadRadius: 0,
                //   ),
                // ],),
                //   padding:EdgeInsets.all(20),child: Column(
                //     crossAxisAlignment:CrossAxisAlignment.start,
                //     children: [
                //       Text('贝壳的用途'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                //       SizedBox(height: 15,),
                //       Text('1.'+'贝壳可以被用来给你喜欢的作品送礼物'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xff999999),height: 1.5),),
                //       SizedBox(height: 15,),
                //       Text('2.'+'贝壳可以用于参与LanLa平台不同时段的活动'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xff999999),height: 1.5),),
                //     ],
                //   ),
                // ),
                // if(CurrentPageType==2)Container(decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)),color: Colors.white,boxShadow: [
                //   BoxShadow(
                //     color: Color(0x0D000000),
                //     offset: Offset(0, 4),
                //     blurRadius: 4,
                //     spreadRadius: 0,
                //   ),
                // ],),
                //   padding:EdgeInsets.all(20),margin:EdgeInsets.only(top: 20),child: Column(
                //     crossAxisAlignment:CrossAxisAlignment.start,
                //     children: [
                //       Text('贝壳的用途'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
                //       SizedBox(height: 15,),
                //       Text('1.'+'贝壳可以被用来给你喜欢的作品送礼物'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xff999999),height: 1.5),),
                //       SizedBox(height: 15,),
                //       Text('2.'+'贝壳可以用于参与LanLa平台不同时段的活动'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15,color: Color(0xff999999),height: 1.5),),
                //     ],
                //   ),
                // )
                if(CurrentPageType==2)
                  Expanded(child: Container(width: double.infinity,
                      alignment:Alignment.center,
                      padding: EdgeInsets.only(left: 15,right: 15),
                      //constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height-300),
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(10)), color: Colors.white,
                        boxShadow: [BoxShadow(
                          color: Color(0x0D000000),
                          offset: Offset(0, 4),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                        ],),child:
                      // GridView.count(
                      //   primary:false,
                      //   padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      //   crossAxisSpacing: 8.0, //水平子 Widget 之间间距
                      //   mainAxisSpacing: 15.0, //垂直子 Widget 之间间距
                      //   // padding: const EdgeInsets.all(10),
                      //   crossAxisCount: 3, //一行的 Widget 数量
                      //   childAspectRatio: 0.7, //宽度和高度的比例
                      //   children: [
                      //     for (var i = 0; i < exchange.length; i++)GestureDetector(
                      //       child: Container(
                      //         child: Container(width: MediaQuery.of(context).size.width-80 /3,decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.all(Radius.circular(5)),
                      //           border: Border.all(
                      //             color: Color(0xffF5F5F5),
                      //             width: 1,
                      //           ),
                      //         ),child: Column(children: [
                      //           Container(constraints: BoxConstraints(
                      //             minHeight: 85,
                      //           ),padding: EdgeInsets.only(top: 10,bottom: 5),child: Image.network(exchange[i].image,fit:BoxFit.cover,width: 70,)),
                      //           ///
                      //           Row(mainAxisAlignment:MainAxisAlignment.center,children: [Image.asset('assets/images/beiketwo.png',width: 15,height: 15,),SizedBox(width: 5,),Text(exchange[i].price,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w800,color: Color(0xffFF97CC)),)],),
                      //           SizedBox(height: 5,),
                      //           Expanded(child: Container(color: Color(0xffFFF5F9),alignment:Alignment.center,width: double.infinity,child: Text('敬请期待'.tr,style: TextStyle(fontSize: 14,color: Color(0xff999999)),),))
                      //         ],),),
                      //       ),
                      //       onTap: (){
                      //
                      //       },
                      //     )
                      //   ],
                      // ),
                      Column(children: [
                        SizedBox(height: 30,),
                        Container(width: double.infinity,child: Text('兑换商城'.tr,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),),
                        SizedBox(height: 25,),
                        Expanded(child: Container(width: double.infinity,child:
                        ListView(padding: EdgeInsets.zero,children: [
                          for (var i = 0; i < exchange.length; i++)
                          Container(margin: EdgeInsets.only(bottom: 25),child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                            Row(children: [
                              Container(alignment: Alignment.center,decoration: BoxDecoration(color: Color(0xffF5F5F5),borderRadius: BorderRadius.all(Radius.circular(8))),width: 60,height: 60,child: Image.network(exchange[i].image,width: 50,height: 50,),),
                              SizedBox(width: 10,),
                              Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                                Text(exchange[i].title,style: TextStyle(fontSize: 13),),
                                SizedBox(height: 12,),
                                Container(child: Row(children: [
                                  Image.asset('assets/images/beiketwo.png',width: 19,height: 17,),
                                  SizedBox(width: 5,),
                                  Container(height: 17,child:Text(exchange[i].price,style: TextStyle(color: Color(0XFFFF789B),fontWeight: FontWeight.w700,fontSize: 18,height: 1),),)

                                ],),)

                              ],)
                            ],),
                            // Expanded(child: )
                            Column(crossAxisAlignment:CrossAxisAlignment.end,children: [
                              Row(children: [
                                Text('剩余'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                                Text(exchange[i].stock.toString(),style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                                Text('件'.tr,style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                              ],),
                              SizedBox(height: 12,),
                              GestureDetector(child: Container(width: 64,height:27,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(color: exchange[i].stock!=0?Color(0XFFFF789B):Color(0XFFD9D9D9),borderRadius: BorderRadius.all(Radius.circular(20))),
                                child: Text(exchange[i].price!='???'?'兑换'.tr:'敬请期待'.tr,style: TextStyle(fontSize: 10,fontWeight: FontWeight.w700,color: Colors.white),),
                              ),onTap: (){
                                if(exchange[i].stock!=0){
                                  var newdatalist=exchange.toList();
                                  var targetElement=exchange[i];
                                  newdatalist.removeAt(i); // 移除指定下标的元素
                                  newdatalist.insert(0, targetElement); // 将元素插入到列表的第一位
                                  Get.to(
                                      PrizedetailsPage(),arguments:{"data":newdatalist,"beibi":Balancequery['nacre']!=null?Balancequery['nacre']:'0.00'} );
                                }
                              },)
                            ],)
                          ],),),
                        ],),
                        )),
                      ],)
                  ),),
                if(CurrentPageType==2)
                  SizedBox(height: 30,)
              ],
            )
              ,)),
            if(CurrentPageType==3)Expanded(child: Container(
              padding: EdgeInsets.only(left: 20,right: 20),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                    GestureDetector(child: Container(width: 110,height: 30,
                      decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Text(dateTime.substring(0,7)),SizedBox(width: 10,),SvgPicture.asset("assets/svg/xiajiantou.svg", color: Colors.black, width: 9, height: 5,)],),
                    ),onTap: (){
                      showPickerDateTimeRoundBg(context);
                    },),
                    // Text('合计  33.98',style: TextStyle(color: Color(0xff999999)),)
                  ],),
                  SizedBox(height: 10,),
                  Expanded(child:  Container(decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: profitlist.length>0?ListView.builder(
                        padding: EdgeInsets.all(0),
                        controller: _scrollControllerls,
                        itemCount: profitlist.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(child:Container(padding: EdgeInsets.all(20),decoration: BoxDecoration(
                              border: Border(bottom: BorderSide(color: Color(0xffF1F1F1)))
                          ),child: Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            children: [
                              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(profitlist[i].title),Text('${profitlist[i].price} +',style: TextStyle(fontWeight: FontWeight.w600),)],),
                              SizedBox(height: 8,),
                              Text(profitlist[i].createdAt,style: TextStyle(fontSize: 12,color: Color(0xff999999)),)

                            ],
                          ),) ,onTap: (){
                            Get.to(GiftDetailsPage(),arguments:profitlist[i].id);
                          },);
                        }):Column(mainAxisAlignment:MainAxisAlignment.center,children: [Container(child: Image.asset('assets/images/xianrenzhang.png',width: 200,height: 200,),width: double.infinity,),
                      SizedBox(height: 20,),
                      Container(alignment: Alignment.center,width: 200,child:Text(textAlign: TextAlign.center,'还没有收益哟，快去发布优质作品赢礼物吧'.tr,style: TextStyle(color: Color(0xff999999),height: 1.5),) ,)],),
                  )),
                ],
              ),
            ),),
            if(CurrentPageType==3)Container(margin: EdgeInsets.only(top: 20),width: double.infinity,color: Colors.white,child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              padding: EdgeInsets.only(top: 10,bottom: 10),
              decoration: BoxDecoration(color: Balancequery['laJewel']==0?Color(0xffe4e4e4):Colors.black,borderRadius: BorderRadius.all(Radius.circular(50))),
              child: GestureDetector(child: Text('立即提现'.tr,style: TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.w600),),onTap: (){
                Cashwithdrawal(context);
              },),
            ),padding: EdgeInsets.fromLTRB(20, 10, 20, 10),)
            // Image.asset('assets/images/jinbitc.png'),
          ],
        ),
      );
  }

  ///日期选择器
  showPickerDateTimeRoundBg(BuildContext context) {
    var picker = Picker(
        height: 250,
        squeeze:1.1,
        cancelTextStyle:TextStyle(color: Color(0xff999999)),
        backgroundColor: Colors.transparent,

        // cancel:GestureDetector(child:Container(child: SvgPicture.asset(
        //   "assets/svg/chahao.svg",
        //   color: Colors.black,
        //   width: 15,
        //   height: 15,
        // ), margin: EdgeInsets.only(right: 20,bottom: 15),) ,onTap: (){
        //
        // },),
        // confirm:Container(child: SvgPicture.asset(
        //   "assets/svg/duigou.svg",
        //   color: Colors.black,
        //   width: 22,
        //   height: 22,
        // ), margin: EdgeInsets.only(left: 20,bottom: 15),),
        headerDecoration: BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Colors.white, width: 0.5))),
        adapter: DateTimePickerAdapter(
          type: PickerDateTimeType.kYM,
          isNumberMonth: true,
          maxValue:DateTime.now(),
          minuteInterval:30,
          value: DateTime.parse(dateTime),
        ),
        onConfirm: (Picker picker, List value) {
          print(picker.adapter.text.substring(0,7));
          setState(() {
            dateTime=picker.adapter.text.substring(0,19);
            page=0;
          });
          profittwo();
        },
        onSelect: (Picker picker, int index, List<int> selected) {
        });
    picker.showModal(context, backgroundColor: Colors.transparent,
        builder: (context, view) {
          return Material(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                padding: const EdgeInsets.only(top: 5),
                child: view,
              ));
        });
  }

  ///提现弹窗
  Future<void> Cashwithdrawal(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.transparent,
                  width: 280,
                  height: 280,
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child: Column(children: [
                    SizedBox(height: 40,),
                    Image.asset('assets/images/meiyou.png',width: 70,height: 70,),
                    SizedBox(height: 30,),
                    Text('提现功能敬请期待'.tr,textAlign: TextAlign.center,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600),),
                    SizedBox(height: 22,),
                    Text('快去发布优质作品更容易得到收益哟！'.tr,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w400),)
                  ],),
                ),
              ]),
        );
      },
    );
  }
  ///贝壳说明弹窗
  Future<void> ShellDescription(context) async {
    print('出来吧');
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.transparent,
                  //color: Colors.red,
                  // height: 280,
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        padding: EdgeInsets.all(20),
                        child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                          Text('贝壳的用途'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                          SizedBox(height: 5,),
                          Text('1.'+'贝壳可以被用来给你喜欢的作品送礼物'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                          SizedBox(height: 5,),
                          Text('2.'+'贝壳可以用于参与LanLa平台不同时段的活动'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                          SizedBox(height: 10,),
                          Text('怎样获得贝壳'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                          SizedBox(height: 5,),
                          Text('1.'+'可以参与LanLa平台不定期任务所得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                          SizedBox(height: 5,),
                          Text('2.'+'每日登陆LanLa可得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                          SizedBox(height: 5,),
                          Text('3.'+'他人送礼可得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        ],),
                      )
                    ],),),
              ]),
        );
      },
    );
  }
}

class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
