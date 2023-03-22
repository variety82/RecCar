import 'package:flutter/material.dart';

class registerLine extends StatefulWidget {
  final String category;
  final String content;
  final bool isLastLine;
  final bool isSelected;

  const registerLine({
    super.key, required this.category, required this.content, required this.isLastLine, required this.isSelected,
  });

  @override
  State<registerLine> createState() => _registerLineState();
}

class _registerLineState extends State<registerLine> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  widget.category,
                  style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).disabledColor
                  ),
                ),
              ),
              Text(
                widget.content,
                style: TextStyle(
                    color: widget.isSelected
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).disabledColor
                ),
              ),
            ],
          ),
        ),

        Offstage(
          offstage: widget.isLastLine,
          child: Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFEFEFEF),
          ),
        )
      ],
    );
  }
}