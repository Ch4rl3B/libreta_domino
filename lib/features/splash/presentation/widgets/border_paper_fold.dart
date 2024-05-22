import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BorderPaperFold extends StatelessWidget {
  const BorderPaperFold({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withAlpha(90),
        border: Border(
          top: BorderSide(color: Theme.of(context).shadowColor),
          left: BorderSide(
            color: Theme.of(context).shadowColor,
            width: 3.0,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: radiusCircular(24),
        ),
      ),
      child: const SizedBox.square(
        dimension: 42,
      ),
    );
  }
}
