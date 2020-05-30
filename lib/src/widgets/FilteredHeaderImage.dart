import 'package:flutter/material.dart';

class FilteredHeaderImage extends StatelessWidget {
  Widget child;

  FilteredHeaderImage({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.grey.withOpacity(0.7),
          BlendMode.modulate,
        ),
        child: child,
      ),
    );
  }
}
