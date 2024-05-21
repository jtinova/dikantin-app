import 'package:get/get.dart';

import '../../../data/models/version_model.dart';

class VersionProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Version.fromJson(map);
      if (map is List)
        return map.map((item) => Version.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Version?> getVersion(int id) async {
    final response = await get('version/$id');
    return response.body;
  }

  Future<Response<Version>> postVersion(Version version) async =>
      await post('version', version);
  Future<Response> deleteVersion(int id) async => await delete('version/$id');
}
