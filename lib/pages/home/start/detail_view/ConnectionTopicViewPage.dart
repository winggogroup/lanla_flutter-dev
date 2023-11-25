import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lanla_flutter/pages/home/start/detail_view/view.dart';

import 'Topicxqpage.dart';

class ConnectionTopicPage extends StatefulWidget {
  const ConnectionTopicPage({Key? key}) : super(key: key);

  @override
  State<ConnectionTopicPage> createState() => _ConnectionTopicPageState();
}

class _ConnectionTopicPageState extends State<ConnectionTopicPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("话题".tr, style: const TextStyle(
            fontSize: 20)),
      ),
      body: Center(
          child: TopicxqpagePage()),
    );
  }
}
