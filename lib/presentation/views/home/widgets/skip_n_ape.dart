import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/presentation/views/wallet/swap.dart';

import '../home.dart';

class SkipAndApe extends ConsumerWidget {
  const SkipAndApe({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _AnimatedButton(
            onPressed: () {
              debugPrint("Skip pressed");
              ref.read(swipeProvider.notifier).state = SwipeDirection.left;
            },
            backgroundColor:
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
            borderColor: Theme.of(context).colorScheme.primary,
            icon: CupertinoIcons.bin_xmark,
            label: 'Skip',
            isOutlined: true,
          ),
        ),
        SizedBox(width: 16.sp),
        Expanded(
          child: _AnimatedButton(
            onPressed: () {
              debugPrint("Ape pressed");
              ref.read(swipeProvider.notifier).state = SwipeDirection.right;
              Timer(
                const Duration(milliseconds: 300),
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JupiterSwapScreen(),
                    ),
                  );
                },
              );
            },
            backgroundColor: Theme.of(context).colorScheme.primary,
            icon: CupertinoIcons.checkmark_circle,
            label: 'Ape',
            isOutlined: false,
          ),
        ),
      ],
    );
  }
}

class _AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color? borderColor;
  final IconData icon;
  final String label;
  final bool isOutlined;

  const _AnimatedButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.icon,
    required this.label,
    this.borderColor,
    this.isOutlined = false,
  });

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: widget.isOutlined
          ? OutlinedButton(
              onPressed: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                widget.onPressed();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                side:
                    BorderSide(color: widget.borderColor ?? Colors.transparent),
                padding: EdgeInsets.symmetric(
                  horizontal: 43.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: _ButtonContent(
                label: widget.label,
                icon: widget.icon,
                context: context,
              ),
            )
          : ElevatedButton(
              onPressed: () {
                _controller.forward().then((_) {
                  _controller.reverse();
                });
                widget.onPressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: widget.backgroundColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 43.w,
                  vertical: 14.h,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.r),
                ),
              ),
              child: _ButtonContent(
                label: widget.label,
                icon: widget.icon,
                context: context,
              ),
            ),
    );
  }
}

class _ButtonContent extends StatelessWidget {
  final String label;
  final IconData icon;
  final BuildContext context;

  const _ButtonContent({
    required this.label,
    required this.icon,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontFamily: "Int",
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        Icon(
          size: 20.sp,
          icon,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ],
    );
  }
}
