import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:oracle/data/controllers/base_controller.dart';
import 'package:convert/convert.dart';
import 'dart:convert';

import '../../main.dart';

final walletControllerProvider = ChangeNotifierProvider<WalletController>(
  (ref) => WalletController(),
);

class WalletController extends BaseChangeNotifier {
  ReownAppKitModal? _appKitModal;
  bool _isInitializing = false;

  ReownAppKitModal? get appKitModal => _appKitModal;

  Future<ReownAppKitModal?> initializeAppKitModal() async {
    if (_isInitializing) return _appKitModal;

    try {
      _isInitializing = true;

      ReownAppKitModalNetworks.removeSupportedNetworks('eip155');
      ReownAppKitModalNetworks.removeSupportedNetworks('bitcoin');

      _appKitModal = ReownAppKitModal(
        context: navigatorKey.currentContext!,
        projectId: '2009f3949892128ca51c1d44fd59e939',
        logLevel: LogLevel.nothing,
        metadata: const PairingMetadata(
          name: 'Oracle AI',
          description: 'AI Memecoin trading padre',
          url: 'https://oracle.fun/',
          icons: ['assets/images/oracle.png'],
          redirect: Redirect(
            native: 'com.oracle.fun://',
            universal:
                'https://cloud.reown.com/app/51a931f0-8541-423a-b1f3-f4cdcc860b44/project/be38ed26-abb9-4432-bf17-239061a24399',
          ),
        ),
        optionalNamespaces: {
          'solana': RequiredNamespace.fromJson({
            'chains': ReownAppKitModalNetworks.getAllSupportedNetworks(
              namespace: 'solana',
            ).map((chain) => 'solana:${chain.chainId}').toList(),
            'methods': NetworkUtils.defaultNetworkMethods['solana']!.toList(),
            'events': [],
          }),
        },
        featuresConfig: FeaturesConfig(
          email: true,
          socials: [
            AppKitSocialOption.X,
            AppKitSocialOption.Apple,
          ],
          showMainWallets: false,
        ),
      );

      _appKitModal?.balanceNotifier.addListener(() {
        notifyListeners();
      });

      await _appKitModal?.init();
      notifyListeners();
      return _appKitModal;
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> launchConnectedWallet() async {
    if (_appKitModal != null) {
      _appKitModal!.launchConnectedWallet();
    }
  }

  Future<void> launchBlockExplorer() async {
    if (_appKitModal != null) {
      _appKitModal!.launchBlockExplorer();
    }
  }

  Future<String?> sendRPCRequest(String message,
      {String method = 'personal_sign'}) async {
    if (_appKitModal != null &&
        _appKitModal!.session != null &&
        _appKitModal!.selectedChain != null) {
      final bytes = utf8.encode(message);
      final encodedMessage = hex.encode(bytes);

      try {
        final result = await _appKitModal!.request(
          topic: _appKitModal!.session!.topic,
          chainId: _appKitModal!.selectedChain!.chainId,
          request: SessionRequestParams(
            method: method,
            params: [
              '0x$encodedMessage',
              _appKitModal!.session!.getAddress(''),
            ],
          ),
        );
        return result.toString();
      } catch (e) {
        debugPrint('RPC Request Error: $e');
        return null;
      }
    }
    return null;
  }

  Future<List<String>?> getApprovedChains() async {
    return _appKitModal?.getApprovedChains();
  }

  Future<List<String>?> getApprovedMethods() async {
    return _appKitModal?.getApprovedMethods();
  }

  Future<List<String>?> getApprovedEvents() async {
    return _appKitModal?.getApprovedEvents();
  }

  Future<List<dynamic>?> requestReadContract({
    required DeployedContract deployedContract,
    required String functionName,
    List parameters = const [],
  }) async {
    if (_appKitModal != null &&
        _appKitModal!.session != null &&
        _appKitModal!.selectedChain != null) {
      try {
        return await _appKitModal!.requestReadContract(
          topic: _appKitModal!.session!.topic,
          chainId: _appKitModal!.selectedChain!.chainId,
          deployedContract: deployedContract,
          functionName: functionName,
          parameters: parameters,
        );
      } catch (e) {
        debugPrint('Read Contract Error: $e');
        return null;
      }
    }
    return null;
  }

  Future<dynamic> requestWriteContract({
    required DeployedContract deployedContract,
    required String functionName,
    required Transaction transaction,
    List<dynamic> parameters = const [],
    String? method,
  }) async {
    if (_appKitModal != null &&
        _appKitModal!.session != null &&
        _appKitModal!.selectedChain != null) {
      try {
        return await _appKitModal!.requestWriteContract(
          topic: _appKitModal!.session!.topic,
          chainId: _appKitModal!.selectedChain!.chainId,
          deployedContract: deployedContract,
          functionName: functionName,
          transaction: transaction,
          parameters: parameters,
          method: method,
        );
      } catch (e) {
        debugPrint('Write Contract Error: $e');
        return null;
      }
    }
    return null;
  }
}
