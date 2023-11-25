import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/models/Topicpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/no_data_widget.dart';
import 'package:lanla_flutter/services/comment.dart';
import 'package:lanla_flutter/services/content.dart';

class newTopicxqpagePage extends StatefulWidget {
  @override
  createState() => newTopicxqpageState();
}

class newTopicxqpageState extends State<newTopicxqpagePage>
    with AutomaticKeepAliveClientMixin {
  final provider = Get.find<ContentProvider>();
  final userController = Get.find<UserLogic>();
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  final ScrollController _scrollControllerls = ScrollController(); //listview 的控制器
  var TopicList = [];
  int page = 0; // 当前页数

  bool Antishaking = true;

  bool get wantKeepAlive => true; // 是否开启缓存
  @override
  void initState() {
    Datarequest();
    _scrollControllerls.addListener(() {
      if (_scrollControllerls.position.pixels >
          _scrollControllerls.position.maxScrollExtent - 50) {
        //达到最大滚动位置
        Datarequest();
      }
    });
    super.initState();
  }

  Datarequest() async {
    if (Antishaking) {
      page++;

      Antishaking = false;
      var result = await provider.Topicpage(page);
      if (result.statusCode == 200) {
        if (TopicpageFromJson(result.bodyString!).isNotEmpty) {
          if (TopicList.isEmpty) {
            TopicList = TopicpageFromJson(result.bodyString!);
          } else {
            TopicList.addAll(TopicpageFromJson(result.bodyString!));
          }
        } else {
          page--;
        }
        setState(() {
          oneData = true;
        });
      } else {
        page--;
      }
      Future.delayed(const Duration(milliseconds: 1000), () {
        Antishaking = true;
      });
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    TopicList = [];
    page = 0;
    _scrollControllerls.dispose();
  }

  Future<void> _onRefresh() async {
    if (Antishaking) {
      page++;

      Antishaking = false;
      var result = await provider.Topicpage(1);
      if (result.statusCode == 200) {
        if (TopicpageFromJson(result.bodyString!).isNotEmpty) {
          TopicList = TopicpageFromJson(result.bodyString!);
        } else {
          page--;
        }
        setState(() {
          oneData = true;
        });
      } else {
        page--;
      }
      Future.delayed(const Duration(milliseconds: 1000), () {
        Antishaking = true;
      });
      setState(() {});
    }
  }

  Widget build(BuildContext context) {
    return !oneData
        ? StartDetailLoading()
        : Column(
            children: [
              TopicList.isNotEmpty
                  ? Expanded(
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        color: Colors.white,
                        child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                              controller: _scrollControllerls,
                              itemCount: TopicList.length,
                              itemBuilder: (context, i) {
                                return GetBuilder<UserLogic>(builder: (logic) {
                                  return GestureDetector(
                                    child: Container(
                                      // color: Colors.red,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            // mainAxisAlignment:
                                            // MainAxisAlignment.spaceBetween,
                                            children: [
                                              Container(
                                                clipBehavior: Clip.hardEdge,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                width: 66,
                                                height: 45,
                                                child: Image.network(
                                                  TopicList[i].imagePath,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 12,
                                              ),
                                              Container(
                                                height: 45,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/images/jinghao.png',
                                                          width: 19,
                                                          height: 19,
                                                        ),
                                                        const SizedBox(
                                                          width: 5,
                                                        ),
                                                        Text(TopicList[i].title)
                                                      ],
                                                    ),
                                                    Text(
                                                      '${TopicList[i]
                                                              .visits} ${'参与人员'.tr}',
                                                      style: const TextStyle(
                                                          fontSize: 12,
                                                          color: Color(
                                                              0xff999999)),
                                                    ),
                                                  ],
                                                ),
                                              )

                                              // GestureDetector(
                                              //   child:
                                              //   Row(
                                              //     children: [
                                              //       Image.asset(
                                              //         'assets/images/jinghao.png',
                                              //         width: 19,
                                              //         height: 19,
                                              //       ),
                                              //       const SizedBox(
                                              //         width: 5,
                                              //       ),
                                              //       Text(TopicList[i].title)
                                              //     ],
                                              //   ),
                                              //   onTap: () {
                                              //     Get.toNamed('/public/topic',
                                              //         arguments: TopicList[i].id);
                                              //   },
                                              // ),
                                              // GestureDetector(
                                              //   child: Row(
                                              //     children: [
                                              //       Text(
                                              //         '显示更多'.tr,
                                              //         style: TextStyle(
                                              //             fontSize: 12,
                                              //             color:
                                              //             Color(0xff999999)),
                                              //       ),
                                              //       SizedBox(
                                              //         width: 10,
                                              //       ),
                                              //       Container(
                                              //           width: 5,
                                              //           height: 10,
                                              //           child: SvgPicture.asset(
                                              //             "assets/svg/zuojiantou.svg",
                                              //           ))
                                              //     ],
                                              //   ),
                                              //   onTap: () {
                                              //     Get.toNamed('/public/topic',
                                              //         arguments: TopicList[i].id);
                                              //   },
                                              // )
                                            ],
                                          ),

                                          // SizedBox(
                                          //   height: 5,
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     // for(var item in TopicList[i].content)
                                          //     for (var f = 0;
                                          //     f < TopicList[i].content.length;
                                          //     f++)
                                          //       Row(
                                          //         children: [
                                          //           Stack(
                                          //             children: [
                                          //               GestureDetector(
                                          //                 child: Container(
                                          //                   constraints:
                                          //                   BoxConstraints(
                                          //                       maxHeight:
                                          //                       125),
                                          //                   width: (MediaQuery.of(
                                          //                       context)
                                          //                       .size
                                          //                       .width -
                                          //                       80) /
                                          //                       3,
                                          //                   height: 125,
                                          //                   child: ClipRRect(
                                          //                     borderRadius:
                                          //                     BorderRadius
                                          //                         .circular(
                                          //                         10),
                                          //                     child:
                                          //                     Image.network(
                                          //                       TopicList[i]
                                          //                           .content[f]
                                          //                           .thumbnail,
                                          //                       fit: BoxFit.cover,
                                          //                     ),
                                          //                   ),
                                          //                 ),
                                          //                 onTap: () {
                                          //                   if (TopicList[i]
                                          //                       .content[f]
                                          //                       .videoPath !=
                                          //                       '') {
                                          //                     Get.toNamed(
                                          //                         '/public/video',
                                          //                         preventDuplicates:
                                          //                         false,
                                          //                         arguments: {
                                          //                           "data":
                                          //                           TopicList[
                                          //                           i]
                                          //                               .content[
                                          //                           f]
                                          //                               .id,
                                          //                           "isEnd": false
                                          //                         });
                                          //                   } else {
                                          //                     Get.toNamed(
                                          //                         '/public/picture',
                                          //                         preventDuplicates: false,
                                          //                         arguments: {
                                          //                           "data":
                                          //                           TopicList[
                                          //                           i]
                                          //                               .content[
                                          //                           f]
                                          //                               .id,
                                          //                           "isEnd": false
                                          //                         });
                                          //                   }
                                          //                 },
                                          //               ),
                                          //               Positioned(
                                          //                 bottom: 10,
                                          //                 left: 10,
                                          //                 child: GestureDetector(
                                          //                   onTap: () {
                                          //                     print('点赞');
                                          //                     if (TopicList[i]
                                          //                         .content[f]
                                          //                         .id !=
                                          //                         0) {
                                          //                       final userLogic =
                                          //                       Get.find<
                                          //                           UserLogic>();
                                          //                       if (!userLogic
                                          //                           .checkUserLogin()) {
                                          //                         Get.toNamed(
                                          //                             '/public/loginmethod');
                                          //                         return;
                                          //                       }
                                          //                       bool status =
                                          //                       userController.setLike(
                                          //                           TopicList[
                                          //                           i]
                                          //                               .content[
                                          //                           f]
                                          //                               .id);
                                          //                       status
                                          //                           ? TopicList[i]
                                          //                           .content[
                                          //                       f]
                                          //                           .likes++
                                          //                           : TopicList[i]
                                          //                           .content[
                                          //                       f]
                                          //                           .likes--;
                                          //                       setState(() {});
                                          //                     }
                                          //                   },
                                          //                   child: Container(
                                          //                       child: Row(
                                          //                         children: [
                                          //                           Padding(
                                          //                             padding: const EdgeInsets
                                          //                                 .only(
                                          //                                 right:
                                          //                                 3,top: 2),
                                          //                             child: Text(
                                          //                               TopicList[
                                          //                               i]
                                          //                                   .content[
                                          //                               f]
                                          //                                   .likes
                                          //                                   .toString(),
                                          //                               style: const TextStyle(
                                          //                                   color:
                                          //                                   Colors.white,
                                          //                                   fontSize: 12,
                                          //                                   fontWeight: FontWeight.w400),
                                          //                               textAlign: TextAlign.center,
                                          //                             ),
                                          //                           ),
                                          //                           SizedBox(width: 4,),
                                          //                           // Icon(
                                          //                           //   userController.getLike(TopicList[i]
                                          //                           //           .content[
                                          //                           //               f]
                                          //                           //           .id)
                                          //                           //       ? Icons
                                          //                           //           .favorite
                                          //                           //       : Icons
                                          //                           //           .favorite_border,
                                          //                           //   size: 16,
                                          //                           //   color: userController.getLike(TopicList[i]
                                          //                           //           .content[
                                          //                           //               f]
                                          //                           //           .id)
                                          //                           //       ? Colors
                                          //                           //           .red
                                          //                           //       : Colors
                                          //                           //           .white70,
                                          //                           // ),
                                          //                           userController.getLike(TopicList[i]
                                          //                               .content[
                                          //                           f]
                                          //                               .id)
                                          //                               ?
                                          //                           SvgPicture.asset('assets/svg/huati_xin_sel.svg', width: 12, height: 12,) : SvgPicture.asset('assets/svg/huati_xin_nor.svg',width: 12, height: 12,),
                                          //                           // SvgPicture.asset('assets/svg/heart_sel_new.svg') : SvgPicture.asset('assets/svg/whiteheart_nor_new.svg'),
                                          //                         ],
                                          //                       ),
                                          //                       padding: EdgeInsets
                                          //                           .only(
                                          //                           left: 10,
                                          //                           right:
                                          //                           10),
                                          //                       height: 20,
                                          //                       decoration: BoxDecoration(
                                          //                           borderRadius:
                                          //                           BorderRadius
                                          //                               .circular(
                                          //                               22),
                                          //                           color:const Color(
                                          //                               0x66000000))),
                                          //                 ),
                                          //               ),
                                          //             ],
                                          //           ),
                                          //           if (f != 2)
                                          //             SizedBox(
                                          //               width: 20,
                                          //             )
                                          //         ],
                                          //       )
                                          //   ],
                                          // ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Container(
                                            height: 1.0,
                                            decoration: const BoxDecoration(
                                              color: Color(0xfff1f1f1),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Color(0x0c00000),
                                                  offset: Offset(0, 2),
                                                  blurRadius: 5,
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      Get.toNamed('/public/topic',
                                          arguments: TopicList[i].id);
                                    },
                                  );
                                });
                              }),
                        ),
                      ),
                    )
                  : Expanded(
                      child: RefreshIndicator(
                          onRefresh: _onRefresh,
                          child: ListView(children: [
                            Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height,
                              child: NoDataWidget(),
                            )
                          ])))
            ],
          );
  }
}
