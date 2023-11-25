import 'package:get/get.dart';

class CellPhoneState {
  late  var  VerificationCode = 0.obs;
  late  var  clicks = true.obs;
  late var timeCount;
  late String phonenumber;
  late String Verification;
  late String verificationId;
  var Areacode= ''.obs;
  var favorite= ''.obs;
  CellPhoneState() {
    ///Initialize variables
    ///
    ///
    ///
    timeCount=60;
    Verification='';
    verificationId='';
    phonenumber='';
  }
}
