import 'dart:ui' as ui;
import 'custom_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_transaction/const/const.dart';
import 'package:money_transaction/utility/func.dart';
import 'package:money_transaction/data/transaction.dart';

class HomeScreenPage extends StatefulWidget {
  const HomeScreenPage({Key? key}) : super(key: key);

  @override
  _HomeScreenPageState createState() => _HomeScreenPageState();
}

class _HomeScreenPageState extends State<HomeScreenPage> {
  late var box;
  double sum = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  bool isFabVisible = true;
  List<TransactionData> filteredTransactions = [];

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    await Hive.initFlutter();
    box = await Hive.openBox<TransactionData>('transactions');
    calculateSum();
  }

  void calculateSum() {
    setState(() {
      totalIncome = filteredTransactions
          .where((transaction) => transaction.type == 'income')
          .map((incomeTransaction) => incomeTransaction.amount)
          .fold(0, (a, b) => a + b);
      totalExpense = filteredTransactions
          .where((transaction) => transaction.type == 'expense')
          .map((expenseTransaction) => expenseTransaction.amount)
          .fold(0, (a, b) => a + b);
      sum = totalIncome - totalExpense;
    });
  }

  void _filterList(String query) {
    setState(() {
      filteredTransactions = box.values
          .where((transaction) =>
              transaction.note!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      calculateSum(); // Update the total after filtering
    });
  }

  @override
  void dispose() {
    Hive.box<TransactionData>('transactions').close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: AppColor.greyColor,
      appBar: AppBar(
        backgroundColor: AppColor.blueColor,
        elevation: 0,
        toolbarHeight: 0.0,
      ),
      floatingActionButton: Visibility(
        visible: isFabVisible,
        child: FloatingActionButton(
          backgroundColor: AppColor.blueColor,
          onPressed: () async {
            var result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TransactionForm(
                  transactionData:
                      null, // Pass null for adding a new transaction
                ),
              ),
            );

            if (result == true) {
              calculateSum();
            }
          },
          child: Icon(
            Icons.add,
            size: 32.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ValueListenableBuilder(
            valueListenable:
                Hive.box<TransactionData>('transactions').listenable(),
            builder: ((context, value, child) {
              return NotificationListener<UserScrollNotification>(
                onNotification: (notif) {
                  setState(() {
                    if (notif.direction == ScrollDirection.forward) {
                      isFabVisible = true;
                    }
                    if (notif.direction == ScrollDirection.reverse) {
                      isFabVisible = false;
                    }
                  });
                  return true;
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        height: 65,
                      ),
                      Text(
                        'لیست تراکنش ها',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: AppColor.blackColor),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: TextField(
                            onChanged: _filterList,
                            decoration: InputDecoration(
                              hintText: 'جستجو',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                borderSide: BorderSide(
                                  width: 1,
                                  style: BorderStyle.solid,
                                ),
                              ),
                              filled: true,
                              fillColor: AppColor.greyColor,
                            ),
                          ),
                        ),
                      ),
                      filteredTransactions.isNotEmpty
                          ? Expanded(
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ListView.builder(
                                  itemCount: filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction =
                                        filteredTransactions[index];

                                    return Dismissible(
                                      key: UniqueKey(),
                                      background: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.redColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.delete,
                                                color: AppColor.whiteColor,
                                                size: 32.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      secondaryBackground: Container(
                                        decoration: BoxDecoration(
                                            color: AppColor.greenColor,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Icon(
                                                Icons.edit,
                                                color: AppColor.whiteColor,
                                                size: 32.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      confirmDismiss: (direction) async {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          return await getDialog(context);
                                        } else {
                                          var result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TransactionForm(
                                                transactionData: transaction,
                                              ),
                                            ),
                                          );
                                          if (result == true) {
                                            calculateSum();
                                          }
                                        }
                                        return false;
                                      },
                                      onDismissed: (direction) {
                                        if (direction ==
                                            DismissDirection.startToEnd) {
                                          box.delete(box.keyAt(index));
                                          setState(() {
                                            calculateSum();
                                          });
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColor.whiteColor,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                        ),
                                        margin: EdgeInsets.all(5.0),
                                        child: ListTile(
                                          title: Text(transaction.note ?? ''),
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
                                                : '${formatNumberWithCommas(transaction.amount)}' +
                                                    ' -',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color:
                                                    transaction.type == 'income'
                                                        ? AppColor.greenColor
                                                        : AppColor.redColor),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          : Expanded(
                              child: Center(
                                child: Text(
                                  'هنوز تراکنشی ثبت نشده است',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey[400],
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  Future<bool?> getDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'پاکش کنم ؟',
              textDirection: ui.TextDirection.rtl,
            ),
          ),
          content: Text(
            'آیا مطمئنی که میخوای پاکش کنی؟',
            textDirection: ui.TextDirection.rtl,
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.redColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(
                'خیر',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.greenColor,
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(
                'بله',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
