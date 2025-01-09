import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/views/home/widgets/skip_n_ape.dart';
import 'package:oracle/presentation/views/home/widgets/top_bar.dart';
import 'package:oracle/presentation/views/home/widgets/suggestion_card_stack.dart';

class Home extends StatefulHookConsumerWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 25.h),
              const SuggestionCardStack(),
              const SkipAndApe().afmPadding(
                EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
