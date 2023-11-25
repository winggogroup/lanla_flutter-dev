import 'package:get/get.dart';
import 'package:lanla_flutter/models/comment_child.dart';
import 'package:lanla_flutter/services/comment.dart';
import 'package:lanla_flutter/ulits/toast.dart';

import 'package:lanla_flutter/models/comment_parent.dart';
import 'state.dart';

class CommentLogic extends GetxController {
  final CommentState state = CommentState();
  final provider = Get.put<CommentProvider>(CommentProvider());
  int contentId = 0;
  late String text = '';
  late var goodsList=[];
  late var topics=[];
  List<CommentParent> parentDataSource = [];

  // 是否结束
  bool isMore = false;
  bool isEmpyt = false;
  bool isLoding = false;
  bool antishake = true;

  // 请求数据
  // init() {
  //   print('初始化评论${contentId}');
  //   parentDataSource = [];
  //   isMore = false;
  //   isEmpyt = false;
  //   isLoding = false;
  //   fetch(1);
  // }
  // onInit() {
  //
  // }

  Interfacerequest(){
    print("1111");
    print('初始化评论${contentId}');
    parentDataSource = [];
    isMore = false;
    isEmpyt = false;
    isLoding = false;
    fetch(1);
  }


  fetch(int page) async {

    if(antishake){
      antishake = false;
      update();
      // 抓取评论数据
      isLoding = true;
      update();
      Response result = await provider.getParent(contentId, page);
      isLoding = false;
      if (result.statusCode != 200 || result.bodyString == null) {
        ToastInfo('请求评论出错'.tr);
        return;
      }
      List<CommentParent> res = commentParentFromJson(result.bodyString!);
      if (parentDataSource.length == 0 && res.length == 0) {
        isEmpyt = true;
      }
      isMore = !(res.length < 10);


      if(page==1){
        parentDataSource=res;
      }else{
        parentDataSource.addAll(res);
      }
      antishake=true;
      update();
    }

  }

  /// 添加一个主评论,
  /// 用于主评论发布成功后的回调
  newParent(CommentParent data) {
    parentDataSource.insert(0, data);
    update();
  }

  /// 添加一个子评论
  newChild(CommentChild data, int index, int parentIndex) {
    print(parentIndex);
    print('a:${parentDataSource[parentIndex].children.length}');
    parentDataSource[parentIndex]
        .children
        .insert(index == 0 ? 0 : index + 1, data);
    print('b:${parentDataSource[parentIndex].children.length}');
    update();
  }

  removeData(index){
    provider.del(parentDataSource[index].id);
    parentDataSource.removeAt(index);
    update();
  }


  removeChildData(pindex, index){
    provider.del(parentDataSource[pindex].children[index].id);
    parentDataSource[pindex].children.removeAt(index);
    update();
  }
}
