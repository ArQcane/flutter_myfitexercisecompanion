import 'package:flutter/material.dart';

class SingleMessage extends StatefulWidget {
  final String message;
  final bool isMe;

  SingleMessage({
    required this.message,
    required this.isMe,
  });

  @override
  State<SingleMessage> createState() => _SingleMessageState();
}

class _SingleMessageState extends State<SingleMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(16),
          constraints: BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
            color: widget.isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceTint,
            borderRadius: BorderRadius.all(Radius.circular(12))
          ),
          child: Text(widget.message, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,),),
        )
      ],
    );
  }
}
