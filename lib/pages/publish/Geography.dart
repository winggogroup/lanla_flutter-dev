import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:lanla_flutter/common/widgets/button_black.dart';
import 'package:lanla_flutter/models/positionlist.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/publish/Longgraphictext.dart';
import 'package:lanla_flutter/services/positioninformation.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:lanla_flutter/ulits/toast.dart';

import 'logic.dart';

class GeographylistPage extends StatefulWidget {
  @override
  _GeographylistState createState() => _GeographylistState();
}

enum searchStatus { defalut, search, loading }

class _GeographylistState extends State<GeographylistPage> {
  final logic = Get.put(PublishLogic());
  final logictwo = Get.put(LonggraphictextLogic());
  final FocusNode _searchFocus = FocusNode();
  final provider = Get.put(positioninformation());
  String _searchText = "";
  bool _searchdata = false;
  searchStatus status = searchStatus.defalut;
  List<Object> _positionList = []; // 热门话题
  List<Object> _searchList = []; // 搜索话题
  late var _selectList = {};
  bool loading = false;

  @override
  void initState() {
    _getposition();
     _selectList=logic.state.positioninformation;
    super.initState();
  }

  /// 获取位置信息
  _getposition() async {
    setState(() {
      loading = true;
    });
    _positionList = await provider.getLocationList('');
    setState(() {
      loading = false;
    });
    print('位置接口');
    print(_positionList);
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(focusNode: _searchFocus, toolbarButtons: [
              (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.close),
              ),
            );
          }
        ]),
      ],
    );
  }

  ///搜索
  _search() async {
    // if (_searchText == "") {
    //   setState(() {
    //     _searchList = [];
    //   });
    //   return;
    // }
    // setState(() {
    //   loading = false;
    // });
    if(loading){
      return;
    };
    _searchList = await provider.getLocationList(_searchText);
    setState(() {
      _searchdata=true;
      loading = false;
    });
    print(_searchText);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // IconButton(
            //     color: Colors.black,
            //     icon: Icon(Icons.arrow_back_ios),
            //     tooltip: "Search",
            //     onPressed: () {
            //       //print('menu Pressed');
            //       Navigator.of(context).pop();
            //     }),
            GestureDetector(child: Container(
              width: 19,
              height: 22,
              child: SvgPicture.asset(
                "assets/svg/youjiantou.svg",
              ),
            ), onTap: (){
              Get.back();
            },),
            Expanded(
                child: Center(
                  child: Text(
                    '添加地址'.tr,
                    style: const TextStyle(fontSize: 20),
                  ),
                )),
            Container(
              width: 19,
            ),
          ],
        ),
      ),
      body: KeyboardActions(
        config: _buildConfig(context),
        child: Container(
          height: 500,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 15,bottom: 10),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: TextField(
                              focusNode: _searchFocus,
                              decoration: InputDecoration(
                                hintStyle:
                                const TextStyle(color: Color(0xff999999)),
                                contentPadding:
                                const EdgeInsets.only(top: 0, bottom: 0),
                                border: const OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                    borderSide: BorderSide.none),
                                hintText: '输入搜索内容'.tr,
                                fillColor: Color(0x07000000),
                                filled: true,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 12, bottom: 12, right: 5),
                                  child: SvgPicture.asset(
                                    'assets/icons/sousuo.svg',
                                    color: const Color(0xff999999),
                                  ),
                                ),
                              ),
                              onChanged: (v) {
                                _searchText = v;
                              },
                              onSubmitted: (value) {
                                print('445566');
                                _search();
                              }),
                        )),
                    GestureDetector(child: Container(
                      margin: EdgeInsets.only(left: 15),
                      child: Text('搜索'.tr,style: TextStyle(
                          fontSize: 15,color: Color(0xff666666)
                      ),),
                    ),onTap: (){
                      _search();
                    },)
                  ],
                ),
              ),
              // Container(
              //   color: Colors.red,
              //   width: double.infinity,
              //   padding: const EdgeInsets.only(
              //       top: 10, bottom: 10, left: 15, right: 15),
              //   child: SingleChildScrollView(
              //     scrollDirection: Axis.horizontal,
              //     child: Row(
              //       children: _selectList.reversed.map((e) {
              //         return TopicButton(e['name']!, () {
              //           _removeTopic(e["id"]!);
              //         });
              //       }).toList(),
              //     ),
              //   ),
              // ),
              Expanded(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SingleChildScrollView(
                    child: _listWidget(),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _listWidget() {
    if (loading) {
      return const Center(
        child: Text('loading'),
      );
    }
    if (_searchdata) {
      return _ssList();
    }
    return SingleChildScrollView(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _positionList.length>0?Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(bottom:BorderSide(width: 1,color: Color(0xfff1f1f1)))
              ),
              //margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                '不显示位置'.tr,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ):Container(alignment: Alignment.center,child: Text("没有更多数据".tr,style: TextStyle(color: Color(0xff999999),fontSize: 16),),width: double.infinity,),
            ..._positionList.map((e) => _listItemWidget(e)).toList(),
          ],
        ),
      ),
    );
  }

  _ssList() {
    return SingleChildScrollView(
      child: Container(
        // color: Colors.red,
        padding: EdgeInsets.fromLTRB(15, 8, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _searchList.length>0?Container(
              padding: const EdgeInsets.only(bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                  border: Border(bottom:BorderSide(width: 1,color: Color(0xfff1f1f1)))
              ),
              //margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                '不显示位置'.tr,
                style:
                const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
              ),
            ):Container(alignment: Alignment.center,child: Text("没有更多数据".tr,style: TextStyle(color: Color(0xff999999),fontSize: 16),),width: double.infinity,),
            if(_searchList.length>0)..._searchList.map((e) => _listItemWidget(e)).toList(),
          ],
        ),
      ),
    );
  }

  _listItemWidget( item) {
    return GestureDetector(
      onTap: () {
        _addTopic(item.placeId, item.name);
      },
      child: Container(
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Container(
          //   child: Image.asset('assets/images/topic/topic_icon.png', height: 20,width:20,),
          // ),
          Expanded(child:Column(
              crossAxisAlignment:CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 5,),
                Text(
                  item.vicinity,
                  // overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12,color: Color(0xff999999)),
                ),
              ]
          ),),

          ///对钩
          _selectList["placeId"]==item.placeId?Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 20,
            height: 20,
            child: SvgPicture.asset(
              "assets/svg/duigou.svg",
              color: Colors.black,
            ),
          ):Container(
            margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
            width: 20,
            height: 20,
          )
        ],
      ),padding: EdgeInsets.fromLTRB(8, 15, 8, 15),
        decoration: BoxDecoration(
          border: Border(bottom:BorderSide(width: 1,color: Color(0xfff1f1f1)))
        ),
      ),
      
    );
  }

  _addTopic(String id, String name) {
      if (_selectList["placeId"] == id) {
        // ToastInfo("已经选择".tr);
        return;
      }
    _selectList={"name": name, "placeId": id};
    setState(() {});
      logic.state.positioninformation = _selectList;
      logic.update();
      logictwo.state.positioninformation = _selectList;
      logictwo.update();
      Get.back();
  }

  ///
  // _removeTopic(String id) {
  //   int index = -1;
  //   int number = 0;
  //   for (var key in _selectList) {
  //     if (key["id"] == id) {
  //       index = number;
  //     }
  //     number++;
  //   }
  //   if (index != -1) {
  //     _selectList.removeAt(index);
  //   }
  //   setState(() {});
  // }

  // _created(String title) async {
  //   String newId = await provider.getCreated(title);
  //   if(newId == ""){
  //     ToastInfo("已经存在话题".tr);
  //     return ;
  //   }
  //   _addTopic(int.parse(newId), title);
  //   _search();
  // }
}
