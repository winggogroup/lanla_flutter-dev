import 'package:logger/logger.dart';

const dynamic _tag = "dayuhaichuang";
/**
 * 直接使用 Logxx() 即可
 */
var _logger = Logger(
  printer: PrettyPrinter(
      methodCount: 2, // number of method calls to be displayed
      errorMethodCount: 8, // number of method calls if stacktrace is provided
      lineLength: 120, // width of the output
      colors: true, // Colorful log messages
      printEmojis: true, // Print an emoji for each log message
      printTime: false // Should each log print contain a timestamp
  ),
);

LogV(dynamic msg) {
  print(msg);
  _logger.v(msg);
}

LogD(dynamic msg) {
  _logger.d("$_tag :: $msg");
}

LogI(dynamic msg) {
  _logger.i("$_tag :: $msg");
}

LogW(dynamic msg) {
  _logger.w("$_tag :: $msg");
}

LogE(dynamic msg) {
  _logger.e("$_tag :: $msg");
}

LogWTF(dynamic msg) {
  _logger.wtf("$_tag :: $msg");
}
