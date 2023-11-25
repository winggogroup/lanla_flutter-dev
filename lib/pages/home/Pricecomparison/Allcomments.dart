import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/models/ProductDetails.dart';
import 'package:lanla_flutter/pages/home/Pricecomparison/Writecomments.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/Pricecomparison.dart';
class allcommentsPage extends StatefulWidget{
  @override
  allcommentsState createState() => allcommentsState();
}
class allcommentsState extends State<allcommentsPage>{
  final ScrollController _controller = ScrollController();
  final Pricemodules = Get.find<Pricemodule>();
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  var commentslist=[];
  var page=1;
  void initState() {
    super.initState();
    spdetail();
    _controller.addListener(() {
      // 拉取下一页
      if (_controller.offset == _controller.position.maxScrollExtent) {
        spdetail();
      }
    });
  }


  ///商品详情
  spdetail() async{
    var res=await Pricemodules.parityRatiodetail(Get.arguments,10,page);
    if(res.statusCode==200){
      if(spDetailsFromJson(res.bodyString!).commentList.isNotEmpty){
        commentslist.addAll(spDetailsFromJson(res.bodyString!).commentList);
        page++;
      }
      oneData=true;
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    var res=await Pricemodules.parityRatiodetail(Get.arguments,10,page);
    if(res.statusCode==200){
      if(spDetailsFromJson(res.bodyString!).commentList.isNotEmpty){
        commentslist=spDetailsFromJson(res.bodyString!).commentList;
        page++;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
        appBar: AppBar(
          elevation: 0,
          //消除阴影
          backgroundColor: Colors.white,
          //设置背景颜色为白色
          centerTitle: true,
          leading: IconButton(
              color: Colors.black,
              icon: const Icon(Icons.arrow_back_ios),
              tooltip: "Search",
              onPressed: () {
                //print('menu Pressed');
                Navigator.of(context).pop();
              }),
          title: Text('用户评测'.tr, style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            //fontFamily: ' PingFang SC-Semibold, PingFang SC',
          ),),
        ),
        body: !oneData ? StartDetailLoading():Container(
          decoration: const BoxDecoration(color: Colors.white),
          child:
         Stack(children: [
           commentslist.isNotEmpty?Column(
              children: [
                Divider(height: 1.0, color: Colors.grey.shade200,),
                ///
                Expanded(child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    displacement: 10.0,
                    child: ListView.builder(shrinkWrap: true,primary:false,controller:  _controller,padding:EdgeInsets.zero,itemCount: commentslist.length,itemBuilder: (context, i) {
                  return  Container(padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),child:Column(children: [
                    const SizedBox(height: 10,),
                    Row(children: [
                      ///头像
                      GestureDetector(child:Container(
                          width: 40, height: 40,
                          decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(100),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(commentslist[i].avatar),
                            ),
                          )
                      ),onTap: (){

                      },),
                      const SizedBox(width: 10,),
                      Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.spaceBetween,children: [Text(commentslist[i].username,style: const TextStyle(fontSize: 15),),const SizedBox(height: 8,),Row(children: [Text(commentslist[i].score,style: const TextStyle(color: Color(0xff9BE400),fontSize: 12,fontWeight: FontWeight.w600),),const SizedBox(width: 10,),Text(commentslist[i].createdAt,style: const TextStyle(fontSize: 12,color: Color(0XFF999999)),)],)],),
                    ],),
                    const SizedBox(height: 5,),
                    ///评论
                    Container(width: double.infinity,margin: const EdgeInsets.only(right: 50),child: Text(commentslist[i].text, overflow: TextOverflow.ellipsis, //长度溢出后显示省略号
                      maxLines: 8,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 13,color: Color(0XFF666666),height: 1.3),
                    ),),
                    const SizedBox(height: 10,),
                    if( commentslist[i].images!='')Container(margin: const EdgeInsets.only(right: 50),width: double.infinity,child: Row(children: [
                      for(var r=0;r<commentslist[i].images.split(',').length;r++)
                        if(r<3)Container(margin: const EdgeInsets.only(left: 15),width: 85,height: 85,decoration: BoxDecoration(
                          color: const Color(0xffd9d9d9),borderRadius: const BorderRadius.all(Radius.circular(5)),image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(commentslist[i].images.split(',')[r]),
                        ),),),
                    ],),),
                    const SizedBox(height: 10,),
                    ///分割线
                    Container(height: 1.0, decoration: const BoxDecoration(color: Color(0xfff1f1f1), boxShadow: [BoxShadow(color: Color(0x0c00000), offset: Offset(0, 2), blurRadius: 5, spreadRadius: 0,),],
                    ),),
                  ],),)
                  ;
                }))
                )
              ],
            ):RefreshIndicator(
               onRefresh: _onRefresh,
               displacement: 10.0,
               child: ListView.builder(
                   itemCount: 1,
                   itemBuilder: (context, i) {
                     return Container(
                       // decoration: BoxDecoration(border:Border.all(color: Colors.red,width:1)),
                       child: Column(
                         // mainAxisAlignment:MainAxisAlignment.center,
                         children: [
                           const SizedBox(
                             height: 100,
                           ),
                           Image.asset(
                             'assets/images/noGuanzhuBg.png',
                             width: 200,
                             height: 200,
                           ),
                           const SizedBox(
                             height: 40,
                           ),
                           Text(
                             '还没有用户评价'.tr,
                             style: const TextStyle(
                               fontSize: 16,
                               //fontFamily: 'PingFang SC-Regular, PingFang SC'
                             ),
                           ),
                         ],
                       ),
                     );
                   })),
            Positioned(left: 10,bottom:200,child:
            GestureDetector(child:Container(
                width: 60, height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/pinglfc.png'),
                  ),
                )
            ),onTap: (){
              Get.to(WritecommentsPage(),arguments: Get.arguments)?.then((value) {
                if (value != null) {
                  page=1;
                  commentslist=[];
                  spdetail();
                  //此处可以获取从第二个页面返回携带的参数
                }
              });
            },),)
          ],),
        )
    );
  }
}