

import 'package:expense_planner/widgets/adaptive_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  //stateful widget so that when we add amount title does not get erased and vice versa
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
} //widget class

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  DateTime selectedDate;

  void submitData() {
    if (amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = titleController.text;
    final eneteredAmount = double.parse(amountController.text);
    if (enteredTitle.isEmpty || eneteredAmount <= 0 || selectedDate == null) {
      return; //doesn't run addTx when the condn is true
    }

    widget.addTx(
      enteredTitle,
      eneteredAmount,
      selectedDate,
    ); //by widget. we can access properties of widget class inside the state class

    Navigator.of(context).pop(); //to close the sheet when we submit the data
  }

  void presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }
      setState(() {
        selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom +
                10, //to shift the sheet upwards if keyboard appears
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                controller: titleController,
                onSubmitted: (_) => submitData(),
                //onChanged: (val) {
                //  titleInput = val;
                //},
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitData(),
                //onChanged: (val) {
                //  amountInput = val;
                //},
              ),
              Container(
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? 'No Date Chosen!'
                            : 'Picked Date: ${DateFormat.yMd().format(selectedDate)}',
                      ),
                    ),
                    AdaptiveButton('Choose Date', presentDatePicker),
                  ],
                ),
              ),
              RaisedButton(
                onPressed: submitData,
                child: Text(
                  'Add Transaction',
                ),
                textColor: Theme.of(context).textTheme.button.color,
                color: Theme.of(context).primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
} //state class
