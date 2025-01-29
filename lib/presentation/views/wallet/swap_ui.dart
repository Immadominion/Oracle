// lib/ui/swap_ui.dart
import 'package:flutter/material.dart';

import '../../../data/model_data/assets.dart';

class SwapUI extends StatelessWidget {
  final TextEditingController fromAmountController;
  final FocusNode focusNode;
  final Asset fromAsset;
  final Asset toAsset;
  final double toAmount;
  final List<Asset> assets;
  final Function(Asset?) onFromAssetChanged;
  final Function(Asset?) onToAssetChanged;
  final Function() onSwapPressed;

  const SwapUI({
    super.key,
    required this.fromAmountController,
    required this.focusNode,
    required this.fromAsset,
    required this.toAsset,
    required this.toAmount,
    required this.assets,
    required this.onFromAssetChanged,
    required this.onToAssetChanged,
    required this.onSwapPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jupiter Swap'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: fromAmountController,
              focusNode: focusNode,
              decoration: const InputDecoration(
                labelText: 'Amount to Swap',
                border: OutlineInputBorder(),
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
            ),
            const SizedBox(height: 20),
            DropdownButton<Asset>(
              value: fromAsset,
              onChanged: onFromAssetChanged,
              items: assets
                  .map((asset) => DropdownMenuItem<Asset>(
                        value: asset,
                        child: Text(asset.name),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton<Asset>(
              value: toAsset,
              onChanged: onToAssetChanged,
              items: assets
                  .map((asset) => DropdownMenuItem<Asset>(
                        value: asset,
                        child: Text(asset.name),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'To Amount: $toAmount ${toAsset.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onSwapPressed,
              child: const Text('Swap'),
            ),
          ],
        ),
      ),
    );
  }
}
