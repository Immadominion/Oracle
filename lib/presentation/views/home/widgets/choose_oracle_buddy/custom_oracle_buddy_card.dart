import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomOracleSetupPage extends HookConsumerWidget {
  const CustomOracleSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(context, currentPage.value),

          // Page View
          Expanded(
            child: PageView(
              controller: pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => currentPage.value = page,
              children: [
                _BaseOracleSelectionPage(
                  onNext: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                ),
                _OracleIdentityPage(
                  onNext: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  onPrevious: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                ),
                _TradingStrategyPage(
                  onNext: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  onPrevious: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                ),
                _RiskManagementPage(
                  onNext: () => pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                  onPrevious: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                ),
                _AdvancedConfigPage(
                  onFinish: () {
                    // Implement save and navigate logic
                    Navigator.pop(context);
                  },
                  onPrevious: () => pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator(BuildContext context, int currentPage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: currentPage == index ? 4.w : 2.w,
            height: 4.h,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: currentPage == index
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

// Base Oracle Selection Page
class _BaseOracleSelectionPage extends StatelessWidget {
  final VoidCallback onNext;

  const _BaseOracleSelectionPage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              'Create your custom AI buddy in 5 steps\nStart off a base oracle, or create a custom one',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          SizedBox(height: 16.h),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: .7,
                crossAxisSpacing: 3.w,
                mainAxisSpacing: 4.h,
              ),
              itemCount: 5,
              itemBuilder: (context, index) {
                if (index == 4) {
                  return _buildCustomStartCard(context);
                }
                return _buildOracleStartCard(context, _getOracleName(index));
              },
            ),
          ),
          Center(
            child: ElevatedButton(
              onPressed: onNext,
              child: const Text('Next: Oracle Identity'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOracleStartCard(BuildContext context, String oracleName) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundImage: AssetImage(
                'assets/images/oracle_card/${oracleName.toLowerCase()}.jpg'),
          ),
          SizedBox(height: 4.h),
          Text(
            oracleName,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomStartCard(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            CupertinoIcons.plus_circle,
            size: 40.r,
            color: Theme.of(context).primaryColor,
          ),
          SizedBox(height: 4.h),
          Text(
            'Create Custom',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  String _getOracleName(int index) {
    switch (index) {
      case 0:
        return 'Mommy';
      case 1:
        return 'Normie';
      case 2:
        return 'Whale';
      case 3:
        return 'Megalodon';
      default:
        return '';
    }
  }
}

// Similar implementation for other pages (_OracleIdentityPage, _TradingStrategyPage, etc.)
// Would include detailed configuration options and interactive UI elements

class _OracleIdentityPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _OracleIdentityPage({required this.onNext, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Create Your Oracle Identity',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Oracle Name',
              prefixIcon: const Icon(Icons.person),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Oracle Bio',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.description),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onPrevious,
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: const Text('Next: Trading Strategy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Implement similar detailed pages for Trading Strategy, Risk Management, Advanced Config

class _TradingStrategyPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _TradingStrategyPage({required this.onNext, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Define Trading Strategy',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Add trading strategy configuration widgets
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onPrevious,
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: const Text('Next: Risk Management'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RiskManagementPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const _RiskManagementPage({required this.onNext, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Risk Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Add risk management configuration widgets
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onPrevious,
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: onNext,
                child: const Text('Next: Advanced Config'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdvancedConfigPage extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback onPrevious;

  const _AdvancedConfigPage({required this.onFinish, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Advanced Configuration',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          // Add advanced configuration widgets
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: onPrevious,
                child: const Text('Back'),
              ),
              ElevatedButton(
                onPressed: onFinish,
                child: const Text('Create Oracle Buddy'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
