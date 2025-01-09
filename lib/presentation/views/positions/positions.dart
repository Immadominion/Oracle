// ignore_for_file: deprecated_member_use

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/constants/constants.dart';
import 'package:oracle/presentation/general_components/top_bar.dart';
import 'package:oracle/presentation/views/positions/widgets/positions_bottom_sheet.dart';

class Positions extends StatefulHookConsumerWidget {
  const Positions({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Positions>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120.h),
          child: Column(
            children: [
              const TopBarWidget(
                text: "Positions",
              ),
              TabBar(
                indicatorColor: CertifyColors.primary,
                controller: TabController(
                  length: 2,
                  vsync: this,
                ),
                tabs: [
                  Tab(
                    icon: Text(
                      'Trades',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Int",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Tab(
                    icon: Text(
                      'History',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Int",
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              height: 80.h,
            ),
            Center(
              child: Icon(
                CupertinoIcons.arrow_up_arrow_down_circle_fill,
                size: 72.sp,
              ),
            ),
            Text(
              'No open positions',
              style: TextStyle(
                color: Colors.black,
                fontFamily: "Int",
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        bottomSheet: const PositionsBottomSheet(),
      ),
    );
  }
}
