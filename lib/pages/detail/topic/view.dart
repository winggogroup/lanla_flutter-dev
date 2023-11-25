import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/common/controller/UserLogic.dart';
import 'package:lanla_flutter/common/widgets/home_item_widget.dart';
import 'package:lanla_flutter/models/HomeItem.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/item.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';
import 'package:lanla_flutter/services/content.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:lanla_flutter/ulits/app_log.dart';
import 'package:lanla_flutter/ulits/language/camera_picker_text_delegate.dart';
import 'package:lanla_flutter/ulits/toast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class TopicPage extends StatefulWidget {
  @override
  _TopicPageState createState() => _TopicPageState();
}

class _TopicPageState extends State<TopicPage> {
  final provider = Get.put(TopicProvider());
  final contentProvider = Get.put(ContentProvider());
  final userController = Get.find<UserLogic>();
  final ScrollController _controller = ScrollController();
  List<HomeItem> contentList = [];
  int page = 1;
  bool isOver = false;
  bool isLoading = false;
  int pageType = 1;
  TopicModel? _dataSource;

  @override
  void initState() {
    _init(Get.arguments);
    _controller.addListener(_listener);
    super.initState();
  }

  _init(int id) async {
    _dataSource = await provider.getDetail(id);
    if (_dataSource == null) {
      ToastInfo("话题不存在".tr);
    }
    _getData();
    setState(() {});
  }

  _listener() {
    // 拉取下一页
    if (_controller.offset == _controller.position.maxScrollExtent) {
      _getData();
    }
  }

  _getData() async {
    if (isOver || isLoading) {
      return;
    }
    isLoading = true;
    var result = await provider.GetTopicContent(
        pageType == 1 ? "New" : "Hot", _dataSource!.id, page);
    if (result.isEmpty) {
      isOver = true;
      ToastInfo('没有更多内容了'.tr);
    }
    contentList.addAll(result);
    page++;
    isLoading = false;
    setState(() {});
  }

