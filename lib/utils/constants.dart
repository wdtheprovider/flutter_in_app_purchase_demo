import '../models/product_id.dart';

class Constants {
  static String rewardKey = "reward";

  static final List<ProductId> storeProductIds = <ProductId>[
    ProductId(id: "test_coins_111", isConsumable: true, reward: 10),
    ProductId(id: "test_coins_201", isConsumable: true, reward: 20),
    ProductId(id: "test_coins_30", isConsumable: true, reward: 30),
  ];
}
