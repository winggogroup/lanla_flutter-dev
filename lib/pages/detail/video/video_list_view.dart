import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/controller/publicmethodes.dart';
import 'package:lanla_flutter/models/HomeDetails.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/pages/detail/video/play_view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/video.dart';
import 'package:lanla_flutter/ulits/event.dart';

class VideoListView extends StatefulWidget {
  var  defalutData;
  late bool isEnd;

  late Function setUseridCallback;

  VideoListView(this.defalutData, this.isEnd, this.setUseridCallback,
      {super.key});

  @override
  _VideoListViewState createState() => _VideoListViewState();
}

class _VideoListViewState extends State<VideoListView>
    with AutomaticKeepAliveClientMixin {
  List<HomeDetails> dataList = [];
  VideoProvider provider = Get.put<VideoProvider>(VideoProvider());
  ContentProvider contentProvider = Get.put<ContentProvider>(ContentProvider());
  final PageController _controller = PageController();
  int nowPage = 0;
  bool isDelete = false;
  int page = 1;
  bool isFetch = false;

  @override
  initState() {
    _controller.addListener(_pageControllerListener);
    _initData();
    super.initState();
  }

  _initData() async {
    //请求当前数据
    dataList.add(widget.defalutData);
    // HomeDetails? defalutData = await _fetchDefalutData(widget.defalutData.id);
    //
    // if (defalutData == null) {
    //   setState(() {
    //     isDelete = true;
    //   });
    //   return;
    // }
   //dataList[0] = widget.defalutData;
   print('shisha${dataList.length}');
    _fetch();
  }

  _pageControllerListener() {
    if (nowPage != _controller.page?.toInt()) {
      nowPage = _controller.page?.toInt() ?? 0;
      print("当前视频页:$nowPage");
      widget.setUseridCallback(dataList[nowPage].userId);
      if(dataList.length - nowPage < 5){
        _fetch();
      }
    }
  }

  Future<HomeDetails?> _fetchDefalutData(int contentId) async {
    return await Get.put<ContentProvider>(ContentProvider()).Detail(contentId);
  }

  // 加载视频列表
  _fetch() async {
    if(isFetch){
      return ;
    }
    print('请求视频数据:$page');
    isFetch = true;
    dataList.addAll(await provider.GetVideoList(page,widget.defalutData.channel));
    page++;
    setState(() {});
    isFetch = false;
  }

  Widget loadingView(){
    return Container(
        color: Colors.black,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width:MediaQuery.of(context).size.width,
          padding: const EdgeInsets.only(bottom: 70),
          child: Image.network(
          widget.defalutData.thumbnail,
          fit: widget.defalutData.attaImageScale!=null&&widget.defalutData.attaImageScale > 1
              ? BoxFit.cover
              : BoxFit.fitWidth,
        ),)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          )),
      body: dataList.isEmpty
          ? loadingView()
          : isDelete
              ? Container(
                  color: Colors.black,
                  child: Center(
                    child: Text(
                      '内容已经被删除'.tr,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              : SafeArea(
                child: PageView.builder(
                    controller: _controller,
                    scrollDirection: Axis.vertical,
                    itemCount: dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        color: Colors.black,
                        child: VideoScreen(
                            dataSource: dataList[index],
                            index: index,
                            page: index == 0 ? 0 : _controller.page!,
                            setLike: setLike,
                            setCollect: setCollect,
                            setFollow: () {},
                            isEnd: widget.isEnd,
                            remove: () {
                              dataList.removeAt(index);
                              _controller
                                  .jumpToPage((_controller.page!.toInt() + 1));
                              setState(() {});
                            },
                            updateCommentNumber: () {
                              updateCommentTotal(index);
                            }),
                      );
                    },
                  ),
              ),
    );
  }

  setLike(index) {
    var status = Get.find<UserLogic>().setLike(dataList[index].id);
    status ? dataList[index].likes++ : dataList[index].likes--;
    setState(() {});
    eventBus.fire(UpdateHomeItemList(status, dataList[index].id));
  }

  setCollect(index) {
    var status = Get.find<UserLogic>().setCollect(dataList[index].id);
    status ? dataList[index].collects++ : dataList[index].collects--;
    setState(() {});
  }

  updateCommentTotal(index) async {
    print('重新拉取评论数');
    Future.delayed(const Duration(seconds: 1),() async {
      HomeDetails? newData = await contentProvider.Detail(dataList[index].id);
      setState(() {
        dataList[index].comments = newData!.comments;
      });
    });

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive {
    print('keep');
    return true;
  }

  @override
  void dispose() {

    super.dispose();
    _controller.removeListener(_pageControllerListener);
  }
}
