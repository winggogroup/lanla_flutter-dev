import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:shared_preferences/shared_preferences.dart';

class draftsWidget extends StatefulWidget {
  @override
  createState() => draftsState();

}
class draftsState extends State<draftsWidget> {
  final userLogic = Get.find<UserLogic>();
  final ScrollController _controllers = ScrollController(); // 滚动条控制器
  var draftsdata=[];

  @override
  void initState() {
    getdata();
    super.initState();
  }
  getdata() async {
    var sp = await SharedPreferences.getInstance();
    draftsdata=jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}'];
    // print('暂存区数据${DateTime.fromMillisecondsSinceEpoch(draftsdata[4]['id']).year}');
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '草稿箱'.tr,
          style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600,),
        ),
      ),
      body:
      Container(child: Column(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Expanded(child: ListView(children: [
            SizedBox(height: 15,),
            Container(padding:EdgeInsets.only(left: 20,right: 20),child:Text('草稿在应用卸载后会被删除，请及时发布'.tr,style: TextStyle(color: Color(0xff999999),fontSize: 12),), ),

            Container(width: double.infinity,child: ListView(scrollDirection: Axis.vertical,
                shrinkWrap: true,
                controller: _controllers,
                children:[
                  MasonryGridView.count(
                    shrinkWrap: true,
                    physics: new NeverScrollableScrollPhysics(),
                    // controller:
                    // widget.type == ApiType.myPublish ? null : _controller,
                    //key: PageStorageKey(item.id),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    // 上下间隔
                    crossAxisSpacing: 10,
                    //左右间隔
                    padding: const EdgeInsets.all(10),
                    // 总数
                    itemCount: draftsdata.length,
                    itemBuilder: (context, index) {
                      //return Container(height:(index % 5 + 1) * 100, child: GestureDetector(onTap: (){Get.toNamed('/setting');},child: Text('第${index}个'),));
                      return Column(children: [
                        GestureDetector(child: Stack(children: [
                          Container(
                            //margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                              padding:EdgeInsets.fromLTRB(0, 0, 0, 10),

                              // padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(color: Colors.white,
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                                border: new Border.all(width: 0.2, color: Color.fromRGBO(0, 0, 1, 0.2)),
                              ),
                              width: double.infinity,
                              child: Column(children: [
                                Stack(children: [
                                  Container(
                                    //超出部分，可裁剪
                                    width: double.infinity,
                                    clipBehavior: Clip.hardEdge,
                                    constraints: BoxConstraints(maxHeight: 250),
                                    //height: (context.width / 2 - 6) * data.attaImageScale>260?260:(context.width / 2 - 6) * data.attaImageScale,
                                    decoration:const BoxDecoration(
                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
                                      // borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                        //borderRadius: BorderRadius.circular(8),
                                        child: Image.file(
                                          draftsdata[index]['type']==1?File(draftsdata[index]['thumbnail']):
                                          File(draftsdata[index]['dataListFile'].split(',')[0]),
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ],),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  alignment: Alignment.centerRight,
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    draftsdata[index]['formData']['title'],
                                    overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                                    maxLines: 3,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 11),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                  margin: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          children: [
                                            /// 删除
                                            GestureDetector(child:
                                              SvgPicture.asset('assets/svg/shanchu.svg',width: 18,height: 18,),onTap: () async {
                                              var sp = await SharedPreferences.getInstance();
                                              draftsdata.removeAt(index);
                                              var newzcdata=jsonDecode(sp.getString("holduptank")!)['${userLogic.userId}'].removeAt(index);
                                              print('新数据${newzcdata is String}');

                                              sp.setString("holduptank", jsonEncode(newzcdata));
                                              setState(() {

                                              });
                                            },),
                                          ],
                                        ),
                                      ),
                                      Text('${DateTime.fromMillisecondsSinceEpoch(draftsdata[index]['id']).day}-${DateTime.fromMillisecondsSinceEpoch(draftsdata[index]['id']).month}-${DateTime.fromMillisecondsSinceEpoch(draftsdata[index]['id']).year}',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 12,color: Color(0xff999999)),)
                                    ],
                                  ),
                                )
                              ])),
                          /// 播放小图标-luo pym_
                          // Positioned(
                          //     top: 10,
                          //     left: 10,
                          //     child: data.type == 1
                          //         ?
                          //     // const Icon(
                          //     //     Icons.linked_camera,
                          //     //     color: Colors.white70,
                          //     //     size: 22,
                          //     //   )
                          //     SvgPicture.asset('assets/svg/play_new.svg')
                          //         : Container()),
                          // ///音频提示
                          // Positioned(
                          //     top: 10,
                          //     left: 10,
                          //     child: data.type == 2&&data.recordingPath!=''
                          //         ?
                          //     // Icon(
                          //     //   Icons.mic,
                          //     //   color: Colors.white70,
                          //     //   size: 18,
                          //     // )
                          //     SvgPicture.asset('assets/svg/mic_new.svg')
                          //         : Container())
                        ]),onTap: (){
                          Get.toNamed('/verify/publish',
                              arguments: {"holduptank": draftsdata[index]});
                        },)
                      ],);
                    },
                  )
                ]),)
          ],),)
        ],
      ),),
    );
  }
}