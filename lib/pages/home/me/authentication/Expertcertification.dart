import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart' as htmljx;
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/services/SetUp.dart';
class ExpertcertificationPage extends StatefulWidget {
  @override
  createState() => ExpertcertificationState();
}
class ExpertcertificationState extends State<ExpertcertificationPage>{


  final userLogic = Get.find<UserLogic>();
  SetUpProvider interface =  Get.put(SetUpProvider());
  Publicmethodes Publicmethods = Get.put(Publicmethodes());
  var conditiondata;
  @override
  void initState() {
    conditiondata=Get.arguments;
    setState(() {

    });
  }
  @override
  void dispose() {
    super.dispose();
  }
  ///申请认证
  certification() async {
    var res = await interface.submit('label_famous_user');
    if(res.statusCode==200){
      Navigator.pop(context);
      Get.back(result: true);
    }else{
      Navigator.pop(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(color:Color(0xffFFFFFF)),
        child: ListView(
          //crossAxisAlignment:CrossAxisAlignment.start,
          children: [
            Container(
              height: 1.0,
              decoration: const BoxDecoration(
                color: Color(0xfff1f1f1),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0c00000),
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    spreadRadius: 0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),child: Row(mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text('申请条件'.tr,style: const TextStyle(fontWeight: FontWeight.w700),),GestureDetector(child: Image.asset('assets/images/wenhaots.png',width: 25,height: 25,),onTap: (){
              ExplanationPopup(context);
            },)],),),
            const SizedBox(height: 30,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),child: Row(children: [
              // Container(alignment: Alignment.center,width: 20,height: 20,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),border: Border.all(width: 2,color: Colors.black)),child: Text('1',style: TextStyle(height: 1.5,fontWeight: FontWeight.w600,fontSize: 12),),),
              // SizedBox(width: 10,),
              Text(conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['title'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
            ],),),
            const SizedBox(height: 10,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),child: Text(conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['desc'],style: const TextStyle(fontSize: 15,),),),
            const SizedBox(height: 10,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),height:30,child: Stack(children: [Positioned(right: 0,child: Container(child: Column(children: [
              Container(
                padding: const EdgeInsets.only(left: 11,right: 11,top: 2,bottom: 2),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: const Color.fromRGBO(225, 225, 225, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Text('${conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['current_point']}/${conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['target_point']}',style: const TextStyle(fontSize: 10),),
              ),
              Stack(clipBehavior: Clip.none,children: [
                Container(width: 9,height: 7,),
                Positioned(top: -1,child:Image.asset('assets/images/dwxiajt.png',width: 9,height: 7,))
              ],),

            ],),)),],),),
            Container(
              height: 6, // 进度条高度
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20,right: 20),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(5), // 圆角边框
              ),
              child: LayoutBuilder(builder:
                  (BuildContext context,
                  BoxConstraints constraints) {
                double boxWidth = constraints.maxWidth;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['target_point']!=0?conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['current_point']/conditiondata['label_famous_user']['second_page_config']['condition_desc'][0]['target_point']:0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffD1FF34), // 进度条颜色
                          borderRadius:
                          BorderRadius.circular(
                              5), // 圆角边框
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
            const SizedBox(height: 25,),
            // Container(
            //   height: 1.0,
            //   margin: EdgeInsets.only(left: 20,right: 20),
            //   decoration: BoxDecoration(
            //     color: Color.fromRGBO(245, 245, 245, 1),
            //     // boxShadow: [
            //     //   BoxShadow(
            //     //     color: Color.fromRGBO(245, 245, 245, 1),
            //     //     offset: Offset(0, 1),
            //     //     blurRadius: 5,
            //     //     spreadRadius: 0,
            //     //   ),
            //     // ],
            //   ),
            // ),
            ///第二个
            const SizedBox(height: 30,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),child: Row(children: [
              // Container(alignment: Alignment.center,width: 20,height: 20,decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(50)),border: Border.all(width: 2,color: Colors.black)),child: Text('2',style: TextStyle(height: 1.5,fontWeight: FontWeight.w600,fontSize: 12),),),
              // SizedBox(width: 10,),
              Text(conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['title'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w700),),
            ],),),
            const SizedBox(height: 10,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),child: Text(conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['desc'],style: const TextStyle(fontSize: 15,),),),
            const SizedBox(height: 10,),
            Container(width: double.infinity,margin: const EdgeInsets.only(left: 20,right: 20),height:30,child: Stack(children: [Positioned(right: 0,child: Container(child: Column(children: [
              Container(
                padding: const EdgeInsets.only(left: 11,right: 11,top: 2,bottom: 2),
                decoration: BoxDecoration(
                  border: Border.all(width: 1,color: const Color.fromRGBO(225, 225, 225, 1)),
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                ),
                child: Text('${conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['current_point']}/${ conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['target_point']}',style: const TextStyle(fontSize: 10),),
              ),
              Stack(clipBehavior: Clip.none,children: [
                Container(width: 9,height: 7,),
                Positioned(top: -1,child:Image.asset('assets/images/dwxiajt.png',width: 9,height: 7,))
              ],),

            ],),)),],),),
            Container(
              height: 6, // 进度条高度
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20,right: 20),
              decoration: BoxDecoration(
                color: const Color(0xffF5F5F5),
                borderRadius: BorderRadius.circular(5), // 圆角边框
              ),
              child: LayoutBuilder(builder:
                  (BuildContext context,
                  BoxConstraints constraints) {
                double boxWidth = constraints.maxWidth;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['target_point']!=0?conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['current_point']/conditiondata['label_famous_user']['second_page_config']['condition_desc'][1]['target_point']:0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xffD1FF34), // 进度条颜色
                          borderRadius:
                          BorderRadius.circular(
                              5), // 圆角边框
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

          ],
        ),
      ),
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
                    conditiondata['label_famous_user']['second_page_config']['title'],
                    style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                  ),
                )),
            Container(
              width: 19,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: const Color(0xffffffff),
        padding: const EdgeInsets.all(50),
        child: ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all<double?>(0),
            backgroundColor: MaterialStateProperty.all(!conditiondata['label_famous_user']['second_page_config']['button_disabled']?const Color.fromRGBO(219, 255, 0, 1):const Color.fromRGBO(245, 245, 245, 1)),
          ),
          onPressed: ()  async {
              if(!conditiondata['label_famous_user']['second_page_config']['button_disabled']){
                Publicmethods.loades(context,'');
                await certification();
              }
          },
          child: Text(!conditiondata['label_famous_user']['second_page_config']['button_disabled']?'立刻申请'.tr:'申请条件未达成'.tr,style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: !conditiondata['label_famous_user']['second_page_config']['button_disabled']?const Color.fromRGBO(0, 0, 0, 1):const Color.fromRGBO(153, 153, 153, 1),
          ),textAlign: TextAlign.center,),
        ),
      ),
    );
  }
  ///说明弹窗
  Future<void> ExplanationPopup(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding:const EdgeInsets.fromLTRB(0, 0, 0, 0),
          shape:const RoundedRectangleBorder(borderRadius:BorderRadius.all(Radius.circular(20))),
          content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  //color: Colors.transparent,
                  //color: Colors.red,
                  // height: 280,
                  child:Column(
                    mainAxisAlignment:MainAxisAlignment.center,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-100,
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        padding: const EdgeInsets.all(20),
                        child:
                        // Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                        //   Text('贝壳的用途'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                        //   SizedBox(height: 5,),
                        //   Text('1.'+'贝壳可以被用来给你喜欢的作品送礼物'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        //   SizedBox(height: 5,),
                        //   Text('2.'+'贝壳可以用于参与LanLa平台不同时段的活动'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        //   SizedBox(height: 10,),
                        //   Text('怎样获得贝壳'.tr,style: TextStyle(fontWeight: FontWeight.w600,fontSize: 15),),
                        //   SizedBox(height: 5,),
                        //   Text('1.'+'可以参与LanLa平台不定期任务所得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        //   SizedBox(height: 5,),
                        //   Text('2.'+'每日登陆LanLa可得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        //   SizedBox(height: 5,),
                        //   Text('3.'+'他人送礼可得'.tr,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13,color: Color(0xff999999),height: 1.5),),
                        // ],),
                        SingleChildScrollView(
                            child:
                            htmljx.HtmlWidget(
                              conditiondata['label_famous_user']['second_page_config']['tip_html'] ,
                            )
                        )
                      )
                    ],),),
              ]),
        );
      },
    );
  }
}
