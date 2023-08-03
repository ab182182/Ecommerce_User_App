import 'package:get/get.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/views/home_screen/home.dart';
import 'package:project/widgets_common/bg_widget.dart';
import 'package:project/widgets_common/custom_textfield.dart';
import 'package:project/widgets_common/our_buttons.dart';
import 'package:project/widgets_common/progress_indicator.dart';
import '../../consts/consts.dart';
import '../../widgets_common/applogo_widget.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool? isCheck = false;
  var controller = Get.put(AuthController());

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordRetypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return bgWidget(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              (context.screenHeight * 0.1).heightBox,
              applogoWidget(),
              10.heightBox,
              'Join The $appname'.text.fontFamily(bold).white.size(18).make(),
              15.heightBox,
              Obx(
                () => Column(
                  children: [
                    customTextField(
                        title: name,
                        hint: nameHint,
                        controller: nameController,
                        isPass: false),
                    customTextField(
                        title: email,
                        hint: emailHint,
                        controller: emailController,
                        isPass: false),
                    customTextField(
                        title: password,
                        hint: passwordHint,
                        controller: passwordController,
                        isPass: true),
                    customTextField(
                        title: retypePassword,
                        hint: passwordHint,
                        controller: passwordRetypeController,
                        isPass: true),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                          onPressed: () {}, child: forgetPass.text.make()),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          activeColor: redColor,
                          checkColor: whiteColor,
                          value: isCheck,
                          onChanged: (newValue) {
                            setState(() {
                              isCheck = newValue;
                            });
                          },
                        ),
                        10.widthBox,
                        Expanded(
                          child: RichText(
                            text: const TextSpan(children: [
                              TextSpan(
                                  text: 'I agree to the ',
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )),
                              TextSpan(
                                  text: termAndCond,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )),
                              TextSpan(
                                  text: ' & ',
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: fontGrey,
                                  )),
                              TextSpan(
                                  text: privacyPolicy,
                                  style: TextStyle(
                                    fontFamily: regular,
                                    color: redColor,
                                  )),
                            ]),
                          ),
                        ),
                      ],
                    ),
                    5.heightBox,
                    controller.isLoading.value
                        ? progressIndicator()
                        : ourButton(
                                onPress: () async {
                                  if (isCheck != false) {
                                    controller.isLoading(true);
                                    try {
                                      await controller
                                          .signupMethod(
                                              context: context,
                                              email: emailController.text,
                                              password: passwordController.text)
                                          .then((value) {
                                        return controller.storeUserData(
                                            name: nameController.text,
                                            email: emailController.text,
                                            password: passwordController.text);
                                      }).then((value) {
                                        VxToast.show(context, msg: loggedIn);
                                        Get.offAll(() => const Home());
                                      });
                                    } catch (e) {
                                      auth.signOut();
                                      VxToast.show(context, msg: e.toString());
                                      controller.isLoading(false);
                                    }
                                  }
                                },
                                color: isCheck == true ? redColor : lightGrey,
                                title: signup,
                                textColor: whiteColor)
                            .box
                            .width(context.screenWidth - 50)
                            .make(),
                    10.heightBox,
                    RichText(
                      text: const TextSpan(children: [
                        TextSpan(
                            text: alreadyHaveAccount,
                            style: TextStyle(
                              fontFamily: semibold,
                              color: fontGrey,
                            )),
                        TextSpan(
                            text: login,
                            style: TextStyle(
                              fontFamily: semibold,
                              color: redColor,
                            )),
                      ]),
                    ).onTap(() {
                      Get.back();
                    }),
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
      ),
    ));
  }
}
