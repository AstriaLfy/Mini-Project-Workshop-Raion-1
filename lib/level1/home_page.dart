import 'package:flutter/material.dart';
import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Map<String, bool> likedProducts = {};

  final List<Widget> _slides = [
    ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Image.asset('assets/dashboard1.png', fit: BoxFit.cover, width: double.infinity, height: 160),
    ),
    _PlaceholderSlide(color: Color(0xFF80C4A8), label: 'Promo Harvest Season'),
    _PlaceholderSlide(color: Color(0xFF4A90D9), label: 'Fresh Vegetables'),
    _PlaceholderSlide(color: Color(0xFFE8A838), label: 'Organic Fruits'),
    _PlaceholderSlide(color: Color(0xFF9B59B6), label: 'Daily Farm Deals'),
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
                decoration: InputDecoration(
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
              Row(children: [
                _productCard('assets/berries.jpg', 'Berries', 'Lorem ipsum dolor sit a met, consectetur.'),
                const SizedBox(width: 16),
                _productCard('assets/tulsi.jpg', 'Tulsi', 'Lorem ipsum dolor sit a met, consectetur.'),
              ]),
              const SizedBox(height: 16),
              Row(children: [
                _productCard('assets/milk.jpg', 'Milk', 'Lorem ipsum dolor sit a met, consectetur.'),
                const SizedBox(width: 16),
                _productCard('assets/tomato.png', 'Tomato', 'Lorem ipsum dolor sit a met, consectetur.'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _productCard(String imagePath, String title, String desc) {
    bool liked = likedProducts[title] ?? false;
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.push<bool>(context,
            MaterialPageRoute(builder: (_) => DetailScreen(imagePath: imagePath, title: title, description: desc, isLiked: liked)),
          );
          if (result != null) setState(() => likedProducts[title] = result);
        },
        child: Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFB8DFCA))),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(imagePath, width: double.infinity, height: 130, fit: BoxFit.cover),
              ),
              Positioned(
                top: 6, right: 6,
                child: GestureDetector(
                  onTap: () => setState(() => likedProducts[title] = !liked),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.white70, shape: BoxShape.circle),
                    child: Icon(liked ? Icons.favorite : Icons.favorite_border, color: liked ? Colors.red : Colors.grey, size: 18),
                  ),
                ),
              ),
            ]),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF3D6B4F))),
                const SizedBox(height: 4),
                Text(desc, style: const TextStyle(fontSize: 12, color: Colors.grey), maxLines: 2, overflow: TextOverflow.ellipsis),
              ]),
            ),
          ]),
        ),
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
