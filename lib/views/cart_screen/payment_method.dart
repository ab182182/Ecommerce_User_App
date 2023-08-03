import 'package:get/get.dart';
import 'package:project/consts/consts.dart';
import 'package:project/consts/lists.dart';
import 'package:project/controllers/cart_controller.dart';
import 'package:project/views/home_screen/home.dart';
import 'package:project/widgets_common/our_buttons.dart';
import 'package:project/widgets_common/progress_indicator.dart';

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Obx(
      () => Scaffold(
        backgroundColor: whiteColor,
        bottomNavigationBar: SizedBox(
          height: 60,
          child: controller.placingOrder.value ? Center(
            child: progressIndicator(),
          ) : ourButton(
              onPress: () async {
               await controller.placeMyOrder(
                    orderPaymentMethod:
                        paymentMethods[controller.paymentIndex.value],
                    totalAmount: controller.totalP.value);
               await controller.clearCart();
               VxToast.show(context, msg: "Order placed Successfully");
               Get.offAll(const Home());
              },
              color: redColor,
              textColor: whiteColor,
              title: "Place my Order"),
        ),
        appBar: AppBar(
          title: "Choose Payment Method"
              .text
              .fontFamily(semibold)
              .color(darkFontGrey)
              .make(),
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Obx(
            () => Column(
              children: List.generate(
                paymentMethodsImg.length,
                (index) {
                  return GestureDetector(
                    onTap: () {
                      controller.changePaymentIndex(index);
                    },
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.paymentIndex.value == index
                              ? redColor
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.asset(
                            paymentMethodsImg[index],
                            width: double.infinity,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                          controller.paymentIndex.value == index
                              ? Transform.scale(
                                  scale: 1.2,
                                  child: Checkbox(
                                      activeColor: Colors.green,
                                      value: true,
                                      onChanged: (value) {}))
                              : Container(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
