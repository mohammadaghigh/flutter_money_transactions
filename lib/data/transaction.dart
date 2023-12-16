import 'package:hive_flutter/hive_flutter.dart';

part 'transaction.g.dart';

@HiveType(typeId: 2)
class TransactionData extends HiveObject {
  @HiveField(0)
  double amount;
  @HiveField(1)
  DateTime time;
  @HiveField(2)
  String note;
  @HiveField(3)
  String type;

  TransactionData(
      {required this.amount,
      required this.time,
      required this.note,
      required this.type});
}
