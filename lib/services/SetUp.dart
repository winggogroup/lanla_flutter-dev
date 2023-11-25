import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class SetUpProvider extends BaseProvider{
  ///意见反馈
  Future<Response> Feedbackjk(text,imagesPath) => post('auth/feedback',
      {"text":text,"imagesPath":imagesPath});
  ///验证验证码
//发送验证码
  Future<Response> SendVerificationCodetwo(String account,String area_code) => post('auth/sendCode',{"account":account,"type":1,"areaCode":area_code});
  ///获取登录信息
  Future<Response> BindingInformation() => post('auth/bindList',{});
  /// 第三方绑定

  Future<Response> Thirdpartybinding(type,userName,userAvatar,email,id,token,idToken) => post('auth/bindAccount',{'type':type,'userName':userName,'userAvatar':userAvatar,'email':email,'id':id,'token':token,'idToken':idToken});

  ///检测是否可以强制绑定
  Future<Response> isAllowEmailBind(idToken,email) => post('auth/isAllowEmailBind',{'idToken':idToken,'email':email});

  ///绑定邮箱
  Future<Response> bindEmailAccount(idToken,email) => post('auth/bindEmailAccount',{'idToken':idToken,'id':email});


  ///换绑旧手机号验证
  Future<Response> verifyOldPhone(phone,areaCode,idToken)=>post('Users/verifyOldPhone',{'phone':phone,'areaCode':areaCode,'idToken':idToken});
  ///解绑

  Future<Response> Unbinding(type) => post('auth/unBindOtherAccount',{'type':type});

  ///
  //验证码验证
  Future<Response> VerificationCode(String phone,String area_code,String code) => post('auth/login',{"account":phone,"code":code,"areaCode":area_code});

  ///绑定新手机号
  Future<Response> GetupdatePhone(oldPhone,oldAreaCode,String phone,String area_code,String code,idToken) => post('users/updatePhone',{"oldPhone":oldPhone,"oldAreaCode":oldAreaCode,"newPhone":phone,"newPhoneCode":code,"newAreaCode":area_code,"idToken":idToken});
  ///改绑身份验证
  Future<Response> Authentication(phone,areaCode,code) => post('users/verifyCode',{'phone':phone,'areaCode':areaCode,'code':code});
  /// 认证信息
  Future<Response> pageDescription() => post('label/pageDescription',{});
  ///申请认证
  Future<Response> submit(type) => post('label/submit',{'type':type});
  ///绑定弹窗
  Future<Response> isNeedBindAccount() => post('Users/isNeedBindAccount',{});

}