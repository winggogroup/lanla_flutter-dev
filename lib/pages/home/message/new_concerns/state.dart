class NewConcernsState {
  var Newconcernslist;
  var page;
  bool oneData = false; // 是否首次请求过-用于展示等待页面
  NewConcernsState() {
    ///Initialize variables
    Newconcernslist=[];
    page=1;
  }
}
