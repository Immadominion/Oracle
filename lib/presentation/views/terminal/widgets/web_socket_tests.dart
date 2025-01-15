// filepath: /Users/immadominion/codes/oracle/lib/presentation/views/terminal/widgets/web_socket_tests.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:logger/logger.dart';

class WebSocketTest extends StatefulWidget {
  const WebSocketTest({super.key});

  @override
  WebSocketTestState createState() => WebSocketTestState();
}

class WebSocketTestState extends State<WebSocketTest> {
  final Logger logger = Logger(printer: PrettyPrinter());
  IOWebSocketChannel? channel;
  bool isConnected = false;
  List<dynamic> tokens = [];

  int _retryCount = 0;
  final int _maxRetries = 5;
  final Duration _retryDelay = const Duration(seconds: 5);
  final String webSocketUrl = 'ws://192.168.1.73:8080';

  @override
  void initState() {
    super.initState();
    connectToWebSocket();
  }

  void connectToWebSocket() {
    if (_retryCount >= _maxRetries) {
      logger.w('Max retry attempts reached. Please check the server.');
      return;
    }

    try {
      debugPrint('Attempting to connect to WebSocket server at $webSocketUrl');
      channel = IOWebSocketChannel.connect(webSocketUrl);

      channel!.stream.listen(
        (data) {
          debugPrint('Received data: $data');
          final parsedData = json.decode(data);
          if (parsedData != null) {
            final newToken = parsedData;
            setState(() {
              tokens.insert(0, newToken);
              if (tokens.length > 50) {
                tokens = tokens.sublist(0, 50);
              }
            });
            logger.d('Received token update: $newToken');
          }
        },
        onDone: () {
          debugPrint('Disconnected from WebSocket server.');
          logger.w('Disconnected from WebSocket server.');
          setState(() {
            isConnected = false;
          });
          if (_retryCount < _maxRetries) {
            _retryCount++;
            Future.delayed(_retryDelay, connectToWebSocket);
          } else {
            logger.w('Max retry attempts reached. Please check the server.');
          }
        },
        onError: (error) {
          debugPrint('WebSocket Error: $error');
          logger.e('WebSocket Error: $error');
          setState(() {
            isConnected = false;
          });
          if (_retryCount < _maxRetries) {
            _retryCount++;
            Future.delayed(_retryDelay, connectToWebSocket);
          } else {
            logger.w('Max retry attempts reached. Please check the server.');
          }
        },
      );

      setState(() {
        isConnected = true;
      });
      _retryCount = 0;
      debugPrint('Successfully connected to WebSocket server.');
      logger.i('Connected to WebSocket server.');
    } catch (e) {
      debugPrint('Exception during WebSocket connection: $e');
      logger.e('Exception: $e');
      setState(() {
        isConnected = false;
      });
      if (_retryCount < _maxRetries) {
        _retryCount++;
        Future.delayed(_retryDelay, connectToWebSocket);
      } else {
        logger.w('Max retry attempts reached. Please check the server.');
      }
    }
  }

  @override
  void dispose() {
    channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Memecoin Launches'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                tokens.clear();
              });
              connectToWebSocket();
            },
          ),
        ],
      ),
      body: isConnected
          ? ListView.builder(
              itemCount: tokens.length,
              itemBuilder: (context, index) {
                final token = tokens[index];
                return ListTile(
                  title: Text(token['symbol'] ?? 'No symbol'),
                  subtitle: Text('Amount: ${token['amount'] ?? 0}'),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
