import 'package:dio/dio.dart';

class PutRequestOption {
  final String? bucketName;
  final ProgressCallback? onSendProgress;
  final ProgressCallback? onReceiveProgress;
  //final AclMode? aclModel;
  final bool? override;
  //final StorageType? storageType;
  final Map<String, dynamic>? headers;

  const PutRequestOption({
    this.bucketName,
    this.onSendProgress,
    this.onReceiveProgress,
    //this.aclModel,
    this.override,
    //this.storageType,
    this.headers,
  });
}


