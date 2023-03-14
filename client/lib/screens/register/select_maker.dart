import 'package:flutter/material.dart';
import 'package:client/widgets/register/category_title.dart';
import 'package:client/widgets/register/maker_item.dart';

class SelectMaker extends StatelessWidget {
  const SelectMaker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          width: 50,
          height: 3,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            color: const Color(0xFFEFEFEF),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(
              vertical: 8,
              horizontal: 20
          ),
          child: Row(
            children: [
              categoryTitle(
                  title: '제조사',
                  isSelected: true
              ),
              categoryTitle(
                  title: '차종',
                  isSelected: false
              ),
              categoryTitle(
                  title: '연료',
                  isSelected: false
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 5),
          width: double.infinity,
          height: 1,
          color: const Color(0xFFEFEFEF),
        ),
        const SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text('제조사를 선택해주세요.'),
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(20),
          child: SizedBox(
            width: double.infinity,
            child: Wrap(
              alignment: WrapAlignment.start,
              direction: Axis.horizontal,
              children: [
                MakerItem(
                  makerTitle: '싸피',
                  makerImageUrl: 'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.6435-9/71140183_2565406580147654_6224942049100038144_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=rFRCaBYqX_kAX-6Pv-x&_nc_ht=scontent-ssn1-1.xx&oh=00_AfA_fpZatlF37xtx_gAEwJunxUpppE_QUaVmozu5c9EURA&oe=64364939',
                ),
                MakerItem(
                  makerTitle: '싸피',
                  makerImageUrl: 'https://scontent-ssn1-1.xx.fbcdn.net/v/t1.6435-9/71140183_2565406580147654_6224942049100038144_n.jpg?_nc_cat=104&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=rFRCaBYqX_kAX-6Pv-x&_nc_ht=scontent-ssn1-1.xx&oh=00_AfA_fpZatlF37xtx_gAEwJunxUpppE_QUaVmozu5c9EURA&oe=64364939',
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}