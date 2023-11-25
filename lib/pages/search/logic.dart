

import 'dart:convert';
import 'dart:ui';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/SearchWorkes.dart';
import 'package:lanla_flutter/pages/search/search_details/logic.dart';
import 'package:lanla_flutter/pages/search/search_details/view.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/toast/view.dart';
import '../../models/SearchTranslation.dart';
import '../../services/search.dart';
import 'state.dart';

class SearchLogic extends GetxController {
  final logicxq = Get.put(SearchDetailsLogic());
  final userLogic = Get.find<UserLogic>();
  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    super.onReady();
    Heatranking();
    var sp = await SharedPreferences.getInstance();
    //if(sp.getString("SearchHistory")["${userLogic.userId}"].length>0){
    if(sp.getString("SearchHistory")!=null){
      state.SearchHistory=jsonDecode(sp.getString("SearchHistory")!);
      if(state.SearchHistory["${userLogic.userId}"]==null){
        state.SearchHistory["${userLogic.userId}"]=[];
      }
    }else{
      state.SearchHistory["${userLogic.userId}"]=[];
    }
    update();
   // state.SearchHistory["${userLogic.userId}"]=[];

    // }
  }
  final SearchState state = SearchState();
  //实例化
  SearchProvider provider =  Get.put(SearchProvider());
  ///周排行
  Future<void> WeeklyRanking() async {
    state.Weeklyranking=!state.Weeklyranking;
    var result = await provider.Weeklyranking();
    update();
  }
  ///月排行
  Future<void> MonthlyRanking() async {
    state.Weeklyranking=!state.Weeklyranking;
    var result = await provider.Monthlyranking();
    if(result.statusCode==200){
      var st =(HotlistFromJson(result?.bodyString ?? ""));
      update();
    }

  }
  ///热度排行
  void Heatranking() async {
    var result = await provider.Heatranking();
    if(result.statusCode==200){
      var st =(HotlistFromJson(result?.bodyString ?? ""));
      state.rankinglist=st;

      update();
    }
  }
  /// 搜索
  Future<void> Searchnr() async {
    if(state.SearchContent!=''){
      if (state.SearchHistory['${userLogic.userId}'].contains(state.SearchContent)) {
        //logicxq.SearchContent(state.SearchContent);
        logicxq.SearchUsers(state.SearchContent);
        Get.to(SearchDetailsPage(),arguments: {'text':state.SearchContent});
        FirebaseAnalytics.instance.logEvent(
          name: "Search",
          parameters: {
            "keyword": state.SearchContent,
            "userid":userLogic.userId,
            'deviceId':userLogic.deviceId
          },
        );

      } else {
        if(state.SearchHistory['${userLogic.userId}'].length<5){
          state.SearchHistory['${userLogic.userId}'].add(state.SearchContent);
          update();
        }else{
          state.SearchHistory['${userLogic.userId}'].removeAt(0);
          state.SearchHistory['${userLogic.userId}'].add(state.SearchContent);
          update();
        }
        var sp = await SharedPreferences.getInstance();
        sp.setString("SearchHistory", jsonEncode(state.SearchHistory));
        //logicxq.SearchContent(state.SearchContent);
        logicxq.SearchUsers(state.SearchContent);
        Get.to(SearchDetailsPage(),arguments: {'text':state.SearchContent});
        FirebaseAnalytics.instance.logEvent(
          name: "Search",
          parameters: {
            "keyword": state.SearchContent,
            "userid":userLogic.userId,
            'deviceId':userLogic.deviceId
          },
        );
      }

    }

  }

  void Searchnrtwo(nr){
    // logicxq.SearchContent(nr);
    logicxq.SearchUsers(nr);
    state.SearchContent='';
    update();
    FirebaseAnalytics.instance.logEvent(
      name: "Search",
      parameters: {
        "keyword":nr,
        "userid":userLogic.userId,
        'deviceId':userLogic.deviceId
      },
    );
    Get.to(SearchDetailsPage(),arguments: {'text':nr});

  }
  ///清空历史
  Future<void> empty(context) async {
    if(state.SearchHistory['${userLogic.userId}'].toString()!="[]"){
      var sp = await SharedPreferences.getInstance();
      sp.remove("SearchHistory");
      state.SearchHistory['${userLogic.userId}']=[];
      update();
      Toast.toast(context,msg:'清除成功'.tr ,position: ToastPostion.center);
    }
  }
}
