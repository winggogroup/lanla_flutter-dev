import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:url_launcher/url_launcher.dart';


class ProductlabelPage extends StatefulWidget {
  @override
  createState() => ProductlabelState();
}

class ProductlabelState extends State<ProductlabelPage> {
  final provider = Get.find<ContentProvider>();
  bool oneData = false;
  int listPage=1;
  ScrollController _scrollController = ScrollController();
  var likelistdata = [];
  @override
  void initState() {
    _fetch();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        //达到最大滚动位置
        _fetch();
      }
    });
    super.initState();

  }
  /// 请求数据
  Future<void> _fetch() async {
    var res=await provider.commoditylist(listPage,Get.arguments['data'],0,);
    if(res.statusCode==200){
      if(res.body['data'].length>0){
        listPage++;
        if(likelistdata.length==0){
          likelistdata=res.body['data'];
        }else{
          likelistdata=[...likelistdata,...res.body['data']];
        }
      }
      oneData=true;
      setState(() {});
    }
  }
  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: SvgPicture.asset(
              "assets/icons/fanhui.svg",
              width: 22,
              height: 22,
            ),
          ),
          title: Text(Get.arguments['title'], style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Divider(height: 1.0, color: Colors.grey.shade200,),
              Expanded(
                  flex: 1,
                  child: !oneData
                      ? StartDetailLoading():likelistdata.length>0?
                  RefreshIndicator(onRefresh: _onRefresh,
                    child: MasonryGridView.count(
                      controller: _scrollController,
                      shrinkWrap: true,
                      // physics: const NeverScrollableScrollPhysics(), //禁止滚动
                      crossAxisCount: 2,
                      mainAxisSpacing: 0,
                      // 上下间隔
                      crossAxisSpacing: 0,
                      //左右间隔
                      padding: const EdgeInsets.all(0),
                      // 总数
                      itemCount: likelistdata.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Container(
                            padding: EdgeInsets.all(15),
                            height: 244,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 0.5,
                                    color: Color.fromRGBO(
                                        245, 245, 245, 1))),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  width: 140,
                                  height: 140,
                                  child: CachedNetworkImage(
                                    imageUrl: likelistdata[index]
                                    ['image'],
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        Container(
                                          color: Color(0xffF5F5F5),
                                          padding: EdgeInsets.only(
                                              left: 20, right: 20),
                                          width: double.infinity,
                                          child: Image.asset(
                                              'assets/images/LanLazhanwei.png'),
                                        ),
                                    errorWidget:
                                        (context, url, error) {
                                      // 网络图片加载失败时显示本地图片
                                      return Container(
                                        color: Color(0xffF5F5F5),
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        width: double.infinity,
                                        child: Image.asset(
                                          'assets/images/LanLazhanwei.png',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    likelistdata[index]['title'],
                                    overflow: TextOverflow.ellipsis,
                                    //长度溢出后显示省略号
                                    maxLines: 2,
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                // SizedBox(height: 8,),
                                Row(
                                  children: [
                                    Text(
                                      likelistdata[index]['price']
                                          .toString(),
                                    ),
                                    Text(likelistdata[index]
                                    ['currency']),
                                  ],
                                )
                              ],
                            ),
                          ),
                          onTap: () async {
                            await launchUrl(
                              Uri.parse(likelistdata[index]['url']),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        );
                      },
                    ),):Container(
                    width: double.infinity,
                    // decoration: BoxDecoration(border: Border.all(width: 1,color: Colors.red),),
                    child:Column(
                      children: [
                        SizedBox(height: 120,),
                        Image.asset('assets/images/noZanguobg.png',width: 200,height: 200,),
                        SizedBox(height: 40,),
                        Text('暂无喜欢的商品'.tr,style: TextStyle(
                            fontSize: 15,
                            color: Color(0xff999999)
                        ),),
                      ],
                    ),
                  )
              )
            ],
          ),
        )
    );
  }

  Future<void> _onRefresh() async {
    oneData=false;
    setState(() {

    });
    var res=await provider.commoditylist(1,jsonEncode([]),1);
    if(res.statusCode==200){
      if(res.body['data'].length>0){
        listPage++;
        likelistdata=res.body['data'];

      }

    }
    oneData=true;
    setState(() {});
  }
}
