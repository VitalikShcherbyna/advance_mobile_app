import 'package:flutter/material.dart';

import '../style_provider.dart';

class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation(
            StylesProvider.of(context).colors.primaryColor),
      ),
    );
  }
}
