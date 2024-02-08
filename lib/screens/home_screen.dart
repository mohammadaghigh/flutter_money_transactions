import 'dart:ui' as ui;
import 'custom_screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:money_transaction/const/const.dart';
import 'package:money_transaction/data/transaction.dart';
import 'package:money_transaction/utility/func.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var box = Hive.box<TransactionData>('transactions');
  double sum = 0;
  double totalIncome = 0;
  double totalExpense = 0;
  bool isFabVisible = true;

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
      totalIncome = box.values
          .where((transaction) => transaction.type == 'income')
          .map((incomeTransaction) => incomeTransaction.amount)
          .fold(0, (a, b) => a + b);
      totalExpense = box.values
          .where((transaction) => transaction.type == 'expense')
          .map((expenseTransaction) => expenseTransaction.amount)
          .fold(0, (a, b) => a + b);
      sum = totalIncome - totalExpense;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportScreen(
                                          transactions: box.values.toList(),
                                        )),
                              );
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: AppColor.whiteColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              child: Icon(
                                Icons.newspaper,
                                color: AppColor.blueColor,
                              ),
                            ),
                          ),
                          Spacer(),
                          Text(
                            'کتاب',
                            style: TextStyle(
                              fontSize: 18.0,
                              color: AppColor.blueColor,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Text(
                            ' حساب',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      getResultBox(sum),
                      SizedBox(
                        height: 40,
                      ),
                      Row(
                        children: [
                          InkWell(
                              // style: ElevatedButton.styleFrom(
                              //     backgroundColor: AppColor.blueColor),
                              onTap: () async {
                                // Fetch TransactionData objects from Hive
                                List<TransactionData> transactions =
                                    box.values.toList();

                                // Pass the list of transactions to the export function
                                await exportToExcel(transactions);
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                    color: AppColor.whiteColor,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                child: Icon(
                                  Icons.attach_file,
                                  color: AppColor.blueColor,
                                ),
                              )),
                          Spacer(),
                          Text(
                            'لیست تراکنش ها',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: AppColor.blackColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      box.length > 0
                          ? Expanded(
                              child: Directionality(
                                textDirection: ui.TextDirection.rtl,
                                child: ListView.builder(
                                  itemCount: box.length,
                                  itemBuilder: (context, index) {
                                    final transaction = box.getAt(index);

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
                                          title: Text(transaction?.note ?? ''),
                                          subtitle: Text(
                                            transaction?.time ?? '',
                                            style: TextStyle(
                                                fontSize: 12.0,
                                                fontFamily: 'vz'),
                                          ),
                                          leading: transaction?.type == 'income'
                                              ? Icon(
                                                  Icons.arrow_downward,
                                                  color: AppColor.greenColor,
                                                )
                                              : Icon(
                                                  Icons.arrow_upward,
                                                  color: AppColor.redColor,
                                                ),
                                          trailing: Text(
                                            box.values.toList()[index].type ==
                                                    'income'
                                                ? '${formatNumberWithCommas(box.values.toList()[index].amount)}'
                                                : '${formatNumberWithCommas(box.values.toList()[index].amount)}' +
                                                    ' -',
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                color: box.values
                                                            .toList()[index]
                                                            .type ==
                                                        'income'
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
                                  fontWeight: FontWeight.w700),
                            )))
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

  Container getResultBox(double sum) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColor.whiteColor,
        borderRadius: BorderRadius.all(
          Radius.circular(14),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
        child: Column(
          children: [
            Text(
              'جمع کل',
              style: TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: AppColor.blackColor),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              formatNumberWithCommas(sum),
              style: TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: sum > 0
                    ? AppColor.greenColor
                    : sum == 0
                        ? AppColor.blackColor
                        : AppColor.redColor,
              ),
            ),
            Spacer(),
            Row(
              children: [
                getResult('expense', totalIncome, totalExpense),
                Spacer(),
                getResult('income', totalIncome, totalExpense),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getResult(String status, double totalIncome, double totalExpense) {
    return Row(children: [
      Icon(
        status == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
        color: status == 'income' ? AppColor.greenColor : AppColor.redColor,
        size: 32.0,
      ),
      Column(
        children: [
          Center(
            child: Text(
              status == 'income' ? 'درآمد' : 'هزینه',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            '${status == 'income' ? formatNumberWithCommas(totalIncome) : ((totalExpense) > 0 ? '- ' + formatNumberWithCommas(totalExpense) : formatNumberWithCommas(totalExpense))}',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )
    ]);
  }
}
