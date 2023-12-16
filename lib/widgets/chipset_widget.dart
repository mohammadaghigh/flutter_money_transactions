import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:money_transaction/const/const.dart';

class TypeChipButtons extends StatelessWidget {
  final List<String> type;
  final String currentType;
  final Function(String) onTypeChanged;

  TypeChipButtons({
    required this.type,
    required this.currentType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: ui.TextDirection.rtl,
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
          Wrap(
            spacing: 10.0,
            children: type.map((String value) {
              return Container(
                width: 160, // Adjust the width of the Container
                padding: EdgeInsets.all(12.0), // Adjust the padding
                child: ChoiceChip(
                  selected: currentType != value,
                  label: Container(
                    width: 100,
                    child: Center(
                      child: Text(
                        value == 'income' ? 'درآمد' : 'هزینه',
                        style: TextStyle(
                          color: currentType == value
                              ? Colors.white
                              : Colors.black,
                          fontWeight: currentType == value
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  backgroundColor: currentType == value
                      ? AppColor.blueColor
                      : AppColor.greyColor,
                  onSelected: (isSelected) {
                    onTypeChanged(value);
                  },
                  selectedColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: currentType == value
                          ? AppColor.blueColor
                          : Colors.transparent,
                      width: 2.0,
                    ),
                    borderRadius:
                        BorderRadius.circular(8.0), // Adjust the border radius
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
