import 'package:clothing_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/product/product_bloc.dart';
import '../bloc/product/product_event.dart';
import '../bloc/product/product_state.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  static const Color navy = Color(0xFF1C2470);

  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9EC),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'PRODUCTS',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                      color: Color(0xFF1B1B1F),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: navy.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.tune, size: 18, color: navy),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.black54),
                        ),
                      ),
                    );
                  }

                  if (state is ProductLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('No products found'));
                    }

                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.68,
                          ),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return _ProductCard(
                          thumbnail: product.thumbnail,
                          title: product.title,
                          price: product.price,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                          onAddToCart: () {
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
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  static const Color navy = Color(0xFF1C2470);

  final String thumbnail;
  final String title;
  final num price;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const _ProductCard({
    required this.thumbnail,
    required this.title,
    required this.price,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                        thumbnail,
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
                      onTap: onAddToCart,
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
                    title,
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
                    '\$${price.toStringAsFixed(2)}',
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
}
