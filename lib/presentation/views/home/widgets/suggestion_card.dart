import 'package:flutter/material.dart';
import 'package:slimy_card/slimy_card.dart';

class SuggestionCards extends StatefulWidget {
  const SuggestionCards({super.key});

  @override
  SuggestionCardsState createState() => SuggestionCardsState();
}

class SuggestionCardsState extends State<SuggestionCards> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlimyCard(
          slimeEnabled: true,
          topCardWidget: topCardWidget(),
          bottomCardWidget: bottomCardWidget(),
        ),
      ],
    );
  }

  // This widget will be passed as Top Card's Widget.
  Widget topCardWidget() {
    return Text(
      'customize as you wish.',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(.85),
      ),
    );
  }

  // This widget will be passed as Bottom Card's Widget.
  Widget bottomCardWidget() {
    return Text(
      'customize as you wish.',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black.withOpacity(.85),
      ),
    );
  }
}
