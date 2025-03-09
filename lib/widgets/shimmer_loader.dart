import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoader extends StatelessWidget {
  const ShimmerLoader(
      {super.key,
      required this.width,
      required this.height,
      required this.isCircular});

  final double width;
  final double height;
  final bool isCircular;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900]!,
          // circular if true
          borderRadius: isCircular ? null : BorderRadius.circular(10),
          shape: isCircular ? BoxShape.circle : BoxShape.rectangle
        ),
      ),
    );
  }
}
