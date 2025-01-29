import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<void> fetchMarkets() async {
  final url = Uri.parse('https://api.mainnet-beta.solana.com/v6/markets');
  final request = http.Request('GET', url);
  request.headers['Accept'] = 'application/json';

  try {
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    debugPrint('Request URL: ${request.url}');
    debugPrint('Request Method: ${request.method}');
    debugPrint('Request Headers: ${request.headers}');

    if (response.statusCode == 200) {
      debugPrint('Response Body: ${response.body}');
    } else {
      debugPrint(
          'Error fetching markets: ${response.statusCode} - ${response.body}');
    }
  } catch (e) {
    debugPrint('Error sending request: $e');
  }
}
