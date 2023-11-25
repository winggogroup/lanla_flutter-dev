import 'dart:math';

getUUid() {
  String randomstr = Random().nextInt(10).toString();
  for (var i = 0; i < 3; i++) {
    var str = Random().nextInt(10);
    randomstr = "$randomstr$str";
  }
  var timenumber = DateTime.now().millisecondsSinceEpoch; //时间
  return "$randomstr$timenumber";
}
