import 'package:clothing_app/models/product_model.dart';
import 'package:clothing_app/constants/constants_colors.dart';
import 'package:flutter/material.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity > 1) setState(() => _quantity--);
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: ConstantsColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Top bar ----------
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                    color: ConstantsColors.textPrimary,
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border, size: 20),
                    color: ConstantsColors.navy,
                  ),
                ],
              ),
            ),

            // ---------- Content ----------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(22),
                      child: Container(
                        height: 260,
                        width: double.infinity,
                        color: ConstantsColors.surfaceMuted,
                        child: Image.network(
                          product.thumbnail,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.checkroom_outlined,
                            size: 64,
                            color: Colors.black26,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Title + price
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: ConstantsColors.textPrimary,
                            ),
                          ),
                        ),
                        Text(
                          '\$${product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: ConstantsColors.navy,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // Rating (optional — remove if your model has no rating)
                    Row(
                      children: [
                        // const Icon(Icons.star, size: 16, color: Colors.amber),
                        // const SizedBox(width: 4),
                        // Text(
                        //   product.rating.toStringAsFixed(1),
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     fontWeight: FontWeight.w600,
                        //     color: Colors.grey.shade700,
                        //   ),
                        // ),
                        // const SizedBox(width: 12),
                        // Text(
                        //   product.brand,
                        //   style: TextStyle(
                        //     fontSize: 13,
                        //     color: Colors.grey.shade500,
                        //   ),
                        // ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: ConstantsColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.description,
                      style: TextStyle(
                        fontSize: 13.5,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Quantity selector
                    Row(
                      children: [
                        const Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: ConstantsColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        _buildQtyButton(Icons.remove, _decrement),
                        SizedBox(
                          width: 36,
                          child: Text(
                            '$_quantity',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        _buildQtyButton(Icons.add, _increment),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ---------- Bottom add-to-cart bar ----------
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                color: ConstantsColors.cardBackground,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 20,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                      Text(
                        '\$${(product.price * _quantity).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: ConstantsColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: ConstantsColors.navy,
                            content: Text(
                              '$_quantity x ${product.title} added to cart',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                        // TODO: dispatch your CartBloc add-to-cart event here,
                        // e.g. context.read<CartBloc>().add(
                        //   CartItemAdded(product: product, quantity: _quantity),
                        // );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantsColors.navy,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add to Cart',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                        ),
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

  Widget _buildQtyButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: ConstantsColors.navy.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 16, color: ConstantsColors.navy),
      ),
    );
  }
}
