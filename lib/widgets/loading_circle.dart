import 'package:flutter/material.dart';

class LoadingCircle extends StatelessWidget {
  bool overlayVisibility;
  LoadingCircle({this.overlayVisibility = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: overlayVisibility ? Theme.of(context).focusColor : null,
      ),
      child: const CircularProgressIndicator(),
    );
  }
}