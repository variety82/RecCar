import 'package:flutter/material.dart';
import 'package:client/widgets/detail/damage_part_tag.dart';

class DamageDetail extends StatelessWidget {

  final Map<String, dynamic> damageInfo;

  const DamageDetail({
    super.key, required this.damageInfo,
  });

  @override
  Widget build(BuildContext context) {
    
    String damageImageUrl = damageInfo['damageImageUrl'];
    String damageDate = damageInfo['damageDate'];

    int scratchCount = damageInfo['scratch'];
    int breakageCount = damageInfo['breakage'];
    int crushedCount = damageInfo['crushed'];
    int separatedCount = damageInfo['separated'];
    
    bool isScratched = scratchCount > 0;
    bool isBreaked = breakageCount > 0;
    bool isCrushed = crushedCount > 0;
    bool isSeparated = separatedCount > 0;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            top: 30,
          ),
          child: Container(
            height: 1,
            width: double.infinity,
            color: const Color(0xFFEFEFEF),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            right: 10,
            left: 10,
            top: 20,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(7),
                child: Container(
                  height: 70,
                  width: 70,
                  child: Image.network(
                    damageImageUrl, // 이미지 URL
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Offstage(
                        offstage: !isScratched,
                        child: const DamagePartTag(
                          part: '스크래치',
                        ),
                      ),
                      Offstage(
                        offstage: !isBreaked,
                        child: const DamagePartTag(
                          part: '파손',
                        ),
                      ),
                      Offstage(
                        offstage: !isCrushed,
                        child: const DamagePartTag(
                          part: '찌그러짐',
                        ),
                      ),
                      Offstage(
                        offstage: !isSeparated,
                        child: const DamagePartTag(
                          part: '이격',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    damageDate,
                    style: TextStyle(
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

