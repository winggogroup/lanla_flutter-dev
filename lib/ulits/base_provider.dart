import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/connect.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'log_util.dart';

const BASE_DOMAIN = 'https://api.lanla.app/';
//const BASE_DOMAIN = 'http://34.0.64.250/';
//const BASE_DOMAIN = 'https://api.dev.lanla.app/';  // 香港测试服务器
//const BASE_DOMAIN = 'https://app.lanla.fun/';  // 新加坡测试服务器
//const BASE_DOMAIN = 'http://192.168.30.11/';    ///本机
//const BASE_DOMAIN = 'http://8.222.161.181:8090/';

String version = '';
String BuildNumber='';
var deviceId ;
var adid ;


DeviceInfoPlugin deviceInfoPlugin  = new DeviceInfoPlugin();
Future<List<String>> Appinformation() async {
  if (version==''){
    if (Platform.isAndroid) {
      var build = await deviceInfoPlugin.androidInfo;
      deviceId =  build.id;
      adid = build.id;
      // deviceId =  build.manufacturer;
    } else if (Platform.isIOS) {
      var iosbuild = await deviceInfoPlugin.iosInfo;
      deviceId=iosbuild.identifierForVendor;
      adid=iosbuild.identifierForVendor;
    }
    PackageInfo info = await PackageInfo.fromPlatform();
    version=info.version;
    BuildNumber=info.buildNumber;
    //判断设备信息：安卓或ios

    return [version,BuildNumber,deviceId,adid];
  }else{
    return [version,BuildNumber,deviceId,adid];
  }

}
class BaseProvider extends GetConnect {
  //引入修改个人信息的文件
  final userLogic = Get.find<UserLogic>();
  final lanlaDomain = BASE_DOMAIN;

  @override
  @mustCallSuper
  onInit(){
    httpClient.baseUrl = lanlaDomain;
    // 请求拦截
    httpClient.addRequestModifier<void>((request) async {
      if (userLogic.token != null && userLogic.token != "") {
        request.headers['Authorization'] = userLogic.token;
      }
      List<String> result = await Appinformation();
      request.headers['Version'] = result[0];
      request.headers['BuildNumber'] = result[1];
      request.headers['Platform'] = Platform.isAndroid ? "android" : "ios";
      request.headers['deviceId'] = result[2];
      request.headers['adid'] = result[3];
      // request.headers['platform'] = 'android';
      return request;
    });
    // 响应拦截
    httpClient.addResponseModifier((request, response) {
      LogV({
        "url": request.url,
        "headers": request.headers,
        "code": response.statusCode,
        "body": response.bodyString,
        "form": request.bodyBytes.toString()
      });
      if (response.statusCode == 400) {
        Map<String, dynamic> responseData =
            jsonDecode(response?.bodyString ?? '');

        ///提示
        ToastInfo(responseData['message']);

        if(responseData!["code"]=='10001'){
          userLogic.Problemuser();
        }
        if(responseData!["code"]=='10003'){
          userLogic.Problemuser();
        }
      }
      return response;
    });
    super.onInit();
  }

  Future<Response<T>> otherGet<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    httpClient.baseUrl = '';
    return super.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }

  Future<Response<T>> get<T>(
    String url, {
    Map<String, String>? headers,
    String? contentType,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
  }) {
    httpClient.baseUrl = lanlaDomain;
    return super.get<T>(
      url,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
    );
  }

  Future<Response<T>> post<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) {
    httpClient.baseUrl = lanlaDomain;
    httpClient.timeout=const Duration(seconds: 30);
    return httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    ); // 设置超时时间为30秒
  }

  Future<String> postHandle(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder? decoder,
    Progress? uploadProgress,
  }) async {
    httpClient.baseUrl = lanlaDomain;
    Response res = await httpClient.post(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
    // 成功了
    if (res.statusCode != null &&
        res.statusCode! >= 200 &&
        res.statusCode! <= 300) {
      return res.bodyString!;
    }
    return "";
  }

  Future<Response<T>> otherPost<T>(
    String? url,
    dynamic body, {
    String? contentType,
    Map<String, String>? headers,
    Map<String, dynamic>? query,
    Decoder<T>? decoder,
    Progress? uploadProgress,
  }) {
    httpClient.baseUrl = '';
    return httpClient.post<T>(
      url,
      body: body,
      headers: headers,
      contentType: contentType,
      query: query,
      decoder: decoder,
      uploadProgress: uploadProgress,
    );
  }

  errorMessage(String body) {
    Map<String, dynamic> res = jsonDecode(body);
    if (res['message'] != null) {
      ToastInfo(res['message'].toString());
    }
  }

  bool resultNoBody(Response data) {
    if (data.statusCode == 200) {
      return true;
    }
    errorMessage(data.bodyString ?? "");
    return false;
  }
}
