import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oracle/data/controllers/choose_oracle_controller.dart';

Widget buildCustomOracleCard(WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        ref.read(chooseOracleControllerProvider).selectedIndex = 4;
      },
      child: const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Custom Oracle',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text('Customize your own trading strategy'),
            ],
          ),
        ),
      ),
    );
  }

class CustomOracleSettings extends StatefulWidget {
  const CustomOracleSettings({super.key});

  @override
  CustomOracleSettingsState createState() => CustomOracleSettingsState();
}

class CustomOracleSettingsState extends State<CustomOracleSettings> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Custom Oracle Settings',
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          const Text('Risk/Reward Ratio'),
          Slider(
            value: ref.read(chooseOracleControllerProvider).myRiskReward,
            min: 1.0,
            max: 5.0,
            onChanged: (value) =>
                ref.read(chooseOracleControllerProvider).setRiskReward(value),
          ),
          const SizedBox(height: 16.0),
          CheckboxListTile(
            title: const Text('Long-term Strategy'),
            value: ref.read(chooseOracleControllerProvider).myIsLongTerm,
            onChanged: (value) => ref
                .read(chooseOracleControllerProvider)
                .setIsLongTerm(value ?? false),
          ),
          const SizedBox(height: 16.0),
          TextFormField(
            initialValue: ref
                .read(chooseOracleControllerProvider)
                .myEntryPrice
                .toStringAsFixed(3),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) => ref
                .read(chooseOracleControllerProvider)
                .setEntryPrice(double.parse(value)),
            decoration: const InputDecoration(
              labelText: 'Entry Price',
            ),
          ),
        ],
      );
    });
  }
}
