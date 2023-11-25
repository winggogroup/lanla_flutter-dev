import 'package:event_bus/event_bus.dart';
// 创建全局事件，其他组件使用
// 发送一个事件，比如通知其他组件刷新一下首页的瀑布流:
// eventBus.fire(UpdateHomeItemList());
// 在瀑布流接收：
// eventBus.on<UpdateHomeItemList>().listen((event) {
//   setState({});
// });
EventBus eventBus = EventBus();

/// 发送内容成功消息
class PublishEvent {
  PublishEvent();
}

/// 刷新一下内容列表
class UploadContentListEvent {
  UploadContentListEvent();
}

/// 停止播放
class VideoStop {
  VideoStop();
}

class UpdateHomeItemList{
  bool status;  // true为增加一个，false为减少一个
  int contentId;
  UpdateHomeItemList(this.status,this.contentId);
}