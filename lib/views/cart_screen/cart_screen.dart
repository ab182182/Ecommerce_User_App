import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project/controllers/cart_controller.dart';
import 'package:project/services/firestore_services.dart';
import 'package:project/views/cart_screen/shipping_screen.dart';
import 'package:project/widgets_common/our_buttons.dart';
import 'package:project/widgets_common/progress_indicator.dart';

import '../../consts/consts.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CartController());
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: "Shopping Cart"
            .text
            .color(darkFontGrey)
            .fontFamily(semibold)
            .make(),
      ),
      body: StreamBuilder(
        stream: FirestoreServices.getCart(currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: progressIndicator(),
            );
          } else if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: "Cart is empty".text.color(darkFontGrey).make(),
            );
          } else {
            var data = snapshot.data!.docs;
            controller.calculate(data);
            controller.productSnapshot = data;
            return Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              leading: Image.network("${data[index]['img']}",width: 70,fit: BoxFit.cover,),
                              title: "${data[index]['title']} (Quantity ${data[index]['qty']})"
                                  .text
                                  .fontFamily(semibold)
                                  .size(16)
                                  .make(),
                              subtitle: "${data[index]['iprice']}"
                                  .numCurrencyWithLocale(locale: "en_IN")
                                  .text
                                  .color(redColor)
                                  .fontFamily(semibold)
                                  .make(),
                              trailing: const Icon(
                                Icons.delete,
                                color: redColor,
                              ).onTap(() {
                                FirestoreServices.deleteDocument(data[index].id);
                              }),
                            );
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        "Total Price"
                            .text
                            .fontFamily(semibold)
                            .color(darkFontGrey)
                            .make(),
                        Obx(
                          () => "${controller.totalP.value}"
                              .numCurrencyWithLocale(locale: "en_IN")
                              .text
                              .fontFamily(semibold)
                              .color(redColor)
                              .make(),
                        ),
                      ],
                    )
                        .box
                        .padding(const EdgeInsets.all(12))
                        .color(lightGolden)
                        .width(context.screenWidth - 60)
                        .roundedSM
                        .make(),
                    10.heightBox,
                    SizedBox(
                      width: context.screenWidth - 60,
                      child: ourButton(
                          color: redColor,
                          onPress: () {
                            Get.to(() => const ShippingDetails());
                          },
                          textColor: whiteColor,
                          title: "Proceed to Shipping"),
                    ),
                  ],
                ));
          }
        },
      ),
    );
  }
}
