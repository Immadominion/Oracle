import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/views/home/widgets/skip_n_ape.dart';
import 'package:oracle/presentation/views/home/widgets/top_bar.dart';
import 'package:oracle/presentation/views/home/widgets/suggestion_card_stack.dart';

enum SwipeDirection {
  left,
  right,
}

final swipeProvider = StateProvider<SwipeDirection?>((ref) => null);

class Home extends StatefulHookConsumerWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: const HomeAppBar(),
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bottomPadding = 16.h;
              final horizontalPadding = 20.w;
              final skipAndApeHeight = 45.h;
              final cardStackHeight =
                  constraints.maxHeight - skipAndApeHeight - bottomPadding;

              return Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    height: cardStackHeight,
                    child: const SuggestionCardStack(),
                  ),
                  AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut,
                    offset: const Offset(0, 0),
                    child: const SkipAndApe().afmPadding(
                      EdgeInsets.only(
                        left: horizontalPadding,
                        right: horizontalPadding,
                        top: 5.h,
                        bottom: 2.h,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
