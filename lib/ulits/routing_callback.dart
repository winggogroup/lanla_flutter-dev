import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/ulits/app_log.dart';

// 当时时间，每次操作更新此时间
int nowTime = DateTime.now().millisecondsSinceEpoch;
String nowPage = '';
List<String> routerLink = [];

Future<void> RoutingCallback(Routing? route) async {
  Map<String, dynamic> log = {
    "path": route?.current ?? '-',
    "args": await route?.args,
    "isBack": route?.isBack ?? true,
  };
  int newTime = DateTime.now().millisecondsSinceEpoch;
  String backPage = '';
  if (!log['isBack']) {
    backPage = routerLink.isEmpty ? "" : routerLink[routerLink.length-1];
    routerLink.add(log['path']);
  } else {
    backPage = routerLink.removeLast();
  }
  int targetid = 0;
  switch (log['path']) {
    case "/public/video":
    case "/PicturePage":
      int? obj = log['args']['data'] ;
      targetid = obj!;
      // if(obj != null){
      //   data = obj.id;
      // }
      break;
  }
  AppLog(
    'page',
    event: route?.isBack ?? false ? "back" : "push",
    pagetime: newTime - nowTime,
    targetid: targetid,
    page: route?.current ?? '-',
    data: routerLink.join('_'),
    backpage: backPage,
  );
  nowTime = newTime;
}
