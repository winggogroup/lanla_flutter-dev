import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logic.dart';

class SearchPage extends StatelessWidget {
  final logic = Get.put(SearchLogic());
  final userLogic = Get.put(UserLogic());
  final state = Get
      .find<SearchLogic>()
      .state;

  // fuzhi() async {
  //   var sp = await SharedPreferences.getInstance();
  //   print('______________________');
  //   //if(sp.getString("SearchHistory")["${userLogic.userId}"].length>0){
  //   state.SearchHistory=jsonDecode(sp.getString("SearchHistory")!);
  //   if(state.SearchHistory["${userLogic.userId}"]==null){
  //     state.SearchHistory["${userLogic.userId}"]=[];
  //   }
  // }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<SearchLogic>(builder: (logic) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                height: 42,
                // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(child: Icon(Icons.arrow_back_ios, size: 22,),onTap: (){
                      Navigator.of(context).pop();
                    },),
                    SizedBox(width: 15,),
                    Expanded(flex: 1, child:
                    TextField(
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Color(0xff999999)),
                          contentPadding: EdgeInsets.only(top: 0, bottom: 0),
                          border: InputBorder.none,
                          hintText: '输入搜索内容'.tr,
                          fillColor: Color(0xFFF9f9f9),
                          enabledBorder: OutlineInputBorder(
                            /*边角*/
                            borderRadius: BorderRadius.all(
                              Radius.circular(20), //边角为5
                            ),
                            borderSide: BorderSide(
                              color: Colors.white, //边线颜色为白色
                              width: 0, //边线宽度为2
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
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
                              padding: EdgeInsets.only(top: 10,bottom: 10,right: 5),
                              child:SvgPicture.asset('assets/icons/sousuo.svg',color: Color(0xff999999),),
                          )
                          // SvgPicture.asset('assets/icons/sousuo.svg',width: 5,height: 5,color: Color(0xffe4e4e4),),
                        ),
                      onChanged: (v){
                       state.SearchContent=v;
                       logic.update();
                      },onSubmitted: (value) {
                          logic.Searchnr();
                        }
                    )

                      ,),
                    SizedBox(width: 15,),
                    GestureDetector(
                      child: Text('搜索'.tr, style: TextStyle(
                          color: Color(0xff666666), fontSize: 15),

                      ),
                      onTap: () {
                        logic.Searchnr();
                      },
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20,),
              Expanded(flex: 1,
                child:
                // Container(decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)
                ListView(
                  //physics: const NeverScrollableScrollPhysics(),
                  children: [
                    if(state.SearchHistory['${userLogic.userId}']!=null&&state.SearchHistory['${userLogic.userId}'].length>0)Container(
                      // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('历史记录'.tr, style: TextStyle(fontSize: 16,
                              color: Color(0xff666666),
                              fontWeight: FontWeight.w600),),
                          GestureDetector(child: Image.asset(
                            'assets/images/shanchu.png', width: 22, height: 22,),onTap: (){
                            logic.empty(context);
                          },)
                        ],
                      ),
                    ),
                    if(state.SearchHistory['${userLogic.userId}']!=null&&state.SearchHistory['${userLogic.userId}'].length>0)SizedBox(height: 20,),
                    if(state.SearchHistory['${userLogic.userId}']!=null&&state.SearchHistory['${userLogic.userId}'].length>0)Container(
                      width: double.infinity,
                      child: Wrap(
                        spacing: 20, //主轴上子控件的间距
                        runSpacing: 20, //交叉轴上子控件之间的间距
                        alignment: WrapAlignment.start,
                        //mainAxisAlignment:MainAxisAlignment.spaceBetween,
                        children: [
                          for(var i = 0; i < state.SearchHistory['${userLogic.userId}'].length; i++)
                            GestureDetector(child:Container(
                              padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                              decoration: BoxDecoration(
                                color: Color(0xffF9F9F9),
                                borderRadius: BorderRadius.circular((20)),
                              ),
                              child: Text(state.SearchHistory['${userLogic.userId}'][i], style: TextStyle(
                                  color: Color(0xff999999),
                                  fontSize: 15),),
                            ) ,onTap: (){
                              logic.Searchnrtwo(state.SearchHistory['${userLogic.userId}'][i]);
                            },)
                        ],
                      ),
                    ),
                    if(state.SearchHistory['${userLogic.userId}']!=null&&state.SearchHistory['${userLogic.userId}'].length>0)SizedBox(height: 50,),
                    Container(
                      //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          GestureDetector(child:Text('热度排行'.tr, style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff000000),
                              fontWeight: FontWeight.w600),),
                            onTap: () {
                              //logic.WeeklyRanking();
                            },),
                          // SizedBox(width: 25,),
                          // GestureDetector(child: Text('本月排行'.tr, style: TextStyle(
                          //     fontSize: 16,
                          //     color: !state.Weeklyranking?Color(0xff000000):Color(0xff999999),
                          //     fontFamily: 'PingFang SC-Semibold',
                          //     fontWeight: FontWeight.w600),),
                          //     onTap: () {
                          //       logic.MonthlyRanking();
                          //     },)
                        ],
                      ),
                    ),
                    for(var i=0;i<state.rankinglist.length;i++)  Container(margin:EdgeInsets.fromLTRB(0, 25, 0, 0),
                      child: GestureDetector(child:Text('${i+1}.${state.rankinglist[i].title}',style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff666666),
                      ),),onTap: (){
                        if(state.rankinglist[i].type==2){
                          Get.toNamed(
                              '/public/picture', preventDuplicates: false,
                              arguments: {
                                "data": state.rankinglist[i].contentId,
                                "isEnd": false
                              });
                        }else if(state.rankinglist[i].type==1){
                          Get.toNamed('/public/video',arguments: {
                            'data':
                            state.rankinglist[i].contentId,
                            'isEnd': false
                          });
                        }
                       // logic.Searchnrtwo(state.rankinglist[i].title);
                      },)
                    ),
                    // Container(width:100,height:800,decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)
                  ],
                )
                ,
              ),



            ],
          ),
        );
      }),
    );
  }
}
