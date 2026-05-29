import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../utils/responsive_utils.dart';

class SkeletonSectionCard extends StatelessWidget {
  const SkeletonSectionCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isCompactPortrait = ResponsiveUtils.isCompact(context) && ResponsiveUtils.isPortrait(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title skeleton
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        Card(
          elevation: 2,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 24),
          child: Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: isCompactPortrait
                ? _buildVerticalLayout()
                : _buildHorizontalLayout(),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image skeleton
        Container(
          height: 200,
          width: double.infinity,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildBodyTextSkeleton(),
        ),
      ],
    );
  }

  Widget _buildHorizontalLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Image skeleton
        Expanded(
          flex: 2,
          child: Container(
            height: 150,
            color: Colors.white,
          ),
        ),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildBodyTextSkeleton(),
          ),
        ),
      ],
    );
  }

  Widget _buildBodyTextSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: double.infinity, height: 14, color: Colors.white),
        const SizedBox(height: 8),
        Container(width: double.infinity, height: 14, color: Colors.white),
        const SizedBox(height: 8),
        Container(width: double.infinity, height: 14, color: Colors.white),
        const SizedBox(height: 8),
        Container(width: 200, height: 14, color: Colors.white),
      ],
    );
  }
}
