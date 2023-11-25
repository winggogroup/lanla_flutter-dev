import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/friend/Planningpage.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/loading_widget.dart';
import 'package:lanla_flutter/services/content.dart';

class ContentZoneListPage extends StatefulWidget {
  @override
  createState() => ContentZoneListState();
}
class ContentZoneListState extends State<ContentZoneListPage> with AutomaticKeepAliveClientMixin {
  ContentProvider provider = Get.put(ContentProvider());
  bool get wantKeepAlive => true; // 是否开启缓存
  final ScrollController _scrollController = ScrollController(); //listview 的控制器
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  bool antishake=true;
  var newdata;
  int page=1;
  @override
  void initState() {
    _fetch(1);
    _scrollController.addListener(() {
      if(_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent){
        // print('进来了'),
        _fetch(page);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  _fetch(pages) async {
    if(antishake){
      antishake=false;
      if(page==1){
        setState(() {
          oneData=false;
        });
      }

      var res =await provider.contentArealist(pages);
      if(res.statusCode==200){
        if(res.body['data'].length!=0){
          page=res.body['currPage']+1;
          if(res.body['currPage']==1){
            newdata=res.body['data'];
          }else{
            newdata=[...newdata,...res.body['data']];
          }
        }

        oneData=true;
      }
      antishake=true;
    }

    setState(() {
    });
  }
  Widget build(BuildContext context) {
    return !oneData
        ? StartDetailLoading()
        : Container(padding: const EdgeInsets.only(left: 20,right: 20,bottom: 10),child: ListView.builder(
        controller: _scrollController,
        itemCount: newdata.length,
        itemBuilder: (context, i) {
          return GestureDetector(child: Container(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(alignment: Alignment.centerRight,child: Text(newdata[i]['title'],style: const TextStyle(fontSize: 15,fontWeight: FontWeight.w600),),),
                const SizedBox(
                  height: 15,
                ),
                Container(clipBehavior: Clip.hardEdge,width: double.infinity,height: 100,decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),child: Image.network(newdata[i]['image'],fit: BoxFit.cover,),),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),onTap: (){
            Get.to(Planningpage(),arguments: {"id":newdata[i]['id'],"title":newdata[i]['title']});
          },);
        }),);
  }
}