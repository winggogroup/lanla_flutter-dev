import 'dart:convert';
import 'dart:ui';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/Starrating.dart';
import 'package:lanla_flutter/models/commoditylistanalysis.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/Pricecomparison.dart';
import 'package:url_launcher/url_launcher.dart';

class PricecomparisonpageCorrelation extends StatefulWidget{
  @override
  PricecomparisonState createState() => PricecomparisonState();

  final List listItem = [];
}
class PricecomparisonState extends State<PricecomparisonpageCorrelation>{

  final ScrollController pd_controller = ScrollController();

  final ScrollController sp_controller = ScrollController();

  final Pricemodules = Get.put(Pricemodule());
  late int sppage=1;
  late int lbpage=1;
  late int spchannel=0;
  late String spkeyword='';
  var commoditylist=[];
  var frequencylist=[];
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  @override
  void initState() {
    super.initState();
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
    ///商品
    pindaolist();
    parityRatiolist();

    pd_controller.addListener(() {
      if (pd_controller.offset == pd_controller.position.maxScrollExtent) {
        pindaolist();
      }
    });

    sp_controller.addListener(() {
      if (sp_controller.offset == sp_controller.position.maxScrollExtent) {
        print('5566');
        parityRatiolist();
      }
    });
  }
  ///商品
  parityRatiolist() async {
    var res= await Pricemodules.parityRatiolist({"keyword":spkeyword,"channel":spchannel,"page":sppage});
    print('2222222${res.statusCode}');
    if(res.statusCode==200){
      if  (res.bodyString != '[]') {
        commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        print('三方数据${jsonDecode(commoditylist[0].priceOther)}');
        sppage++;
        setState(() {});
      }
    }
    setState(() {
      oneData=true;
    });
  }
  pindaolist() async {
    var pdres= await Pricemodules.parityRatiochannlelist(lbpage);
    if(pdres.statusCode==200){
      if  (pdres.bodyString != '[]') {
        frequencylist.addAll(pdres.body);
        lbpage++;
        //commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        setState(() {});
      }

    }
  }

  void dispose() {
    super.dispose();
    sppage = 1;
    lbpage = 1;
    spkeyword='';
    pd_controller.dispose();
    sp_controller.dispose();
  }

  Future<void> _onRefresh() async {
    commoditylist=[];
    var res= await Pricemodules.parityRatiolist({"keyword":spkeyword,"channel":spchannel,"page":sppage});
    if(res.statusCode==200){
      if  (res.bodyString != '[]') {
        commoditylist.addAll(commoditylistanalysisFromJson(res.bodyString!));
        sppage++;

      }else{
        sppage=1;
      }
      setState(() {});
    }


  }

