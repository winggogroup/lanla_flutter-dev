import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
class CardStack extends StatefulWidget {
  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  TCardController _controller = TCardController();
  List<String> cardData = [
    "Card 1",
    "Card 2",
    "Card 3",
    "Card 4",
    "Card 5",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Card Stack'),
      ),
      body: Container(
        color: Colors.cyan,
        child: TCard(
          lockYAxis:true,
          size:Size(MediaQuery.of(context).size.width, MediaQuery.of(context).size.width),
          cards: cardData.map((data) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(data, style: TextStyle(fontSize: 24.0)),
                    SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.thumb_down),
                          onPressed: () {
                            _controller.forward(direction: SwipDirection.Left);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.thumb_up),
                          onPressed: () {
                            _controller.forward(direction: SwipDirection.Right);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
          controller: _controller,
          onForward: (index, info) {
            // 当卡片被滑动时触发的回调
            if (info.direction == SwipDirection.Left) {
              print('Left swipe');
              // 执行左滑操作
            } else if (info.direction == SwipDirection.Right) {
              print('Right swipe');
              // 执行右滑操作
            }
          },
        ),
      ),
    );
  }
}
