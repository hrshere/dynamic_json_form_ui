import 'package:flutter/material.dart';

import '../../../../utils/colors_constant.dart';


class NonMandatoryTitle extends StatelessWidget {
  final String text;

  const NonMandatoryTitle({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: text,
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(color: TextColor.black),
          ),
        ],
      ),
    );
  }
}
