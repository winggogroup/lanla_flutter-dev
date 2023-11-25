import 'package:flutter/material.dart';

Widget blackButton(String text, Function callback, {String type = "blank"}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      foregroundColor: type == "black" ? Colors.black : Colors.white,
      backgroundColor: type == "black" ? Colors.white : Colors.black87,
      surfaceTintColor: Colors.white,
      minimumSize: const Size(66, 28),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
    ),
    onPressed: () {
      callback();
    },
    child: Text(text),
  );
}

Widget TopicButton(String text,Function remove,{hideIcon = false}) {
  return Stack(children: [
    Positioned(
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
        margin: EdgeInsets.only(left:12,top:hideIcon ? 0 : 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular((20)),
            border: Border.all(width: 0.5)),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              child: Image.asset('assets/images/topic/topic_icon.png'),
            ),
            Text(text)
          ],
        ),
      ),
    ),
    if(!hideIcon)Positioned(
      top: 3,
      left: 8,
      child: GestureDetector(
        onTap: (){
          remove();
        },
        child: Container(
          width: 18,
          height: 18,
          child: Image.asset('assets/icons/publish/x.png'),
        ),
      ),
    )
  ]);
}
