import 'package:flutter/material.dart';
import '../core/theme.dart';

class SkeletonLoader extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.2, end: 0.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AgroTheme.surface.withOpacity(_animation.value),
            borderRadius: widget.borderRadius ?? AgroTheme.radiusSm,
            border: Border.all(color: AgroTheme.border.withOpacity(0.1)),
          ),
        );
      },
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AgroTheme.surface,
        borderRadius: AgroTheme.radius,
        border: Border.all(color: AgroTheme.border),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SkeletonLoader(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          const SizedBox(height: 12),
          const SkeletonLoader(width: 120, height: 16),
          const SizedBox(height: 6),
          const SkeletonLoader(width: 80, height: 12),
          const SizedBox(height: 12),
          Row(
            justifyAxisAlignment: MainAxisAlignment.between,
            children: const [
              SkeletonLoader(width: 70, height: 20),
              SkeletonLoader(width: 32, height: 32, borderRadius: BorderRadius.all(Radius.circular(16))),
            ],
          ),
        ],
      ),
    );
  }
}
