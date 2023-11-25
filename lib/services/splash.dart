import 'package:lanla_flutter/models/splash.dart';

import '../ulits/base_provider.dart';

class SplashProvider extends BaseProvider{

  Future<List<SplashModel>> getAd() async {
    var res = await post('auth/appInit',null);
    if(res.statusCode == 200 && res.bodyString != null){
      return splashModelFromJson(res.bodyString!);
    }
    return [];
  }
}