import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'package:money_transaction/const/const.dart';
import 'package:money_transaction/data/transaction.dart';
import 'package:money_transaction/utility/func.dart';
import 'package:money_transaction/widgets/chipset_widget.dart';
import 'package:money_transaction/widgets/custom_linear_date_picker_widget.dart';
import 'package:money_transaction/widgets/custom_widgets.dart';

class TransactionForm extends StatefulWidget {
  final TransactionData? transactionData;

  const TransactionForm({Key? key, this.transactionData}) : super(key: key);

  @override
  State<TransactionForm> createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final FocusNode negahban1 = FocusNode();
  final FocusNode negahban2 = FocusNode();
  final TextEditingController controllerAmount = TextEditingController();
  final TextEditingController controllerNote = TextEditingController();

  var box = Hive.box<TransactionData>('transactions');
  List<String> type = ['income', 'expense'];
  String currentType = '';

  late DateTime selectedDate;
  @override
  void initState() {
    super.initState();
    currentType = type[0];
    selectedDate = DateTime.now();

    if (widget.transactionData != null) {
      // Editing existing transaction
      controllerAmount.text = widget.transactionData!.amount.round().toString();
      controllerNote.text = widget.transactionData!.note;
      currentType = widget.transactionData!.type;
    }

    negahban1.addListener(() {
      setState(() {});
    });
    negahban2.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.greyColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.transactionData != null
            ? 'ویرایش عملیات'
            : 'اضافه کردن عملیات'),
        backgroundColor: AppColor.blueColor,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              AmountInput(focusNode: negahban1, controller: controllerAmount),
              SizedBox(
                height: 25,
              ),
              NoteInput(focusNode: negahban2, controller: controllerNote),
              SizedBox(
                height: 25,
              ),
              TypeChipButtons(
                type: type,
                currentType: currentType,
                onTypeChanged: (value) {
                  setState(() {
                    currentType = value;
                  });
                },
              ),
              SizedBox(
                height: 50,
              ),
              // CustomLinearDatePicker(
              //   dateChangeListener: (selectedDate) {
              //     print(selectedDate);
              //   },
              // ),
              SizedBox(
                height: 50,
              ),
              ElevatedButton(
                onPressed: () {
                  // Check if controllerAmount has a valid number and controllerNote has some value
                  if (isValidAmount(controllerAmount) &&
                      isNoteNotEmpty(controllerNote)) {
                    double amount = double.parse(controllerAmount.text);
                    String note = controllerNote.text;
                    String type = currentType;

                    if (widget.transactionData != null) {
                      // Editing existing transaction
                      editTransaction(widget.transactionData!, amount, note,
                          type, selectedDate);
                    } else {
                      // Adding new transaction
                      addTransaction(amount, note, type);
                    }

                    Navigator.pop(context, true);
                  } else {
                    if (!isValidAmount(controllerAmount)) {
                      // Show Snackbar for invalid amount
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBar('لطفاً مبلغ را به صورت صحیح وارد نمایید'));
                    }

                    if (!isNoteNotEmpty(controllerNote)) {
                      // Show Snackbar for empty note
                      ScaffoldMessenger.of(context).showSnackBar(
                          snackBar('لطفاً شرح عملیات را وارد نمایید'));
                    }
                  }
                },
                child: Text(
                  widget.transactionData != null ? 'ویرایش' : 'اضافه کردن',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.blueColor,
                  minimumSize: Size(340, 48),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
