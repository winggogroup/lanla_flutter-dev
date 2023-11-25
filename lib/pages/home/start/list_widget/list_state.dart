import 'package:flutter/material.dart';
import 'package:lanla_flutter/models/ChannelList.dart';

class StartListState {
  late TabController channelTabController;
  List<ChannelList> channelDataSource = [];
  var switchlist = [0];
  var newchannel;
}