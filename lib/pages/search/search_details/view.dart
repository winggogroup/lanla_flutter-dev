import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/pages/search/search_details/tab_view.dart';

import 'logic.dart';


class SearchDetailsPage extends StatefulWidget {
  @override
  createState() => SearchDetailsState();
  final logic = Get.put(SearchDetailsLogic());
}
class SearchDetailsState extends State<SearchDetailsPage> {
  TextEditingController selectionController = TextEditingController();
  final state = Get.find<SearchDetailsLogic>().state;
  final userLogic = Get.find<UserLogic>();
  void initState() {
    super.initState();
    print("112");
    print(Get.arguments['text']);
    selectionController.text=Get.arguments['text'];
  }
  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
      child: GetBuilder<SearchDetailsLogic>(builder: (logic) {
        return Container(

          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              SizedBox(height: 10,),
              Container(
                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                        controller: selectionController,
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
                          ),
                        ),
                        onChanged: (v){
                          if(v!=''){
                            state.monisj=v;
                            widget.logic.update();
                          }
                        },onSubmitted: (value) {
                          if(value!=''){
                            state.keywords=value;
                            widget.logic.update();// logic.Searchnr();
                          }

                        }
                    )

                      ,),
                    SizedBox(width: 15,),
                    GestureDetector(
                      child: Text('搜索'.tr, style: TextStyle(
                          color: Color(0xff666666), fontSize: 15),
                      ),
                      onTap: () {
                        if(state.monisj!=''){
                          state.keywords=state.monisj;
                        }
                        widget.logic.SearchUsers(state.keywords);
                        widget.logic.update();
                        FocusScope.of(context).unfocus();
                        childKey.currentState?.toupdate(state.keywords);
                        FirebaseAnalytics.instance.logEvent(
                          name: "Search",
                          parameters: {
                            "keyword": state.keywords,
                            "userid":userLogic.userId,
                            'deviceId':userLogic.deviceId
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15,),
              Expanded(flex: 1,

                child:
                _tabBar()
                // Container(decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)
                // ListView(
                //   //physics: const NeverScrollableScrollPhysics(),
                //
                // )
                ,
              ),
               //Container(decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),)


            ],
          ),
        );
      }),
    );
  }
  _tabBar() {
    return SearchTabView();
  }
}
