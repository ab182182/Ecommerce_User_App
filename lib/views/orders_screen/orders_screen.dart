import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project/services/firestore_services.dart';
import 'package:project/views/orders_screen/orders_details.dart';
import 'package:project/widgets_common/progress_indicator.dart';

import '../../consts/consts.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "My Orders".text.color(darkFontGrey).fontFamily(semibold).make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getAllOrders(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: progressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return "No Orders Yet...!".text.color(darkFontGrey).makeCentered();
          } else {
            var data = snapshot.data!.docs;
            return ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: "${index + 1}"
                        .text
                        .fontFamily(bold)
                        .color(darkFontGrey)
                        .xl
                        .make(),
                    title: data[index]['order_code']
                        .toString()
                        .text
                        .color(redColor)
                        .fontFamily(semibold)
                        .make(),
                    subtitle: data[index]['total_amount']
                        .toString()
                        .numCurrencyWithLocale(locale: "en_IN")
                        .text
                        .fontFamily(semibold)
                        .make(),
                    trailing: IconButton(
                      onPressed: () {
                        Get.to(() => OrdersDetails(data: data[index],));
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: darkFontGrey,
                      ),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
