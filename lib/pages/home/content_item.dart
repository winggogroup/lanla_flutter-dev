import 'package:flutter/cupertino.dart';

import '../../models/category.dart';

/**
 * 首页瀑布流的内容组件
 */
class HomeContentItem extends StatelessWidget{
   int index;
   CategoryModel item;
   HomeContentItem(this.index, this.item, {super.key});

  @override
  Widget build(BuildContext context) {
    print(item.name);
    return SizedBox(height: (index % 5 + 1) * 200, child: Text('${item.id}+${item.name}'),);
  }

}