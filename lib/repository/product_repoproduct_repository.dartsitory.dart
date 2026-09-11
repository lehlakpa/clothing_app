import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductRepository {
  final ProductService productService;

  ProductRepository(this.productService);

  Future<List<ProductModel>> fetchProducts() {
    return productService.fetchProducts();
  }
}
