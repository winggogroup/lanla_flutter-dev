import 'dart:async';
import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/pages/detail/video/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:web_socket_channel/io.dart';

import 'state.dart';

class StartDetailLogic extends GetxController with GetSingleTickerProviderStateMixin{
  final StartDetailState state = StartDetailState();
  final userLogic = Get.put(UserLogic());
  final contentProvider = Get.find<ContentProvider>();
  var channel;
  ///重连次数
  var WebSocketfrequency=0;
  var times;
  int id = 0;
  late StreamSubscription _sub;

  @override
  void onReady() {
    getPermissionStatus();
    WebSocketconnection();
    tsPush();
    initUniLinks();
    super.onReady();
  }
  

  ///拉起
  Future<void> initUniLinks() async {
    // ... check initialLink
    // Attach a listener to the stream
    _sub = linkStream.listen((String? link) {
      FirebaseAnalytics.instance.logEvent(
        name: "Wakeupapp_click",
        parameters: {
          'type':Uri.parse(link!).queryParameters['type'],
          'targetId':int.parse(Uri.parse(link).queryParameters['targetId']!),
          'targetOther':Uri.parse(link).queryParameters["targetOther"],
        },
      );
      if(userLogic.token!=''){
        if(Uri.parse(link).queryParameters['type']=='2'){
          Get.toNamed('/public/picture', preventDuplicates: false,arguments: {"data": int.parse(Uri.parse(link).queryParameters['targetId']!),"isEnd": false});
        }else if(Uri.parse(link).queryParameters['type']=='4'){
          Get.toNamed('/public/webview',arguments: 'https://api.lanla.app/bests?bestId=${int.parse(Uri.parse(link).queryParameters['targetId']!)}');
        }else if(Uri.parse(link).queryParameters['type']=='3'){
          Get.toNamed('/public/topic',arguments: int.parse(Uri.parse(link).queryParameters['targetId']!));
        }else if(Uri.parse(link).queryParameters['type']=='1'){
          Get.to(const VideoPage(),
              //transition: Transition.leftToRight,
              arguments: {
                'data':
                int.parse(Uri.parse(link).queryParameters['targetId']!),
                'isEnd': false
              });
        }else if(Uri.parse(link).queryParameters['type']=='10'){
          // 进入个人主页
          Get.toNamed('/public/user',
              arguments: int.parse(Uri.parse(link).queryParameters['targetId']!));
        }
        else if(Uri.parse(link).queryParameters['type'] == "11"){
          if(Uri.parse(link).queryParameters["targetOther"]=='/public/video' || Uri.parse(link).queryParameters["targetOther"]=='/public/picture'||Uri.parse(link).queryParameters["targetOther"] == '/public/xiumidata'){
            Get.toNamed(Uri.parse(link).queryParameters["targetOther"]!,arguments:  {
              'data':  int.parse(Uri.parse(link).queryParameters['targetId']!),
              'isEnd': false
            });
          }else{
            Get.toNamed(Uri.parse(link).queryParameters["targetOther"]!,arguments: int.parse(Uri.parse(link).queryParameters['targetId']!));
          }
        }
      }

      // Parse the link and warn the user, if it is not correct
    }, onError: (err) {
      // Handle exception by warning the user their action did not succeed
    });

    // NOTE: Don't forget to call _sub.cancel() in dispose()
  }

