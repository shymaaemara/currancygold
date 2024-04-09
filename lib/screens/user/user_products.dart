import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:untitled12/models/Product_model.dart';
import 'package:untitled12/screens/user/User_Exhabitions.dart';

class UserProducts extends StatefulWidget {
  static const routeName = '/ UserProducts';
final String  Exhabitname;
  const UserProducts({super.key, required this.Exhabitname});

  @override
  State<UserProducts> createState() => _UserProductsState();
}

class _UserProductsState extends State<UserProducts> {
  late DatabaseReference base;
  late FirebaseDatabase database;
  late FirebaseApp app;
  List<Product> ProductList = [];
  List<String> keyslist = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchproduct();

  }
  @override

  @override
  void fetchproduct() async {
    app = await Firebase.initializeApp();
    database = FirebaseDatabase(app: app);
    base = database.reference().child('product').child('${widget.Exhabitname}');
    base.onChildAdded.listen((event) {
      print(event.snapshot.value);
      Product p = Product.fromJson(event.snapshot.value);
      ProductList.add(p);
      keyslist.add(event.snapshot.key.toString());
      print(keyslist);
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return
        Scaffold(
          appBar: AppBar(
            title: Align(
                alignment: Alignment.center,
                child: Text("  المنتجات", style: TextStyle(color: Colors.black))),
            backgroundColor: Colors.amber.shade500,
            actions: [],
          ),
          body:Container(child: Container(
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
                    itemCount: ProductList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,mainAxisSpacing: 15,crossAxisSpacing: 5,mainAxisExtent: 250), itemBuilder: (context,i){
                  return

                    InkWell(
                      onTap: (){

                      },
                      child: Card(

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.amber.shade100,

                        child: Column(children: [
                          Container(height: 10,),
                          CircleAvatar(
                            radius: 37,
                            backgroundImage: NetworkImage(
                                '${ProductList[i].imageUrl.toString()}'),
                          ),

                          Text(
                            '   ${ProductList[i].name.toString()}',
                            style:
                            TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white),
                          ),


                          Text('          عيار ${ProductList[i].caliber.toString()}'),


                          Text(
                              'جرام ${ProductList[i].gram.toString()}'),

           MaterialButton(

 color: Colors.green,
             onPressed: (){
               showAlertDialog(context);
           },child: Text("شراء"),)



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



void showAlertDialog(BuildContext context) {
  Widget remindButton = TextButton(
    style: TextButton.styleFrom(
      primary: Colors.amber.shade500,
    ),
    child: Text("Ok"),
    onPressed: () {
      Navigator.pushNamed(context, UserExhabition.routeName);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("لقد تم الشراء بنجاح"
        ),
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
