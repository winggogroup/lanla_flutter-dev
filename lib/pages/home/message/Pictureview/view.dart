import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/ulits/image_cache.dart';

class Pictureviewpage extends StatefulWidget{
  @override
  createState() => Pictureview();
}
class Pictureview extends State<Pictureviewpage>{
  List<String> imageList = [];
  @override
  void initState(){
    super.initState();
    imageList.add(Get.arguments);
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
      body: Container(
          alignment: Alignment.center,child:Stack(
        children: [
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 20,
            child:
            Center(
              child:_swiper(context, imageList),
            ),
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
        ],
      )
      ),
    );
  }
  ///轮播图
  Widget _swiper(BuildContext context, imageList, ) {

    bool isOne = imageList.length == 1 ? true : false;
    return ConstrainedBox(
        constraints: BoxConstraints.loose(Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height)),
        child: isOne
            ? ImageCacheWidget(imageList[0],MediaQuery.of(context).size.height)
            : Swiper(
          outer: true,
          itemBuilder: (c, i) {
            return CachedNetworkImage(imageUrl: imageList[i]);
            // return ImageCacheWidget(imageList[i]);
          },
          pagination: const SwiperPagination(
              margin: EdgeInsets.all(10),
              builder: DotSwiperPaginationBuilder(
                color: Colors.black12,
                activeColor: Colors.black,
                size: 5,
                activeSize: 6,
              )),
          itemCount: imageList.length,
        ));
  }
}