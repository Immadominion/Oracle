import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oracle/presentation/views/home/home.dart';

import 'ai_suggestion_cards_build_widget/chart_data_point.dart';
import 'suggestion_card_content.dart';

class SuggestionCardStack extends ConsumerStatefulWidget {
  const SuggestionCardStack({super.key});

  @override
  SuggestionCardStackState createState() => SuggestionCardStackState();
}

class SuggestionCardStackState extends ConsumerState<SuggestionCardStack>
    with SingleTickerProviderStateMixin {
  List<int> cardData = List.generate(20, (index) => index + 1);
  int visibleCards = 3;
  double _panX = 0;
  int _currentIndex = 0;
  bool _isDragging = false;

  // Animation controller for programmatic swipes
  late AnimationController _swipeController;
  late Animation<Offset> _swipeAnimation;

  // Constants for animation and gesture detection
  static const double swipeThreshold = 50.0;
  static const double rotationFactor = 0.02;
  static const Duration animationDuration = Duration(milliseconds: 200);
  static const Curve animationCurve = Curves.easeOutCubic;

  // Enhanced cascade effect constants
  static const double scaleFactorBetweenCards = 0.08;
  static const double verticalOffsetBetweenCards = -25.0;

  @override
  void initState() {
    super.initState();
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.0, 0),
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    _swipeController.addStatusListener(_handleSwipeStatus);
  }

  @override
  void dispose() {
    _swipeController.dispose();
    super.dispose();
  }

  void _handleSwipeStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _swipeController.reset();
      onSwiped(
          0,
          _currentDirection == SwipeDirection.right
              ? DismissDirection.startToEnd
              : DismissDirection.endToStart);
    }
  }

  SwipeDirection? _currentDirection;

  void triggerSwipe(SwipeDirection direction) {
    if (_swipeController.isAnimating) return;

    _currentDirection = direction;
    final double endX = direction == SwipeDirection.right ? 2.0 : -2.0;

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(endX, 0),
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));

    _swipeController.forward();
  }

  void onSwiped(int index, DismissDirection direction) {
    setState(() {
      if (cardData.isNotEmpty) {
        cardData.removeAt(index);
        _panX = 0;
        _currentIndex = 0;
        _isDragging = false;
      }
    });
  }

  double _getScale(int index) {
    if (_isDragging && index == 0) {
      return 1.2;
    }
    return 1.2 - (index * scaleFactorBetweenCards);
  }

  double _getYOffset(int index) {
    if (_isDragging && index > 0) {
      return (index - 1) * verticalOffsetBetweenCards;
    }
    return index * verticalOffsetBetweenCards;
  }

  double _getRotation() {
    return _panX * rotationFactor;
  }

  @override
  Widget build(BuildContext context) {
    // Listen to swipe commands
    ref.listen(swipeProvider, (previous, next) {
      if (next != null) {
        triggerSwipe(next as SwipeDirection);
        ref.read(swipeProvider.notifier).state = null;
      }
    });

    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth * 0.77;
        double height = constraints.maxHeight;

        return SizedBox(
          height: height,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: List.generate(
              cardData.length,
              (index) {
                if (index >= visibleCards) {
                  return const SizedBox.shrink();
                }

                return AnimatedPositioned(
                  duration: animationDuration,
                  curve: animationCurve,
                  top: (height - (height * 0.8)) / 2 + _getYOffset(index),
                  child: GestureDetector(
                    onHorizontalDragStart: (_) {
                      if (!_swipeController.isAnimating) {
                        setState(() => _isDragging = true);
                      }
                    },
                    onHorizontalDragUpdate: (details) {
                      if (!_swipeController.isAnimating) {
                        setState(() {
                          _panX += details.delta.dx;
                        });
                      }
                    },
                    onHorizontalDragEnd: (details) {
                      if (!_swipeController.isAnimating) {
                        if (_panX.abs() > swipeThreshold) {
                          onSwiped(
                            index,
                            _panX > 0
                                ? DismissDirection.startToEnd
                                : DismissDirection.endToStart,
                          );
                        } else {
                          setState(() {
                            _panX = 0;
                            _isDragging = false;
                          });
                        }
                      }
                    },
                    child: AnimatedBuilder(
                      animation: _swipeAnimation,
                      builder: (context, child) {
                        double offsetX = index == 0
                            ? (_isDragging
                                ? _panX
                                : _swipeAnimation.value.dx * width)
                            : 0;
                        double rotation = index == 0
                            ? (_isDragging
                                ? _getRotation()
                                : _swipeAnimation.value.dx * rotationFactor)
                            : 0;

                        return Transform.translate(
                          offset: Offset(offsetX, 0),
                          child: Transform.rotate(
                            angle: rotation,
                            child: AnimatedScale(
                              duration: animationDuration,
                              curve: animationCurve,
                              scale: _getScale(index),
                              child: TweenAnimationBuilder<double>(
                                duration: animationDuration,
                                tween: Tween<double>(
                                  begin: 0,
                                  end: index == 0 ? 1 : 0.8 - (index * 0.1),
                                ),
                                builder: (context, value, child) {
                                  return Opacity(
                                    opacity: value,
                                    child: SizedBox(
                                      width: width,
                                      height: height * 0.8,
                                      child: Card(
                                        elevation: 8 * value,
                                        shadowColor:
                                            Colors.black.withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          side: BorderSide(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        child: Center(
                                          child: SuggestionCardContent(
                                            ticker: 'DOGE',
                                            launchDate: DateTime(2013, 12, 6),
                                            aiAnalysis: '...',
                                            chartData: [
                                              ChartDataPoint(
                                                  DateTime(2024, 1, 1), 0.08),
                                              ChartDataPoint(
                                                  DateTime(2024, 1, 2), 0.09),
                                              // ... more data
                                            ],
                                            socials: const {/* ... */},
                                            currentPrice: 0.087,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ).reversed.toList(),
          ),
        );
      },
    );
  }
}
