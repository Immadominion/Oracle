import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:oracle/core/constants/constants.dart';
import 'package:oracle/core/extensions/widget_extension.dart';
import 'package:oracle/presentation/general_components/top_bar.dart';

class Terminal extends StatefulHookConsumerWidget {
  const Terminal({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TerminalState();
}

class _TerminalState extends ConsumerState<Terminal> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: const TopBarWidget(
        text: "Terminal",
      ),
      body: Padding(
        padding: EdgeInsets.all(14.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontFamily: "Int",
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                prefixIcon: Icon(
                  CupertinoIcons.search,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                ),
                hintText: 'Enter CA or ticker',
                hintStyle: TextStyle(
                  fontSize: 16.sp,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(.6),
                  fontFamily: "Int",
                ),
                filled: true,
                fillColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(.05),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                  borderSide: BorderSide(
                    width: 2,
                    color:
                        Theme.of(context).colorScheme.onSurface.withOpacity(.2),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.sp),
                  borderSide: BorderSide(
                    width: .5,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(.01),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', context),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Main', context, isDisabled: true),
                  SizedBox(width: 8.w),
                  _buildFilterChip('DeFi', context),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Memes', context),
                  SizedBox(width: 8.w),
                  _buildFilterChip('Gaming', context, isDisabled: true),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Recent',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.sp),
            // Recent Cards
            SizedBox(
              height: 90.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCryptoCard(
                      'CHILL', '0.999264', '-3.40%', Colors.blue, context),
                  _buildCryptoCard(
                      'PNUT', '200.288', '-0.38%', Colors.cyan, context),
                  _buildCryptoCard('MOONDENG', '95,108.46', '-1.39%',
                      Colors.orange, context),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Change',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Crypto List with Graphs
            Expanded(
              child: ListView(
                children: [
                  _buildCryptoListTile('BONK', '95,108.46', '-1.39%',
                      Colors.orange, context, 200),
                  _buildCryptoListTile('PEPE', '3,552.20', '-0.68%',
                      Colors.purple, context, 200),
                  _buildCryptoListTile(
                      'SHIBA', '0.028521', '-0.14%', Colors.indigo, context),
                  _buildCryptoListTile(
                      'ORCL', '0.999264', '-3.40%', Colors.blue, context),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

Widget _buildFilterChip(String label, BuildContext context,
    {bool isDisabled = false}) {
  return ChoiceChip(
    label: Text(
      label,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onSurface,
        fontFamily: "Int",
        fontSize: label == 'All' ? 16.sp : 14.sp,
        fontWeight: FontWeight.w600,
      ),
    ).afmPadding(EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h)),
    selected: false,
    disabledColor: isDisabled
        ? Theme.of(context).colorScheme.surface
        : Theme.of(context).colorScheme.onSurface.withOpacity(.2),
    shape: StadiumBorder(
      side: BorderSide(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
          width: .5),
    ),
  );
}

Widget _buildCryptoCard(String ticker, String value, String change, Color color,
    BuildContext context) {
  return Container(
    width: 120,
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(.2),
      borderRadius: BorderRadius.circular(12),
    ),
    padding: const EdgeInsets.all(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ticker,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          change,
          style: const TextStyle(
            color: OracleColors.errorColor,
          ),
        ),
      ],
    ),
  );
}

Widget _buildCryptoListTile(String ticker, String value, String change,
    Color color, BuildContext context,
    [int? quantity]) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: color,
      child: Text(
        ticker[0],
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: "Int",
        ),
      ),
    ),
    title: Text(ticker,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontFamily: "Int",
        )),
    subtitle: quantity != null
        ? Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.yellow[700],
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('×$quantity',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontFamily: "Int",
                    )),
              ),
            ],
          )
        : null,
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          value,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        Text(
          change,
          style: const TextStyle(
            color: OracleColors.errorColor,
          ),
        ),
      ],
    ),
  );
}
