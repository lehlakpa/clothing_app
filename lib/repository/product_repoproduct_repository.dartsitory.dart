import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService productService;

  ProductRepository(this.productService);

  Future<List<ProductModel>> fetchProducts() {
    return productService.fetchProducts();
  }

  Future<List<ProductModel>> filteredProducts() async {
    final products = await productService.fetchProducts();

    return products
        .where((product) => product.category?.toLowerCase() == 'beauty')
        .toList();
  }
}
