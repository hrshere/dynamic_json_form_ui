import 'package:flutter/material.dart';

import '../../../../utils/colors_constant.dart';

class MandatoryTitle extends StatelessWidget {
  final String text;

  const MandatoryTitle({
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
                ?.copyWith(color:  TextColor.black),
          ),
          TextSpan(
            text: ' *',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
          ),
        ],
      ),
    );
  }
}
