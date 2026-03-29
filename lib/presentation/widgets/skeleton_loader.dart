import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? Colors.white10 : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.white24 : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}

class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        const SkeletonLoader(width: double.infinity, height: 200, borderRadius: BorderRadius.all(Radius.circular(24))),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) => const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: SkeletonLoader(width: 60, height: 32, borderRadius: BorderRadius.all(Radius.circular(20))),
          )),
        ),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SkeletonLoader(width: 120, height: 24),
            const SkeletonLoader(width: 60, height: 24),
          ],
        ),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 2.0,
          children: List.generate(4, (index) => const SkeletonLoader(width: double.infinity, height: 60)),
        ),
        const SizedBox(height: 30),
        const SkeletonLoader(width: 100, height: 24),
        const SizedBox(height: 15),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.8,
          children: List.generate(4, (index) => const SkeletonLoader(width: double.infinity, height: 150)),
        ),
      ],
    );
  }
}
