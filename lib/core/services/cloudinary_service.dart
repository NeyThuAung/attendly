import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../../config/cloudinary_config.dart';

abstract interface class ICloudinaryService {
  Future<String?> uploadImage(String filePath);
}

@LazySingleton(as: ICloudinaryService)
class CloudinaryService implements ICloudinaryService {
  @override
  Future<String?> uploadImage(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return null;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(CloudinaryConfig.uploadUrl),
    );

    request.fields['upload_preset'] = CloudinaryConfig.uploadPreset;
    request.fields['folder'] = 'profile_images';
    request.files.add(await http.MultipartFile.fromPath('file', filePath));

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final jsonMap = jsonDecode(responseData);
      return jsonMap['secure_url'] as String?;
    } else {
      final responseData = await response.stream.bytesToString();
      throw Exception('Cloudinary upload failed (${response.statusCode}): $responseData');
    }
  }
}
