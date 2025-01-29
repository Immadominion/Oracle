import 'package:solana/dto.dart';
import 'package:solana/solana.dart';
import 'package:reown_appkit/reown_appkit.dart';

class SolanaService {
  static Future<int?> getBalance(String mint, ReownAppKitModal appKitModal) async {
    try {
      if (!appKitModal.isConnected || appKitModal.session == null) {
        throw Exception('Wallet not connected');
      }

      final address = appKitModal.session?.getAddress('solana');
      if (address == null || address.isEmpty) {
        throw Exception('No wallet address available');
      }

      final connection = SolanaClient(
        rpcUrl: Uri.parse('https://api.mainnet-beta.solana.com'),
        websocketUrl: Uri.parse('wss://api.mainnet-beta.solana.com'),
      );

      final publicKey = Ed25519HDPublicKey.fromBase58(address);

      if (mint == 'So11111111111111111111111111111111111111112') {
        final balance = await connection.rpcClient.getBalance(publicKey.toBase58());
        return balance.value;
      }

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

      return tokenAmount != null && tokenAmount.containsKey('amount')
          ? int.parse(tokenAmount['amount'])
          : 0;
    } catch (e) {
      print('Error getting balance: $e');
      rethrow;
    }
  }
}