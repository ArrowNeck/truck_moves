import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<String?> compressFile(String path) async {
  final directory = await getTemporaryDirectory();
  String targetPath =
      '${directory.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';

  var result = await FlutterImageCompress.compressAndGetFile(
    path,
    targetPath,
    quality: 10,
  );
  return result?.path;
}
