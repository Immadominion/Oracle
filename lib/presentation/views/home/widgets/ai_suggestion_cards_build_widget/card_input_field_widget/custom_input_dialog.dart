// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomInputDialog extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final Function(String) onChanged;
  final List<String> percentageTags;
  final Color color;

  const CustomInputDialog({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
    required this.percentageTags,
    required this.color,
  });

  @override
  State<CustomInputDialog> createState() => CustomInputDialogState();
}

class CustomInputDialogState extends State<CustomInputDialog>
    with SingleTickerProviderStateMixin {
  late TextEditingController tempController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  int? _selectedTagIndex;

  @override
  void initState() {
    super.initState();
    tempController = TextEditingController(text: widget.controller.text);
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();

    if (tempController.text.isNotEmpty) {
      _selectedTagIndex = widget.percentageTags.indexOf(tempController.text);
    }
  }

  @override
  void dispose() {
    tempController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleTagSelection(String tag, int index) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedTagIndex = index;
      tempController.text = tag;
    });
    widget.onChanged(tag);
  }

  void _handleConfirm() {
    if (tempController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a percentage value'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
      );
      return;
    }

    double? value = double.tryParse(tempController.text.replaceAll('%', ''));
    if (value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid number'),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        ),
      );
      return;
    }

    HapticFeedback.mediumImpact();
    widget.onChanged(tempController.text);
    Navigator.pop(context, tempController.text);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on the screen width
    final screenWidth = MediaQuery.of(context).size.width;
    const desiredColumnWidth = 80.0;
    final columnsCount = (screenWidth / desiredColumnWidth).floor().clamp(2, 3);

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 8,
        backgroundColor: Theme.of(context).colorScheme.surface,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Title with Icon
                Row(
                  children: [
                    Icon(
                      widget.label == 'TP'
                          ? Icons.trending_up
                          : Icons.trending_down,
                      color: widget.color,
                      size: 24.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Set ${widget.label} Percentage',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Input Field
                TextFormField(
                  controller: tempController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: widget.color,
                  ),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: widget.color.withOpacity(0.1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: '0.00',
                    suffixText: '%',
                    suffixStyle: TextStyle(
                      color: widget.color,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Percentage Tags Grid
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columnsCount,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8.w,
                    mainAxisSpacing: 8.h,
                  ),
                  itemCount: widget.percentageTags.length,
                  itemBuilder: (context, index) {
                    final tag = widget.percentageTags[index];
                    final isSelected = _selectedTagIndex == index;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => _handleTagSelection(tag, index),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? widget.color
                                  : widget.color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: widget.color
                                    .withOpacity(isSelected ? 1 : 0.5),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '$tag%',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : widget.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
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
      ),
    );
  }
}