  Widget build(BuildContext context) {
    return
      Scaffold(
        // appBar: AppBar(
        //   systemOverlayStyle: SystemUiOverlayStyle.light,
        // ),
        body: GestureDetector(child:!oneData ? StartDetailLoading():Container(color: Colors.white,child: Column(
          children: [
            Container(width: double.infinity,height: 170,decoration: const BoxDecoration(gradient: LinearGradient(
                begin: Alignment.topCenter,//渐变开始于上面的中间开始
                end: Alignment.bottomCenter,//渐变结束于下面的中间
                colors: [Color(0xffC5FF00),Color(0xFFFFFFFF)//开始颜色和结束颜色
                ])),
              child: Column(children: [
                SizedBox(height: MediaQueryData.fromWindow(window).padding.top+20,),
                ///搜索
                Container(width: double.infinity,padding:const EdgeInsets.fromLTRB(20, 0, 20, 0),child:
                  Row(children: [
                    GestureDetector(child:SvgPicture.asset(
                      "assets/icons/fanhui.svg",
                      width: 22,
                      height: 22,
                    ) ,onTap: (){
                      Navigator.of(context).pop();
                    },),
                      const SizedBox(width: 15,),
                      Expanded(child: TextField(
                        //focusNode: _searchFocus,
                          decoration: InputDecoration(
                            hintStyle:
                            const TextStyle(color: Color(0xffD9D9D9),fontSize: 13),
                            contentPadding:
                            const EdgeInsets.only(top: 0, bottom: 0),
                            enabledBorder: const OutlineInputBorder(
                              ///设置边框四个角的弧度
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              ///用来配置边框的样式
                              // borderSide: BorderSide(
                              //   ///设置边框的颜色
                              //   color: Colors.black,
                              //   ///设置边框的粗细
                              //   width: 2.0,
                              // )
                              borderSide: BorderSide.none,),
                            focusedBorder: const OutlineInputBorder(
                              // borderSide: BorderSide(
                              //   color: Colors.black, //边框颜色为白色
                              //   width: 2, //宽度为5
                              // ),
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.all(
                                Radius.circular(30), //边角为30
                              ),
                            ),
                            hintText: '输入搜索内容'.tr,
                            fillColor: const Color(0xffffffff),
                            filled: true,
                            prefixIcon: Padding(                        padding: const EdgeInsets.only(
                                top: 12, bottom: 12, right: 5),
                              child: SvgPicture.asset(
                                'assets/icons/sousuo.svg',
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          enableInteractiveSelection: true,
                          onChanged: (v) {
                            //_searchText = v;
                            print(v);
                            spkeyword=v;
                            sppage=1;
                            spchannel=0;
                            commoditylist=[];
                            parityRatiolist();
                          },
                          onSubmitted: (value) {
                            print('445566');
                            // _search();
                          })),
                    ])
                ,),

                ///
                const SizedBox(height: 10,),
                Expanded(child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [Text('全网比价'.tr,style: const TextStyle(color: Colors.black,fontSize: 13,),),const SizedBox(height: 1,),Text('你的LanLa时尚购物指南'.tr,style: const TextStyle(color: Colors.black,fontSize: 13,))],))
              ],),
            ),
            Expanded(child: Column(children: [
              Row(children: [
                Expanded(child: Container(height: 105,alignment: Alignment.center,
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                  child: ListView(
                      shrinkWrap: true,
                      primary:false,
                      controller:  pd_controller,
                      scrollDirection: Axis.horizontal,
                      children:[
                        for(var item in frequencylist)
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
                                  //padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: spchannel==item['id']? Colors.black:const Color(0xfff1f1f1)),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Image.network(
                                    item['thumbnail'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height:5,),
                                Container(constraints: const BoxConstraints(maxWidth: 60,),child: Text(item['title'],overflow: TextOverflow.ellipsis,
                                  maxLines: 1,style: TextStyle(fontSize: 12,color: spchannel==item['id']? Colors.black:const Color(0xffD9D9D9)),),)
                              ],
                            ),
                          ),onTap: (){
                            if(spchannel!=item['id']){
                              print('13333333');
                              setState(() {
                                spchannel=item['id'];
                              });
                              spkeyword='';
                              sppage=1;
                              commoditylist=[];
                              parityRatiolist();
                            }
                            // Get.toNamed('/public/Evaluationdetails');
                          },),
                        const SizedBox(width: 20,)
                      ]),
                )),
              ],),
              Expanded(child: Container(child: RefreshIndicator(onRefresh: _onRefresh,
                child: ListView.builder(shrinkWrap: true,primary:false,controller:  sp_controller,padding:EdgeInsets.zero,itemCount: commoditylist.length,itemBuilder: (context, i) {
                  return GestureDetector(onTap: (){
                    // Get.toNamed('/public/Evaluationdetails',arguments: {'data':commoditylist[i]} );
                    widget.listItem.add(commoditylist[i]);
                    Navigator.pop(context, widget.listItem);
                  },child: Column(children: [
                    Container(width: double.infinity,height: 10,color: const Color(0xfff9f9f9),),
                    const SizedBox(height: 15,),
                    Row(children: [const SizedBox(width: 20,),
                      Container(width: 80, height: 80,
                        //超出部分，可裁剪
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          color:const Color(0xfff5f5f5),
                          borderRadius: BorderRadius.circular(5),
                            border:Border.all(width: 0.5,color: const Color(0xfff5f5f5))
                        ),
                        child: Image.network(
                          commoditylist[i].thumbnail,
                          //fit: BoxFit.cover,
                          fit: BoxFit.cover,
                          width: 50, height: 50,
                        ),
                      ),
                      const SizedBox(width: 8,),
                      Column(crossAxisAlignment:CrossAxisAlignment.start,children: [
                        Container(constraints: const BoxConstraints(maxWidth: 250,),child:
                        Text(commoditylist[i].title,overflow: TextOverflow.ellipsis,
                          maxLines: 1,style: const TextStyle(fontSize: 14),),),
                        const SizedBox(height: 8,),
                        Row(children: [
                          Container(height: 25,child: Text('评估'.tr,style: const TextStyle(color: Color(0xff999999)),),),
                          const SizedBox(width: 5,),
                          XMStartRating(rating: double.parse(commoditylist[i].score) ,showtext:true)
                        ],),
                      ],)],),
                    Container(height: 56,alignment: Alignment.centerRight,
                      padding: const EdgeInsets.fromLTRB(0, 10, 0,0),
                      child: ListView(
                          shrinkWrap: true,
                          primary:false,
                          scrollDirection: Axis.horizontal,
                          children:[
                            for(var j=0;j<jsonDecode(commoditylist[i].priceOther).length;j++)
                              GestureDetector(child:Container(margin:const EdgeInsets.only(right: 10),width: 110,height: 56,decoration: BoxDecoration(border: Border.all(width: 0.5,color: const Color((0xffF5F5F5))),
                                  color: const Color(0xfff5f5f5),
                                  borderRadius: const BorderRadius.all(Radius.circular(5))
                              ),child: Column(mainAxisAlignment:MainAxisAlignment.center,children: [
                                Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children: [
                                  // Text("SAR",style: TextStyle(fontSize: 12,height: 1.1),),
                                  // SizedBox(width: 2,),
                                  Text(jsonDecode(commoditylist[i].priceOther)[j]['price'].split(' ')[0],style: const TextStyle(height: 1.3,fontSize: 15,fontWeight: FontWeight.w600),),
                                  const SizedBox(width: 4,),
                                  Text(jsonDecode(commoditylist[i].priceOther)[j]['price'].split(' ')[1],style: const TextStyle(height: 1.3,fontSize: 12),)
                                ],),
                                Text(jsonDecode(commoditylist[i].priceOther)[j]['platform'],style: const TextStyle(fontSize: 12,color: Color(0xff999999)),)
                              ],),) ,onTap: () async {
                                await launchUrl(Uri.parse(jsonDecode(commoditylist[i].priceOther)[j]['detailPath']), mode: LaunchMode.externalApplication,);
                              },)
                          ]),
                    ),
                    const SizedBox(height: 15,),
                  ]),);
                }),)),),]),)
          ],
        ),),onPanDown: (details){
          // print('出发了吗???');
          FocusScope.of(context).unfocus();
        },),
      )
    ;
  }
}