  ///WebSocket连接
  WebSocketconnection(){
    if(userLogic.userId!=0){
      channel = IOWebSocketChannel.connect('ws://api.lanla.app:8084/ws?uid=${userLogic.userId}&token=${userLogic.token}');
      WebSocketfrequency=0;
      userLogic.Chatdisconnected=true;
      userLogic.update();
      if(userLogic.Chatrelated['${userLogic.userId}']==null){
        userLogic.Chatrelated['${userLogic.userId}']={"Chatlist":[],'Unreadmessagezs':0,'record':{}};
      };
      channel.stream.listen((message) {
        // print('监听到了');
        // print(message);
        if(jsonDecode(message)['Code']==30001){
          if(times!=null){
            // print('12333333');
            times.cancel();
          }
          userLogic.Chatdisconnected=false;
          userLogic.update();
          if(WebSocketfrequency<300){
            Timer.periodic(const Duration(milliseconds: 6000),(timer){
              //debugPrint("Socket is closed");
              // print('重连');
              WebSocketconnection();
              WebSocketfrequency++;
              timer.cancel();//取消定时器
            }
            );
          }else{
            channel.sink.close();
            userLogic.Chatdisconnected=false;
            userLogic.update();
          }
        }
        if(jsonDecode(message)['Code']==20003){
          ToastInfo('包含敏感词'.tr);
        }
        if(jsonDecode(message)['Code']==20001){
          ToastInfo('请重新登录'.tr);
        }
        if(jsonDecode(message)['Code']==10006){
          if(userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].length>0){
            var xini;
            for(var i=0;i<userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].length;i++){
              if(userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][i]['Uid']==jsonDecode(message)['Data']['Uid']){
                xini=i;
              }
            }
            if(xini!=null){
              userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][xini]["Name"]=jsonDecode(message)['Data']['Name'];
              userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][xini]["Avatar"]=jsonDecode(message)['Data']['Avatar'];
              userLogic.update();
            }
          }
        }
        if(jsonDecode(message)['Code']==10001){
          if(jsonDecode(message)['Data']!=null){
            // for(var item in userLogic.Chatrelated){
            //   if(item['code']==userLogic.userId){
            //     if(item['Chatlist'].length>0){
            //       var xini;
            //       for(var i=0;i<item['Chatlist'].length;i++){
            //         if(item['Chatlist'][i]['Uid']==jsonDecode(message)['Data']['Uid']){
            //           xini=i;
            //         }
            //       }
            //       if(xini!=null){
            //         item['Chatlist'].removeAt(xini);
            //         item['Chatlist'].insert(0, jsonDecode(message)['Data']);
            //         userLogic.update();
            //       }else{
            //         item['Chatlist'].insert(0, jsonDecode(message)['Data']);
            //         userLogic.update();
            //       }
            //     }else{
            //       item['Chatlist'].insert(0, jsonDecode(message)['Data']);
            //       userLogic.update();
            //     }
            //   }
            // }
            ///聊天列表
            if(userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].length>0){
              var xini;
              for(var i=0;i<userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].length;i++){
                if(userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][i]['Uid']==jsonDecode(message)['Data']['Uid']){
                  xini=i;
                }
              }
              if(xini!=null){
                var numes;
                if(userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][xini]['Messagesnum']==null){
                  numes=1;
                }else{
                  numes= userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][xini]['Messagesnum']+1;
                }
                userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].removeAt(xini);
                userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].insert(0, jsonDecode(message)['Data']);
                userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][0]['Messagesnum']=numes;



                userLogic.update();
              }else{
                userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].insert(0, jsonDecode(message)['Data']);
                userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][0]['Messagesnum']=1;
                userLogic.update();
              }
            }else{
              userLogic.Chatrelated['${userLogic.userId}']['Chatlist'].insert(0, jsonDecode(message)['Data']);
              userLogic.Chatrelated['${userLogic.userId}']['Chatlist'][0]['Messagesnum']=1;
              userLogic.update();
            }
            ///聊天未读消息数
            userLogic.Chatrelated['${userLogic.userId}']['Unreadmessagezs']+=1;

            ///聊天记录
            if(userLogic.Chatrelated['${userLogic.userId}']['record']['${jsonDecode(message)['Data']['Uid']}']==null){
              userLogic.Chatrelated['${userLogic.userId}']['record']['${jsonDecode(message)['Data']['Uid']}']=[];
            }
            userLogic.Chatrelated['${userLogic.userId}']['record']['${jsonDecode(message)['Data']['Uid']}'].insert(0, jsonDecode(message)['Data']['Message']);
            // userLogic.Chatrelated['${userLogic.userId}']['record']+=1;
            // History.insert(0, jsonDecode(message)['Data']['Message']);
            // update();
          }
          userLogic.SaveChat();

        }
        if(jsonDecode(message)['Code']==30002){
          heartbeat();
        }
      },onError: (error){
        // print("Socket is errorssss");
        //debugPrint("Socket is error");
        //channel.sink.add(jsonEncode({'Code':20003,'Send':userLogic.userId}));
      }, //连接错误时调用
          onDone: (){
            userLogic.Chatdisconnected=false;
            userLogic.update();
            if(times!=null){
              times.cancel();
            }
            // timer.cancel();//取消定时器
            //print("Socket is error");
            // WebSocketconnection();
            if(WebSocketfrequency<300){
              Timer.periodic(const Duration(milliseconds: 6000),(timer){
               // debugPrint("Socket is closed");
                WebSocketconnection();
                WebSocketfrequency++;
                timer.cancel();//取消定时器
              }
              );
            }else{
              channel.sink.close();
              userLogic.Chatdisconnected=false;
              userLogic.update();
            }

            // channel.sink.add(jsonEncode({'Code':20003,'Send':userLogic.userId}));
          });
    }
  }

  ///心跳
  heartbeat(){
    Timer.periodic(const Duration(seconds: 20),(timer) async {
      if(userLogic.token == ''){
        timer.cancel();//取消定时器
        return;
      }
      times=timer;
      channel.sink.add(jsonEncode({'Code':30000,'Send':userLogic.userId}));
    }
    );
  }
  ///推送
  tsPush() async {
    if(userLogic.token!=''){
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await contentProvider.pushtoken(fcmToken,await userLogic.createDynamicLinkes(userLogic.userId));
    }
    ///app内部通知
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification != null) {
        Get.snackbar(notification.title!, notification.body!);
      }
    });


    ///系统通知
    RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();

    // If the message also contains a data property with a "type" of "chat",
    // navigate to a chat screen
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    // Also handle any interaction when the app is in the background via a
    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
    // Also handle any interaction when the app is in the background via a
    // Stream listener
    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   if (message.data['type'] == 'chat') {
    //     // Navigator.pushNamed(context, '/chat',
    //     //     arguments: ChatArguments(message));
    //   }
    // });
  }

  Future<void> _handleMessage(RemoteMessage message) async {
    // if (message.data['type'] == 'chat') {
    if(message.data['router']=='2'){
      Get.toNamed('/public/picture', preventDuplicates: false,arguments: {"data": int.parse(message.data['targetId']),"isEnd": false});
    }else if(message.data['router']=='4'){
      Get.toNamed('/public/webview',arguments: 'https://api.lanla.app/bests?bestId=${int.parse(message.data['targetId'])}');
    }else if(message.data['router']=='3'){
      Get.toNamed('/public/topic',arguments: int.parse(message.data['targetId']));
    }else if(message.data['router']=='1'){
      Get.to(const VideoPage(),
          //transition: Transition.leftToRight,
          arguments: {
            'data':
            int.parse(message.data['targetId']),
            'isEnd': false
          });
    }else if(message.data['router']=='10'){
      // 进入个人主页
      Get.toNamed('/public/user',
          arguments: int.parse(message.data['targetId']));
    }else if(message.data['router'] == '11'){
      if(message.data['targetOther']=='/public/video'||message.data['targetOther']=='/public/picture'||message.data['targetOther'] == '/public/xiumidata'){
        Get.toNamed(message.data['targetOther'],arguments:  {
          'data': int.parse(message.data['targetId']),
          'isEnd': false
        });
      }else{
        Get.toNamed(message.data['targetOther'],arguments: int.parse(message.data['targetId']),);
      }
    }
    else if(message.data['router']=='12'){
      //Get.toNamed('/public/webview',arguments: data.activity[i].targetId);
      await launchUrl(Uri.parse(message.data['targetOther']), mode: LaunchMode.externalApplication,);
    }

    //
    // Navigator.pushNamed(context, '/chat',
    //   arguments: ChatArguments(message),
    // );
    // }
  }

  ///通知权限
  Future<bool> getPermissionStatus() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    return true;

    //
    // Permission permission = Permission.notification;
    // //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    // PermissionStatus status = await permission.status;
    // if (status.isGranted) {
    //   return true;
    // } else if (status.isDenied) {
    //   requestPermission(permission);
    // } else if (status.isPermanentlyDenied) {
    //   openAppSettings();
    // } else if (status.isRestricted) {
    //   requestPermission(permission);
    // } else {}
    // return false;
  }

  ///申请权限
  void requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
