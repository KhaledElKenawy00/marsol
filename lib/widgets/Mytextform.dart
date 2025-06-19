// ignore_for_file: must_be_immutable, file_names

import 'package:flutter/material.dart';

class TextForm extends StatelessWidget {
  String hint;
  String? Function(String?)? validator;
  TextEditingController controller = TextEditingController();
  TextForm(
      {super.key,
      required this.hint,
      required this.controller,
      required this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        validator: validator,
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          fillColor: Colors.white24,
          filled: true,
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 28),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 1.7)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 145, 0), width: 1.7)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.red, width: 1.7)),
          hintText: hint,
          suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: Icon(
                Icons.close_outlined,
                color: Colors.white54,
                size: MediaQuery.of(context).size.width / 20,
              )),
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}

class PTextForm extends StatefulWidget {
  String hint;
  String? Function(String?)? validator;
  TextEditingController controller = TextEditingController();
  PTextForm(
      {super.key,
      required this.hint,
      required this.controller,
      required this.validator});

  @override
  State<PTextForm> createState() => _PTextFormState();
}

class _PTextFormState extends State<PTextForm> {
  bool kind = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        validator: widget.validator,
        style: const TextStyle(color: Colors.white),
        obscureText: kind,
        controller: widget.controller,
        decoration: InputDecoration(
          fillColor: Colors.white24,
          filled: true,
          contentPadding:
              EdgeInsets.all(MediaQuery.of(context).size.width / 28),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(50)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide:
                  const BorderSide(color: Colors.transparent, width: 1.7)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(70),
              borderSide: const BorderSide(
                  color: Color.fromARGB(255, 255, 145, 0), width: 1.7)),
          errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Colors.red, width: 1.7)),
          hintText: widget.hint,
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  kind = !kind;
                });
              },
              icon: Icon(
                kind ? Icons.remove_red_eye : Icons.do_not_disturb,
                color: Colors.white54,
                size: MediaQuery.of(context).size.width / 20,
              )),
          hintStyle: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ),
    );
  }
}
