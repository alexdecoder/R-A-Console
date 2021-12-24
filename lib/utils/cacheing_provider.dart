import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ra_console/services/data_parser.dart';

class CacheingProvider {
  late String _documentRoot;
  final String _fileName = '/prevfetch.json';

  late File _localFile;

  Future<int> initialize() async {
    final Directory appDocumentRoot = await getApplicationDocumentsDirectory();
    _documentRoot = appDocumentRoot.path;

    _localFile = File(_documentRoot + _fileName);

    return 0;
  }

  Future<bool> cacheDoesExist() async {
    bool _buffer = await File(_documentRoot + _fileName).exists();
    return _buffer;
  }

  Future<int> readCacheToMemory() async {
    await DataParser.initializeDatasets(await _localFile.readAsString());
    return 0;
  }

  Future<int> writeCacheToDisk(String payload) async {
    await _localFile.writeAsString(payload);
    return 0;
  }
}
