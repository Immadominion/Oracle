// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:reown_appkit/reown_appkit.dart';

// final appKitProvider =
//     FutureProvider.family<ReownAppKitModal, BuildContext>((ref, context) async {
//   ReownAppKitModalNetworks.removeSupportedNetworks('eip155');
//   ReownAppKitModalNetworks.removeSupportedNetworks('bitcoin');

//   final appKitModal = ReownAppKitModal(
//     context: context,
//     projectId: '2009f3949892128ca51c1d44fd59e939',
//     logLevel: LogLevel.nothing,
//     metadata: const PairingMetadata(
//       name: 'Oracle AI',
//       description: 'AI Memecoin trading padre',
//       url: 'https://certifyme.live/',
//       icons: ['assets/images/oracle.png'],
//     ),
//     optionalNamespaces: {
//       'solana': RequiredNamespace.fromJson({
//         'chains': ReownAppKitModalNetworks.getAllSupportedNetworks(
//           namespace: 'solana',
//         ).map((chain) => 'solana:${chain.chainId}').toList(),
//         'methods': NetworkUtils.defaultNetworkMethods['solana']!.toList(),
//         'events': [],
//       }),
//     },
//     featuresConfig: FeaturesConfig(
//       email: true,
//       socials: [
//         AppKitSocialOption.X,
//         AppKitSocialOption.Apple,
//       ],
//       showMainWallets: true, // ✅ Show wallets for selection
//     ),
//   );

//   await appKitModal.init();

//   // ✅ Prompt the user to connect their wallet if not connected
//   if (appKitModal.selectedWallet == null) {
//     await appKitModal.init(); // This triggers the wallet connection UI
//   }

//   return appKitModal;
// });
