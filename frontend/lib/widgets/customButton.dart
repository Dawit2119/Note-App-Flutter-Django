import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.lableText,
    required this.onpressed,
    required this.color,
    Key? key,
  }) : super(key: key);
  final String lableText;
  final Function()? onpressed;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ElevatedButton(
        onPressed: onpressed,
        
        child: Text(lableText),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(MediaQuery.of(context).size.width - 50, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: color,
        ),
      ),
    );
  }
}
