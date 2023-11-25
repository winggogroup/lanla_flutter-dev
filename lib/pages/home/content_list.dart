import 'package:flutter/cupertino.dart';

class ContentList extends StatelessWidget{
  ContentList(
    this.height,this.child
  );
  int height;
  Widget child;
  onInit(){
    print('重绘');
  }
  @override
  Widget build(BuildContext context) {
    return Container(height:height.toDouble(), child:const Text('text'));
  }
}