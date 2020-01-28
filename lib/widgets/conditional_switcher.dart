import 'package:flutter/material.dart';

class ConditionalSwitcher extends StatelessWidget {
  final bool statement;
  final WidgetBuilder trueItemBuilder;
  final WidgetBuilder falseItemBuilder;
  ConditionalSwitcher({
    @required this.statement,
    @required this.falseItemBuilder,
    @required this.trueItemBuilder,
  }) : assert(falseItemBuilder != null && trueItemBuilder != null);
  @override
  Widget build(BuildContext context) =>
      statement ? trueItemBuilder(context) : falseItemBuilder(context);
}
