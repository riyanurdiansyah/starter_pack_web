class SimulationM {
  String groupName;
  List<SimulationAreaM> productSell;

  SimulationM({
    required this.groupName,
    required this.productSell,
  });

  Map<String, dynamic> toJson() {
    return {
      'groupName': groupName,
      'productSell': productSell.map((area) => area.toJson()).toList(),
    };
  }
}

class SimulationAreaM {
  String areaId;
  String areaName;
  List<SimulationProductM> products;

  SimulationAreaM({
    required this.areaId,
    required this.areaName,
    required this.products,
  });

  // Menambahkan metode toJson untuk mengubah objek menjadi Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'areaId': areaId,
      'areaName': areaName,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

class SimulationProductM {
  String productId;
  String productName;
  int pricePerProduct;
  int qty;

  SimulationProductM({
    required this.productId,
    required this.productName,
    required this.pricePerProduct,
    required this.qty,
  });

  // Menambahkan metode toJson untuk mengubah objek menjadi Map<String, dynamic>
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'pricePerProduct': pricePerProduct,
      'qty': qty,
    };
  }
}