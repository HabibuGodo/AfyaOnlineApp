class ItemsModel {
  ItemsModel({
    required this.id,
    required this.subcategoryId,
    required this.name,
    required this.price,
    required this.wardId,
    required this.street,
    required this.status,
    required this.type,
    required this.userId,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.ward,
    required this.subcategory,
    required this.images,
    required this.user,
  });

  int id;
  int subcategoryId;
  String name;
  String price;
  int wardId;
  String street;
  String status;
  String type;
  int userId;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  Ward ward;
  Subcategory subcategory;
  List<Images> images;
  User user;

  factory ItemsModel.fromMap(Map<String, dynamic> json) {
    final List list = (json['images'] ?? []) as List;

    final List<Images> images = list
        .map(
          (e) => Images.fromMap(e as Map<String, dynamic>),
        )
        .toList();
    return ItemsModel(
      id: json["id"],
      subcategoryId: json["subcategory_id"],
      name: json["name"],
      price: json["price"],
      wardId: json["ward_id"],
      street: json["street"],
      status: json["status"],
      type: json["type"],
      userId: json["user_id"],
      description: json["description"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
      ward: Ward.fromMap(json["ward"]),
      subcategory: Subcategory.fromMap(json["subcategory"]),
      images: images,
      user: User.fromMap(json["user"]),
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "subcategory_id": subcategoryId,
        "name": name,
        "price": price,
        "ward_id": wardId,
        "street": street,
        "status": status,
        "type": type,
        "user_id": userId,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "ward": ward.toMap(),
        "subcategory": subcategory.toMap(),
        "images": List<dynamic>.from(images.map((x) => x.toMap())),
        "user": user.toMap(),
      };
}

class Images {
  Images({
    required this.id,
    required this.productId,
    required this.userId,
    required this.status,
    required this.url,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int productId;
  int userId;
  String status;
  String url;
  String path;
  DateTime createdAt;
  DateTime updatedAt;

  factory Images.fromMap(Map<String, dynamic> json) => Images(
        id: json["id"],
        productId: json["product_id"],
        userId: json["user_id"],
        status: json["status"],
        url: json["url"],
        path: json["path"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "product_id": productId,
        "user_id": userId,
        "status": status,
        "url": url,
        "path": path,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Subcategory {
  Subcategory({
    required this.id,
    required this.name,
    required this.userId,
    required this.categoryId,
    required this.createdAt,
    required this.updatedAt,
    required this.category,
  });

  int id;
  String name;
  int userId;
  int categoryId;
  dynamic createdAt;
  dynamic updatedAt;
  CategoryModel category;

  factory Subcategory.fromMap(Map<String, dynamic> json) => Subcategory(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        categoryId: json["category_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        category: CategoryModel.fromMap(json["category"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "category_id": categoryId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "category": category.toMap(),
      };
}

class CategoryModel {
  CategoryModel({
    required this.id,
    required this.name,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  int userId;
  dynamic createdAt;
  dynamic updatedAt;

  factory CategoryModel.fromMap(Map<String, dynamic> json) => CategoryModel(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"] == null ? null : json["user_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "user_id": userId == null ? null : userId,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.username,
    required this.phone,
    required this.email,
    required this.status,
    required this.emailVerifiedAt,
    required this.role,
    required this.imagePath,
    required this.imageUrl,
    required this.idType,
    required this.idNo,
    required this.identity,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String username;
  String phone;
  String email;
  String status;
  dynamic emailVerifiedAt;
  String role;
  dynamic imagePath;
  dynamic imageUrl;
  dynamic idType;
  dynamic idNo;
  dynamic identity;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        email: json["email"],
        status: json["status"],
        emailVerifiedAt: json["email_verified_at"],
        role: json["role"],
        imagePath: json["image_path"],
        imageUrl: json["image_url"],
        idType: json["id_type"],
        idNo: json["id_no"],
        identity: json["identity"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "username": username,
        "phone": phone,
        "email": email,
        "status": status,
        "email_verified_at": emailVerifiedAt,
        "role": role,
        "image_path": imagePath,
        "image_url": imageUrl,
        "id_type": idType,
        "id_no": idNo,
        "identity": identity,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class Ward {
  Ward({
    required this.id,
    required this.districtId,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    required this.district,
  });

  int id;
  int districtId;
  String name;
  dynamic createdAt;
  dynamic updatedAt;
  District district;

  factory Ward.fromMap(Map<String, dynamic> json) => Ward(
        id: json["id"],
        districtId: json["district_id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        district: District.fromMap(json["district"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "district_id": districtId,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "district": district.toMap(),
      };
}

class District {
  District({
    required this.id,
    required this.name,
    required this.regionId,
    required this.createdAt,
    required this.updatedAt,
    required this.region,
  });

  int id;
  String name;
  int regionId;
  dynamic createdAt;
  dynamic updatedAt;
  CategoryModel region;

  factory District.fromMap(Map<String, dynamic> json) => District(
        id: json["id"],
        name: json["name"],
        regionId: json["region_id"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        region: CategoryModel.fromMap(json["region"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "region_id": regionId,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "region": region.toMap(),
      };
}
