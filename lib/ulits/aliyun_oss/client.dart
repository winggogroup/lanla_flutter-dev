import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lanla_flutter/ulits/log_util.dart';

import 'asset_entity.dart';
import 'auth.dart';
import 'dio_client.dart';
import 'encrypt.dart';
import 'request.dart';
import 'package:mime_type/mime_type.dart';

class AliOssClient {
  static AliOssClient? _instance;

  factory AliOssClient() => _instance!;

  final String endpoint;
  final String bucketName;
  final Future<String> Function() tokenGetter;

  AliOssClient._(
    this.endpoint,
    this.bucketName,
    this.tokenGetter,
  );

  static void init(
      {String? stsUrl,
      required String ossEndpoint,
      required String bucketName,
      Future<String> Function()? tokenGetter}) {
    assert(stsUrl != null || tokenGetter != null);
    final tokenGet = tokenGetter ??
        () async {
          final response = await RestClient.getInstance().post<String>(stsUrl!);
          return response.data!;
        };

    _instance = AliOssClient._(ossEndpoint, bucketName, tokenGet);
  }

  Auth? _auth;
  String? _expire;

  /// get auth information from sts server
  Future<Auth> _getAuth() async {
    if (_isNotAuthenticated()) {
      final resp = await tokenGetter();
      final respMap = jsonDecode(resp.toString());
      print('获取口令');
      _auth = Auth(respMap['AccessKeyId'], respMap['AccessKeySecret'],
          respMap['SecurityToken']);
      _expire = respMap['Expiration'];
    }
    return _auth!;
  }

  /// get object(file) from oss server
  /// [fileKey] is the object name from oss
  /// [bucketName] is optional, we use the default bucketName as we defined in Client
  Future<Response<dynamic>> getObject(String fileKey,
      {String? bucketName}) async {
    final String bucket = bucketName ?? this.bucketName;
    final Auth auth = await _getAuth();

    final String url = "https://$bucket.$endpoint/$fileKey";
    final HttpRequest request = HttpRequest(url, 'GET', {}, {});
    auth.sign(request, bucket, fileKey);

    return RestClient.getInstance()
        .get(request.url, options: Options(headers: request.headers));
  }

  /// download object(file) from oss server
  /// [fileKey] is the object name from oss
  /// [savePath] is where we save the object(file) that download from oss server
  /// [bucketName] is optional, we use the default bucketName as we defined in Client
  Future<Response> downloadObject(String fileKey, String savePath,
      {String? bucketName}) async {
    final String bucket = bucketName ?? this.bucketName;
    final Auth auth = await _getAuth();

    final String url = "https://$bucket.$endpoint/$fileKey";
    final HttpRequest request = HttpRequest(url, 'GET', {}, {});
    auth.sign(request, bucket, fileKey);

    return await RestClient.getInstance().download(request.url, savePath,
        options: Options(headers: request.headers));
  }

  /// upload object(file) to oss server
  /// [fileData] is the binary data that will send to oss server
  /// [bucketName] is optional, we use the default bucketName as we defined in Client
  Future<String> putObject(String path, String dir, String fileKey,
      {String? bucketName}) async {
    final String bucket = bucketName ?? this.bucketName;
    final Auth auth = await _getAuth();

    final Map<String, String> headers = {
      //'content-md5': EncryptUtil.md5File(fileData),
      'content-type': mime(path) ?? "image/png",
    };
    final fileLast = path.split(".").last;

    final String url = "https://$bucket.$endpoint/user/$dir/$fileKey.$fileLast";
    final HttpRequest request = HttpRequest(url, 'PUT', {}, headers);
    auth.sign(request, bucket, 'user/$dir/$fileKey.$fileLast');
    Response respons = await RestClient.getInstance().put(
      request.url,
      data: File(
        path,
      ).openRead(),
      options: Options(headers: request.headers),
      onSendProgress: (int sent, int total) {
        LogV(
            'progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
      },
    );
    // TODO , 这里应该上报错误
    return respons.statusCode == 200 ? url : '';
  }




  /// 压缩图片并上传
  Future<String> putCompressObject(String path, Uint8List obj, String dir, String fileKey,
      {String? bucketName}) async {
    final String bucket = bucketName ?? this.bucketName;
    final Auth auth = await _getAuth();

    final Map<String, String> headers = {
      //'content-md5': EncryptUtil.md5File(fileData),
      'content-type': mime(path) ?? "image/png",
    };
    final fileLast = path.split(".").last;

    final String url = "https://$bucket.$endpoint/user/$dir/$fileKey.$fileLast";
    final HttpRequest request = HttpRequest(url, 'PUT', {}, headers);
    auth.sign(request, bucket, 'user/$dir/$fileKey.$fileLast');
    Response respons = await RestClient.getInstance().put(
      request.url,
      data: obj,
      options: Options(headers: request.headers),
      onSendProgress: (int sent, int total) {
        LogV(
            'progress: ${(sent / total * 100).toStringAsFixed(0)}% ($sent/$total)');
      },
    );
    // TODO , 这里应该上报错误
    return respons.statusCode == 200 ? url : '';
  }



  /// 通过路径上传文件
  /// tangbing
  Future<Response<dynamic>?> putObjectFromPath(String filePath, String fileKey,
      {String? bucketName}) async {
    final Auth auth = await _getAuth();
    final String bucket = bucketName ?? this.bucketName;
    final String url = "https://$bucket.$endpoint/$fileKey";
    final Dio request = Dio();

    return null;
  }

  /// delete object from oss
  Future<Response<dynamic>> deleteObject(String fileKey,
      {String? bucketName}) async {
    final String bucket = bucketName ?? this.bucketName;
    final Auth auth = await _getAuth();

    final String url = "https://$bucket.$endpoint/$fileKey";
    final HttpRequest request = HttpRequest(
        url, 'DELETE', {}, {'content-type': Headers.jsonContentType});
    auth.sign(request, bucket, fileKey);

    return RestClient.getInstance()
        .delete(request.url, options: Options(headers: request.headers));
  }

  /// delete objects from oss
  Future<List<Response<dynamic>>> deleteObjects(List<String> keys,
      {String? bucketName}) async {
    final deletes = keys
        .map((fileKey) async =>
            await deleteObject(fileKey, bucketName: bucketName))
        .toList();
    return await Future.wait(deletes);
  }

  /// whether auth is valid or not
  bool _isNotAuthenticated() {
    return _auth == null || _isExpired();
  }

  /// whether the auth is expired or not
  bool _isExpired() {
    return _expire == null || DateTime.now().isAfter(DateTime.parse(_expire!));
  }
}
