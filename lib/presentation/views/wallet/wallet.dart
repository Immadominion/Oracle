import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/general_components/top_bar.dart';
import 'package:oracle/presentation/views/wallet/widgets/user_tokens.dart';
import 'package:oracle/presentation/views/wallet/widgets/wallet_balance.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'widgets/deposit_et_withdraw.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<StatefulWidget> createState() => _WalletState();
}

final List<String> images = <String>[
  "assets/images/composure.jpeg",
  "assets/images/oracle-ai.jpg",
  "assets/images/oracle_mum_buddy.jpg",
];

final List<String> name = <String>[
  "Composure",
  "OracleAI",
  "OracleMumBuddy",
];
final List<String> balance = <String>[
  "599,231.00",
  "498,000.00",
  "500,000.00",
];

final List<String> ticker = <String>[
  "T-Pain",
  "ORCL",
  "Step-Mum",
];

class _WalletState extends State<Wallet> with WidgetsBindingObserver {
  late ReownAppKitModal appKitModal;

  void _initializeW3MService() async {
    // You can add more EVM networks
    List<ReownAppKitModalNetworkInfo> extraChains = [
      ReownAppKitModalNetworkInfo(
        isTestNetwork: true,
        currency: 'SOL',
        chainId: '101',
        name: 'Solana Devnet',
        rpcUrl: 'https://api.devnet.solana.com',
        explorerUrl: 'https://explorer.solana.com/clusters/devnet',
      ),
      ReownAppKitModalNetworkInfo(
        isTestNetwork: true,
        currency: 'SOL',
        chainId: '102',
        name: 'Solana Testnet',
        rpcUrl: 'https://api.testnet.solana.com',
        explorerUrl: 'https://explorer.solana.com/clusters/testnet',
      ),
    ];
    ReownAppKitModalNetworks.addSupportedNetworks('eip155', extraChains);
    appKitModal = ReownAppKitModal(
      context: context,
      projectId: '2009f3949892128ca51c1d44fd59e939',
      metadata: const PairingMetadata(
        name: 'Oracle AI',
        description: 'Memecoin trading made easy',
        url: 'https://certifyme.live/',
        icons: ['assets/images/oracle.png'],
      ),
    );

    await appKitModal.init();
  }

  @override
  void initState() {
    super.initState();
    _initializeW3MService();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const TopBarWidget(
        text: "Wallet",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WalletBalance().afmPadding(
            EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
          ),
          const DepositWithdrawWidget(),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                return TokensList(
                  balance: balance[index],
                  ticker: "ORCL",
                  name: name[index],
                  image: images[index],
                ).afmPadding(
                  EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                );
              },
            ),
          ),
          Center(
            child: AppKitModalConnectButton(
              context: context,
              appKit: appKitModal,
            ),
          ),
        ],
      ),
    ));
  }
}
