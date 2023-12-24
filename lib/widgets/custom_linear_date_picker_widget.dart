import 'package:flutter/material.dart';
import 'package:money_transaction/const/const.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';

class CustomLinearDatePicker extends StatelessWidget {
  final Function(String) dateChangeListener;
  final String data;

  const CustomLinearDatePicker(
      {Key? key, required this.dateChangeListener, required this.data})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: LinearDatePicker(
            startDate: "1399/01/01",
            endDate: "1500/12/29",
            initialDate: data,
            addLeadingZero: true,
            dateChangeListener: dateChangeListener,
            showDay: true,
            labelStyle: TextStyle(
              fontFamily: 'vz',
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            selectedRowStyle: TextStyle(
              fontFamily: 'vz',
              fontSize: 18.0,
              color: AppColor.redColor,
            ),
            unselectedRowStyle: TextStyle(
              fontFamily: 'vz',
              fontSize: 16.0,
              color: Colors.blueGrey,
            ),
            yearText: "سال ",
            monthText: "ماه ",
            dayText: "روز ",
            showLabels: true,
            columnWidth: 100,
            showMonthName: true,
            isJalaali: true,
          ),
        ),
      ),
    );
  }
}
