import 'package:flutter/material.dart';

class ReuseableTextField extends StatefulWidget {
  ReuseableTextField(
      {super.key, required this.lable, required this.controller});
  String lable;
  TextEditingController controller = new TextEditingController();
  @override
  State<ReuseableTextField> createState() => _ReuseableTextFieldState();
}

class _ReuseableTextFieldState extends State<ReuseableTextField> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      width: 300,
      height: 50,
      child: TextField(
        style: const TextStyle(
            color: Color.fromARGB(179, 24, 17, 2), fontSize: 20),
        controller: widget.controller,
        cursorColor: Colors.white,
        decoration: InputDecoration(
            labelText: widget.lable,
            focusColor: Colors.white,
            focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            floatingLabelStyle: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 24,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
            filled: true,
            fillColor: Color.fromARGB(58, 255, 255, 255)),
      ),
    );
  }
}
