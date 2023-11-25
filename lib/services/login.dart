import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class LoginProvider extends BaseProvider{
  ///google登录
  Future<Response> Googlelogin(id,userName,userAvatar,email,serverAuthCode,sourcePlatform,idToken) => post('auth/googleLogin',
      {"id":id,"userName":userName,"userAvatar":userAvatar,"email":email,"serverAuthCode":serverAuthCode,"sourcePlatform":sourcePlatform,'idToken':idToken});
  ///facebook登录
  Future<Response>Facebooklogin(token,sourcePlatform) => post('auth/fbLogin',
      {"token":token,"sourcePlatform":sourcePlatform});
  ///苹果登录
  Future<Response>Applelogin(id,userName,userAvatar,email,sourcePlatform,idToken) => post('auth/appleIdLogin',
      {"id":id,"userName":userName,"userAvatar":userAvatar,"email":email,"sourcePlatform":sourcePlatform,'idToken':idToken});
  ///email
  Future<Response>emailLogin(email,sourcePlatform,idToken) => post('auth/emailLogin',
      {"email":email,"sourcePlatform":sourcePlatform,'idToken':idToken});
  ///密码登录
  Future<Response>loginByPassword(phone,area_code,password) => post('phoneLogin/loginByPassword', {"password":password,"area_code":area_code,'phone':phone});

}