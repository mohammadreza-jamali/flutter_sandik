import 'package:flutter/material.dart';

class HintColorContainer extends StatelessWidget {
  const HintColorContainer(this.child,{Key? key}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return  Container(
              color: Theme.of(context).appBarTheme.backgroundColor,
              padding: EdgeInsets.all(4),
              child:child
              );
  }
}