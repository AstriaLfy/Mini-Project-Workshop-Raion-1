import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final bool isLiked;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.imagePath,
    this.isLiked = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    String? imagePath,
    bool? isLiked,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [id, title, description, imagePath, isLiked];
}
