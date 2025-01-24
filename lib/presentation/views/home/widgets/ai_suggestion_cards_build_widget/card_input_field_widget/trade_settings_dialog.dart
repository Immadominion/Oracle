import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TradingSettingsDialog extends StatefulWidget {
  final double currentSlippage;
  final double currentMaxTxFee;
  final bool currentMevProtection;
  final Color color;

  const TradingSettingsDialog({
    super.key,
    required this.currentSlippage,
    required this.currentMaxTxFee,
    required this.currentMevProtection,
    required this.color,
  });

  @override
  State<TradingSettingsDialog> createState() => _TradingSettingsDialogState();
}

class _TradingSettingsDialogState extends State<TradingSettingsDialog> 
    with SingleTickerProviderStateMixin {
  late TextEditingController _slippageController;
  late TextEditingController _maxTxFeeController;
  late bool _mevProtection;

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _slippageController = TextEditingController(
      text: widget.currentSlippage.toStringAsFixed(2)
    );
    _maxTxFeeController = TextEditingController(
      text: widget.currentMaxTxFee.toStringAsFixed(4)
    );
    _mevProtection = widget.currentMevProtection;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _slippageController.dispose();
    _maxTxFeeController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleConfirm() {
    // Validate slippage
    final slippageValue = double.tryParse(_slippageController.text.replaceAll('%', ''));
    if (slippageValue == null || slippageValue < 0 || slippageValue > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid slippage (0-50%)'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
      );
      return;
    }

    // Validate max transaction fee
    final txFeeValue = double.tryParse(_maxTxFeeController.text);
    if (txFeeValue == null || txFeeValue < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid transaction fee'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    Navigator.pop(context, {
      'slippage': slippageValue,
      'maxTxFee': txFeeValue,
      'mevProtection': _mevProtection,
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Text(
                'Trading Settings',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h),

              // Slippage Input
              _buildSettingInput(
                label: 'Slippage',
                controller: _slippageController,
                suffixText: '%',
                keyboardType: TextInputType.number,
                color: widget.color,
              ),
              SizedBox(height: 16.h),

              // Max Transaction Fee Input
              _buildSettingInput(
                label: 'Max Transaction Fee',
                controller: _maxTxFeeController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                color: widget.color,
              ),
              SizedBox(height: 16.h),

              // MEV Protection Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'MEV Protection',
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  Switch.adaptive(
                    value: _mevProtection,
                    onChanged: (bool value) {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _mevProtection = value;
                      });
                    },
                    activeColor: widget.color,
                  ),
                ],
              ),
              if (_mevProtection)
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'Send with MEV protection to a JITO validator',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.green,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                Padding(
                  padding: EdgeInsets.only(top: 8.h),
                  child: Text(
                    'MEV protection is off, you might be subject to sandwich attacks, please monitor your slippage settings!',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.orange,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              SizedBox(height: 24.h),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 12.h),
                    ),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16.sp,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handleConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.color,
                      padding: EdgeInsets.symmetric(
                          horizontal: 32.w, vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Confirm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingInput({
    required String label,
    required TextEditingController controller,
    required Color color,
    String? suffixText,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
        color: color,
      ),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: color.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixText: suffixText,
        suffixStyle: TextStyle(
          color: color,
          fontSize: 16.sp,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
    );
  }
}