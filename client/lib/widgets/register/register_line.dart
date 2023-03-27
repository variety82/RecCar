import 'package:flutter/material.dart';

class registerLine extends StatefulWidget {
  final String category;
  final String? content;
  final bool isLastLine;
  final bool isSelected;
  final bool isInput;
  final void Function(String)? updateInput;
  final String? placeholder;
  final FocusNode? focusNode;
  final VoidCallback? onSubmitted;


  const registerLine({
    Key? key,
    required this.category,
    this.content,
    required this.isLastLine,
    required this.isSelected,
    required this.isInput,
    this.updateInput,
    this.placeholder,
    this.focusNode, this.onSubmitted,
  }) : super(key: key);

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
              widget.isInput
                  ? Expanded(
                child: Center(
                  child: Container(
                    height: 20,
                    child: TextField(
                      focusNode: widget.focusNode,
                      onSubmitted: (_) {
                        if (widget.onSubmitted != null) {
                          widget.onSubmitted!();
                        }
                      },
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        hintText: widget.placeholder,
                        hintStyle: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14
                        ),
                      ),
                      style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 14,
                      ),
                      onChanged: (String text) {
                        if (widget.updateInput != null) {
                          widget.updateInput!(text);
                        }
                      },
                    ),
                  ),
                ),
              )
                  : Text(
                widget.content ?? '',
                style: TextStyle(
                    color: widget.isSelected
                        ? Theme.of(context).secondaryHeaderColor
                        : Theme.of(context).disabledColor
                ),
              ),
              // Text(
              //   widget.content,
              //   style: TextStyle(
              //       color: widget.isSelected
              //           ? Theme.of(context).secondaryHeaderColor
              //           : Theme.of(context).disabledColor
              //   ),
              // ),
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