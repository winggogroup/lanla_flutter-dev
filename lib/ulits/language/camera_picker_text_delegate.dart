import 'package:wechat_camera_picker/wechat_camera_picker.dart';

///阿拉伯
class ArabCameraPickerTextDelegate extends CameraPickerTextDelegate{
  const ArabCameraPickerTextDelegate();

  String get languageCode => 'ar';

  /// Confirm string for the confirm button.
  /// 确认按钮的字段
  String get confirm => 'تأكيد';

  /// Tips above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字
  String get shootingTips => 'انقر لألتقاط الصورة';

  /// Tips with recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（带录像）
  String get shootingWithRecordingTips => 'انقرلإلتقاط صورة ، واضغط مطولاً لالتقاط فيديو';

  /// Tips with only recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（仅录像）
  String get shootingOnlyRecordingTips => 'اضغط مطولاَ لإلتقاط الفيديو';

  /// Tips with tap recording above the shooting button before shooting.
  /// 拍摄前确认按钮上方的提示文字（点击录像）
  String get shootingTapRecordingTips => 'لمس الكاميرا';

  /// Load failed string for item.
  /// 资源加载失败时的字段
  String get loadFailed => 'فشل في التحميل';

  ///保存的提示字段
  String get saving => 'جاري الحفظ...';

  /// Semantics fields.
  ///
  /// Fields below are only for semantics usage. For customizable these fields,
  /// head over to [EnglishCameraPickerTextDelegate] for better understanding.
  String get sActionManuallyFocusHint => 'دليل التركيز';

  String get sActionPreviewHint => 'معاينة';

  String get sActionRecordHint => 'تصوير';

  String get sActionShootHint => 'تصوير';

  String get sActionShootingButtonTooltip => 'زر الإلتقاط';

  String get sActionStopRecordingHint => 'إيقاف التصوير';

  String sCameraLensDirectionLabel(CameraLensDirection value) {
    switch (value) {
      case CameraLensDirection.front:
        return 'أمامي';
      case CameraLensDirection.back:
        return 'خلفي';
      case CameraLensDirection.external:
        return 'خارجي';
    }
  }

  String? sCameraPreviewLabel(CameraLensDirection? value) {
    if (value == null) {
      return null;
    }
    return 'معاينة الشاشة${sCameraLensDirectionLabel(value)}';
  }

  String sFlashModeLabel(FlashMode mode) {
    final String modeString;
    switch (mode) {
      case FlashMode.off:
        modeString = 'إنهاء';
        break;
      case FlashMode.auto:
        modeString = 'تلقائي';
        break;
      case FlashMode.always:
        modeString = 'فلاش عند التقاط الصور';
        break;
      case FlashMode.torch:
        modeString = 'فلاش دائم';
        break;
    }
    return '$modeString:وضع الفلاش';
  }

  String sSwitchCameraLensDirectionLabel(CameraLensDirection value) {
    return ' كاميرا${sCameraLensDirectionLabel(value)}التبديل إلى';
  }
}