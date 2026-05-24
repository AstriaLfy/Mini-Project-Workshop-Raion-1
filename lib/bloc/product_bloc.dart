import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/product.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(const ProductLoadingState()) {
    on<LoadProductsEvent>(_onLoadProducts);
    on<ToggleLikeEvent>(_onToggleLike);
    on<SearchProductsEvent>(_onSearchProducts);
  }

  void _onLoadProducts(LoadProductsEvent event, Emitter<ProductState> emit) {
    final initialProducts = [
      const Product(
        id: 'berries',
        title: 'Berries',
        description: 'Lorem ipsum dolor sit a met, consectetur.',
        imagePath: 'assets/berries.jpg',
      ),
      const Product(
        id: 'tulsi',
        title: 'Tulsi',
        description: 'Lorem ipsum dolor sit a met, consectetur.',
        imagePath: 'assets/tulsi.jpg',
      ),
      const Product(
        id: 'milk',
        title: 'Milk',
        description: 'Lorem ipsum dolor sit a met, consectetur.',
        imagePath: 'assets/milk.jpg',
      ),
      const Product(
        id: 'tomato',
        title: 'Tomato',
        description: 'Lorem ipsum dolor sit a met, consectetur.',
        imagePath: 'assets/tomato.png',
      ),
    ];

    emit(ProductLoadedState(
      products: initialProducts,
      filteredProducts: initialProducts,
    ));
  }

  void _onToggleLike(ToggleLikeEvent event, Emitter<ProductState> emit) {
    if (state is ProductLoadedState) {
      final loadedState = state as ProductLoadedState;
      
      final updatedProducts = loadedState.products.map((product) {
        if (product.id == event.productId) {
          return product.copyWith(isLiked: !product.isLiked);
        }
        return product;
      }).toList();

      // Maintain active search filter
      final query = loadedState.searchQuery.toLowerCase();
      final updatedFilteredProducts = updatedProducts.where((product) {
        return product.title.toLowerCase().contains(query);
      }).toList();

      emit(loadedState.copyWith(
        products: updatedProducts,
        filteredProducts: updatedFilteredProducts,
      ));
    }
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) {
    if (state is ProductLoadedState) {
      final loadedState = state as ProductLoadedState;
      final query = event.query.toLowerCase();

      final updatedFilteredProducts = loadedState.products.where((product) {
        return product.title.toLowerCase().contains(query);
      }).toList();

      emit(loadedState.copyWith(
        filteredProducts: updatedFilteredProducts,
        searchQuery: event.query,
      ));
    }
  }
}
