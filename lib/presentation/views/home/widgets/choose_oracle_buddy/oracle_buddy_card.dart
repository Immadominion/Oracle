import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oracle/data/controllers/choose_oracle_controller.dart';

import 'buddy_icon_info.dart';

class OracleBuddyCard extends StatefulWidget {
  final String name;
  final String bio;
  final String riskLevel;
  final String riskImage;
  final String assets;
  final String assetsImage;
  final String strategy;
  final String strategyImage;
  final String imagePath;
  final List<OracleCapability> capabilities;

  const OracleBuddyCard({
    super.key,
    required this.name,
    required this.riskLevel,
    required this.assets,
    required this.strategy,
    required this.imagePath,
    required this.bio,
    required this.riskImage,
    required this.strategyImage,
    required this.assetsImage,
    required this.capabilities,
  });

  @override
  OracleBuddyCardState createState() => OracleBuddyCardState();
}

class OracleCapability {
  final String name;
  final bool isActive;

  OracleCapability({required this.name, this.isActive = false});
}

class OracleBuddyCardState extends State<OracleBuddyCard> {
  List<String> get _oracles => ['Mommy', 'Auntie', 'Uncle', 'Grandpa'];

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      return LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.85,
          child: GestureDetector(
            onTap: () {
              ref
                  .read(chooseOracleControllerProvider)
                  .setSelectedIndex(_oracles.indexOf(widget.name));
            },
            child: Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(widget.imagePath),
                    ),
                    SizedBox(height: 4.h),
                    // Name
                    Text(
                      widget.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Int',
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      widget.bio,
                      textAlign: TextAlign.center,
                      maxLines: 7,
                      softWrap: true,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    // Icons and Descriptions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: buildIconInfo(
                            widget.riskImage,
                            widget.riskLevel,
                          ),
                        ),
                        Expanded(
                          child: buildIconInfo(
                            widget.assetsImage,
                            widget.assets,
                          ),
                        ),
                        Expanded(
                          child: buildIconInfo(
                            widget.strategyImage,
                            widget.strategy,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Capabilities Section
                    _buildCapabilitiesSection(),

                    const Spacer(),
                    // Select Button
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(chooseOracleControllerProvider)
                            .setSelectedIndex(_oracles.indexOf(widget.name));
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        fixedSize: Size(
                          constraints.maxWidth * 0.65,
                          35.h,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 8.h,
                        ),
                      ),
                      child: Text('Select ${widget.name}'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  Widget _buildCapabilitiesSection() {
    // Default capabilities if none are provided
    final capabilities = widget.capabilities.isNotEmpty
        ? widget.capabilities
        : [
            OracleCapability(name: 'Real-time Market Data', isActive: true),
            OracleCapability(name: 'Custom GPT Access', isActive: false),
            OracleCapability(name: 'Twitter Scanner', isActive: true),
            OracleCapability(name: 'Website Validation', isActive: false),
            OracleCapability(name: 'Telegram Channel Checks', isActive: true),
            OracleCapability(name: 'Whale Wallet Checks', isActive: false),
            OracleCapability(name: 'Bundle Buy Checks', isActive: true),
            OracleCapability(name: 'Market Structure Analysis', isActive: true),
            OracleCapability(name: 'Relevant News Access', isActive: false),
          ];

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.scrim.withAlpha(100),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 12.w,
        vertical: 6.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...capabilities.map((capability) => _buildCapabilityRow(capability)),
        ],
      ),
    );
  }

  Widget _buildCapabilityRow(OracleCapability capability) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              capability.name,
              style: TextStyle(
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
          Icon(
            capability.isActive
                ? CupertinoIcons.check_mark_circled
                : CupertinoIcons.xmark_circle,
            color: capability.isActive ? Colors.green : Colors.red,
            size: 15.sp,
          ),
        ],
      ),
    );
  }
}
