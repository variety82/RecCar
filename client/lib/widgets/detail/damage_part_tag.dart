import 'package:flutter/material.dart';

class DamagePartTag extends StatelessWidget {

  final String part;

  const DamagePartTag({
    super.key, required this.part,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 2,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 3,
        ),
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColorLight,
            borderRadius: const BorderRadius.all(
                Radius.circular(7)
            )
        ),
        child: Text(
          part,
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}