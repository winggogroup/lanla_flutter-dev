import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class KeyboardScrollDemo extends StatefulWidget {
  @override
  _KeyboardScrollDemoState createState() => _KeyboardScrollDemoState();
}

class _KeyboardScrollDemoState extends State<KeyboardScrollDemo>
    with WidgetsBindingObserver {
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
   // _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    // _scrollController.removeListener(_scrollListener);
    _textController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // void _scrollListener() {
  //   if (_scrollController.offset >=
  //       _scrollController.position.maxScrollExtent - 50) {
  //     // Scroll to bottom of page
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   }
  // }

  // @override
  // void didChangeMetrics() {
  //   super.didChangeMetrics();
  //   final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
  //   if (keyboardHeight == 0) return; // Keyboard closed
  //   _scrollController.animateTo(
  //     _scrollController.position.maxScrollExtent,
  //     duration: Duration(milliseconds: 300),
  //     curve: Curves.easeOut,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Keyboard Scroll Demo'),
      ),
      body: Container(color: Colors.white, child:
      // KeyboardActions(config: KeyboardActionsConfig(
      //     keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      //     keyboardBarColor: Colors.white,
      //     nextFocus: true,
      //     defaultDoneWidget: Text("完成"),
      //     actions: [
      //
      //     ]),
      // child:
      // )

        SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [

              TextField(
                controller: _textController,
                decoration: const InputDecoration(
                  hintText: 'Enter some text',
                ),
              ),
              // TextField(
              //   controller: _textController,
              //   decoration: InputDecoration(
              //     hintText: 'Enter some more text',
              //   ),
              // ),
              GestureDetector(child: const Text('12222'),onTap: (){
                final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
                if (keyboardHeight == 0) return; // Keyboard closed
                _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                );
              },),
              const SizedBox(height: 800,),
              const Text('1223333333'),
              // Add more text fields as needed
            ],
          ),
        ),
      )
      )
      ,
    );
  }
}
