import 'package:equatable/equatable.dart';
import '../models/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];
}

class ProductLoadingState extends ProductState {
  const ProductLoadingState();
}

class ProductLoadedState extends ProductState {
  final List<Product> products;
  final List<Product> filteredProducts;
  final String searchQuery;

  const ProductLoadedState({
    required this.products,
    required this.filteredProducts,
    this.searchQuery = '',
  });

  ProductLoadedState copyWith({
    List<Product>? products,
    List<Product>? filteredProducts,
    String? searchQuery,
  }) {
    return ProductLoadedState(
      products: products ?? this.products,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [products, filteredProducts, searchQuery];
}
