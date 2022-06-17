import 'package:flutter/material.dart';

/// Import constant created in constant.dart
/// and used it so that we don't need to re-define
/// everytime

/// background Color
const kBackgroundColor = Color(0xFF48426D);

/// Color list/palette
const List<Color> kColorList = [
  Colors.redAccent,
  Colors.blueAccent,
  Colors.purpleAccent,
  Colors.greenAccent,
];

/// CategoryList
const List<String> kCategory = ["Food", "Transport", "Bill", "Others"];

/// Icon path (note that the index is corresponding to the above, category)
const List<String> kIconPath = [
  'lib/icons/food.png',
  'lib/icons/transport.png',
  'lib/icons/bill.png',
  'lib/icons/other.png',
];

const Map<String, int> kHistoryDate = {
  "Yesterday" : 1,
  "2 days ago" : 2,
  "3 days ago" : 3,
  "4 days ago" : 4,
  "5 days ago" : 5,
  "6 days ago" : 6,
  "Last week" : 7,
};

/// Category icon path map
const Map<String, String> kIconMap = {
  "Food": 'lib/icons/food.png',
  "Transport": 'lib/icons/transport.png',
  "Bill": 'lib/icons/bill.png',
  "Others": 'lib/icons/other.png'
};

/// Category color map
const Map<String,Color> kColorMap = {
  "Food": Colors.redAccent,
  "Transport": Colors.blueAccent,
  "Bill": Colors.purpleAccent,
  "Others": Colors.greenAccent,
};

