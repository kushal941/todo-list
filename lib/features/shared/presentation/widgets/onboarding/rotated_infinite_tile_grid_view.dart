import 'package:flutter/material.dart';
import 'dart:math' as math;

/// A custom widget that displays a rotated infinite tile grid view.
class RotatedInfiniteTileGridView extends StatelessWidget {
  /// Creates a [RotatedInfiniteTileGridView].
  ///
  /// The [scrollController] is used to control the grid scrolling, and the
  /// [itemBuilder] is a function that builds each tile in the grid.
  const RotatedInfiniteTileGridView({
    Key? key,
    required this.scrollController,
    required this.itemBuilder,
  }) : super(key: key);

  /// Scroll controller to control the grid scrolling.
  final ScrollController scrollController;

  /// Builder function to build each tile in the grid.
  final Widget? Function(BuildContext, int) itemBuilder;

  /// Rotation angle for the grid.
  final double gridRotationAngle = math.pi / 18;

  /// Number of tiles in each row.
  final int crossAxisCount = 7;

  /// Spacing between tiles in the grid.
  final double axisSpacing = 5;

  /// Aspect ratio of each tile.
  final double childAspectRatio = 281 / 500;

  @override
  Widget build(BuildContext context) {
    // Calculate the overflow dimensions.
    final double overflowHeight = MediaQuery.of(context).size.height +
        MediaQuery.of(context).size.width * 0.2;
    final double overflowWidth = MediaQuery.of(context).size.width +
        MediaQuery.of(context).size.height * 0.2;

    return OverflowBox(
      // Allows the grid to overflow the screen.
      maxHeight: overflowHeight,
      maxWidth: overflowWidth,
      child: Transform.rotate(
        // Rotates the grid.
        angle: gridRotationAngle,
        child: GridView.builder(
          // Disables manual scrolling.
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          scrollDirection: Axis.horizontal,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: axisSpacing,
            mainAxisSpacing: axisSpacing,
            childAspectRatio: childAspectRatio,
          ),
          itemBuilder: itemBuilder,
        ),
      ),
    );
  }
}
