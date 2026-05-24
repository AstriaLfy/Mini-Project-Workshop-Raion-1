import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workshop1_raion/bloc/product_bloc.dart';
import 'package:workshop1_raion/bloc/product_event.dart';
import 'package:workshop1_raion/bloc/product_state.dart';
import 'package:workshop1_raion/models/product.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Widget> _slides = [
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset('assets/dashboard1.png', fit: BoxFit.cover, width: double.infinity, height: 160),
    ),
    const _PlaceholderSlide(color: Color(0xFF80C4A8), label: 'Promo Harvest Season'),
    const _PlaceholderSlide(color: Color(0xFF4A90D9), label: 'Fresh Vegetables'),
    const _PlaceholderSlide(color: Color(0xFFE8A838), label: 'Organic Fruits'),
    const _PlaceholderSlide(color: Color(0xFF9B59B6), label: 'Daily Farm Deals'),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF7BC89B),
        centerTitle: false,
        title: const Text('Farmers', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24, color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                onChanged: (value) {
                  context.read<ProductBloc>().add(SearchProductsEvent(query: value));
                },
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7BC89B)),
                  hintText: 'Search..',
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFB8DFCA)), borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFFB8DFCA)), borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 160,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) => setState(() => _currentPage = index),
                  itemBuilder: (context, index) => _slides[index],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_slides.length, (index) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == index ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index ? const Color(0xFF7BC89B) : const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              const Text('Categories', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF3D6B4F))),
              const SizedBox(height: 14),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    CategoryCard(title: 'Fruits', imagePath: 'assets/berries.jpg'),
                    SizedBox(width: 10),
                    CategoryCard(title: 'Grains', imagePath: 'assets/kacang.png'),
                    SizedBox(width: 10),
                    CategoryCard(title: 'Herbs', imagePath: 'assets/tulsi.jpg'),
                    SizedBox(width: 10),
                    CategoryCard(title: 'Vegetables', imagePath: 'assets/tomato.png'),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Browse Products', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF3D6B4F))),
              const SizedBox(height: 14),
              BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoadingState) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: CircularProgressIndicator(color: Color(0xFF7BC89B)),
                      ),
                    );
                  }
                  if (state is ProductLoadedState) {
                    final products = state.filteredProducts;
                    if (products.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 32),
                        child: Center(
                          child: Text(
                            'No products found',
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.grey),
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.83,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _productCard(context, products[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailScreen(productId: product.id)),
        );
      },
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB8DFCA))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Stack(children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.asset(product.imagePath, width: double.infinity, height: 130, fit: BoxFit.cover),
            ),
            Positioned(
              top: 6, right: 6,
              child: GestureDetector(
                onTap: () {
                  context.read<ProductBloc>().add(ToggleLikeEvent(productId: product.id));
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                  child: Icon(product.isLiked ? Icons.favorite : Icons.favorite_border, color: product.isLiked ? Colors.red : Colors.grey, size: 18),
                ),
              ),
            ),
          ]),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF3D6B4F))),
              const SizedBox(height: 4),
              Text(product.description, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _PlaceholderSlide extends StatelessWidget {
  final Color color;
  final String label;
  const _PlaceholderSlide({required this.color, required this.label});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 160,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String imagePath;
  const CategoryCard({super.key, required this.title, required this.imagePath});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      height: 56,
      decoration: BoxDecoration(color: const Color(0xFFDFF0E4), borderRadius: BorderRadius.circular(50), border: Border.all(color: const Color(0xFFB8DFCA))),
      child: Row(children: [
        ClipOval(child: Image.asset(imagePath, width: 46, height: 46, fit: BoxFit.cover)),
        const SizedBox(width: 8),
        Padding(padding: const EdgeInsets.only(right: 16), child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF3D6B4F)))),
      ]),
    );
  }
}
