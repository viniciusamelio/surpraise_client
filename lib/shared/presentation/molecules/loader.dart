import 'package:flutter/material.dart';

import '../../../core/core.dart';

class LoaderMolecule extends StatelessWidget {
  const LoaderMolecule({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              color: context.theme.colorScheme.accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
