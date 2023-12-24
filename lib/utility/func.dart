import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:money_transaction/data/transaction.dart';

bool isValidAmount(TextEditingController controller) {
  // Check if controllerAmount has a valid number
  try {
    double.parse(controller.text);
    return true;
  } catch (e) {
    return false;
  }
}

bool isNoteNotEmpty(TextEditingController controller) {
  // Check if controllerNote has some value
  return controller.text.trim().isNotEmpty;
}

String formatNumberWithCommas(double number) {
  final formatter = NumberFormat('#,##0', 'fa_IR');
  return formatter.format(number);
}

dynamic editTransaction(TransactionData transactionData, double amount,
    String note, String type, String selectedDate) {
  transactionData.amount = amount;
  transactionData.time = selectedDate;
  transactionData.note = note;
  transactionData.type = type;
  print(transactionData.time);
  transactionData.save();
}

dynamic addTransaction(
    double amount, String note, String type, String selectedDate) {
  var box = Hive.box<TransactionData>('transactions');
  var transactions = TransactionData(
    amount: amount,
    time: selectedDate,
    note: note,
    type: type,
  );

  box.add(transactions);
}
