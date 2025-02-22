import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crud/addmedicine.dart';
import 'package:firebase_crud/auth.dart';
import 'package:firebase_crud/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Signup(),
      routes: {
      '/addmedicine': (context) => const AddMedicine(),
         '/login': (context) => const Login(),
                 '/home': (context) => const AddMedicine(), // Home screen after login

        
      },
    );
  }
}

class AddMedicine extends StatefulWidget {
  const AddMedicine({super.key});

  @override
  State<AddMedicine> createState() => _AddMedicineState();
}

class _AddMedicineState extends State<AddMedicine> {
CollectionReference AddMedicine= FirebaseFirestore.instance.collection('AddMedicine');

 _deleteProduct(String id)async{
try {
  await AddMedicine.doc(id).delete();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product deleted successfully"),));
} catch (e) {
  print(e);
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fail to delete product"),));
}
 }
 void _editProduct(String id,String title,String description,double price){

  TextEditingController medicineNameController=TextEditingController(text: title);
  TextEditingController medicineDescController=TextEditingController(text: description);
  TextEditingController medicinePriceController=TextEditingController(text: price.toString());

  showDialog(context: context, builder: (context){
return
AlertDialog(
  title: Text("Edit $title"),
  content: Column(
     mainAxisSize: MainAxisSize.min,
    children: [
      TextField(
        controller: medicineNameController,
        decoration: InputDecoration(
          labelText: "Title"
        ),),
         TextField(
        controller: medicineDescController,
        decoration: InputDecoration(
          labelText: "Description"
        ),
      ),
       TextField(
        controller: medicinePriceController,
        decoration: InputDecoration(
          labelText: "Price"
        ),)
    ],
  ),
  
  
  actions: [
    TextButton(onPressed: () {
      Navigator.pop(context);
    }, child: Text("Cancel")),

    TextButton(onPressed: () async{
      try {
        await AddMedicine.doc(id).update({
          'Title':medicineNameController.text,
          'Description':medicineDescController.text,
          'price':double.parse(medicinePriceController.text)
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Product updated successfully"),));
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Fail to update product"),));
      }
    }, child: Text("Update"))
  ],);
  });


 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Products"),
        actions: [
          IconButton(onPressed: (){
            // Navigator.pushNamed(context, '/login');
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
          }, icon: Icon(Icons.logout))
        ],

      ),
      body: Center(
        child: StreamBuilder(stream: AddMedicine.snapshots(), builder: (context,snapshot){
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return ListView.builder(itemBuilder: (context,index){

              var AddMedicine=snapshot.data!.docs[index];
        return ListTile(
          title: Text(AddMedicine['Title']),
          subtitle: Text(AddMedicine['Description']),
          leading: CircleAvatar(
            child: Text(AddMedicine['Price'].toString()),),
            trailing:
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
             IconButton(onPressed: () {
              _editProduct(AddMedicine.id, AddMedicine['Title'],AddMedicine['Description'],AddMedicine['Price']);
            },
              icon:Icon(Icons.edit,color: Colors.blue,),
            ),
              IconButton(onPressed: () {
              _deleteProduct(AddMedicine.id);
            },
              icon:Icon(Icons.delete,color: Colors.red,),
            ),
            ],)
             
        );
            },
            itemCount: snapshot.data!.docs.length,);
          } else {
             return Text("No data found");
          }
        } else {
          return SpinKitDancingSquare(color: Colors.blueAccent,); 
          
        }
        }),
      ),
    );
  }
}