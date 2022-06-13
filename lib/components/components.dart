import 'package:flutter/material.dart';

Widget defaultTextFormField({
  required String label,
  IconData? suffixIcon,
  required TextEditingController controller,
  required IconData prefixIcon,
  required Function validation,
  final void Function()? suffixPressed,
  final void Function(String value)? submit,
  bool isPassword = false,
  required TextInputType type,
}) =>
    TextFormField(
      obscureText: isPassword,
      onFieldSubmitted: (String value){
        submit!(value);
      },
      controller: controller,
      validator: ( value){
        validation(value);
      },
      keyboardType:type ,
      decoration: InputDecoration(

        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        prefixIcon: Icon(prefixIcon),
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffixIcon),
        ),
      ),
    );

Widget defaultButton({required String text, required Function press}) =>
    Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.deepOrange,
        ),
        child: MaterialButton(
          onPressed: () {
            press();
          },
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ));

void navigateTo(context, widget) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context, MaterialPageRoute(builder: (context) => widget), (route) => false);
