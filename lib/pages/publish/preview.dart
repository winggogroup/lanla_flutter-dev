
import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PublishPreviewPage extends StatefulWidget {
  late final FijkPlayer player;
  PublishPreviewPage(){
    player = FijkPlayer();
    player.setDataSource(Get.arguments,autoPlay: true);
  }
  @override
  _PublishPreviewPageState createState() => _PublishPreviewPageState();
}

class _PublishPreviewPageState extends State<PublishPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body:  FijkView(
        color: Colors.black,
        player: widget.player,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.player.pause();
    widget.player.release();
  }
}

