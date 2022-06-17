import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/expense.dart';
import '../utils/constant.dart';


/// Category card class, i created
/// Parsed information about expenses
/// could only parse in Expense
/// but i decide to parse in information
/// so the card can be use other that expenses.
class CategoryCard extends StatelessWidget {
  final String name;
  final String iconPath;
  final int? transactionCount;
  final double? sum;
  final Color iconColor;
  final Future<List<Expense>> expenses;

  const CategoryCard(
      {Key? key,
      required this.name, //category
      required this.iconPath,
      required this.transactionCount,
      required this.sum,
      required this.iconColor,
      required this.expenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 25),
        child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: Container(
                    height: 60,
                    color: iconColor,
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(iconPath, color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(name,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)), // TYPE
                      Text(transactionCount.toString() + " transactions",
                          textAlign: TextAlign.start),
                    ],
                  ),
                ),
                Expanded(
                    flex: 2,
                    child: Text("\$" + sum.toString(),
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontWeight: FontWeight.bold))),
              ],
            )),
      ),
      onTap: () async {
        List<Expense> items = await expenses;
        if (items.isNotEmpty){
          showDialog(
              context: context,
              builder: (BuildContext context) => createHistoryDialog(context, items));
        }
      },
    );
  }

  /// create History Dialog which returns dialog
  /// a child of this dialog will be _historyDialog
  /// (a custom Container class with a bunch of stuff i customized)
  Widget createHistoryDialog(BuildContext context, List<Expense> items) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: _historyDialog(context, items)
    );
  }

  /// iterate the items, using Listview to create
  _historyDialog(BuildContext context, List<Expense> items) { /// child
    return Container(
      height: 500,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          Container(
            height: 120,
            child: Image.asset(kIconMap[items[0].category].toString()),
            width: double.infinity,
            decoration: BoxDecoration(
                color: kColorMap[items[0].category],
                shape: BoxShape.rectangle,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12))),
          ),
          const SizedBox(height: 10),
          const Text("History",
              style:
              TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15)),
          Expanded(
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  DateTime date =
                  DateTime.fromMicrosecondsSinceEpoch(items[index].date);
                  return Column(
                    children: [
                      ListTile(
                        dense: true,
                        title: Text(items[index].name),
                        subtitle: Text(
                            DateFormat('dd MMM yyyy, h:mm a').format(date),
                            style: const TextStyle(fontSize: 10)),
                        trailing: SizedBox(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "\$" + items[index].cost.toString(),
                                  style: const TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                                Text(items[index].note,
                                    style: const TextStyle(fontSize: 10)),
                                // const Icon(FontAwesomeIcons.trash)
                              ]),
                        ),
                      ),
                      const Divider(height: 2)
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }
}
