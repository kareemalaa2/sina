import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class ImagePickerHelper {
  factory ImagePickerHelper() => _instance;
   ImagePickerHelper._();
  static  ImagePickerHelper _instance = ImagePickerHelper._();
  
  final _logger = Logger();
  final _picker = ImagePicker();

  /// اختيار صورة واحدة من المعرض (بدون أذونات)
  Future<XFile?> pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(
        source: ImageSource.gallery,
        requestFullMetadata: false, // مهم جداً: لا تطلب بيانات وصفية كاملة
        maxWidth: 1920, // اختياري: لتقليل حجم الصورة
        maxHeight: 1920,
        imageQuality: 85, // اختياري: جودة الصورة (0-100)
      );
      
      return pickedImage;
    } catch (e) {
      _logger.e('Error picking image: $e');
      return null;
    }
  }

  /// اختيار عدة صور من المعرض
  Future<List<XFile>> pickMultipleImages({int? limit}) async {
    try {
      final pickedImages = await _picker.pickMultiImage(
        requestFullMetadata: false,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        limit: limit, // اختياري: حد أقصى لعدد الصور
      );
      
      return pickedImages;
    } catch (e) {
      _logger.e('Error picking multiple images: $e');
      return [];
    }
  }

  /// التقاط صورة بالكاميرا
  Future<XFile?> captureImage() async {
    try {
      final capturedImage = await _picker.pickImage(
        source: ImageSource.camera,
        requestFullMetadata: false,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        preferredCameraDevice: CameraDevice.rear, // الكاميرا الخلفية
      );
      
      return capturedImage;
    } catch (e) {
      _logger.e('Error capturing image: $e');
      return null;
    }
  }

  /// اختيار فيديو من المعرض
  Future<XFile?> pickVideo({Duration? maxDuration}) async {
    try {
      final pickedVideo = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: maxDuration ?? const Duration(minutes: 5),
      );
      
      return pickedVideo;
    } catch (e) {
      _logger.e('Error picking video: $e');
      return null;
    }
  }

  /// تسجيل فيديو بالكاميرا
  Future<XFile?> recordVideo({Duration? maxDuration}) async {
    try {
      final recordedVideo = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration ?? const Duration(minutes: 5),
        preferredCameraDevice: CameraDevice.rear,
      );
      
      return recordedVideo;
    } catch (e) {
      _logger.e('Error recording video: $e');
      return null;
    }
  }

  /// اختيار صورة أو فيديو (الاثنين معاً)
  Future<XFile?> pickMedia() async {
    try {
      final pickedMedia = await _picker.pickMedia(
        requestFullMetadata: false,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      return pickedMedia;
    } catch (e) {
      _logger.e('Error picking media: $e');
      return null;
    }
  }

  /// اختيار عدة صور/فيديوهات
  Future<List<XFile>> pickMultipleMedia({int? limit}) async {
    try {
      final pickedMediaList = await _picker.pickMultipleMedia(
        requestFullMetadata: false,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
        limit: limit,
      );
      
      return pickedMediaList;
    } catch (e) {
      _logger.e('Error picking multiple media: $e');
      return [];
    }
  }
}