// 1. compress file and get Uint8List
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

Future<File> CompressImageFile(File file) async {
  final fileLast = file.path.split(".").last;
  Directory dir = await getTemporaryDirectory();
  print(fileLast);
  var result = await FlutterImageCompress.compressAndGetFile(
    file.absolute.path, dir.path +"/"+"yasuo."+fileLast,
    format: fileLast == 'png' ? CompressFormat.png : CompressFormat.jpeg,
    minHeight: 1000,
    minWidth: 800,
    quality: 90,
  );
  if(result == null){
    return file;
  }
  return result;
}

