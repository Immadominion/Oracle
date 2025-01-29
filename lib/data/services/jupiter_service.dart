import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../model_data/assets.dart';

class JupiterService {
  static Future<Map<String, dynamic>?> getQuote({
    required Asset fromAsset,
    required Asset toAsset,
    required double fromAmount,
  }) async {
    try {
      final response = await http.get(Uri.parse(
          'https://quote-api.jup.ag/v6/quote?inputMint=${fromAsset.mint}&outputMint=${toAsset.mint}&amount=${(fromAmount * pow(10, fromAsset.decimals)).toInt()}&slippage=0.5'));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Failed to fetch quote: $e');
    }
  }

  static Future<Map<String, dynamic>?> swap({
    required Map<String, dynamic> quoteResponse,
    required String userPublicKey,
  }) async {
    try {
      final swapRequestBody = {
        'quoteResponse': quoteResponse,
        'userPublicKey': userPublicKey,
        'wrapUnwrapSOL': true,
        'computeUnitPriceMicroLamports': 1000,
        'asLegacyTransaction': true,
        'useSharedAccounts': true,
        'restrictIntermediateTokens': true,
      };

      final swapResponse = await http.post(
        Uri.parse('https://quote-api.jup.ag/v6/swap'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(swapRequestBody),
      );

      if (swapResponse.statusCode == 200) {
        return jsonDecode(swapResponse.body);
      } else {
        throw Exception('Failed to swap: ${swapResponse.body}');
      }
    } catch (e) {
      throw Exception('Failed to swap: $e');
    }
  }
}
