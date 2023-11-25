import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:lanla_flutter/common/widgets/report.dart';
import 'package:lanla_flutter/pages/detail/user/inner_view.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:share_plus/share_plus.dart';

import 'content_view.dart';
import 'logic.dart';

class UserHomePage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return UserInnerView(Get.arguments);
  }

}