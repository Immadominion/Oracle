import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/presentation/views/home/widgets/choose_oracle_buddy/oracle_buddy_card.dart';

import '../../../../../core/constants/oracle_buddies.dart';
import '../../../../../data/controllers/choose_oracle_controller.dart';
import 'custom_oracle_buddy_card.dart';
import 'oracle_feature.dart';

class ChooseOracleModal extends StatefulWidget {
  const ChooseOracleModal({super.key});

  @override
  ChooseOracleModalState createState() => ChooseOracleModalState();
}

class ChooseOracleModalState extends State<ChooseOracleModal> {
  int _currentPage = 0;

  final PageController _pageController = PageController(viewportFraction: 0.9);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.77,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Padding(
              padding: EdgeInsets.only(
                top: 16.sp,
                left: 16.sp,
                right: 16.sp,
                bottom: 14.sp,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      CupertinoIcons.xmark,
                      color: Theme.of(context).colorScheme.onPrimary,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Choose Your Oracle',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            // Oracle Cards
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                  ref
                      .read(chooseOracleControllerProvider)
                      .setSelectedIndex(index);
                },
                itemCount: 5,
                itemBuilder: (context, index) {
                  if (index == 4) {
                    return const CustomOracleSetupPage();
                  }

                  final oracle = oracles[index];

                  return OracleBuddyCard(
                    name: oracle['name']!,
                    bio: oracle['bio']!,
                    riskLevel: oracle['riskLevel']!,
                    riskImage: oracle['riskImage']!,
                    assets: oracle['assets']!,
                    assetsImage: oracle['assetsImage']!,
                    strategy: oracle['strategy']!,
                    strategyImage: oracle['strategyImage']!,
                    imagePath: oracle['imagePath']!,
                    capabilities: getCapabilitiesForOracle(oracle['name']!),
                  );
                },
              ),
            ),
            SizedBox(height: 10.h),

            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 3.sp),
                  height: 6.h,
                  width: _currentPage == index ? 16.sp : 7.sp,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Theme.of(context).primaryColor
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      );
    });
  }
}
