import 'package:flutter/material.dart';
import 'package:gradients/gradients.dart';

import 'constants.dart';
String phoneNumber='';
Widget primaryButton({
  required String text,
  required VoidCallback onPressed,
  double height = 50,
  double width = 100.0,
  Color? background,
  Color? textColor,
  double radius = 30,
  bool isUpperCase = true,
  double fontSize = 18,
  colors,
}) =>
    Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color:Colors.blueAccent ,
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradientPainter(
          colorSpace: ColorSpace.oklab,
          colors: colors ??
              [
                MyColors.myBlue,
                MyColors.myBlue,

              ],
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            fontSize: fontSize,
          ),
        ),
      ),
    );
Widget  myTextFormField({ required BuildContext context,
    IconData? icon, String? hintText, required bool isPassword, required bool isEmail}) {
  double _width = MediaQuery.of(context).size.width;
  return Container(

    height: _width / 7,
    width: _width / 1.22*0.6,
    alignment: Alignment.center,
    padding: EdgeInsets.only(right: _width / 30),
    decoration: BoxDecoration(
      border: Border.all(color: MyColors.lightGrey),
      borderRadius: BorderRadius.circular(15),
    ),
    child: TextField(

     // autofocus: true,
      onSubmitted: (value) {
        print(value);
        phoneNumber =value;
       print('phoneNumber in compenents is $phoneNumber');
      },
      style: const TextStyle(color: Colors.black),
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Colors.white.withOpacity(.7),
        ),
        border: InputBorder.none,
        hintMaxLines: 1,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.white.withOpacity(.5),
        ),
      ),
    ),
  );
}
Widget buildDrawerItem({required BuildContext context,
  required String text,
  required IconData icon,
   var tailingShown = true,
   var iconColor = Colors.black,
 }){
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Icon(icon,
        color: iconColor,
      ),
      SizedBox(
        width: 20,
      ),
      Text('$text',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.normal,
        ),
      ),
      Spacer(),
      if(tailingShown)
        Icon(Icons.arrow_forward_ios,
        ),

    ],
  );
}

Widget buildButton(
    {
      required BuildContext context,
      required String text,
      required VoidCallback onPressed,
      double height = 50,
      double width = 100.0,
      Color? background,
      Color? textColor,
      double radius = 30,
      bool isUpperCase = true,
      double fontSize = 18,
      colors,
    }) =>
    Container(
      width: width,
      height: height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: background ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        gradient: LinearGradientPainter(
          colorSpace: ColorSpace.oklab,
          colors: colors ??
              [
                MyColors.myBlue,
                MyColors.myBlue,

              ],
        ),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor ?? Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: "Cairo",
            fontSize: fontSize,
          ),
        ),
      ),
    );
Widget dividerSeparator() => Divider(
  thickness: 0.3,
  color: Colors.grey,
);

