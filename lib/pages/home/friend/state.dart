import 'package:get/get.dart';
import 'package:lanla_flutter/models/HomeItem.dart';

class FriendState {
  var page;

  late var followlist=[];

  int Initialselection=0;
  FriendState() {
    ///Initialize variables
    page=0.obs;
    Initialselection=0;
  }
}
