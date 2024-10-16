import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:starter_pack_web/module/product/model/product_m.dart';

class ProductController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final CarouselSliderController carouselSliderController =
      CarouselSliderController();

  Rx<int> currentPage = 0.obs;

  Rx<int> price = 0.obs;

  Rx<bool> isLoading = true.obs;

  Rx<bool> isUseIklan = false.obs;

  RxList<ProductM> products = <ProductM>[].obs;

  RxList<InformasiProductM> informasiSelected = <InformasiProductM>[].obs;

  @override
  void onInit() async {
    await getProducts();
    await onChangeLoading(false);
    super.onInit();
  }

  Future onChangeLoading(bool val) async {
    isLoading.value = val;
  }

  Future<List<ProductM>> getProducts() async {
    final response = await firestore.collection("produk").get();

    products.value = response.docs.map((e) {
      return ProductM.fromJson(e.data());
    }).toList();
    products.sort((a, b) => a.nama.compareTo(b.nama));
    return products;
  }

  void onChangeProduct(int index) {
    currentPage.value = index;
  }

  void onChangeIklan(bool val) {
    isUseIklan.value = val;
  }

  void onSelectInformasi(InformasiProductM infor) {
    if (informasiSelected.contains(infor)) {
      informasiSelected
          .removeWhere((x) => x.gizi == infor.gizi && x.price == infor.price);
      price.value -= infor.price;
    } else {
      informasiSelected.add(infor);
      price.value += infor.price;
    }
  }
}
