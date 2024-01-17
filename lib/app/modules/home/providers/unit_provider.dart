import 'package:get/get.dart';

import '../../../data/models/unit_model.dart';

class UnitProvider extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Unit.fromJson(map);
      if (map is List) return map.map((item) => Unit.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<Unit?> getUnit(int id) async {
    final response = await get('unit/$id');
    return response.body;
  }

  Future<Response<Unit>> postUnit(Unit unit) async => await post('unit', unit);
  Future<Response> deleteUnit(int id) async => await delete('unit/$id');
}
