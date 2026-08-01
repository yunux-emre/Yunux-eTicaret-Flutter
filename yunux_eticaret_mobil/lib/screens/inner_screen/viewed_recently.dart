import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:mobil_projesi/providers/viewed_recently_provider.dart';
import 'package:mobil_projesi/services/assets_manager.dart';
import 'package:mobil_projesi/widgets/empy_bag.dart';
import 'package:mobil_projesi/widgets/products/product_widget.dart';
import 'package:mobil_projesi/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedProdProvider>(context);

    return viewedProdProvider.getViewedProds.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "Henüz görüntülenen ürün yok",
              subtitle:
                  "Henüz bir ürün görüntülemediniz. Alışverişe devam edin ve yeni ürünler keşfedin.",
              buttonText: "Alışverişe başla",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              title: TitlesTextWidget(
                label:
                    "Son görüntülenenler (${viewedProdProvider.getViewedProds.length})",
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Provider.of<ViewedProdProvider>(
                      context,
                      listen: false,
                    ).clearViewedProds();
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductWidget(
                    productId: viewedProdProvider.getViewedProds.values
                        .toList()[index]
                        .productId,
                  ),
                );
              },
              itemCount: viewedProdProvider.getViewedProds.length,
              crossAxisCount: 2,
            ),
          );
  }
}
