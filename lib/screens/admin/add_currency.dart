import 'package:untitled12/screens/admin/admin_currency.dart';
import 'package:untitled12/screens/admin/admin_gold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../models/Currancymodel.dart';
import 'admin_currency.dart';

class AddCurrency extends StatefulWidget {
  static const routeName = '/addCurrency';
  const AddCurrency({Key? key}) : super(key: key);

  @override
  State<AddCurrency> createState() => _AddCurrencyState();
}

class _AddCurrencyState extends State<AddCurrency> {
  var priceController = TextEditingController();
  var categoryController = TextEditingController();
  String dropdownValue = 'الجنيه الاسترلينى';
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Currency> currencyList = [];
  List<String> keyslist = [];

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchCurrency();
  }

  @override
  void fetchCurrency() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("currency");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Currency p = Currency.fromJson(event.snapshot.value);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(color: Colors.black),
          title: Text('اضافة سعر العملات',
          style: TextStyle(color: Colors.black)),
          backgroundColor: Colors.amber.shade500,
        ),
        body: Container(
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.only(top: 20, right: 10, left: 10, bottom: 20),
            child: Column(children: [
               Theme(
                data: Theme.of(context).copyWith(
                  canvasColor: Colors.black,
                ),
                child: DecoratedBox(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                          width: 1.0,
                          style: BorderStyle.solid,
                          color: Colors.amber.shade500),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  child: DropdownButton<String>(
                    isExpanded: true,
                    underline: SizedBox(),

                    // Step 3.
                    value: dropdownValue,
                    icon: Padding(
                      padding: EdgeInsets.only(
                        right: 5
                      ),
                      child: Icon(Icons.arrow_drop_down,
                          color: Colors.amber.shade500),
                    ),

                    // Step 4.
                    items: keyslist
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        
                        child: Center(
                          child: Text(
                            value,
                            style: TextStyle(
                                fontSize: 21, color: Colors.amber.shade500),
                          ),
                        ),
                      );
                    }).toList(),
                    // Step 5.
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: priceController,
                  style: TextStyle(
                      fontFamily: "yel", color: Colors.amber.shade500),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(color: Colors.amber.shade600),
                    ),
                    hintText: "سعر العملة بالجنيه",
                    hintStyle: TextStyle(color: Colors.amber.shade500),
                    labelStyle: TextStyle(color: Colors.amber.shade500),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.amber),
                  ),
                  onPressed: () async {
                    String currencyPrice = priceController.text.trim();
                    String category = dropdownValue;

                    if (category.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please provide currancy name');
                      return;
                    }

                    if (currencyPrice.isEmpty) {
                      Fluttertoast.showToast(
                          msg: 'Please provide currency price');
                      return;
                    }

                    User? user = FirebaseAuth.instance.currentUser;

                    if (user != null) {
                      String uid = user.uid;
                      int date = DateTime.now().millisecondsSinceEpoch;

                      DatabaseReference currencyRef = FirebaseDatabase.instance
                          .reference()
                          .child('currency')
                          .child('$category');

                      String? id = currencyRef.push().key;

                      await currencyRef.child(id!).set({
                        'date': date,
                        'currencyPrice': currencyPrice,
                        'id': id,
                        'name': category,
                      });
                    }
                    showAlertDialog(context);
                  },
                  child: Text('حفظ'))
            ]),
          ),
        ));
  }
}

void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: Colors.amber.shade500,
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, AdminCurrency.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("your currency price is created"),
    actions: [
      remindButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
