import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:lanla_flutter/pages/search/search_details/logic.dart';

class commodityPage extends StatefulWidget{
  @override
  commodityState createState() => commodityState();
}

class commodityState extends State<commodityPage>{
  TextEditingController selectionController = TextEditingController();
  void initState() {
    super.initState();
    //selectionController.text=Get.arguments['text'];
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          SizedBox(height: MediaQueryData.fromWindow(window).padding.top+10,),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: 42,
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
                    controller: selectionController,
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
                      ),
                    ),
                    onChanged: (v){
                      if(v!=''){
                        // state.monisj=v;
                        // widget.logic.update();
                      }
                    },onSubmitted: (value) {
                  if(value!=''){
                    // state.keywords=value;
                    // widget.logic.update();// logic.Searchnr();
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
          // SizedBox(height: 15,),
          Row(children: [
            Expanded(child: Container(height: 105,alignment: Alignment.center,
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
              child: ListView(
                  shrinkWrap: true,
                  primary:false,
                  scrollDirection: Axis.horizontal,
                  children:[
                    for(var i=0;i<10;i++)
                      GestureDetector(child:Container(
                        color: Colors.white,
                        margin: const EdgeInsets.only(right: 20),
                        child: Column(
                          children: [
                            Container(
                              width: 45,
                              height: 45,
                              //超出部分，可裁剪
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: Colors.black),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Image.asset(
                                'assets/images/ceshitp.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height:5,),
                            const Text('口红',style: TextStyle(fontSize: 15,color: Colors.black),)
                          ],
                        ),
                      ),onTap: (){
                        print('13333333');
                        Get.toNamed('/public/Evaluationdetails');
                      },),
                    const SizedBox(width: 20,)
                  ]),
            )),
          ],),
          // Container(width: double.infinity,decoration: BoxDecoration(color: Color(0xffF5F5F5)),padding: EdgeInsets.fromLTRB(20, 15, 20, 15),child:
          //   Text('共xxx个品牌xxxx个宝贝',style: TextStyle(fontSize: 15,fontWeight: FontWeight.w600,height: 1),),),
          // Expanded(child: ListView.builder(shrinkWrap: true,primary:false,padding:EdgeInsets.zero,itemCount: 15,itemBuilder: (context, i) {
          //   return Container(margin: EdgeInsets.only(left: 20,right: 20),padding: EdgeInsets.only(top: 12,bottom: 12),child:
          //   Row(children: [Container(width: 34,height: 34,color: Colors.red,),SizedBox(width: 5,),Text('NOON')],),
          //     decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: Color(0xFFE1E1E1)),
          //     )),
          //   );
          // }))

          ///第二个页面
         
          Expanded(child: ListView.builder(shrinkWrap: true,primary:false,padding:EdgeInsets.zero,itemCount: 15,itemBuilder: (context, i) {
            return Column(children: [
              Container(width: double.infinity,decoration: const BoxDecoration(color: Color(0xffF5F5F5)),height: 10,),
              Container(padding: const EdgeInsets.all(20),child: Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                const Text('口红笔',style: TextStyle(fontWeight: FontWeight.w600),),
                const SizedBox(height: 15,),
                MasonryGridView.count(
                  shrinkWrap: true,
                  padding:EdgeInsets.zero,
                  physics:  const NeverScrollableScrollPhysics(),
                  // controller:
                  // widget.type == ApiType.myPublish ? null : _controller,
                  //key: PageStorageKey(item.id),
                  crossAxisCount: 3,
                  mainAxisSpacing: 15,
                  // 上下间隔
                  crossAxisSpacing: 15,
                  //左右间隔
                  //padding: const EdgeInsets.all(2),
                  // 总数
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    // bool isEnd = widget.type != ApiType.home;
                    //return Container(height:(index % 5 + 1) * 100, child: GestureDetector(onTap: (){Get.toNamed('/setting');},child: Text('第${index}个'),));
                    return Container(decoration: BoxDecoration(border: Border.all(width: 1,color: const Color(0xffE1E1E1))),width: 102,height: 146,child: Column(children: [
                      Image.asset('assets/images/ceshi.png',width: double.infinity,),
                      Expanded(child: Container(alignment: Alignment.center,child: const Text('1233333'),))
                    ],),);
                  },
                )
              ],),)
            ],);
          }))
        ],
      ),
    );
  }

}