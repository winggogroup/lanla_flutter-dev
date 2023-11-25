import 'package:fijkplayer/fijkplayer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

class Videoplaybackpage extends StatefulWidget{
  @override
  createState() => Videoplayback();
}
class Videoplayback extends State<Videoplaybackpage>{
  //final FijkPlayer player = FijkPlayer();
  late VideoPlayerController _controller;
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        Get.arguments)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
          preferredSize: Size.zero,
          child: AppBar(
            backgroundColor: Colors.black,
            elevation: 0,
          )),
      body: Container(alignment: Alignment.center,child:
      Stack(children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 20,
          child:
          GestureDetector(child: Center(
            child:
            _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : Container(),
          ),onTap: (){
            setState(() {
              _controller.value.isPlaying
                  ? _controller.pause()
                  : _controller.play();
            });
          },),
        ),
        Positioned(
          top: 20,
          right: 20,
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Container(
                width: 20,
                height: 20,
                child: SvgPicture.asset(
                  "assets/svg/cha.svg",
                  color: Colors.white,
              ),
            ),
          ),
        ),
        !_controller.value.isPlaying
            ?  Positioned(
            top: 10,
            right: 10,
            left: 10,
            bottom: 10,
            child: GestureDetector(child: Icon(
              Icons.play_circle_outline,
              size: 120,
              color: Colors.white54,
            ),onTap: (){
              setState(() {
                _controller.value.isPlaying
                    ? _controller.pause()
                    : _controller.play();
              });
            },))
            : Container()
      ],)
        ,),
    );
  }
}