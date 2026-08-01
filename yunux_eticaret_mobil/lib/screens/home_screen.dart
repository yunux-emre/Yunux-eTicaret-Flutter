import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:mobil_projesi/consts/app_constans.dart';
import 'package:mobil_projesi/providers/products_provider.dart';
import 'package:mobil_projesi/services/assets_manager.dart';
import 'package:mobil_projesi/widgets/app_name_text.dart';
import 'package:mobil_projesi/widgets/products/ctg_rounded_widget.dart';
import 'package:mobil_projesi/widgets/products/latest_arrival.dart';
import 'package:mobil_projesi/widgets/title_text.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(AssetsManager.shoppingCart),
        ),
        title: const AppNameTextWidget(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              SizedBox(
                height: size.height * 0.25,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(50),
                  child: Swiper(
                    autoplay: true,
                    itemBuilder: (BuildContext context, int index) {
                      return Image.asset(
                        AppConstants.bannersImages[index],
                        fit: BoxFit.fill,
                      );
                    },
                    itemCount: AppConstants.bannersImages.length,
                    pagination: const SwiperPagination(
                      // alignment: Alignment.center,
                      builder: DotSwiperPaginationBuilder(
                        activeColor: Colors.red,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: productsProvider.getProducts.isNotEmpty,
                child: const TitlesTextWidget(label: "En son gelenler"),
              ),
              const SizedBox(height: 15.0),
              Visibility(
                visible: productsProvider.getProducts.isNotEmpty,
                child: SizedBox(
                  height: size.height * 0.2,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productsProvider.getProducts.length < 10
                        ? productsProvider.getProducts.length
                        : 10,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                        value: productsProvider.getProducts[index],
                        child: const LatestArrivalProductsWidget(),
                      );
                    },
                  ),
                ),
              ),
              const TitlesTextWidget(label: "Kategoriler"),
              const SizedBox(height: 15.0),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                children: List.generate(AppConstants.categoriesList.length, (
                  index,
                ) {
                  return CategoryRoundedWidget(
                    image: AppConstants.categoriesList[index].image,
                    name: AppConstants.categoriesList[index].name,
                    categoryId: AppConstants.categoriesList[index].id,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
