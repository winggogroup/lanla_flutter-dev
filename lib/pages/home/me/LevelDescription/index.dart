import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/round_underline_tabindicator.dart';
import 'package:lanla_flutter/models/userGiftDetail.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/logic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/services/newes.dart';
import 'package:lanla_flutter/ulits/hex_color.dart';
import 'package:url_launcher/url_launcher.dart';
class LevelDescriptionPage extends StatefulWidget  {
  @override
  LevelDescriptionState createState() => LevelDescriptionState();
}
class LevelDescriptionState extends State<LevelDescriptionPage>with SingleTickerProviderStateMixin {
  final userLogic = Get.find<UserLogic>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              GestureDetector(child: Container(
                width: 19,
                height: 22,
                child: SvgPicture.asset(
                  "assets/svg/youjiantou.svg",
                ),
              ), onTap: (){
                Get.back();
              },),
              Expanded(
                  child: Center(
                    child: Text(
                      '等级说明'.tr,
                      style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                    ),
                  )),
              Container(
                width: 19,
              ),
            ],
          ),
        ),
        body:
        Column(children: [
          Container(width: double.infinity,height: 1,color: const Color(0x0c000000),),
          Expanded(child: Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 25),
            child: ListView(physics: const BouncingScrollPhysics(),children: [
              const SizedBox(height: 25,),
              const Text('استبدال الجوائز',style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14),),
              const SizedBox(height: 10,),
              const Text('عنوان المستوى هو مؤشر لقياس حالتك النشطة في لانلا ، وإكمال تسجيل الحضور ، والمهام اليومية ، ومدة وجودك في لانلا كل يوم لترقية قيمة التجربة التراكمية.',style: TextStyle(fontSize: 12,height: 1.8),),
              const SizedBox(height: 5,),
              const Text('مع زيادة المستوى ، ستتلقى مكافآت المستوى على مراحل ، والتي يمكن استبدالها بمكافآت مادية في المركز التجاري.في نفس الوقت ، تتوافق المستويات المختلفة مع ألقاب المستويات المختلفة ، وستستمر مكافآت المستوى في التوسع في المستقبل.شدو حيلكم يا بنات لانلا !',style: TextStyle(fontSize: 12,height: 1.8),),
             Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
               const Text('تقسيم الدرجات',style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700),),
               Image.asset('assets/images/dengjitu.png',width: 108,height: 95,)
             ],),
              ///lv1
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Image.asset('assets/images/gzlv1.png',width: 77,height: 30,),
                Container()
              ],),
              //Container(alignment: Alignment.centerRight,child: Image.asset('assets/images/gzlv1.png',width: 77,height: 30,),),
              const SizedBox(height: 10,),
              const Text('(1) '' جميع المستخدمين المسجلين الجدد يستحقون العضوية في لانلا',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(2)  ''استمتع بمزايا نقاط لانلا الحصرية ومزايا الاستبدال',style: TextStyle(fontSize: 12,height: 1.8),),
              const SizedBox(height: 20,),
              ///lv2
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Image.asset('assets/images/gzlv2.png',width: 77,height: 30,),
                Container(alignment: Alignment.center,width: 66,height: 30,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(55)),color: Color(0xffF5F5F5)),
                  child: const Text('غير منجز',style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                )
              ],),
              const SizedBox(height: 10,),
              const Text('(1) '' هناك فرصة للحصول على فرصة للتحسين كل شهر ، والحصول على 50 نقطة لكل منشور يتوافق مع الشروط  (منشورين كحد أقصى ) ',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(2)  ''الحصول على 1.1 ضعف حقوق تسريع النقاط الإجمالية',style: TextStyle(fontSize: 12,height: 1.8),),
              const SizedBox(height: 20,),
              ///lv3
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Image.asset('assets/images/gzlv3.png',width: 77,height: 30,),
                Container(alignment: Alignment.center,width: 66,height: 30,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(55)),color: Color(0xffF5F5F5)),
                  child: const Text('غير منجز',style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                )
              ],),
              const SizedBox(height: 10,),
              const Text('(1)  ''هناك فرصة للحصول على فرصة للتحسين كل شهر ، والحصول على 100 نقطة لكل منشور يتوافق مع الشروط  ( منشورين كحد أقصى)',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(2)  ''الحصول على حقوق التسريع الإجمالية 1.3 مرة',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(3)  ''المشاركة ذات الأولوية في أنشطة منح الجوائز التي تنظمها لانلا',style: TextStyle(fontSize: 12,height: 1.8),),
              const SizedBox(height: 20,),
              ///lv4
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Image.asset('assets/images/gzlv4.png',width: 77,height: 30,),
                Container(alignment: Alignment.center,width: 66,height: 30,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(55)),color: Color(0xffF5F5F5)),
                  child: const Text('غير منجز',style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                )
              ],),
              const SizedBox(height: 10,),
              const Text('(1)  '' هناك فرصة للحصول على فرصة للتحسين كل شهر ، والحصول على 150 نقطة لكل منشور يتوافق مع الشروط (منشورين كحد أقصى)',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(2)  ''الحصول على حقوق التسريع الإجمالية 1.5 مرة',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(3) '' المشاركة ذات الأولوية في أنشطة منح الجوائز التي تنظمها لانلا',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(4)  ''فرصة واحدة للظهور في مجلة  لانلا السنوية ؛',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(5)  ''فرصة لمرة واحدة على متن لانلا ؛',style: TextStyle(fontSize: 12,height: 1.8),),
              const SizedBox(height: 20,),
              ///lv5
              Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [
                Image.asset('assets/images/gzlv5.png',width: 77,height: 30,),
                Container(alignment: Alignment.center,width: 66,height: 30,decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(55)),color: Color(0xffF5F5F5)),
                  child: const Text('غير منجز',style: TextStyle(fontSize: 12,color: Color(0xff999999)),),
                )
              ],),
              const SizedBox(height: 10,),
              const Text('(1)  ''هناك فرصة للحصول على فرصة للتحسين كل شهر ، والحصول على 150 نقطة لكل منشوريتوافق مع الشروط  (منشورين كحد أقصى)',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(2)  ''الحصول على حقوق التسريع الإجمالية 1.5 مرة',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(3)  ''المشاركة ذات الأولوية في أنشطة منح الجوائز التي تنظمها لانلا',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(4)  ''فرصة واحدة للظهور في مجلة لانلا السنوية ؛',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(5)  ''فرصة لمرة واحدة على متن لانلا  ؛',style: TextStyle(fontSize: 12,height: 1.8),),
              const Text('(6)  ''لديك الفرصة للترقية إلى ماستر لانلا أولاً ؛',style: TextStyle(fontSize: 12,height: 1.8),),
            ],),
          ))

        ],)

      );
  }
}