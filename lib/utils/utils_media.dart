
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


Future<void> downloadFile(String url, String fileName) async {
  final response = await http.get(Uri.parse(url));
  final bytes = response.bodyBytes;

  final dir = await getApplicationDocumentsDirectory();

  final file = File('${dir.path}/$fileName');

  await file.writeAsBytes(bytes);

  print('File downloaded and saved: ${file.path}');
}
