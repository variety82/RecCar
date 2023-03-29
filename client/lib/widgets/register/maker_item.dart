import 'package:flutter/material.dart';


class MakerItem extends StatefulWidget {
  final int makerId;
  final String makerTitle;
  final String makerLogoUrl;
  final ValueChanged<int> changeSelectedItem;
  final bool isSelected;
  final void Function(int, String, String) updateSelectedMaker;


  const MakerItem({
    super.key, required this.makerTitle, required this.makerLogoUrl, required this.makerId, required this.isSelected, required this.changeSelectedItem, required this.updateSelectedMaker,
  });

  @override
  State<MakerItem> createState() => _MakerItemState();
}

class _MakerItemState extends State<MakerItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                widget.changeSelectedItem(widget.makerId);
                widget.updateSelectedMaker(widget.makerId, widget.makerTitle, widget.makerLogoUrl);
              });
            },
            child: Container(
              width: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: widget.isSelected ? Theme.of(context).primaryColor : const Color(0xFFEFEFEF),
                  width: 2.0,
                ),
              ),
              child: ClipOval(
                child: Container(
                  width: 60,
                  height: 60,
                  padding: EdgeInsets.all(8.0), // 테두리와 이미지 사이의 간격을 조절합니다.
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Image.network(
                      widget.makerLogoUrl,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5,),
          Text(
            widget.makerTitle,
            style: TextStyle(
              fontSize: 12,
              color: widget.isSelected ? Colors.black : Theme.of(context).disabledColor ,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}