import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanQRCode extends StatefulWidget {
  const ScanQRCode({
    super.key,
  });

  @override
  State<ScanQRCode> createState() => _ScanQRCodeState();
}

class _ScanQRCodeState extends State<ScanQRCode>
    with SingleTickerProviderStateMixin {
  late MobileScannerController cameraController;
  late AnimationController _animationController;
  late Animation<double> _animation;
  bool isCodeDetected = false;

  Future<void> _handleBarcodeDetection(Barcode barcode) async {
    setState(() {
      isCodeDetected = true;
      _animationController.stop();
    });

    // setState(() {
    //   isCodeDetected = false;
    //   _animationController.repeat(reverse: true);
    // });
  }

  @override
  void initState() {
    super.initState();
    cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.noDuplicates,
      returnImage: true,
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scanBoxWidth = 200.w;
    final scanBoxHeight = 300.w;
    final screenSize = MediaQuery.of(context).size;
    return Container(
      width: double.maxFinite,
      height: screenSize.height * .7,
      decoration: BoxDecoration(
          // color: Theme.of(context).colorScheme.onSurface.withOpacity(.7),
          ),
      child: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                if (isCodeDetected) return;

                final barcodes = capture.barcodes;

                if (barcodes.isNotEmpty) {
                  final barcode = barcodes.first;
                  if (barcode.rawValue != null &&
                      barcode.rawValue!.isNotEmpty) {
                    _handleBarcodeDetection(barcode);
                  }
                }
              },
            ),
          ),

          //  // Custom overlay with transparent center
          CustomPaint(
            size: Size(screenSize.width, (screenSize.height * .7)),
            painter: OverlayPainter(
              overlayColor: const Color(0xFF333333).withOpacity(.5),
              scannerWidth: scanBoxWidth + 60.w,
              scannerHeight: scanBoxHeight - 2.h,
              borderRadius: 20.r,
            ),
          ),

          // Scanner Frame with Corner Edges
          Positioned(
            top: 50.h,
            left: 50.sp,
            right: 50.sp,
            child: SizedBox(
              width: scanBoxWidth,
              height: scanBoxHeight,
              child: Stack(
                children: [
                  // Scanner Frame Corners
                  ...List.generate(4, (index) {
                    final isTop = index < 2;
                    final isLeft = index.isEven;
                    return Positioned(
                      top: isTop ? 0 : null,
                      bottom: !isTop ? 0 : null,
                      left: isLeft ? 0 : null,
                      right: !isLeft ? 0 : null,
                      child: Container(
                        width: 80.w,
                        height: 80.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft:
                                Radius.circular(isTop && isLeft ? 20.r : 0),
                            topRight:
                                Radius.circular(isTop && !isLeft ? 20.r : 0),
                            bottomLeft:
                                Radius.circular(!isTop && isLeft ? 20.r : 0),
                            bottomRight:
                                Radius.circular(!isTop && !isLeft ? 20.r : 0),
                          ),
                          border: Border(
                            top: isTop
                                ? BorderSide(
                                    color: const Color(0xFF8246F3), width: 4.sp)
                                : BorderSide.none,
                            bottom: !isTop
                                ? BorderSide(
                                    color: const Color(0xFF8246F3), width: 4.sp)
                                : BorderSide.none,
                            left: isLeft
                                ? BorderSide(
                                    color: const Color(0xFF8246F3), width: 4.sp)
                                : BorderSide.none,
                            right: !isLeft
                                ? BorderSide(
                                    color: const Color(0xFF8246F3), width: 4.sp)
                                : BorderSide.none,
                          ),
                        ),
                      ),
                    );
                  }),

                  // Animated Scanning Line
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value * scanBoxHeight,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 2.sp,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.transparent,
                                isCodeDetected ? Colors.green : Colors.red,
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverlayPainter extends CustomPainter {
  final Color overlayColor;
  final double scannerWidth;
  final double scannerHeight;
  final double borderRadius;

  OverlayPainter({
    required this.overlayColor,
    required this.scannerWidth,
    required this.scannerHeight,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = overlayColor;

    final scannerLeft = (size.width - scannerWidth) / 2;
    final scannerTop = (size.height - scannerHeight) / 4.3;
    final scannerRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(scannerLeft, scannerTop, scannerWidth, scannerHeight),
      Radius.circular(borderRadius),
    );

    // Create path for entire screen
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // Cut out scanner area
    path.addRRect(scannerRect);

    // Set fillType to evenOdd to create a transparent window effect
    path.fillType = PathFillType.evenOdd;

    // Draw the overlay with the transparent center
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
