import 'package:flutter/material.dart';
import 'dart:math';

class SuggestionCardStack extends StatefulWidget {
  const SuggestionCardStack({super.key});

  @override
  SuggestionCardStackState createState() => SuggestionCardStackState();
}

class SuggestionCardStackState extends State<SuggestionCardStack> {
  double _page = 10;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height * .55;
    PageController pageController;
    pageController = PageController(initialPage: 10);
    pageController.addListener(
      () {
        setState(
          () {
            _page = pageController.page!;
          },
        );
      },
    );

    return Stack(
      children: [
        SizedBox(
          height: height,
          width: width * .99,
          child: LayoutBuilder(
            builder: (context, boxConstraints) {
              List<Widget> cards = <Widget>[];

              for (int i = 0; i <= 11; i++) {
                double currentPageValue = i - _page;
                bool pageLocation = currentPageValue > 0;

                double start = 10 +
                    max(
                        (boxConstraints.maxWidth - width * .85) -
                            ((boxConstraints.maxWidth - width * .85) / 2) *
                                -currentPageValue *
                                (pageLocation ? 12 : 1),
                        0.0);

                double cardWidth =
                    width * .77 * (1 - 0.1 * min(currentPageValue.abs(), 1.0));

                var customizableCard = Positioned.directional(
                  top: 20 * max(-currentPageValue, 0.0),
                  bottom: 20 * max(-currentPageValue, 0.0),
                  start: start,
                  textDirection: TextDirection.ltr,
                  child: Container(
                    height: height,
                    width: cardWidth,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.15),
                            blurRadius: 10),
                      ],
                    ),
                  ),
                );
                cards.add(customizableCard);
              }
              return Stack(children: cards);
            },
          ),
        ),
        Positioned.fill(
          child: PageView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            itemCount: 5,
            controller: pageController,
            itemBuilder: (context, index) {
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
