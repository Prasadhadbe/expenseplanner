import 'package:expenseplanner/Widgets/chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Models/transactions.dart';
import './Widgets/transaction_list.dart';
import './Widgets/new_transactions.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations(
  //     [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //this widget is the root of the application cuz of the material app
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Planner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.blue.shade500,
        errorColor: Colors.grey,
        textTheme: ThemeData.light().textTheme.copyWith(
            subtitle1: TextStyle(
                fontFamily: 'OpenSens',
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        buttonColor: Colors.white,
        fontFamily: 'Quicksand',
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                subtitle2: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  //fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transactions> _userTransactions = [
    // Transactions(id: 't1', title: 'Shoes', amount: 34.12, date: DateTime.now()),
    // Transactions(id: 't2', title: 'Books', amount: 54.20, date: DateTime.now()),
  ];

  List<Transactions> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(String txtitle, double txamount, DateTime newDate) {
    final newTx = Transactions(
        title: txtitle,
        amount: txamount,
        date: newDate,
        id: DateTime.now().toString());

    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransaction(_addNewTransaction),
          behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  bool _showChart = false;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) => tx.id == id);
    });
  }

  Widget _buildLandscapeContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Show Chart'),
        Switch(
            value: _showChart,
            onChanged: (val) {
              setState(() {
                _showChart = val;
              });
            })
      ],
    );
  }

  Widget _BuildPotraitContent(MediaQueryData mediaQuery, AppBar appBar) {
    return Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          .4,
      child: Chart(_recentTransactions),
    );
  }

  PreferredSizeWidget _BuildAppBar() {
    return AppBar(
      //backgroundColor: Colors.red,
      title: Text(
        'Expense Planner',
        style: TextStyle(
          fontSize: 25,
          color: Colors.white,
          fontFamily: 'OpenSans-Bold',
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final appBar = _BuildAppBar();
    final _txlist = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            .6,
        child: TransactionList(_userTransactions, _deleteTransaction));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape) _buildLandscapeContent(),
            if (!isLandscape) _BuildPotraitContent(mediaQuery, appBar),
            if (!isLandscape)
              Container(
                  height: (mediaQuery.size.height -
                          appBar.preferredSize.height -
                          mediaQuery.padding.top) *
                      .6,
                  child:
                      TransactionList(_userTransactions, _deleteTransaction)),
            if (isLandscape)
              _showChart == true
                  ? Container(
                      height: (mediaQuery.size.height -
                              appBar.preferredSize.height -
                              mediaQuery.padding.top) *
                          .6,
                      child: Chart(_recentTransactions))
                  : _txlist
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
