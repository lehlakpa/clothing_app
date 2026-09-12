import 'package:clothing_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';
import '../models/product_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const Color navy = Color(0xFF1C2470);

  final TextEditingController _searchController = TextEditingController();
  final PageController _bannerController = PageController();
  int _currentBanner = 0;

  final List<Map<String, String>> _banners = const [
    {
      'tag': 'NEW SEASON',
      'title': 'Up to 50% Off\non selected items',
      'cta': 'Shop Now',
    },
    {
      'tag': 'JUST DROPPED',
      'title': 'Fresh Streetwear\nfor Autumn',
      'cta': 'Explore',
    },
    {
      'tag': 'MEMBERS ONLY',
      'title': 'Free Shipping\non orders over \$50',
      'cta': 'Join Now',
    },
  ];

  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductFetchRequested());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  // Applies the selected category chip + search text on top of whatever
  // the bloc fetched. Swap this for a bloc-dispatched filter event if you'd
  // rather filter server-side.
  List<ProductModel> _applyFilters(List<ProductModel> products) {
    return products.where((product) {
      final matchesCategory =
          _selectedCategory == 'All' ||
          product.category?.toLowerCase() == _selectedCategory.toLowerCase();

      final matchesSearch =
          _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9EC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ---------- Banner ----------
            SliverToBoxAdapter(child: _buildBannerCarousel()),

            const SliverToBoxAdapter(child: SizedBox(height: 10)),

            // ---------- Banner dot indicators ----------
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_banners.length, (index) {
                  final bool active = index == _currentBanner;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: active ? 18 : 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? navy : const Color(0xFFD5D5DC),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
            ),

            // ---------- Search bar ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: _buildSearchField(),
              ),
            ),

            // ---------- Category chips (built from real product data) ----------
            SliverToBoxAdapter(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  List<String> categories = ['All'];

                  if (state is ProductLoaded) {
                    final unique =
                        state.products.map((p) => p.category).toSet().toList()
                          ..sort();
                    categories = [
                      'All',
                      "shoes",
                      "watches",
                      "sunglasses",
                      "bags",
                      "clothes",
                    ];
                  }

                  return SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        final bool selected = category == _selectedCategory;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = category),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: selected ? navy : const Color(0xFFF4F4F6),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: selected
                                    ? navy
                                    : const Color(0xFFE3E3E8),
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              category,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ---------- Section title ----------
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory == 'All'
                          ? 'New Arrivals'
                          : _selectedCategory,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B1B1F),
                      ),
                    ),
                    Text(
                      'See all',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: navy,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 14)),

            // ---------- Filtered product grid ----------
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  );
                }

                if (state is ProductError) {
                  return SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(40),
                      child: Center(
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                  );
                }

                if (state is ProductLoaded) {
                  final filtered = _applyFilters(state.products);

                  if (filtered.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Center(child: Text('No products found')),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildProductCard(context, filtered[index]),
                        childCount: filtered.length,
                      ),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Scrollable banner carousel ----------
  Widget _buildBannerCarousel() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: SizedBox(
        height: 170,
        child: PageView.builder(
          controller: _bannerController,
          itemCount: _banners.length,
          onPageChanged: (index) {
            setState(() => _currentBanner = index);
          },
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(
                right: index == _banners.length - 1 ? 0 : 10,
              ),
              child: _buildBannerSlide(_banners[index]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBannerSlide(Map<String, String> banner) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF242C86), navy],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -40,
              top: -40,
              child: _buildDecoCircle(size: 150),
            ),
            Positioned(
              right: 30,
              bottom: -50,
              child: _buildDecoCircle(size: 100),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    banner['tag'] ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    banner['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      banner['cta'] ?? '',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE3E3E8)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Colors.black45),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14.5, color: Color(0xFF1B1B1F)),
              decoration: const InputDecoration(
                hintText: 'Search for clothes, brands...',
                hintStyle: TextStyle(color: Color(0xFF9A9AA3)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.tune, size: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F9),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFE3E3E8),
                      child: Image.network(
                        product.thumbnail,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.checkroom_outlined,
                          size: 40,
                          color: Colors.black26,
                        ),
                        loadingBuilder: (context, child, progress) {
                          if (progress == null) return child;
                          return const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: navy,
                            content: Text('${product.title} added to cart'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        // TODO: dispatch your CartBloc add-to-cart event here
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart_outlined,
                          size: 16,
                          color: navy,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1B1B1F),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: navy,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Decorative icy circle used inside the banner
  Widget _buildDecoCircle({required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.18),
            Colors.white.withOpacity(0.04),
          ],
        ),
      ),
    );
  }
}
