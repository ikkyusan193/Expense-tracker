import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../database/database_controller.dart';
import '../model/expense.dart';
import '../utils/constant.dart';

/// Transaction pages (Recent)
/// I tried to replicate similar structure like Grab
/// it display recent transactions made by the user
/// (sort by date)
/// display all the details (date, cost, notes, category)

class TransactionPage extends StatefulWidget {
  const TransactionPage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _TransactionPageState();
  }
}

class _TransactionPageState extends State<TransactionPage> with SingleTickerProviderStateMixin {
  NumberFormat numberFormat = NumberFormat.decimalPattern('hi');  /// Number format to format the date
  final QueryController _query = QueryController(); /// Query controller = instance to connect us to DB
  late Future<List<Expense>> _expenses; /// List of expenses (note the late, we will query it when we create widgets)

  /// GlobalKey and TextController
  /// used for:
  /// 1. validating user input (null check, format check)
  /// 2. Keyboard custom (for cost we use number keyboard, and for others we use normal keyboard)
  /// 3. Text forms, Number forms (so that user can't put number on text field)
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _noteController = TextEditingController();

  /// Tab controller, simply changes tab (based on index category)
  /// to see Recent history for each individually Category
  late TabController _controller;

  /// Init
  @override
  void initState() {
    super.initState();
    _expenses = _query.allExpense();
    _controller = TabController(length: 5, vsync: this);
    _controller.addListener(() {
    refreshExpense();
    });
  }

  /// Refresh all the expense (to keep the data updated)
  void refreshExpense(){
    setState((){
      if (_controller.index == 0){
        _expenses = _query.allExpense(); // query all
      }else{
        _expenses = _query.allByCategory(kCategory[_controller.index-1]); // query based on category
      }
    });
  }

  /// Dialog that shows info of the press/selected items
  /// when press dialog will pops up displaying all the
  /// necessary values/information
  /// we can also modify the transaction here
  Widget createDialog(BuildContext context, Expense item) {
    _nameController.text = item.name;
    _costController.text = item.cost.toString();
    _noteController.text = item.note;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: _childDialog(context, item),
    );
  }

  /// custom content of the dialog
  _childDialog(BuildContext context, Expense item) {
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: kColorMap[item.category],
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12.0),
            child: Image.asset(kIconMap[item.category].toString(),
                height: 120, width: 120),
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          ),
          const SizedBox(height: 24),
          const Text('Expense information',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(children: [
                createForm(
                    _costController,
                    TextInputType.number,
                    "Amount",
                    "Please enter amount",
                    const Icon(FontAwesomeIcons.dollarSign)),
                createForm(
                    _nameController,
                    TextInputType.text,
                    "Name",
                    "Please enter a name",
                    const Icon(Icons.drive_file_rename_outline)),
                createForm(_noteController, TextInputType.text, "Note", "",
                    const Icon(Icons.sticky_note_2_outlined)),
              ]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    _query.delete(item.id);
                    refreshExpense();
                    return Navigator.of(context).pop();
                  },
                  child: const Icon(FontAwesomeIcons.trash),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: kColorMap[item.category],
                  )),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _query.update(Expense(
                        id: item.id,
                        date: item.date,
                        name: _nameController.text,
                        category: item.category,
                        cost: int.parse(_costController.text),
                        note: _noteController.text));
                    _costController.clear();
                    _noteController.clear();
                    _nameController.clear();
                    refreshExpense();
                    return Navigator.of(context).pop();
                  }
                },
                child: const Text('Save & Exit'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: kColorMap[item.category],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Listview widgets for our expenses
  Widget createListView(BuildContext context, AsyncSnapshot snapshot) {
    List<Expense> expenses = snapshot.data;
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (context, index) {
        String category = expenses[index].category;
        DateTime date =
            DateTime.fromMicrosecondsSinceEpoch(expenses[index].date);
        return Column(
          children: <Widget>[
            ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  color: Colors.transparent,
                  height: 60,
                  padding: const EdgeInsets.all(14),
                  child: Image.asset(kIconMap[category].toString(),
                      color: Colors.black),
                ),
              ),
              title: Text(expenses[index].name),
              subtitle: Text(DateFormat('dd MMM yyyy, h:mm a').format(date),
                  style: const TextStyle(fontSize: 10)),
              trailing: SizedBox(
                width: 200,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "\$" + expenses[index].cost.toString(),
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                      Text(expenses[index].note,
                          style: const TextStyle(fontSize: 10)),
                      // const Icon(FontAwesomeIcons.trash)
                    ]),
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        createDialog(context, expenses[index]));
              },
            ),
            const Divider(height: 2.0)
          ],
        );
      },
    );
  }

  /// Custom form builder I created
  /// We parse in Controllers, Keyboard Type, ValidatorText and Icon
  /// So that we can create form by just parsing in the neccessary
  Widget createForm(
      controller, keyboardType, labelText, String validatorText, Icon icon) {
    if (validatorText.isNotEmpty) {
      return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value!.isEmpty) {
            return validatorText;
          }
        },
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
            icon: icon,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            )),
      );
    } else {
      return TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 15, color: Colors.white),
            icon: icon,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            )),
      );
    }
  }

  /// By simply making all the customized widgets above
  /// It makes our build widget look simple and clean
  /// easier to refactor and can scale!.
  @override
  Widget build(BuildContext context)  {
    return Scaffold(
            appBar: AppBar(title: const Text('My Activity'),
            bottom: TabBar(
              controller: _controller,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Food"),
                Tab(text: "Transport"),
                Tab(text: "Bill"),
                Tab(text: "Other")
              ],
            )),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Recent",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                    child: FutureBuilder<List<Expense>>(
                        future: _expenses,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const Center(child: Text('No Expense'));
                          } else if (snapshot.hasData) {
                            return createListView(context, snapshot); /// we call our customize list view builder here!
                          } else {
                            return const Center(child: Text('Loading'));
                          }
                        })),
              ],
            ),
    );
  }
}
