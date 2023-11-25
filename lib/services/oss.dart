import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/base_provider.dart';

class OssProvider extends BaseProvider{
  Future<Response> StsAvg() => post('sts/stsAvg',null);

}