class Subcategory2 {
  final String id;
  final String name;
  final String categoryId;

  Subcategory2({
    required this.id,
    required this.name,
    required this.categoryId,
  });

  factory Subcategory2.fromJson(Map<String, dynamic> data) {
    return Subcategory2(
        id: (data['id'] ?? '').toString(),
        name: (data['name'] ?? '').toString(),
        categoryId: (data['category_id'] ?? '').toString());
  }
}

class AllCategoryModel {
  final String id;
  final String name;
  final String categoryId;
  final List<Subcategory2> subcategories;

  AllCategoryModel(
      {required this.id,
      required this.name,
      required this.categoryId,
      required this.subcategories});

  factory AllCategoryModel.fromJson(Map<String, dynamic> data) {
    final List list = (data['subcategories'] ?? []) as List;
    final List<Subcategory2> subcategories = list
        .map(
          (e) => Subcategory2.fromJson(e as Map<String, dynamic>),
        )
        .toList();
    return AllCategoryModel(
      id: (data['id'] ?? '').toString(),
      name: (data['name'] ?? '').toString(),
      categoryId: (data['category_id'] ?? '').toString(),
      subcategories: subcategories,
    );
  }
}
