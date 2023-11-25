import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:lanla_flutter/common/widgets/button_black.dart';
import 'package:lanla_flutter/models/topic.dart';
import 'package:lanla_flutter/pages/publish/Longgraphictext.dart';
import 'package:lanla_flutter/services/topic.dart';
import 'package:lanla_flutter/ulits/toast.dart';

import 'logic.dart';

class PublishTopicPage extends StatefulWidget {
  @override
  _PublishTopicState createState() => _PublishTopicState();
}

enum searchStatus { defalut, search, loading }

class _PublishTopicState extends State<PublishTopicPage> {
  final logic = Get.put(PublishLogic());
  final logictwo = Get.put(LonggraphictextLogic());
  final FocusNode _searchFocus = FocusNode();
  final provider = Get.put(TopicProvider());
  String _searchText = "";
  searchStatus status = searchStatus.defalut;
  List<TopicModel> _hotList = []; // 热门话题
  List<TopicModel> _searchList = []; // 搜索话题
  final List<Map<String, String>> _selectList = [];
  bool loading = false;

  @override
  void initState() {
    _getHot();
    _selectList.addAll(logic.state.selectTopic);
    super.initState();
  }

  /// 获取热门
  _getHot() async {
    setState(() {
      loading = true;
    });
    _hotList = await provider.getHotList();
    setState(() {
      loading = false;
    });
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

  _search() async {
    if (_searchText == "") {
      setState(() {
        _searchList = [];
      });
      return;
    }
    setState(() {
      loading = false;
    });
    _searchList = await provider.getSearchList(_searchText);
    setState(() {
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
            blackButton("保存".tr, () {
              logic.state.selectTopic = _selectList;
              logictwo.state.selectTopic = _selectList;
              logictwo.update();
              logic.update();
              Get.back();
            }),
            Expanded(
                child: Center(
              child: Text(
                '添加话题'.tr,
                style: const TextStyle(fontSize: 20),
              ),
            )),
            Container(
              width: 50,
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
                margin: const EdgeInsets.only(top: 15),
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
                            fillColor: const Color(0x07000000),
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
                            _search();
                          }),
                    )),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                    top: 20, bottom: 20, left: 10, right: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _selectList.reversed.map((e) {
                      return TopicButton(e['name']!, () {
                        _removeTopic(e["id"]!);
                      });
                    }).toList(),
                  ),
                ),
              ),
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
    if (_searchList.isNotEmpty) {
      return _hostList();
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                '热门话题'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            ..._hotList.map((e) => _listItemWidget(e)).toList(),
          ],
        ),
      ),
    );
  }

  _hostList() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Text(
                '热门话题'.tr,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            ..._searchList.map((e) => _listItemWidget(e)).toList(),
          ],
        ),
      ),
    );
  }

  _listItemWidget(TopicModel item) {
    return GestureDetector(
      onTap: () {
        _addTopic(item.id, item.title);
      },
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Image.asset('assets/images/jinghao.png', height: 20,width:20,),
              ),
              const SizedBox(width: 5,),
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              item.id == 0 ? GestureDetector(
                onTap: () {
                  _created(item.title);
                },
                child: Container(
                  child: Text(
                    '立即创建'.tr,
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ) : Container()
            ],
          ),
          Row(
            children: [
              Text(
                item.visits,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              ),
              Container(
                width: 5,
              ),
              Text(
                '浏览量'.tr,
                style: const TextStyle(color: Colors.black54, fontSize: 16),
              )
            ],
          ),
          const Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15),
            child: Divider(
              height: 1.0,
              color: Color(0xffF1F1F1),
            ),
          ),
        ],
      ),
    );
  }

  _addTopic(int id, String name) {
    for (var key in _selectList) {
      if (key["id"] == id.toString()) {
        ToastInfo("已经选择".tr);
        return;
      }
    }
    _selectList.add({"name": name, "id": id.toString()});
    setState(() {});
  }

  ///
  _removeTopic(String id) {
    int index = -1;
    int number = 0;
    for (var key in _selectList) {
      if (key["id"] == id) {
        index = number;
      }
      number++;
    }
    if (index != -1) {
      _selectList.removeAt(index);
    }
    setState(() {});
  }

  _created(String title) async {
    String newId = await provider.getCreated(title);
    if(newId == ""){
      ToastInfo("已经存在话题".tr);
      return ;
    }
    _addTopic(int.parse(newId), title);
    _search();
  }
}
