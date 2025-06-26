import 'dart:io';

class Items {
  final String id;
  final String name;
  final File? imagePath;
  final String? imageUrl;
  final String price;
  final String category;

  Items({required this.id, required this.name, required this.imagePath, required this.price, required this.category, required this.imageUrl});
}