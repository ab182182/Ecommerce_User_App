import 'package:get/get.dart';
import 'package:project/consts/consts.dart';
import 'package:project/consts/lists.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/views/auth_screen/signup_screen.dart';
import 'package:project/views/home_screen/home.dart';
import 'package:project/widgets_common/applogo_widget.dart';
import 'package:project/widgets_common/custom_textfield.dart';
import 'package:project/widgets_common/our_buttons.dart';
import 'package:project/widgets_common/progress_indicator.dart';

import '../../widgets_common/bg_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            (context.screenHeight * 0.1).heightBox,
            applogoWidget(),
            10.heightBox,
            'Log in to $appname'.text.fontFamily(bold).white.size(18).make(),
            15.heightBox,
            Obx(
              () => Column(
                children: [
                  customTextField(
                      title: email,
                      hint: emailHint,
                      isPass: false,
                      // controller: controller.emailController),
                      controller: emailController),
                  customTextField(
                      title: password,
                      hint: passwordHint,
                      isPass: true,
                      // controller: controller.passwordController),
                      controller: passwordController),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {}, child: forgetPass.text.make()),
                  ),
                  5.heightBox,
                  controller.isLoading.value
                      ? progressIndicator()
                      : ourButton(
                              onPress: () async {
                                controller.isLoading(true);
                                try {
                                  await controller
                                      .loginMethod(
                                          context: context,
                                          email: emailController.text,
                                          password: passwordController.text)
                                      .then((value) {
                                    if (value != null) {
                                      VxToast.show(context, msg: loggedIn);
                                      Get.offAll(() => const Home());
                                    } else {
                                      controller.isLoading(false);
                                    }
                                  });
                                } catch (e) {
                                  VxToast.show(context, msg: e.toString());
                                }
                              },
                              color: redColor,
                              title: login,
                              textColor: whiteColor)
                          .box
                          .width(context.screenWidth - 50)
                          .make(),
                  5.heightBox,
                  createNewAccount.text.color(fontGrey).make(),
                  5.heightBox,
                  ourButton(
                          onPress: () {
                            Get.to(() => const SignupScreen());
                          },
                          color: lightGolden,
                          title: signup,
                          textColor: redColor)
                      .box
                      .width(context.screenWidth - 50)
                      .make(),
                  10.heightBox,
                  loginWith.text.color(fontGrey).make(),
                  5.heightBox,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        3,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircleAvatar(
                                backgroundColor: lightGrey,
                                radius: 25,
                                child: Image.asset(
                                  socialIconList[index],
                                  width: 30,
                                ),
                              ),
                            )),
                  ),
                ],
              )
                  .box
                  .white
                  .rounded
                  .padding(EdgeInsets.all(16))
                  .width(context.screenWidth - 70)
                  .shadowSm
                  .make(),
            ),
          ],
        ),
      ),
    ));
  }
}
