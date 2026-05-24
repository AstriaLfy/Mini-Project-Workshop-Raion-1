import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop1_raion/bloc/product_bloc.dart';
import 'package:workshop1_raion/bloc/product_event.dart';
import 'package:workshop1_raion/bloc/product_state.dart';
import 'package:workshop1_raion/models/product.dart';

class DetailScreen extends StatelessWidget {
  final String productId;

  const DetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoadedState) {
          final product = state.products.firstWhere(
            (p) => p.id == productId,
            orElse: () => const Product(id: '', title: '', description: '', imagePath: ''),
          );

          if (product.id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('Product not found')),
            );
          }

          return Scaffold(
            backgroundColor: const Color(0xFFF2F8F4),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    // Gambar produk atau fallback warna
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                      child: Image.asset(product.imagePath, width: double.infinity, height: 319, fit: BoxFit.cover),
                    ),
                    // Back button
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                            child: const Icon(Icons.arrow_back_ios_new, size: 18),
                          ),
                        ),
                      ),
                    ),
                    // Heart button pojok kanan atas
                    Positioned(
                      top: MediaQuery.of(context).padding.top + 20,
                      right: 20,
                      child: GestureDetector(
                        onTap: () {
                          context.read<ProductBloc>().add(ToggleLikeEvent(productId: product.id));
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                          child: Icon(
                            product.isLiked ? Icons.favorite : Icons.favorite_border,
                            color: product.isLiked ? Colors.red : Colors.grey,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(36),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Color(0xFF3D6B4F))),
                      const SizedBox(height: 8),
                      Text(product.description, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(color: Color(0xFF7BC89B))),
        );
      },
    );
  }
}
