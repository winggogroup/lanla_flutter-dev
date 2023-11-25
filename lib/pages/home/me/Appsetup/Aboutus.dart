import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutusWidget extends StatelessWidget {
  final userLogic = Get.find<UserLogic>();
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text(
            '关于我们'.tr,
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: Container(
          //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
            padding: EdgeInsets.fromLTRB(20, 23, 20, 0),
            color: Color(0xffF5F5F5),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  decoration:BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text('隐私政策'.tr),
                            Icon(Icons.chevron_right,)
                          ],
                        ) ,
                      ),onTap: (){
                        launchUrl(Uri.parse("https://www.lanla.app/ys.html"),mode: LaunchMode.externalApplication,);
                      },) ,
                      Divider(height: 1.0,color: Color(0xffF1F1F1),),
                      GestureDetector(child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                          children: [
                            Text('用户协议'.tr),
                            Icon(Icons.chevron_right,)
                          ],
                        ) ,
                      ),onTap: (){
                        launchUrl(Uri.parse("https://www.lanla.app/UserAgreement.html"), mode: LaunchMode.externalApplication,);
                      },) ,
                      Divider(height: 1.0,color: Color(0xffF1F1F1),),
                    ],
                  ),
                ),
              ],)
        ),
      );
  }


}