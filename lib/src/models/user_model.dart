class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.gender,
    required this.phone,
    required this.mrn,
    required this.profileImage,
    required this.status,
    required this.roleId,
    required this.createdAt,
    required this.updatedAt,
  });

  int? id;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  String? gender;
  String? phone;
  String? mrn;
  String? profileImage;
  String? status;
  int? roleId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory UserModel.fromMap(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        gender: json["gender"],
        phone: json["phone"],
        mrn: json["mrn"],
        profileImage: json["profile_image"],
        status: json["status"],
        roleId: json["role_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "gender": gender,
        "phone": phone,
        "mrn": mrn,
        "profile_image": profileImage,
        "status": status,
        "role_id": roleId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
