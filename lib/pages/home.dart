import 'package:flutter/material.dart';

import 'package:flutter_application/app_bar.dart';
import 'package:flutter_application/book.dart';
import 'package:flutter_application/global.dart';
import 'package:flutter_application/pages/book.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  List<Animate> animations = [];

  Books books = Books(gBooksPath);

  bool isImageHovered = false;

  int? currentAnimationIndex;

  @override
  void initState() {
    super.initState();

    // Animate baseValue = Animate(25.0, 0.0, 400, this, setState);
    animations = [
      for (int i = 0; i < books.number; ++i)
        Animate(25.0, 0.0, 200, this, setState)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: generalBar(context),
        body: Container(
          margin: const EdgeInsets.all(10.0),
          child: LayoutBuilder(builder: (context, constraints) {
            double parentWidth = constraints.maxWidth;
            double parentHeight = constraints.maxHeight;
            double ratio = parentWidth / parentHeight;
            return GridView.count(
              primary: false,
              crossAxisCount: getNumberOfElement(ratio),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2 / 3,
              children: List.generate(books.number, (index) {
                return Container(
                  padding: EdgeInsets.all(animations[index].animation.value),
                  child: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookPage(books[index])),
                      );
                    },
                    icon: ClipRRect(
                        borderRadius: BorderRadius.circular(20.0),
                        child: MouseRegion(
                            onEnter: (PointerEvent details) {
                              currentAnimationIndex = index;
                              animations[index].controller.forward();
                            },
                            onExit: (PointerEvent details) {
                              animations[index].controller.reverse();
                            },
                            child: Image.file(books.getTitlePage(index)))),
                  ),
                );
              }),
            );
          }),
        ));
  }
}

int getNumberOfElement(double ratio) {
  if (ratio >= 4) {
    return 7;
  } else if (ratio >= 3) {
    return 6;
  } else if (ratio >= 2.2) {
    return 5;
  } else if (ratio >= 1.6) {
    return 4;
  } else if (ratio >= 1.2) {
    return 3;
  } else if (ratio >= 0.6) {
    return 2;
  } else {
    return 1;
  }
}

class Animate {
  late AnimationController controller;
  late Animation animation;

  Animate(double begin, double end, int duration, var thisValue,
      Function setStateFunction) {
    // Defining controller with animation duration of two seconds
    controller = AnimationController(
        vsync: thisValue, duration: const Duration(milliseconds: 400));

    animation = Tween<double>(begin: 25.0, end: 0.0).animate(controller);

    // Rebuilding the screen when animation goes ahead
    controller.addListener(() {
      setStateFunction(() {});
    });
  }
}
