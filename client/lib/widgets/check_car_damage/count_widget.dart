import 'package:flutter/material.dart';

class CountWidget extends StatefulWidget {
  final String damage_name;
  final int count_num;
  final void Function(String, int) checkChangeCount;

  const CountWidget({
    required this.damage_name,
    required this.count_num,
    required this.checkChangeCount,
  });

  @override
  State<CountWidget> createState() => _CountWidgetState();
}

class _CountWidgetState extends State<CountWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      height: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColorLight,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.damage_name,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Divider(
            thickness: 1.5,
            color: Colors.white,
            indent: 16,
            endIndent: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                // 눌렀을 때 발생하는 효과 제거
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  if (widget.count_num > 0) {
                    int newCount = widget.count_num - 1;
                    widget.checkChangeCount(widget.damage_name, newCount);
                  }
                },
                icon: Icon(
                  Icons.remove_circle,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
              Text(
                '${widget.count_num}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                // 눌렀을 때 발생하는 효과 제거
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: () {
                  int newCount = widget.count_num + 1;
                  widget.checkChangeCount(widget.damage_name, newCount);
                },
                icon: Icon(
                  Icons.add_circle,
                  color: Theme.of(context).primaryColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
