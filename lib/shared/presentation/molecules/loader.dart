import 'package:flutter/material.dart';

import '../../../core/external_dependencies.dart';

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
          LottieBuilder.asset(
            "assets/animations/loading.json",
            width: 120,
            height: 120,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
