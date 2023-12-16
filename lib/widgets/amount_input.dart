import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:money_transaction/const/const.dart';

class AmountInput extends StatelessWidget {
  final FocusNode focusNode;
  final TextEditingController controller;

  AmountInput({required this.focusNode, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Directionality(
        textDirection: ui.TextDirection.rtl,
        child: TextField(
          keyboardType: TextInputType.phone,
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 15,
            ),
            labelText: 'مبلغ را وارد نمایید',
            labelStyle: TextStyle(
              fontSize: 20,
              color:
                  focusNode.hasFocus ? AppColor.blueColor : Color(0xffC5C5C5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                width: 3,
                color: Color(0xffC5C5C5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(15),
              ),
              borderSide: BorderSide(
                width: 3,
                color: AppColor.blueColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
