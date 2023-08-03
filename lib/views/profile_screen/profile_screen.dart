import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project/consts/lists.dart';
import 'package:project/controllers/auth_controller.dart';
import 'package:project/controllers/profile_controller.dart';
import 'package:project/views/auth_screen/login_screen.dart';
import 'package:project/views/chat_screen/messaging_screen.dart';
import 'package:project/views/orders_screen/orders_screen.dart';
import 'package:project/views/profile_screen/components/details_card.dart';
import 'package:project/views/profile_screen/edit_profile.dart';
import 'package:project/views/wishlist_screen/wishlist_screen.dart';
import 'package:project/widgets_common/bg_widget.dart';
import 'package:project/widgets_common/progress_indicator.dart';
import '../../consts/consts.dart';
import '../../services/firestore_services.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ProfileController());
    return SafeArea(
      child: bgWidget(
        child: Scaffold(
          body: StreamBuilder(
            stream: FirestoreServices.getUser(currentUser!.uid),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: progressIndicator(),
                );
              } else {
                var data = snapshot.data!.docs[0];
                return Column(
                  children: [
                    // edit profile button
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.edit,
                        color: whiteColor,
                      ),
                    ).onTap(() {
                      controller.nameController.text = data['name'];
                      Get.to(() => EditProfile(data: data));
                    }),
                    // users details section
                    Row(
                      children: [
                        data['imageUrl'] == ''
                            ? Image.asset(
                                imgProfile2,
                                width: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make()
                            : Image.network(
                                data['imageUrl'],
                                width: 100,
                                fit: BoxFit.cover,
                              ).box.roundedFull.clip(Clip.antiAlias).make(),
                        10.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              "${data['name']}"
                                  .text
                                  .fontFamily(semibold)
                                  .white
                                  .make(),
                              "${data['email']}".text.white.make(),
                            ],
                          ),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                            color: whiteColor,
                          )),
                          onPressed: () async {
                            await Get.put(AuthController())
                                .signOutMethod(context);
                            Get.offAll(() => const LoginScreen());
                          },
                          child: logout.text.fontFamily(semibold).white.make(),
                        ),
                      ],
                    ),
                    8.heightBox,
                   FutureBuilder(
                     future: FirestoreServices.getCounts(),
                     builder: (BuildContext context, AsyncSnapshot snapshot){
                       if(!snapshot.hasData){
                         return Center(
                           child: progressIndicator(),
                         );
                       } else {
                         var countData = snapshot.data;
                         return  Row(
                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                           children: [
                             detailsCard(
                                 count: countData[0].toString(),
                                 title: "in your cart",
                                 width: context.screenWidth / 3.3),
                             detailsCard(
                                 count: countData[1].toString(),
                                 title: "in your wishlist",
                                 width: context.screenWidth / 3.3),
                             detailsCard(
                                 count: countData[2].toString(),
                                 title: "your orders",
                                 width: context.screenWidth / 3.3),
                           ],
                         );
                       }
                     },),
                    // buttons section
                    // 40.heightBox,
                    ListView.separated(
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  switch (index) {
                                    case 0:
                                      Get.to(() => const OrdersScreen());
                                      break;
                                    case 1:
                                      Get.to(() => const WishlistScreen());
                                      break;
                                    case 2:
                                      Get.to(() => const MessagesScreen());
                                      break;
                                  }
                                },
                                leading: Image.asset(
                                  profileButtonsIcon[index],
                                  width: 22,
                                ),
                                title: profileButtonsList[index]
                                    .text
                                    .fontFamily(semibold)
                                    .color(darkFontGrey)
                                    .make(),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: lightGrey,
                              );
                            },
                            itemCount: profileButtonsList.length)
                        .box
                        .white
                        .rounded
                        .margin(const EdgeInsets.all(12))
                        .padding(const EdgeInsets.symmetric(horizontal: 16))
                        .shadowSm
                        .make()
                        .box
                        .color(redColor)
                        .make()
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
