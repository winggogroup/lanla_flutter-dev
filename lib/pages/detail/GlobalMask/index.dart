import 'package:flutter/material.dart';

class TransparentOverlay extends StatelessWidget {
  final bool visible;
  final VoidCallback onClose;

  const TransparentOverlay({
    required this.visible,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    print('打开透明弹窗');
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onClose,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0),
          // color: Colors.red,
        ),
      ),
    );
  }
}
