import 'package:yunux_eticaret_admin/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../widgets/empty_bag.dart';
import '../../../models/order_model.dart';
import '../../../services/assets_manager.dart';
import '../../../widgets/title_text.dart';
import 'orders_widget.dart';

class OrdersScreenFree extends StatefulWidget {
  static const routeName = '/OrderScreen';

  const OrdersScreenFree({Key? key}) : super(key: key);

  @override
  State<OrdersScreenFree> createState() => _OrdersScreenFreeState();
}

class _OrdersScreenFreeState extends State<OrdersScreenFree> {
  bool isEmptyOrders = false;

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<OrderProvider>(
      context,
    ); // OrderProvider'a erişin
    return Scaffold(
      appBar: AppBar(title: const TitlesTextWidget(label: 'Siparişler')),
      body: FutureBuilder<List<OrdersModelAdvanced>>(
        future: ordersProvider.fetchOrder(), // fetchOrder() kullanın
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: SelectableText(snapshot.error.toString()));
          } else if (!snapshot.hasData || ordersProvider.getOrders.isEmpty) {
            isEmptyOrders = true;
            return EmptyBagWidget(
              imagePath: AssetsManager.order,
              title: "Henüz sipariş verilmedi",
              subtitle: "Siparişleriniz burada görünecek.",
            );
          } else {
            isEmptyOrders = false;
            return ListView.separated(
              itemCount: snapshot.data!.length,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 2,
                    vertical: 6,
                  ),
                  child: OrdersWidgetFree(
                    ordersModelAdvanced: ordersProvider.getOrders[index],
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(
                    // thickness: 8,
                    // color: Colors.red,
                    );
              },
            );
          }
        },
      ),
    );
  }
}
