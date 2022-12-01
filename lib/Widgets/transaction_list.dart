import 'dart:math';
import 'package:expenseplanner/Models/transactions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionList extends StatefulWidget {
  final List<Transactions> transactions;
  final Function deleteElement;

  TransactionList(this.transactions, this.deleteElement);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  Color _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.blue,
      Colors.pink,
      Colors.green,
      Colors.black
    ];

    _bgColor = availableColors[Random().nextInt(4)];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.transactions.isEmpty
        ? LayoutBuilder(builder: (context, constraints) {
            return Column(
              children: [
                Text(
                  'No transactions added yet!',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 20), //for blank spaces
                Container(
                  height: constraints.maxHeight * 0.6,
                  child: Image.asset(
                    'images/waiting.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            );
          })
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _bgColor,
                      radius: 30,
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          child: Text('\$${widget.transactions[index].amount}'),
                        ),
                      ),
                    ),
                    title: Text(
                      widget.transactions[index].title,
                      style: Theme.of(context).textTheme.subtitle2,
                    ),
                    subtitle: Text(
                      DateFormat.yMMMd()
                          .format(widget.transactions[index].date),
                    ),
                    trailing: MediaQuery.of(context).size.width > 420
                        ? TextButton.icon(
                            icon: Icon(Icons.delete),
                            label: Text('Delete'),
                            // textColor: Theme.of(context).errorColor,
                            onPressed: () {
                              widget
                                  .deleteElement(widget.transactions[index].id);
                            },
                          )
                        : IconButton(
                            onPressed: () {
                              widget
                                  .deleteElement(widget.transactions[index].id);
                            },
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          )),
              );
            },
            itemCount: widget.transactions.length,
            //transations.map((tx) {
            //return Card(
            //child: Text(tx.title),
            //);
            /////map creates a map of the entries in transaction and put them in a anonymus variable i.e tx
          );
  }
}
