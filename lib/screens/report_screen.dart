import 'dart:ui' as ui;
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:money_transaction/const/const.dart';
import 'package:money_transaction/data/transaction.dart';

import 'package:money_transaction/utility/func.dart';

class ReportScreen extends StatefulWidget {
  final List<TransactionData> transactions;

  ReportScreen({required this.transactions});

  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.greyColor,
      appBar: AppBar(
        backgroundColor: AppColor.blueColor,
        title: Text('گزارش تراکنش‌ها'),
        bottom: TabBar(
          indicatorColor: AppColor.whiteColor,
          labelColor: AppColor.whiteColor,
          controller: _tabController,
          tabs: [
            Tab(
              text: 'هزینه',
            ),
            Tab(
              text: 'درآمد',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TransactionList(type: 'expense', transactions: widget.transactions),
          TransactionList(type: 'income', transactions: widget.transactions),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class TransactionList extends StatelessWidget {
  final String type;
  final List<TransactionData> transactions;

  TransactionList({required this.type, required this.transactions});

  List<TransactionData> getFilteredTransactions() {
    return transactions
        .where((transaction) => transaction.type == type)
        .toList();
  }

  var box = Hive.box<TransactionData>('transactions');
  @override
  Widget build(BuildContext context) {
    final filteredTransactions = getFilteredTransactions();

    return Directionality(
      textDirection: ui.TextDirection.rtl,
      child: ListView.builder(
        itemCount: filteredTransactions.length,
        itemBuilder: (context, index) {
          final transaction = filteredTransactions[index];

          return Container(
            decoration: BoxDecoration(
              color: AppColor.whiteColor,
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            margin: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(transaction.note),
              subtitle: Text(
                transaction.time,
                style: TextStyle(fontSize: 12.0, fontFamily: 'vz'),
              ),
              leading: transaction.type == 'income'
                  ? Icon(
                      Icons.arrow_downward,
                      color: AppColor.greenColor,
                    )
                  : Icon(
                      Icons.arrow_upward,
                      color: AppColor.redColor,
                    ),
              trailing: Text(
                transaction.type == 'income'
                    ? '${formatNumberWithCommas(transaction.amount)}'
                    : '${formatNumberWithCommas(transaction.amount)}' + ' -',
                style: TextStyle(
                    fontSize: 18.0,
                    color: transaction.type == 'income'
                        ? AppColor.greenColor
                        : AppColor.redColor),
              ),
            ),
          );
          // Add more details if needed
        },
      ),
    );
  }
}
