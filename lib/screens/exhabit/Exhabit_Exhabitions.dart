import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled12/screens/exhabit/Exhabit_products.dart';

import '../../models/exhibit_model.dart';
import '../../models/user_model.dart';
class ExhabitExhabitions extends StatefulWidget {
  static const routeName = '/ExhabitExhabitions';
  const ExhabitExhabitions({super.key});

  @override
  State<ExhabitExhabitions> createState() => _ExhabitExhabitionsState();
}

class _ExhabitExhabitionsState extends State<ExhabitExhabitions> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Exhibit> ExhibitList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchexhibittions();
    getUserData();
  }
  @override

  @override
  void fetchexhibittions() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child("exhibittions");
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Exhibit p = Exhibit.fromJson(event.snapshot.value);
      ExhibitList.add(p);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
      setState(() {});
    });
  }
  late Users currentUser;



  void initState() {
    getUserData();
    super.initState();
  }

  getUserData() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database
        .reference()
        .child("users")
        .child(FirebaseAuth.instance.currentUser!.uid);

    final snapshot = await base.get();
    setState(() {
      currentUser = Users.fromSnapshot(snapshot);
    });
  }
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(
            leading: BackButton(color: Colors.black),
            title: Text('المعارض'
                ,
                style: TextStyle(color: Colors.black)),
            backgroundColor: Colors.amber.shade500,
          ),
          body:  Container(child: Container(
            color: Colors.black,
            child:  Container(
                width: double.infinity,
                child: GridView.builder(
                    padding: EdgeInsets.only(
                        top: 15,
                        left: 15,
                        right: 15,
                        bottom: 15
                    ),
                    itemCount: ExhibitList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,mainAxisSpacing: 15,crossAxisSpacing: 5,mainAxisExtent: 250), itemBuilder: (context,i){
                  return

                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ExhabitProducts(Exhabit:'${ExhibitList[i].name.toString()}')) );
                      },
                      child: Card(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.amber.shade100,

                        child: Column(children: [
                          CircleAvatar(
                            radius: 37,
                            backgroundImage: NetworkImage(
                                '${ExhibitList[i].imageUrl.toString()}'),
                          ),

                          Text(
                            '${ExhibitList[i].name.toString()}',
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.green),
                          ),


                          Text('${ExhibitList[i].email.toString()}'),


                          Text(
                              'كلمة المرور: ${ExhibitList[i].password.toString()}'),





                          Text(
                              'الهاتف: ${ExhibitList[i].phone.toString()}'),

                          Container(
                              child: Text('${ExhibitList[i].address.toString()}')),

                        ],),

                      ),
                    )

                  ;
                }

                )),
          ),
          ),
        );
  }
}
