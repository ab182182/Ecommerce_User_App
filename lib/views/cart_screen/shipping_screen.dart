import 'package:get/get.dart';
import 'package:project/consts/consts.dart';
import 'package:project/controllers/cart_controller.dart';
import 'package:project/views/cart_screen/payment_method.dart';
import 'package:project/widgets_common/custom_textfield.dart';
import 'package:project/widgets_common/our_buttons.dart';

class ShippingDetails extends StatelessWidget {
  const ShippingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<CartController>();
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        title: "Shipping Info"
            .text
            .fontFamily(semibold)
            .color(darkFontGrey)
            .make(),
      ),
      bottomNavigationBar: SizedBox(
        height: 60,
        child: ourButton(
          onPress: () {
            if (controller.addressController.text == '' ||
                controller.cityController.text == '' ||
                controller.stateController.text == '' ||
                controller.postalCodeController.text == '' ||
                controller.phoneController.text == '') {
              VxToast.show(context, msg: "Please fill all Details");
            } else {
              Get.to(() => const PaymentMethods());
            }
          },
          color: redColor,
          textColor: whiteColor,
          title: "Continue",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              customTextField(
                  hint: "Address",
                  isPass: false,
                  title: "Address",
                  controller: controller.addressController),
              customTextField(
                  hint: "City",
                  isPass: false,
                  title: "City",
                  controller: controller.cityController),
              customTextField(
                  hint: "State",
                  isPass: false,
                  title: "State",
                  controller: controller.stateController),
              customTextField(
                  hint: "Postal Code",
                  isPass: false,
                  title: "Postal Code",
                  controller: controller.postalCodeController),
              customTextField(
                  hint: "Phone",
                  isPass: false,
                  title: "Phone",
                  controller: controller.phoneController),
            ],
          ),
        ),
      ),
    );
  }
}
