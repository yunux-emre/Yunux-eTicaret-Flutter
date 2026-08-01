import 'package:mobil_projesi/models/categories_model.dart';
import 'package:mobil_projesi/services/assets_manager.dart';

class AppConstants {
  static const String imageUrl =
      'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2,
  ];

  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Phones",
      image: AssetsManager.mobiles,
      name: "Telefonlar",
    ),
    CategoriesModel(id: "Laptops", image: AssetsManager.pc, name: "Laptoplar"),
    CategoriesModel(
      id: "Electronics",
      image: AssetsManager.electronics,
      name: "Elektronik",
    ),
    CategoriesModel(id: "Watches", image: AssetsManager.watch, name: "Saatler"),
    CategoriesModel(
      id: "Clothes",
      image: AssetsManager.fashion,
      name: "Kıyafetler",
    ),
    CategoriesModel(
      id: "Shoes",
      image: AssetsManager.shoes,
      name: "Ayakkabılar",
    ),
    CategoriesModel(id: "Books", image: AssetsManager.book, name: "Kitaplar"),
    CategoriesModel(
      id: "Cosmetics",
      image: AssetsManager.cosmetics,
      name: "Kozmetikler",
    ),
  ];

  static String getCategoryDisplayName(String categoryId) {
    for (final category in categoriesList) {
      if (category.id == categoryId) {
        return category.name;
      }
    }
    return categoryId;
  }
}
