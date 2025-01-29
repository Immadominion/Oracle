import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/data/controllers/dashboard_controller.dart';
import 'package:oracle/presentation/views/home/home.dart';
import 'package:oracle/presentation/views/positions/positions.dart';
import 'package:oracle/presentation/views/terminal/widgets/web_socket_tests.dart';
import 'package:oracle/presentation/views/wallet/wallet.dart' as oracle_wallet;
import 'package:reown_appkit/reown_appkit.dart';

import '../../data/controllers/wallet_controller.dart';
import 'terminal/terminal.dart';

class DashBoard extends HookConsumerWidget {
  const DashBoard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<IconData> listOfIcons = [
      CupertinoIcons.house_fill,
      CupertinoIcons.lab_flask_solid,
      CupertinoIcons.arrow_up_arrow_down_circle_fill,
      CupertinoIcons.rectangle_stack_person_crop_fill,
    ];
    debugPrint('Consumer Home rebuilt: ${DateTime.now()}');
    final selectedPageIndex = ref.watch(dashBoardControllerProvider).myPage;
    Size size = MediaQuery.of(context).size;

    final appKitModal = ref.watch(walletControllerProvider).appKitModal!;

    final List<Widget> tabs = [
      const Home(),
      const Terminal(), // WebSocketTest(),
      const Positions(),
      oracle_wallet.Wallet(
        appKitModal: appKitModal,
      ),
    ];

    return Scaffold(
      body: tabs[selectedPageIndex],
      bottomNavigationBar: Container(
        margin: EdgeInsets.all(20.sp),
        height: size.width * .155,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.onSurface.withOpacity(.1),
              blurRadius: 5,
              offset: const Offset(0, 0),
            ),
          ],
          borderRadius: BorderRadius.circular(50),
        ),
        child: ListView.builder(
          itemCount: 4,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: size.width * .024),
          itemBuilder: (context, index) => InkWell(
            onTap: () {
              selectedPageIndex == index
                  ? ref.read(dashBoardControllerProvider).setTwoPage()
                  : ref.read(dashBoardControllerProvider).myPage = index;
            },
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 1500),
                  curve: Curves.fastLinearToSlowEaseIn,
                  margin: EdgeInsets.only(
                    bottom: index == selectedPageIndex ? 0 : size.width * .029,
                    right: size.width * .0422,
                    left: size.width * .0422,
                  ),
                  width: size.width * .128,
                  height: index == selectedPageIndex ? size.width * .014 : 0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(10),
                    ),
                  ),
                ),
                Icon(
                  listOfIcons[index],
                  size: size.width * .076,
                  color: index == selectedPageIndex
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(.36),
                ),
                SizedBox(height: size.width * .03),
              ],
            ),
          ),
        ),
      ).afmPadding(EdgeInsets.only(bottom: 10.sp)),
    );
  }
}
