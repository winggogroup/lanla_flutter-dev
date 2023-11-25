import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/toast/view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class sommoditysearchPage extends StatefulWidget {
  createState() => sommoditysearchState();
}
class sommoditysearchState extends State<sommoditysearchPage> {
  final userLogic = Get.find<UserLogic>();
  var SpsearchHistory= {};
  var SearchFor = '';
  void initState() {
    initial();

  }
  @override
  void dispose() {
    super.dispose();
  }
  initial() async {
    var sp = await SharedPreferences.getInstance();
    if(sp.getString("SpsearchHistory")!=null){
      SpsearchHistory=jsonDecode(sp.getString("SpsearchHistory")!);
      if(SpsearchHistory["${userLogic.userId}"]==null){
        SpsearchHistory["${userLogic.userId}"]=[];
      }
    }else{
      SpsearchHistory["${userLogic.userId}"]=[];
    }
  }


  @override
  Widget build(context){
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const SizedBox(height: 10,),
            Container(
              height: 36,
              // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(child: const Icon(Icons.arrow_back_ios, size: 22,),onTap: (){
                    Navigator.of(context).pop();
                  },),
                  const SizedBox(width: 15,),
                  Expanded(flex: 1, child:
                  TextField(
                      decoration: InputDecoration(
                          hintStyle: const TextStyle(color: Color(0xff999999)),
                          contentPadding: const EdgeInsets.only(top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintText: '输入搜索内容'.tr,
                          fillColor: const Color(0xFFF9f9f9),
                          enabledBorder: const OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(20), //边角为5
                            ),
                            borderSide: BorderSide(
                              color: Colors.white, //边线颜色为白色
                              width: 0, //边线宽度为2
                            ),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(20), //边角为5
                            ),
                            borderSide: BorderSide(
                              color: Colors.white, //边线颜色为白色
                              width: 0, //边线宽度为2
                            ),

                          ),
                          filled: true,
                          prefixIcon:Padding(
                            padding: const EdgeInsets.only(top: 10,bottom: 10,right: 5),
                            child:SvgPicture.asset('assets/icons/sousuo.svg',color: const Color(0xff999999),),
                          )
                        // SvgPicture.asset('assets/icons/sousuo.svg',width: 5,height: 5,color: Color(0xffe4e4e4),),
                      ),
                      onChanged: (v){
                        SearchFor=v;
                        setState(() {

                        });
                      },onSubmitted: (value) async {
                        if(SearchFor!=''){
                          if(SpsearchHistory['${userLogic.userId}'].contains(SearchFor)){

                          }else{
                            ///存储历史
                            if(SpsearchHistory['${userLogic.userId}'].length<5){
                              SpsearchHistory['${userLogic.userId}'].add(SearchFor);

                            }else{
                              SpsearchHistory['${userLogic.userId}'].removeAt(0);
                              SpsearchHistory['${userLogic.userId}'].add(SearchFor);
                            }
                            setState(() {

                            });
                            var sp = await SharedPreferences.getInstance();
                            sp.setString("SpsearchHistory", jsonEncode(SpsearchHistory));
                          }
                        }

                  }
                  )

                    ,),
                  const SizedBox(width: 15,),
                  GestureDetector(
                    child: Text('搜索'.tr, style: const TextStyle(
                        color: Color(0xff666666), fontSize: 15),

                    ),
                    onTap: () {

                    },
                  ),

                ],
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(flex: 1,
              child:
              // Container(decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)
              ListView(
                //physics: const NeverScrollableScrollPhysics(),
                children: [
                  if(SpsearchHistory['${userLogic.userId}']!=null&&SpsearchHistory['${userLogic.userId}'].length>0)Container(
                    // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('历史记录'.tr, style: const TextStyle(fontSize: 16,
                            color: Color(0xff666666),
                            fontWeight: FontWeight.w600),),
                        GestureDetector(child: Image.asset(
                          'assets/images/shanchu.png', width: 22, height: 22,),onTap: () async {

                          if(SpsearchHistory['${userLogic.userId}'].toString()!="[]"){
                            var sp = await SharedPreferences.getInstance();
                            sp.remove("SpsearchHistory");
                            SpsearchHistory['${userLogic.userId}']=[];
                            setState(() {

                            });
                            Toast.toast(context,msg:'清除成功'.tr ,position: ToastPostion.center);
                          }
                        },)
                      ],
                    ),
                  ),
                  if(SpsearchHistory['${userLogic.userId}']!=null&&SpsearchHistory['${userLogic.userId}'].length>0)const SizedBox(height: 20,),
                  if(SpsearchHistory['${userLogic.userId}']!=null&&SpsearchHistory['${userLogic.userId}'].length>0)Container(
                    width: double.infinity,
                    child: Wrap(
                      spacing: 20, //主轴上子控件的间距
                      runSpacing: 20, //交叉轴上子控件之间的间距
                      alignment: WrapAlignment.start,
                      //mainAxisAlignment:MainAxisAlignment.spaceBetween,
                      children: [
                        for(var i = 0; i < SpsearchHistory['${userLogic.userId}'].length; i++)
                          GestureDetector(child:Container(
                            padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
                            decoration: BoxDecoration(
                              color: const Color(0xffF9F9F9),
                              borderRadius: BorderRadius.circular((20)),
                            ),
                            child: Text(SpsearchHistory['${userLogic.userId}'][i], style: const TextStyle(
                                color: Color(0xff999999),
                                fontSize: 15),),
                          ) ,onTap: (){
                            // logic.Searchnrtwo(SpsearchHistory['${userLogic.userId}'][i]);
                          },)
                      ],
                    ),
                  ),
                  if(SpsearchHistory['${userLogic.userId}']!=null&&SpsearchHistory['${userLogic.userId}'].length>0)const SizedBox(height: 50,),
                  // Container(
                  //   //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     children: [
                  //       GestureDetector(child:Text('热度排行'.tr, style: TextStyle(
                  //           fontSize: 16,
                  //           color: Color(0xff000000),
                  //           fontWeight: FontWeight.w600),),
                  //         onTap: () {
                  //           //logic.WeeklyRanking();
                  //         },),
                  //       // SizedBox(width: 25,),
                  //       // GestureDetector(child: Text('本月排行'.tr, style: TextStyle(
                  //       //     fontSize: 16,
                  //       //     color: !state.Weeklyranking?Color(0xff000000):Color(0xff999999),
                  //       //     fontFamily: 'PingFang SC-Semibold',
                  //       //     fontWeight: FontWeight.w600),),
                  //       //     onTap: () {
                  //       //       logic.MonthlyRanking();
                  //       //     },)
                  //     ],
                  //   ),
                  // ),
                  // for(var i=0;i<state.rankinglist.length;i++)  Container(margin:EdgeInsets.fromLTRB(0, 25, 0, 0),
                  //     child: GestureDetector(child:Text('${i+1}.${state.rankinglist[i].title}',style: TextStyle(
                  //       fontSize: 15,
                  //       color: Color(0xff666666),
                  //     ),),onTap: (){
                  //       if(state.rankinglist[i].type==2){
                  //         Get.toNamed(
                  //             '/public/picture', preventDuplicates: false,
                  //             arguments: {
                  //               "data": state.rankinglist[i].contentId,
                  //               "isEnd": false
                  //             });
                  //       }else if(state.rankinglist[i].type==1){
                  //         Get.toNamed('/public/video',arguments: {
                  //           'data':
                  //           state.rankinglist[i].contentId,
                  //           'isEnd': false
                  //         });
                  //       }
                  //       // logic.Searchnrtwo(state.rankinglist[i].title);
                  //     },)
                  // ),
                  // Container(width:100,height:800,decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)
                ],
              )
              ,
            ),



          ],
        ),
      ),
    );
  }

}