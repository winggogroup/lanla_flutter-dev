import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PhoneVerificationState {
  late  var  VerificationCode = 0.obs;
  late  var  clicks = false.obs;
  late var timeCount;
  var aly=false;
  late String verificationId;
  late String Verification;
  late  var  ownyanzhneg = false.obs;
  PhoneVerificationState() {
    ///Initialize variables
     timeCount=60;
     Verification='';
     verificationId='';
  }
}
