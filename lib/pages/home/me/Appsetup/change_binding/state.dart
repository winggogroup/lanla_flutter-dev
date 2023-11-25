import 'package:get/get.dart';

class ChangeBindingState {
  late  var  VerificationCode = 0.obs;
  late  var  clicks = true.obs;
  late var timeCount;
  late String phonenumber;
  late String verificationId;
  late String Verification;
  var Areacode= ''.obs;
  var favorite= ''.obs;
  ChangeBindingState() {
    ///Initialize variables
   timeCount=60;
   Verification='';
   verificationId='';
   phonenumber='';
  }
}
