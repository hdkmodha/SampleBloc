
class ScreenNameConstants {
  static const productListScreen = '/productListScreen';
}

enum ApiType {
  getAllProducts,
  getProduct,
  getAllCategories,
  getCategory,
  addProduct,
  updateProduct,
  deleteProduct
}


class APIConstant {

  static const int statusCodeSuccess = 200;
  static const int statusCodeCreated = 201;
  static const int statusCodeNotFound = 404;
  static const int statusCodeServiceNotAvailable = 503;
  static const int statusCodeBadGateway = 502;
  static const int statusCodeServerError = 500;
  static const int timeoutDurationNormalAPIs = 300;

  static String get baseDomain => 'https://fakestoreapi.com/';
  static const String product = "products";
  static int id = 0;


  static String getValue(ApiType apiType) {
    switch (apiType) {
      case ApiType.getAllProducts:
        return "products";
      case ApiType.getProduct:
        return product;
      case ApiType.getAllCategories:
        return '${product}/categories';
      case ApiType.getCategory:
        return '${product}/category/jewelery';
      case ApiType.addProduct:
        return product;
      case ApiType.updateProduct:
        return product;
      case ApiType.deleteProduct:
        return product;
    }
  }
}