  _setPageType(int type) {
    if (pageType == type) {
      return false;
    }
    pageType = type;

    contentList = [];
    page = 1;
    isOver = false;
    isLoading = false;

    setState(() {});
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
              child: NestedScrollView(
              controller: _controller,
              floatHeaderSlivers: true,
              headerSliverBuilder: (contex, _) {
              return [
                SliverAppBar(
                  expandedHeight: (_dataSource?.imagePath ?? "") == ""
                      ? 60
                      : MediaQuery.of(context).size.width * 0.56,
                  floating: true,
                  snap: false,
                  pinned: true,
                  actions: [
                    GestureDetector(
                      onTap: (){
                        AppLog('share', event: 'topic',targetid: Get.arguments);
                        Get.put<ContentProvider>(ContentProvider()).ForWard(Get.arguments,4);
                        Share.share('${'分享给你一个话题'.tr} https://api.lanla.app/share?t=${Get.arguments}');
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 20,right: 20),
                        width: 22,
                        height: 22,
                        child: Image.asset(
                          // 'assets/images/fenxiang_mengban.png',
                          'assets/images/fenxiang.png',
                          color: (_dataSource?.imagePath ?? "") == ""
                              ? Colors.black : Colors.white,
                        ),//pym_
                        // child: SvgPicture.asset(
                        //   "assets/svg/fenxiang.svg",
                        //   color: Colors.black,
                        // ),
                      ),
                    )
                  ],
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgPicture.asset(
                      "assets/icons/fanhui.svg",
                      width: 22,
                      height: 22,
                    ),
                  ),
                  flexibleSpace: (_dataSource?.imagePath ?? "") != ""
                      ? FlexibleSpaceBar(
                          centerTitle: true,
                          background: Image.network(
                              fit: BoxFit.cover, _dataSource!.imagePath))
                      : null,
                ),
                SliverToBoxAdapter(
                    child: Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                    color: Colors.black12,
                    width: 0.5,
                  ))),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                        child: Row(
                          children: [
                            Image.asset('assets/images/jinghao.png',fit: BoxFit.cover,width: 22,height: 22,),
                            const SizedBox(width: 7,),
                            Container(constraints: BoxConstraints(maxWidth: 250,),child:Text(
                              overflow: TextOverflow.ellipsis,
                               _dataSource?.title ?? "---",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 15, right: 15, bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                if (!userController.checkUserLogin()) {
                                  Get.toNamed('/public/loginmethod');
                                  return;
                                }
                                if (_dataSource == null) {
                                  return;
                                }
                                EasyLoading.show(status: 'loading...',maskType: EasyLoadingMaskType.black);
                                bool isSuccess = await provider.setCollects(
                                    _dataSource!.id, !_dataSource!.isCollect);
                                if (isSuccess) {
                                  _dataSource!.isCollect =
                                      !_dataSource!.isCollect;
                                }
                                EasyLoading.dismiss();
                                setState(() {});
                              },
                              child: Container(
                                padding:
                                    const EdgeInsets.fromLTRB(15, 6, 15, 6),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular((20)),
                                  border: Border.all(
                                    color: Colors.black26,
                                    width: 0.3,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  children: [
                                    _dataSource != null &&
                                            _dataSource!.isCollect
                                        ? Image.asset(
                                            'assets/images/topic/collect2.png',
                                            height: 22,
                                            width: 22,
                                          )
                                        : Image.asset(
                                            'assets/images/topic/collect1.png',
                                            height: 22,
                                            width: 22,
                                          ),
                                    Container(
                                      width: 5,
                                    ),
                                    _dataSource != null
                                        ? _dataSource!.isCollect
                                        ? Text("已收藏".tr,style: const TextStyle(
                                        color: Color.fromRGBO(153, 153, 153, 1),
                                        fontSize: 14,fontWeight: FontWeight.w400)): Text("收藏".tr,style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,fontWeight: FontWeight.w400)): Text("收藏".tr,style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,fontWeight: FontWeight.w400))
                                  ],
                                ),
                              ),
                            ),
                            Row(children: [
                              Text(
                                (_dataSource?.visits ?? "0")+'浏览量'.tr,
                                style: const TextStyle(color: Color(0xFF999999),fontSize: 12,fontWeight: FontWeight.w400),
                              )
                            ]),
                          ],
                        ),
                      )
                    ],
                  ),
                )),
                SliverPersistentHeader(
                  delegate: MyDelegate(
                      pageType: pageType,
                      callback: (type) {
                        _setPageType(type);
                      }),
                  pinned: true,
                ),
              ];
            },
            body: MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), //禁止滚动
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              // 上下间隔
              crossAxisSpacing: 5,
              //左右间隔
              padding: const EdgeInsets.all(10),
              // 总数
              itemCount: contentList.length,
              itemBuilder: (context, index) {
                return IndexItemWidget(
                  contentList[index],
                  index,
                  userController.getLike(contentList[index].id),
                  (index) {
                    bool status = userController.setLike(contentList[index].id);
                    status ? contentList[index].likes++ : contentList[index].likes--;
                    setState(() {});
                  },
                  false,
                  ApiType.topicHot,
                  "1",
                  isLoading: false,
                  () {},
                );
              },
            ),
          )),
          Positioned(
              bottom: 50,
              left: MediaQuery.of(context).size.width / 2 - 60,
              child: GestureDetector(
                onTap: () {
                  ///关闭登录验证
                  if (!userController.checkUserLogin()) {
                    Get.toNamed('/public/loginmethod');
                    return;
                  }
                  _publish();
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  width: 140,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular((30)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.25),
                        offset: Offset(0, 4),
                        blurRadius: 4,
                        spreadRadius: 0.5,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/publish/c.svg',
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        '立即发布'.tr,
                        style: const TextStyle(color: Colors.white, fontSize: 16,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }

  _publish() {
    Map<String, String> topicObject = {
      "name": _dataSource!.title,
      "id": _dataSource!.id.toString()
    };

    Get.bottomSheet(Container(
      color: Colors.white,
      child: Wrap(
        children: [
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-camera');
              Get.back();
              final AssetEntity? result = await CameraPicker.pickFromCamera(
                context,
                pickerConfig: CameraPickerConfig(
                    textDelegate: ArabCameraPickerTextDelegate(),
                    enableRecording: true,
                    shouldAutoPreviewVideo: true),
              );
              // 选择图片后跳转到发布页
              if (result != null) {
                Get.toNamed('/verify/publish', arguments: {"asset": result,"topic": topicObject});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '拍摄'.tr,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          GestureDetector(
            onTap: () async {
              AppLog('tap', event: 'publish-picker');
              Get.back();
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                pickerConfig: const AssetPickerConfig(
                    textDelegate: ArabicAssetPickerTextDelegate()),
              );
              // 选择图片后跳转到发布页
              if (result != null && result.isNotEmpty) {
                Get.toNamed('/verify/publish',
                    arguments: {"asset": result, "topic": topicObject});
              }
            },
            child: Container(
              height: 70,
              alignment: Alignment.center,
              color: Colors.white,
              child: Text(
                '从相册选择'.tr,
                style: TextStyle(fontSize: 17),
              ),
            ),
          ),
          Container(
            color: Colors.black12,
            height: 0.5,
          ),
          Container(
            color: Colors.black12,
            height: 8,
          ),
          GestureDetector(
            onTap: () async {
              Get.back();
            },
            child: Container(
              height: 70,
              color: Colors.white,
              child: Center(
                child: Text(
                  '取消'.tr,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  late int pageType;
  late Function callback;

  MyDelegate({required this.pageType, required this.callback});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 15, right: 15),
      alignment: Alignment.center,
      color: Colors.white,
      child: Container(
        height: 50,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Row(
            children: [
              Container(
                width: 60,
                child: GestureDetector(
                  onTap: () {
                    callback(1);
                  },
                  child: Text('最新'.tr,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              pageType == 1 ? FontWeight.w600 : FontWeight.w500,
                          color: pageType == 1 ? Colors.black : Colors.black38)),
                ),
              ),
              Container(
                width: 20,
              ),
              GestureDetector(
                onTap: () {
                  callback(2);
                },
                child: Text('最热'.tr,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            pageType == 2 ? FontWeight.w600 : FontWeight.w600,
                        color: pageType == 2 ? Colors.black : Colors.black38)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
