import 'package:scoped_model/scoped_model.dart';
import '../model/productinfo.dart';

class ProductModel extends Model {
  List<ProductInfo> _products = [];

  int _selectedProductIndex;

  List<ProductInfo> get products {
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  ProductInfo get selectedProduct {
    if(_selectedProductIndex == null){
      return null;
    }
    return _products[_selectedProductIndex];
  }

  void addGlass(ProductInfo glassproduct) {
    _products.add(glassproduct);
    _selectedProductIndex = null;
  }

  void updateGlass(ProductInfo updatedproduct) {
    _products[_selectedProductIndex] = updatedproduct;
    _selectedProductIndex = null;
  }

  void deleteGlass() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }
}
