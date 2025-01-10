import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/general_components/top_bar.dart';
import 'package:oracle/presentation/views/wallet/widgets/user_tokens.dart';
import 'package:oracle/presentation/views/wallet/widgets/wallet_balance.dart';
import 'package:reown_appkit/reown_appkit.dart';
import '../../../core/helpers/string_helpers.dart';
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
  @override
  Widget build(BuildContext context) {
    print(widget.appKitModal.balanceNotifier.value); //balance
    print(widget.appKitModal.session?.email); // email
    print(widget.appKitModal.session?.getAddress('solana')); // address

    String shortenedAddress = StringHelper.shortenWalletAddress(
        widget.appKitModal.session?.getAddress('solana'));

    return SafeArea(
        child: Scaffold(
      appBar: const TopBarWidget(
        text: "Wallet",
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Center(
          //     child: Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       shortenedAddress,
          //       style: TextStyle(
          //         fontSize: 20.sp,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //     SizedBox(
          //       width: 5.w,
          //     ),
          //     Icon(
          //       CupertinoIcons.doc_on_doc,
          //       size: 18.sp,
          //       weight: 1,
          //     )
          //   ],
          // )),
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
