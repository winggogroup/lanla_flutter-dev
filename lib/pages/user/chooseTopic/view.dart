import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/toast/view.dart';
import 'logic.dart';

class ChooseTopicPage extends StatelessWidget {
  final logic = Get.put(ChooseTopicLogic());
  final state = Get.find<ChooseTopicLogic>().state;


  List<Widget> _getListData(topiclist) {
    List<Widget> list = [];
    for (var i = 0; i < 9; i++) {
      list.add(Container(
        color: Colors.blue,
        // width: 106,
        // height: 106,
        child: Column(
          children: [
          Expanded(
          flex: 1,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            alignment: Alignment.topLeft,
            child:true? Image.asset('assets/images/weixuan.png',width: 15.0,
                height: 15.0):
            Image.asset('assets/images/xuanzhong.png',width: 20.0,
                height: 20.0)
            // decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1)),
          ),
          ),
            Expanded(
              flex: 1,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                alignment: Alignment.bottomRight,
                // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                child:const Text("123",style:TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                )),
              ),
            )
          ],
        ),
// height: 400, //设置高度没有反应
      ));
    }
    return list;
  }

  @override


  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 88, 20, 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('选择感兴趣的内容'.tr,textAlign:TextAlign.center,style: const TextStyle(
                  fontSize:30,
                )),
                //
              ],
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('根据兴趣生成你的内容'.tr,textAlign:TextAlign.center,style: const TextStyle(
                    fontSize:14,
                  ))
                  //
                ],
              ),
            ),
            //话题模块

        Expanded(
          flex:1, child: Container(
          width: double.infinity,
          // height: 500,
          margin: const EdgeInsets.fromLTRB(0, 36, 0, 0),

          // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
          child: Obx(() =>GridView.count(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
            crossAxisSpacing: 15.0, //水平子 Widget 之间间距
            mainAxisSpacing: 15.0, //垂直子 Widget 之间间距
            // padding: const EdgeInsets.all(10),
            crossAxisCount: 3, //一行的 Widget 数量
            childAspectRatio: 1, //宽度和高度的比例
            children: [
              for (var i = 0; i < state.topiclist.value.length; i++)GestureDetector(
                child: Container(
                // width: 106,
                // height: 106,
                  decoration: ShapeDecoration(
                        image: DecorationImage(
                          image: NetworkImage(state.topiclist.value[i].picture),
                          fit: BoxFit.fill,
                        ),
                    shape:RoundedRectangleBorder(borderRadius: BorderRadiusDirectional.circular(10)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              alignment: Alignment.topLeft,
                              child:!state.xztopiclist.value.contains(state.topiclist.value[i].id)? Image.asset('assets/images/weixuan.png',width: 15.0, height: 15.0): Image.asset('assets/images/xuanzhong.png',width: 20.0,
                                  height: 20.0)
                            // decoration: BoxDecoration(border: Border.all(color: Colors.black,width: 1)),
                          ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          alignment: Alignment.bottomRight,
                          // decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
                          child:Text(state.topiclist.value[i].name,style:const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                          )),
                        ),
                    )
                  ],
                ),
// height: 400, //设置高度没有反应
              ),
                onTap: (){
                  if(!state.xztopiclist.contains(state.topiclist.value[i].id)){
                    state.xztopiclist.add(state.topiclist.value[i].id);
                  }else{
                    state.xztopiclist.remove(state.topiclist.value[i].id);
                  }
                },
              )
            ],
          ),)

        ),
        ),
            Container(

              width: double.infinity,
              height: 46,
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
              //decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:MaterialStateProperty.all(const Color(0xff000000)),
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  shadowColor: MaterialStateProperty.all(Colors.black),
                  elevation: MaterialStateProperty.all(5),
                  // elevation: MaterialStateProperty.all(20),
                  shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(37))
                  ),
                ),

                child: Text('完成'.tr,),
                onPressed: () {
                  if(state.xztopiclist.isNotEmpty){
                    logic.complete();
                  }else{
                    Toast.toast(context,msg: "最少选择1个".tr,position: ToastPostion.bottom);
                  }
                  // Get.to(ChooseTopicPage());

                },
              ),
            ),
            // Positioned(
            //   // left: 20.0,
            //   // top: 120.0,
            //   bottom: 50,
            //   child: Container(
            //     width: double.infinity,
            //     height: 100,
            //     decoration: BoxDecoration(border: Border.all(color: Colors.red,width: 1)),
            //     child: ElevatedButton(
            //       style: ButtonStyle(
            //         backgroundColor:MaterialStateProperty.all(Color(0xff3E9900)),
            //         foregroundColor: MaterialStateProperty.all(Colors.white),
            //         // elevation: MaterialStateProperty.all(20),
            //         shape: MaterialStateProperty.all(
            //             RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(37))
            //         ),
            //       ),
            //
            //       child: Text('下一步'.tr,),
            //       onPressed: () {
            //         Get.to(ChooseTopicPage());
            //         // Toast.toast(context,msg: "居中显示",position: ToastPostion.bottom);
            //       },
            //     ),
            //   ),
            // ),


        ],
        ),
      )
    );







  }
}
