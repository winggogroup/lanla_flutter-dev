import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget ImageCacheWidget(String imagePath,height){
  return CachedNetworkImage(
    imageUrl: imagePath,
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        Container(
          width:  MediaQuery.of(context).size.width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(
              color: Color(0xffD1FF34),
              strokeWidth: 4,
            ),
          ),
        ),
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}