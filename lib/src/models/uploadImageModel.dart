class UploadedImage {
  final String imagePath;
  final String imageUrl;

  UploadedImage({
    required this.imagePath,
    required this.imageUrl,
  });

  factory UploadedImage.fromJson(Map<String, dynamic> json) {
    return UploadedImage(
      imagePath: json['image_path'].toString(),
      imageUrl: json['image_url'].toString(),
    );
  }
}
