import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:mobil_projesi/consts/app_constans.dart';
import 'package:mobil_projesi/models/product_model.dart';
import 'package:mobil_projesi/providers/products_provider.dart';
import 'package:mobil_projesi/services/assets_manager.dart';
import 'package:mobil_projesi/widgets/products/product_widget.dart';
import 'package:mobil_projesi/widgets/title_text.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  List<ProductModel> productListSearch = [];
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    List<ProductModel> productList = passedCategory == null
        ? productsProvider.products
        : productsProvider.findByCategory(categoryName: passedCategory);
    final titleText = passedCategory == null
        ? "Ürün Ara"
        : AppConstants.getCategoryDisplayName(passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(AssetsManager.shoppingCart),
          ),
          title: TitlesTextWidget(label: titleText),
        ),
        body: productList.isEmpty
            ? const Center(child: TitlesTextWidget(label: "Ürün bulunamadı"))
            : StreamBuilder<List<ProductModel>>(
                stream: productsProvider.fetchProductsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  } else if (snapshot.data == null) {
                    return const Center(
                      child: SelectableText("Ürün eklenmedi"),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 15.0),
                        TextField(
                          controller: searchTextController,
                          decoration: InputDecoration(
                            hintText: "Ara",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                // setState(() {
                                FocusScope.of(context).unfocus();
                                searchTextController.clear();
                                // });
                              },
                              child: const Icon(Icons.clear, color: Colors.red),
                            ),
                          ),
                          // onChanged: (value) {
                          //   setState(() {
                          //     productListSearch = productsProvider.searchQuery(
                          //         searchText: searchTextController.text);
                          //   });
                          // },
                          onSubmitted: (value) {
                            setState(() {
                              productListSearch = productsProvider.searchQuery(
                                searchText: searchTextController.text,
                                passedList: productList,
                              );
                            });
                          },
                        ),
                        const SizedBox(height: 15.0),
                        if (searchTextController.text.isNotEmpty &&
                            productListSearch.isEmpty) ...[
                          const Center(
                            child: TitlesTextWidget(label: "Ürün bulunamadı"),
                          ),
                        ],
                        Expanded(
                          child: DynamicHeightGridView(
                            itemCount: searchTextController.text.isNotEmpty
                                ? productListSearch.length
                                : productList.length,
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            builder: (context, index) {
                              return ProductWidget(
                                productId: searchTextController.text.isNotEmpty
                                    ? productListSearch[index].productId
                                    : productList[index].productId,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
