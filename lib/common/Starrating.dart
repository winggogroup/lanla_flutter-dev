import 'package:flutter/material.dart';

/// 5星评分的展示的小组件 -- 支持不同数量的星星、颜色、大小等
class XMStartRating extends StatelessWidget {
  final int count; // 星星的数量，默认是5个
  final double rating; // 获得的分数
  final double totalRating; // 总分数
  final Color unSelectColor; // 未选中的颜色
  final Color selectColor; // 选中的颜色
  final double size; // 星星的大小
  final double spacing; // 星星间的间隙
  final bool showtext; // 星星间的间隙
  // 自定义构造函数
  const XMStartRating({
    required this.rating,
    required this.showtext,
    this.totalRating = 5,
    this.unSelectColor = Colors.blue,
    this.selectColor = Colors.red,
    this.size = 14,
    this.count = 5,
    this.spacing = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25,
      //alignment: Alignment.bottomCenter,
      child: Row(
        //mainAxisSize: MainAxisSize.min,
        children: [
          if(showtext)
            Container(height: 25, alignment: Alignment.bottomCenter,child: Text("${rating}",style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Color(0xff9BE400),height: 1.3),),),
          if(showtext)const SizedBox(width: 5,),
          Stack(
            children: [
              getUnSelectStarWidget(),
              getSelectStarWidget(),
            ],
          ),

        ],
      ),
    );
  }

  // 获取背景：未填充的星星
  List<Widget> _getUnSelectStars() {
    return List<Widget>.generate(count, (index) {
      return Icon(Icons.star_outline_rounded,size: size,color: const Color(0xffD9D9D9),);
    });
  }

  // 填充星星
  List<Widget> _getSelectStars() {
    return List<Widget>.generate(count, (index) {
      return Icon(Icons.star, size: size, color: const Color(0xFF9BE400),);
    });
  }

  // 获取背景星星的组件
  Widget getUnSelectStarWidget() {
    return  Wrap(
      spacing: spacing,
      alignment: WrapAlignment.spaceBetween,
      children: _getUnSelectStars(),
    );
  }

  // 获取针对整个选中的星星裁剪的组件
  Widget getSelectStarWidget() {
    // 应该展示几个星星 --- 例如：4.6个星星
    final double showStarCount = count * (rating/totalRating);
    final int fillStarCount = showStarCount.floor();// 满星的数量

    final double halfStarCount = showStarCount - fillStarCount; // 半星的数量
    // 最终需要裁剪的宽度
    final double clipWith = fillStarCount*(size + spacing) + halfStarCount*size;
    return ClipRect(
      clipper: XMStarClipper(clipWith),
      child: Container(
        child: Wrap(
          textDirection: TextDirection.ltr,
          spacing: spacing,
          //alignment: WrapAlignment.center,
          children: _getSelectStars(),
        ),
      ),
    );
  }
}
// 获取裁剪过的星星
class XMStarClipper extends CustomClipper<Rect> {
  double clipWidth;
  XMStarClipper(this.clipWidth);
  @override
  Rect getClip(Size size) {
    print('jianqie$clipWidth');
    return Rect.fromLTRB(size.width-clipWidth, 0, size.width, size.height);
    //return Rect.fromLTRB(0, 0, clipWidth, size.height);
  }
  @override
  bool shouldReclip(XMStarClipper oldClipper) {
    // TODO: implement shouldReclip
    return clipWidth != oldClipper.clipWidth;
  }
}