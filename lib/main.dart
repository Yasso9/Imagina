import 'package:flutter/material.dart';

import 'package:flutter_application/pages/home.dart';

void main() => runApp(const MaterialApp(
      // Remove the debug band
      debugShowCheckedModeBanner: false,
      home: BeginPage(),
    ));

class BeginPage extends StatefulWidget {
  const BeginPage({super.key});

  @override
  State<BeginPage> createState() => _BeginPageState();
}

class _BeginPageState extends State<BeginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Home();
  }
}
