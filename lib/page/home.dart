import 'package:eTracker/widgets/home_card.dart';
import 'package:flutter/material.dart';

import '../database/database_controller.dart';
import '../utils/constant.dart';
import '../widgets/category_card.dart';

class Home extends StatefulWidget {
  static const routeName = '/';
  const Home({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  /// Query controller = instance to connect us to DB
  final QueryController _query = QueryController();

  /// declaring a
  double _total = 0;
  Map<String, double> costMap = {
    "Food": 0,
    "Transport": 0,
    "Bill": 0,
    "Others": 0,
  };
  Map<String, int> countMap = {
    "Food": 0,
    "Transport": 0,
    "Bill": 0,
    "Others": 0,
  };

  /// update all the values to keep us updated!
  void _updateValue() async {
    List categoryCount = await _query.sumCount();
    for (var item in categoryCount) {
      countMap[item['category']] = item['SUM'];
    }

    List categorySum = await _query.sumCategory();
    for (var item in categorySum) {
      costMap[item['category']] = item['SUM'].toDouble();
      _total += item['SUM'].toDouble();
    }
    setState(() {
      costMap = costMap;
      countMap = countMap;
      _total = _total;
    });
  }

  /// init
  @override
  void initState() {
    super.initState();
    _updateValue();
  }

  /// build widget
  /// which call customize card class i created in widgets folder!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Expense Overview")),
      ),
      body: Column(
        children: [
          Card(
            elevation: 3,
            child: SizedBox(
              height: 200,
              width: 350,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 50),
                /// for requested feature purpose since i didn't have database for past transaction,
                /// i decided to use total Cost map first (just to show) how will it look like.
                children: [
                  HomeCard(title: "Total", costMap: costMap, total: _total),
                  HomeCard(title: "Yesterday", costMap: costMap, total: _total),
                  HomeCard(title: "2 days ago", costMap: costMap, total: _total),
                  HomeCard(title: "3 days ago", costMap: costMap, total: _total),
                  HomeCard(title: "4 days ago", costMap: costMap, total: _total),
                  HomeCard(title: "5 days ago", costMap: costMap, total: _total),
                  HomeCard(title: "6 days ago", costMap: costMap, total: _total),
                  HomeCard(title: "Last week", costMap: costMap, total: _total),
                ],
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: kCategory.length,
                  itemBuilder: (context, index) {
                    return CategoryCard(
                      name: kCategory[index],
                      iconPath: kIconPath[index],
                      transactionCount: countMap[kCategory[index]] ?? 0,
                      sum: costMap[kCategory[index]],
                      iconColor: kColorList[index],
                      expenses:
                          _query.allByCategory(kCategory[index].toString()),
                    );
                  }))
        ],
      ),
      // floatingActionButton: Padding(
      //   padding: const EdgeInsets.only(bottom: 50.0),
      //   child: FloatingActionButton(
      //     child: const Icon(Icons.add),
      //     onPressed: _deleteDB,
      //   ),
      // ),
    );
  }
}
