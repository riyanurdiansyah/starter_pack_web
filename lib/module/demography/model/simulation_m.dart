class SimulationM {
  String distributeId;
  String cycleId;
  String groupId;
  String groupName;
  List<SimulationAreaM> productSell;

  SimulationM({
    required this.distributeId,
    required this.cycleId,
    required this.groupName,
    required this.groupId,
    required this.productSell,
  });

  Map<String, dynamic> toJson() {
    return {
      'distributeId': distributeId,
      'cycleId': cycleId,
      'groupName': groupName,
      'groupId': groupId,
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
  double pricePerProduct;
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
