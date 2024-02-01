import 'package:flutter/material.dart';

class Page3 extends StatefulWidget {
  Page3({Key? key}) : super(key: key);

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 3, 189, 3),
      child: Center(
        child: Text(
          "Page3",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}