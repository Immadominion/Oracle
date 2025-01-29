// lib/screens/jupiter_swap_screen.dart
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart';
import 'package:reown_appkit/reown_appkit.dart';
import '../../../data/controllers/wallet_controller.dart';
import '../../../data/model_data/assets.dart';
import '../../../data/services/jupiter_service.dart';
import '../../../data/services/solana_service.dart';
import 'swap_ui.dart';

class JupiterSwapScreen extends ConsumerStatefulWidget {
  const JupiterSwapScreen({super.key});

  @override
  ConsumerState<JupiterSwapScreen> createState() => _JupiterSwapScreenState();
}

class _JupiterSwapScreenState extends ConsumerState<JupiterSwapScreen> {
  late final TextEditingController _fromAmountController;
  late final FocusNode _focusNode;

  static final List<Asset> assets = [
    const Asset(
      name: 'SOL',
      mint: 'So11111111111111111111111111111111111111112',
      decimals: 9,
    ),
    const Asset(
      name: 'USDC',
      mint: 'EPjFWdd5AufqSSqeM2qN1xzybapC8G4wEGGkZwyTDt1v',
      decimals: 6,
    ),
    const Asset(
      name: 'BONK',
      mint: 'DezXAZ8z7PnrnRJjz3wXBoRgixCa6xjnB7YaB1pPB263',
      decimals: 5,
    ),
  ];

  Asset _fromAsset = assets[0];
  Asset _toAsset = assets[1];
  double _toAmount = 0;
  dynamic _quoteResponse;

  @override
  void initState() {
    super.initState();
    _fromAmountController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _fromAmountController.dispose();
    super.dispose();
  }

  Future<void> _getQuote() async {
    final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    if (fromAmount <= 0) return;

    try {
      final quote = await JupiterService.getQuote(
        fromAsset: _fromAsset,
        toAsset: _toAsset,
        fromAmount: fromAmount,
      );

      if (quote != null && quote['outAmount'] != null) {
        setState(() {
          _toAmount =
              double.parse(quote['outAmount']) / pow(10, _toAsset.decimals);
          _quoteResponse = quote;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not retrieve a valid quote. Markets might have changed. Please try again.')),
        );
        setState(() {
          _toAmount = 0;
          _quoteResponse = null;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote error: $e')),
      );
      setState(() {
        _toAmount = 0;
        _quoteResponse = null;
      });
    }
  }

  Future<void> _checkBalanceAndSwap() async {
    try {
      final walletController = ref.read(walletControllerProvider);
      final appKitModal = walletController.appKitModal;

      if (appKitModal == null || !appKitModal.isConnected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wallet not connected')),
        );
        return;
      }

      final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
      if (fromAmount <= 0) throw Exception('Invalid amount');

      final fromAssetBalance =
          await SolanaService.getBalance(_fromAsset.mint, appKitModal);
      if (fromAssetBalance == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error fetching balance')),
        );
        return;
      }

      if (fromAssetBalance < fromAmount * pow(10, _fromAsset.decimals)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Insufficient balance')),
        );
        return;
      }

      await _getQuote();

      if (_quoteResponse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not retrieve a valid quote. Markets might have changed. Please try again.')),
        );
        return;
      }

      await _signAndSendTransaction();
    } catch (e) {
      debugPrint("Error during swap: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Swap error: $e')),
      );
    }
  }

  Future<void> _signAndSendTransaction() async {
    final walletController = ref.read(walletControllerProvider);
    final appKitModal = walletController.appKitModal;

    if (appKitModal == null || !appKitModal.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet not connected')),
      );
      return;
    }

    try {
      final publicKey = appKitModal.session?.getAddress('solana');
      if (publicKey == null) throw Exception('No public key available');

      final swapData = await JupiterService.swap(
        quoteResponse: _quoteResponse,
        userPublicKey: publicKey,
      );

      if (swapData == null || swapData['swapTransaction'] == null) {
        throw Exception('No swap transaction in response');
      }

      final String base64Transaction = swapData['swapTransaction'];

      final signatureResponse = await appKitModal.request(
        topic: appKitModal.session?.topic,
        chainId: 'solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp',
        request: SessionRequestParams(
          method: 'solana_signTransaction',
          params: {
            'message': base64Transaction,
          },
        ),
      );

      if (signatureResponse == null || signatureResponse is! Map) {
        throw Exception('Invalid signature response');
      }

      final signature = signatureResponse['signature'] as String?;
      if (signature == null) {
        throw Exception('No signature in response');
      }

      const rpcUrl = 'https://api.mainnet-beta.solana.com';
      final sendResponse = await http.post(
        Uri.parse(rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'sendTransaction',
          'params': [
            base64Transaction,
            {
              'skipPreflight': true,
              'preflightCommitment': 'confirmed',
              'encoding': 'base64',
              'maxRetries': 3,
            }
          ],
        }),
      );

      final result = jsonDecode(sendResponse.body);

      if (result['error'] != null) {
        throw Exception(result['error']['message']);
      }

      final txSignature = result['result'];
      if (txSignature == null) {
        throw Exception('No transaction signature returned');
      }

      await _waitForConfirmation(rpcUrl, txSignature);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Swap successful! Signature: ${txSignature.toString().substring(0, 8)}...'),
        ),
      );
    } catch (e) {
      debugPrint("Detailed swap error: $e");
      if (e is http.ClientException) {
        debugPrint("HTTP error details: ${e.message}");
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Swap error: $e')),
      );
    }
  }

  Future<void> _waitForConfirmation(String rpcUrl, String signature) async {
    const maxRetries = 45;
    const interval = Duration(milliseconds: 500);

    for (int i = 0; i < maxRetries; i++) {
      try {
        final response = await http.post(
          Uri.parse(rpcUrl),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'jsonrpc': '2.0',
            'id': 1,
            'method': 'getSignatureStatuses',
            'params': [
              [signature],
              {'searchTransactionHistory': true}
            ],
          }),
        );

        final result = jsonDecode(response.body);
        final status = result['result']['value'][0];

        if (status != null) {
          if (status['err'] != null) {
            throw Exception('Transaction failed: ${status['err']}');
          }
          if (status['confirmationStatus'] == 'confirmed' ||
              status['confirmationStatus'] == 'finalized') {
            return;
          }
        }
      } catch (e) {
        debugPrint('Error checking confirmation: $e');
      }

      await Future.delayed(interval);
    }

    throw Exception(
        'Transaction not confirmed after ${maxRetries / 2} seconds');
  }

  @override
  Widget build(BuildContext context) {
    return SwapUI(
      fromAmountController: _fromAmountController,
      focusNode: _focusNode,
      fromAsset: _fromAsset,
      toAsset: _toAsset,
      toAmount: _toAmount,
      assets: assets,
      onFromAssetChanged: (Asset? newValue) {
        setState(() {
          _fromAsset = newValue!;
          _toAmount = 0;
          _quoteResponse = null;
        });
      },
      onToAssetChanged: (Asset? newValue) {
        setState(() {
          _toAsset = newValue!;
          _toAmount = 0;
          _quoteResponse = null;
        });
      },
      onSwapPressed: _checkBalanceAndSwap,
    );
  }
}
