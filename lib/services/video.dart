import 'package:get/get_connect/http/src/response/response.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';

import '../ulits/base_provider.dart';

class VideoProvider extends BaseProvider {
  Future<List<HomeDetails>> GetVideoList(page, int channel) async {
    Response res = await post('works/video', {"page": page, "channel": channel, "isConcern": 0});
    if(res.statusCode == 200 && res.bodyString != '' ){
      List<HomeDetails> source = homeDetailsFromJson(res.bodyString!);
      return source;
    }
    return [];
  }
}