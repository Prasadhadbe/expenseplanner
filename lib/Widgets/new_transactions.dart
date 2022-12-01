import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function userInput;

  const NewTransaction(this.userInput);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();
  DateTime _newDate;
  DateTime now = DateTime.now();

  void submitAns() {
    final enterdTitle = titleController.text;
    final enterdAmount = double.parse(amountController.text);

    if (enterdTitle.isEmpty || enterdAmount <= 0 || _newDate == null) {
      return;
    }

    widget.userInput(
      titleController.text,
      double.parse(amountController.text),
      _newDate,
    );

    Navigator.of(context).pop();
  }

  void _pickADate() {
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
        _newDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          margin: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: titleController,
                onSubmitted: (_) => submitAns(),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => submitAns(),
              ),
              Container(
                height: 80,
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _newDate == null
                            ? 'No Date Selected'
                            : DateFormat.yMd().format(_newDate),
                      ),
                    ),
                    TextButton(
                        onPressed: _pickADate,
                        // textColor: Theme.of(context).primaryColor,
                        child: Text(
                          'Pick A Date',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: submitAns,
                  // color: Theme.of(context).primaryColor,
                  child: Text(
                    'Add Transaction',
                    style: TextStyle(color: Theme.of(context).buttonColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
