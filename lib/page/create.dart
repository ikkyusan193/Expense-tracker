import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../database/database_controller.dart';
import '../model/expense.dart';
import '../utils/constant.dart';

class CreateTransactionPage extends StatefulWidget {
  const CreateTransactionPage({Key? key}) : super(key: key);

  @override
  State<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends State<CreateTransactionPage> {

  //
  final QueryController _query = QueryController();

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _noteController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Transaction"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 35),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    createForm(_costController,TextInputType.number, "Amount", "Please enter amount", const Icon(FontAwesomeIcons.dollarSign)),
                    createForm( _nameController,TextInputType.text,"Name","Please enter a name", const Icon(Icons.drive_file_rename_outline)),
                    createForm(_noteController,TextInputType.text, "Note (optional)", "", const Icon(Icons.sticky_note_2_outlined)),
                    const SizedBox(height: 20),
                    DropdownButtonFormField2(
                      decoration: InputDecoration(
                        //Add isDense true and zero Padding.
                        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        //Add more decoration as you want here
                        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                      ),
                      isExpanded: true,
                      hint: const Text(
                        'Select Category',
                        style: TextStyle(fontSize: 20),
                      ),
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.black45,
                      ),
                      iconSize: 30,
                      buttonHeight: 60,
                      buttonPadding: const EdgeInsets.only(left: 20, right: 10),
                      dropdownDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      items: kCategory
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(fontSize: 15),
                                ),
                              ))
                          .toList(),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select category.';
                        }
                      },
                      onChanged: (value) {
                        selectedCategory = value.toString();
                      },
                    ),
                    const SizedBox(height: 20),

                  ],
                  // This trailing comma makes auto-formatting nicer for build methods.
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  save();
                  _costController.clear();
                  _noteController.clear();
                  _nameController.clear();
                  selectedCategory = "";
                }
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget createForm(controller, keyboardType, labelText, String validatorText,Icon icon){
    if (validatorText.isNotEmpty){
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
            labelStyle: const TextStyle(fontSize: 20),
            icon: icon,
            suffixIcon: IconButton(
              onPressed: () {
                controller.clear();
              },
              icon: const Icon(Icons.clear),
            )),
      );
    }else{
      return TextFormField(
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 20),
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

  void save() async {
    int epoch = DateTime.now().microsecondsSinceEpoch; // the order by ascending
    _query.add(Expense(
        date: epoch,
        name: _nameController.text,
        category: selectedCategory.toString(),
        cost: int.parse(_costController.text),
        note: _noteController.text));
  }
}
