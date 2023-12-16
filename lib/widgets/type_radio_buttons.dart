import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class TypeRadioButtons extends StatelessWidget {
  final List<String> type;
  final String currentType;
  final Function(String) onTypeChanged;

  TypeRadioButtons(
      {required this.type,
      required this.currentType,
      required this.onTypeChanged});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                'نوع عملیات',
                textDirection: ui.TextDirection.rtl,
              ),
            ),
            ListTile(
              title: Text('درآمد'),
              leading: Radio(
                  value: type[0],
                  groupValue: currentType,
                  onChanged: (value) {
                    onTypeChanged(value.toString());
                  }),
            ),
            ListTile(
              title: Text('هزینه'),
              leading: Radio(
                  value: type[1],
                  groupValue: currentType,
                  onChanged: (value) {
                    onTypeChanged(value.toString());
                  }),
            )
          ],
        ),
      ),
    );
  }
}
