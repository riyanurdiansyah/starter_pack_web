// Model untuk Product
class ProductNewM {
  final String productId;
  final String productName;
  final double profit;
  final double price;
  final int qty;
  final int sold;

  ProductNewM({
    required this.productId,
    required this.productName,
    required this.profit,
    required this.price,
    required this.qty,
    required this.sold,
  });

  // Konversi dari JSON
  factory ProductNewM.fromJson(Map<String, dynamic> json) {
    return ProductNewM(
      productId: json['productId'],
      productName: json['productName'],
      profit: json['revenue'] ?? 0,
      qty: json['qty'],
      price: json['price'] ?? 0,
      sold: json['sold'],
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'profit': profit,
      'qty': qty,
      'price': price,
      'sold': sold,
    };
  }
}

// Model untuk Area
class AreaNewM {
  final String areaId;
  final String areaName;
  final String groupId;
  final String groupName;
  final String cycleId;
  final List<ProductNewM> products;

  AreaNewM({
    required this.areaId,
    required this.areaName,
    required this.groupId,
    required this.groupName,
    required this.cycleId,
    required this.products,
  });

  // Konversi dari JSON
  factory AreaNewM.fromJson(Map<String, dynamic> json) {
    return AreaNewM(
      areaId: json['areaId'],
      areaName: json['areaName'],
      groupId: json['groupId'] ?? "",
      groupName: json['groupName'] ?? "",
      cycleId: json['cycleId'] ?? "",
      products: List<ProductNewM>.from(
        json['products']
            .map((productJson) => ProductNewM.fromJson(productJson)),
      ),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'areaId': areaId,
      'areaName': areaName,
      'groupId': groupId,
      'groupName': groupName,
      'cycleId': cycleId,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}

// Model untuk Distribute
class DistributeNewM {
  final String cycleId;
  final String groupId;
  final String groupName;

  DistributeNewM({
    required this.cycleId,
    required this.groupId,
    required this.groupName,
  });

  // Konversi dari JSON
  factory DistributeNewM.fromJson(Map<String, dynamic> json) {
    return DistributeNewM(
      cycleId: json['cycleId'],
      groupId: json['groupId'],
      groupName: json['groupName'],
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'cycleId': cycleId,
      'groupId': groupId,
      'groupName': groupName,
    };
  }
}

// Model untuk Data utama
class DistributionData {
  final String id;
  final String cycleId;
  final String areaId;
  final String areaName;
  final String groupId;
  final String groupName;
  final List<DistributeNewM> products;

  DistributionData({
    required this.id,
    required this.cycleId,
    required this.areaId,
    required this.areaName,
    required this.groupId,
    required this.groupName,
    required this.products,
  });

  // Konversi dari JSON
  factory DistributionData.fromJson(Map<String, dynamic> json) {
    return DistributionData(
      id: json['id'],
      cycleId: json['cycleId'],
      areaId: json['areaId'],
      areaName: json['areaName'],
      groupId: json['groupId'],
      groupName: json['groupName'],
      products: List<DistributeNewM>.from(
        json['products']
            .map((productJson) => DistributeNewM.fromJson(productJson)),
      ),
    );
  }

  // Konversi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cycleId': cycleId,
      'areaId': areaId,
      'areaName': areaName,
      'groupId': groupId,
      'groupName': groupName,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
