import 'package:project/consts/consts.dart';

Widget progressIndicator (){
  return const CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation(redColor),
  );
}