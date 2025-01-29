import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:reown_appkit/reown_appkit.dart';
import 'package:solana/dto.dart';
import 'package:solana/solana.dart';

import '../../../data/controllers/wallet_controller.dart';
import '../../../data/model_data/assets.dart';

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

  Future<void> _getQuote() async {
    final fromAmount = double.tryParse(_fromAmountController.text) ?? 0;
    if (fromAmount <= 0) return;

    try {
      // Use Jupiter v6 quote API directly
      final quoteUrl = Uri.parse(
          'https://quote-api.jup.ag/v6/quote?inputMint=${_fromAsset.mint}'
          '&outputMint=${_toAsset.mint}'
          '&amount=${(fromAmount * pow(10, _fromAsset.decimals)).toInt()}'
          '&slippageBps=50'
          '&platformFeeBps=0'
          // Only use reliable AMMs
          '&onlyDirectRoutes=true'
          '&excludeDexes=Aldrin,Crema,Lifinity,Mercurial,Serum,Step'
          '&enforceIntermediaryTokens=usdc,usdt');

      final quoteResponse = await http.get(quoteUrl);

      if (quoteResponse.statusCode != 200) {
        throw Exception('Quote API error: ${quoteResponse.body}');
      }

      final quote = jsonDecode(quoteResponse.body);

      setState(() {
        _toAmount =
            double.parse(quote['outAmount']) / pow(10, _toAsset.decimals);
        _quoteResponse = quote;
      });
    } catch (e) {
      debugPrint('Error in _getQuote: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Quote error: $e')),
      );
      setState(() {
        _toAmount = 0;
        _quoteResponse = null;
      });
    }
  }

  Future<int?> _getBalance(String mint, ReownAppKitModal appKitModal) async {
    try {
      // Check wallet connection first
      if (!appKitModal.isConnected || appKitModal.session == null) {
        throw Exception('Wallet not connected');
      }

      // Get wallet address
      final address = appKitModal.session?.getAddress('solana');
      if (address == null || address.isEmpty) {
        throw Exception('No wallet address available');
      }

      // Setup Solana connection
      final connection = SolanaClient(
        rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
        websocketUrl: Uri.parse('wss://api.mainnet-beta.solana.com'),
      );

      // Get public key
      final publicKey = Ed25519HDPublicKey.fromBase58(address);

      // For SOL token, get native balance
      if (mint == 'So11111111111111111111111111111111111111112') {
        final balance =
            await connection.rpcClient.getBalance(publicKey.toBase58());
        return balance.value;
      }

      if (publicKey == null || publicKey.toBase58().isEmpty) {
        throw Exception('No wallet address available');
      }

      // For other tokens, get token accounts
      final tokenAccounts = await connection.rpcClient.getTokenAccountsByOwner(
        publicKey.toBase58(),
        TokenAccountsFilter.byMint(mint),
        encoding: Encoding.jsonParsed,
      );

      if (tokenAccounts.value.isEmpty) {
        return 0;
      }

      final accountData = tokenAccounts.value.first;
      final parsed = accountData.account.data as Map<String, dynamic>?;
      final info = parsed?['parsed'] as Map<String, dynamic>?;
      final tokenAmount = info?['info'] as Map<String, dynamic>?;

      if (tokenAmount != null && tokenAmount.containsKey('amount')) {
        return int.parse(tokenAmount['amount']);
      } else {
        return 0; // Handle cases where 'amount' is missing
      }
    } catch (e) {
      print('Error getting balance: $e');
      rethrow; // Rethrow to handle in calling function
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

      final fromAssetBalance = await _getBalance(_fromAsset.mint, appKitModal);
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

      await _getQuote(); // *** Refresh Quote ***

      if (_quoteResponse == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Could not retrieve a valid quote. Markets might have changed. Please try again.')),
        );
        return;
      }

      if (!await _validateQuoteResponse()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Invalid quote received. Markets might have changed. Please try again.')),
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

    try {
      if (appKitModal == null || !appKitModal.isConnected) {
        debugPrint('Wallet not connected. Attempting to connect...');
        await appKitModal?.connectSelectedWallet();
        if (appKitModal?.isConnected != true) {
          throw Exception('Failed to connect wallet');
        }
      }

      appKitModal?.launchConnectedWallet();

      final session = appKitModal?.session;
      if (session == null) {
        throw Exception('No active wallet session');
      }

      final publicKey = session.getAddress('solana');
      if (publicKey == null || publicKey.isEmpty) {
        throw Exception('No public key available');
      }

      debugPrint('Using public key: $publicKey');

      // Prepare swap request
      final swapRequestBody = {
        'quoteResponse': _quoteResponse,
        'userPublicKey': publicKey,
        'wrapUnwrapSOL': true,
        'computeUnitPriceMicroLamports': 1000,
        'asLegacyTransaction': true,
        'useSharedAccounts': true,
        'strictTokenList': true,
        'restrictIntermediateTokens': true,
        'intermediateTokens': ['usdc', 'usdt']
      };

      debugPrint('Requesting swap transaction...');
      final swapResponse = await http.post(
        Uri.parse('https://quote-api.jup.ag/v6/swap'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(swapRequestBody),
      );

      if (swapResponse.statusCode != 200) {
        final errorBody = jsonDecode(swapResponse.body);
        throw Exception(
            'Jupiter API error: ${errorBody['error'] ?? 'Unknown error'}');
      }

      final swapData = jsonDecode(swapResponse.body);
      final String base64Transaction = swapData['swapTransaction'];
      debugPrint('Got swap transaction');

      // Sign the transaction
      final signatureResponse = await appKitModal?.request(
        topic: session.topic,
        chainId: 'solana:5eykt4UsFv8P8NJdTREpY1vzqKqZKvdp',
        request: SessionRequestParams(
          method: 'solana_signTransaction',
          params: {
            'transaction': base64Transaction,
            'network': 'mainnet-beta',
          },
        ),
      );

      debugPrint('Got signature response: $signatureResponse');

      if (signatureResponse == null) {
        throw Exception('No signature response received');
      }

      // Get the signature from the response
      final String signature;
      if (signatureResponse is Map) {
        signature = signatureResponse['signature'] ?? '';
      } else if (signatureResponse is String) {
        signature = signatureResponse;
      } else {
        throw Exception('Invalid signature format received');
      }

      // We'll use the original base64Transaction from Jupiter
      // instead of the wallet's returned transaction
      debugPrint('Using original transaction for RPC submission');

      // Send the signed transaction
      final rpcUrl = 'https://api.mainnet-beta.solana.com';
      final sendResponse = await http.post(
        Uri.parse(rpcUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jsonrpc': '2.0',
          'id': 1,
          'method': 'sendTransaction',
          'params': [
            base64Transaction, // Use the original transaction from Jupiter
            {
              'skipPreflight': true,
              'preflightCommitment': 'confirmed',
              'encoding': 'base64',
              'maxRetries': 3,
            }
          ],
        }),
      );

      final sendResult = jsonDecode(sendResponse.body);
      if (sendResult['error'] != null) {
        throw Exception('Failed to send transaction: ${sendResult['error']}');
      }

      final txSignature = signature; // Use the signature from the wallet
      debugPrint('Using signature for confirmation: $txSignature');

      // Wait for confirmation using the transaction signature
      await _waitForConfirmationHelius(txSignature);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Swap successful! Signature: ${txSignature.substring(0, 8)}...'),
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      debugPrint("Swap error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Swap error: $e'),
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }

// Helper method to validate and clean base64 string
  String _cleanBase64(String input) {
    // Remove any non-base64 characters
    final cleanStr = input.replaceAll(RegExp(r'[^A-Za-z0-9+/=]'), '');

    // Add padding if necessary
    var padded = cleanStr;
    while (padded.length % 4 != 0) {
      padded += '=';
    }

    return padded;
  }

  Future<void> _waitForConfirmation(String signature,
      {int maxRetries = 30, int retryDelaySeconds = 2}) async {
    final client = http.Client();
    int retryCount = 0;

    try {
      while (retryCount < maxRetries) {
        debugPrint(
            'Checking confirmation for signature: $signature (attempt ${retryCount + 1})');

        final response = await client.post(
          Uri.parse('https://api.mainnet-beta.solana.com'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'jsonrpc': '2.0',
            'id': 1,
            'method':
                'getSignatureStatuses', // Changed from getSignatureStatus to getSignatureStatuses
            'params': [
              [signature], // Parameter needs to be an array of signatures
              {'searchTransactionHistory': true}
            ],
          }),
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);

          if (body['error'] != null) {
            debugPrint('RPC error: ${body['error']}');
            throw Exception('RPC error: ${body['error']['message']}');
          }

          final statuses = body['result']?['value'] as List?;
          if (statuses != null && statuses.isNotEmpty) {
            final status = statuses[0];
            debugPrint('Status response: $status');

            if (status != null) {
              if (status['err'] != null) {
                throw Exception('Transaction failed: ${status['err']}');
              }

              final confirmationStatus = status['confirmationStatus'];
              if (confirmationStatus == 'finalized') {
                debugPrint('Transaction confirmed: $signature');
                return;
              }
              debugPrint('Current confirmation status: $confirmationStatus');
            }
          }
        } else {
          debugPrint('HTTP error: ${response.statusCode} - ${response.body}');
        }

        retryCount++;
        await Future.delayed(Duration(seconds: retryDelaySeconds));
      }

      throw Exception(
          'Transaction confirmation timeout after ${maxRetries * retryDelaySeconds} seconds');
    } finally {
      client.close();
    }
  }

  Future<void> _waitForConfirmationHelius(String signature,
      {int maxRetries = 60, int retryDelaySeconds = 5}) async {
    final client = http.Client();
    final apiKey = 'PLEASE-DO-NOT-USE-MY-API-KEY';

    try {
      for (int i = 0; i < maxRetries; i++) {
        debugPrint(
            'Checking confirmation for signature: $signature (attempt ${i + 1})');

        final response = await client.post(
          // Use POST for this endpoint
          Uri.parse(
              'https://api.helius.xyz/v0/enhanced/transactions/get-by-signature'),
          headers: {
            'Content-Type':
                'application/json', // Important: Content-Type is required
            'x-api-key': apiKey,
          },
          body: jsonEncode({"signature": signature}), // Correct request body
        );

        if (response.statusCode == 200) {
          final body = jsonDecode(response.body);
          debugPrint('Helius transaction response: $body');

          // Check confirmations (handle different response structures)
          if (body != null && body is Map && body.containsKey('transaction')) {
            final transaction = body['transaction'];
            if (transaction != null &&
                transaction is Map &&
                transaction.containsKey('confirmation')) {
              final confirmation = transaction['confirmation'];
              if (confirmation != null &&
                  confirmation is Map &&
                  confirmation.containsKey('status')) {
                final status = confirmation['status'];
                if (status == 'confirmed' || status == 'finalized') {
                  debugPrint('Transaction confirmed: $signature');
                  return;
                } else {
                  debugPrint('Current confirmation status: $status');
                }
              } else {
                debugPrint('Confirmation information not found in response');
              }
            } else {
              debugPrint('Transaction information not found in response');
            }
          } else {
            debugPrint('Unexpected response structure from Helius');
          }
        } else if (response.statusCode == 404) {
          debugPrint('Transaction not found on Helius: $signature');
          return; // Or throw if you prefer
        } else {
          debugPrint(
              'Helius HTTP error: ${response.statusCode} - ${response.body}');
        }

        await Future.delayed(Duration(seconds: retryDelaySeconds));
      }

      throw Exception(
          'Transaction confirmation timeout after ${maxRetries * retryDelaySeconds} seconds');
    } finally {
      client.close();
    }
  }

// Also add this helper method to validate quotes before attempting swap
  Future<bool> _validateQuoteResponse() async {
    if (_quoteResponse == null) {
      debugPrint('Quote response is null');
      return false;
    }

    // Check required fields
    final requiredFields = [
      'inputMint',
      'outputMint',
      'inAmount',
      'outAmount',
      'swapMode',
      'slippageBps',
      'routePlan'
    ];

    for (final field in requiredFields) {
      if (!_quoteResponse.containsKey(field)) {
        debugPrint('Missing required field in quote: $field');
        return false;
      }
    }

    // Validate route plan and ammKeys
    final routePlan = _quoteResponse['routePlan'];
    if (routePlan is! List || routePlan.isEmpty) {
      debugPrint('Invalid or empty route plan');
      return false;
    }

    for (final route in routePlan) {
      final swapInfo = route['swapInfo'];
      if (swapInfo == null || !swapInfo.containsKey('ammKey')) {
        debugPrint('Missing ammKey in route plan');
        return false;
      }
      // Advanced:  Check ammKey against a list of valid markets if needed.
    }

    return true;
  }

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
            // From amount input
            TextField(
              controller: _fromAmountController,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                labelText: 'Amount to Swap',
                border: OutlineInputBorder(),
              ),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onEditingComplete: () {
                _focusNode.unfocus();
                _getQuote();
              },
              onTapOutside: (event) {
                _focusNode.unfocus();
              },
              onChanged: (value) {
                setState(() {
                  _toAmount = 0;
                  _quoteResponse = null;
                });
              },
            ),
            const SizedBox(height: 20),
            // From asset selection
            DropdownButton<Asset>(
              value: _fromAsset,
              onChanged: (Asset? newValue) {
                setState(() {
                  _fromAsset = newValue!;
                  _toAmount = 0;
                  _quoteResponse = null;
                });
              },
              items: assets
                  .map((asset) => DropdownMenuItem<Asset>(
                        value: asset,
                        child: Text(asset.name),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // To asset selection
            DropdownButton<Asset>(
              value: _toAsset,
              onChanged: (Asset? newValue) {
                setState(() {
                  _toAsset = newValue!;
                  _toAmount = 0;
                  _quoteResponse = null;
                });
              },
              items: assets
                  .map((asset) => DropdownMenuItem<Asset>(
                        value: asset,
                        child: Text(asset.name),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // Display quote or calculated amount
            Text(
              'To Amount: $_toAmount ${_toAsset.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Swap button
            GestureDetector(
              onTap: () {
                _checkBalanceAndSwap();
              },
              child: ElevatedButton(
                onPressed: _checkBalanceAndSwap,
                child: const Text('Swap'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
