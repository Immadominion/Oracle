import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/general_components/top_bar.dart';
import 'package:oracle/presentation/views/wallet/widgets/user_tokens.dart';
import 'package:oracle/presentation/views/wallet/widgets/wallet_balance.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'widgets/deposit_et_withdraw.dart';

class Wallet extends StatefulWidget {
  final ReownAppKitModal appKitModal;
  const Wallet({super.key, required this.appKitModal});

  @override
  State<StatefulWidget> createState() => _WalletState();
}

final List<String> images = <String>[
  "assets/images/composure.jpeg",
  "assets/images/oracle-ai.jpg",
  "assets/images/oracle_card/oracle_mum_buddy.jpg",
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
  @override
  Widget build(BuildContext context) {
    debugPrint(widget.appKitModal.balanceNotifier.value);
    debugPrint(widget.appKitModal.session?.email);
    debugPrint(widget.appKitModal.session?.getAddress(''));

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
          DepositWithdrawWidget(
            appKit: widget.appKitModal,
          ),
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
        ],
      ),
    ));
  }
}
