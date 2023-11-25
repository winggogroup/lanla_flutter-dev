import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

/**
 * 所有用户中心的接口
 */
class UserHomeProvider extends BaseProvider {
  Future<Response?> getUserFansData() async {
    Response data = await post('users/fansList', {'userId': 0});
    if (data.statusCode != 200 || data.bodyString == '') {
      return null;
    }
    print(data.bodyString);
    return null;
  }

  Future<Response?> getUserFocusData() async {
    Response data = await post('users/focusList', {'userId': 0});
    if (data.statusCode != 200 || data.bodyString == '') {
      return null;
    }
    print(data.bodyString);
    return null;
  }

  Future<Response?> getinviteCode(code)=>post('invite/invitationCode', {'code': code});

  ///推荐博主
  Future<Response?> recommendedUsers()=>post('users/recommendedUsers', {});



}
