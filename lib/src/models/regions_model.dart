import 'dart:developer';

class WardModel {
  final String name;
  final String id;
  final String districtId;

  WardModel({
    required this.name,
    required this.id,
    required this.districtId,
  });

  factory WardModel.fromJson(Map<String, dynamic> data) {
    return WardModel(
        name: (data['name'] ?? '').toString(),
        id: (data['id'] ?? '').toString(),
        districtId: (data['district_id'] ?? '').toString());
  }
}

class DistrictModel {
  final String name;
  final String id;
  final String regionId;
  final List<WardModel> wards;

  DistrictModel({
    required this.name,
    required this.id,
    required this.regionId,
    required this.wards,
  });

  factory DistrictModel.fromJson(Map<String, dynamic> data) {
    final List list = data['wards'] as List;
    final List<WardModel> wards =
        list.map((e) => WardModel.fromJson(e as Map<String, dynamic>)).toList();
    return DistrictModel(
      name: (data['name'] ?? '').toString(),
      id: (data['id'] ?? '').toString(),
      regionId: (data['region_id'] ?? '').toString(),
      wards: wards,
    );
  }
}

class RegionModel {
  final String name;
  final int code;
  final String id;
  final List<DistrictModel> districts;

  RegionModel({
    required this.name,
    required this.districts,
    required this.code,
    required this.id,
  });

  factory RegionModel.fromJson(Map<String, dynamic> data) {
    final List list = data['districts'] as List;
    final List<DistrictModel> districts = list
        .map((e) => DistrictModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return RegionModel(
      name: (data['name'] ?? '').toString(),
      districts: districts,
      code: (data['code'] ?? 0) as int,
      id: (data['id'] ?? '').toString(),
    );
  }
}
