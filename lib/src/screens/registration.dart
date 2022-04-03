import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studygroup/model/user_model.dart';
import 'package:studygroup/src/screens/dashboard.dart';
import 'package:studygroup/src/screens/predashboard.dart';
import 'package:studygroup/src/screens/profile.dart';

class RegistrationScreen extends StatefulWidget {

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;

  //notre form key
  final _formKey = GlobalKey<FormState>();
  //modifier le controller
  final userNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //userName field
    final userName = TextFormField(
      autofocus: false,
      controller: userNameEditingController,
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if(value!.isEmpty)
        {
          return ('user name cannot be Empty');
        }
        if(!regex.hasMatch(value)) {
          return ('Enter Valid userName(Min. 3 Character)');
        }
        return null;
      },
      onSaved: (value) {
        userNameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon:Icon(Icons.person),
          hintText: 'Name',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailEditingController,
      keyboardType: TextInputType.emailAddress,
      validator: (value)
      {
        if(value!.isEmpty) {
          return ('Please Enter your Email');
        }
        //reg expression for email validation
        if(!RegExp('^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]').hasMatch(value))
        {
          return ('Please enter a Valid Email!');
        }
        return null;
      },
      onSaved: (value) {
        emailEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon:Icon(Icons.mail),
          hintText: 'Email',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //password field
    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordEditingController,
      obscureText: true,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{6,}$');
        if(value!.isEmpty)
        {
          return ('Password is required for login');
        }
        if(!regex.hasMatch(value)) {
          return ('Enter Valid Password(Min. 6 Character)');
        }
      },
      onSaved: (value) {
        passwordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon:Icon(Icons.vpn_key),
          hintText: 'Password',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //confirmPassword field
    final confirmPasswordField = TextFormField(
      autofocus: false,
      controller: confirmPasswordEditingController,
      obscureText: true,
      validator: (value)
      {
        if (confirmPasswordEditingController.text != passwordEditingController.text)
          {
            return 'Password dont match';
          }
        return null;
      },
      onSaved: (value) {
        confirmPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon:Icon(Icons.vpn_key),
          hintText: 'Confirm Password',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //signUp button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signUp(emailEditingController.text, passwordEditingController.text);
        },
        child: Text(
          'SignUp',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              color: Colors.white,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                        children:[ Image.asset('assets/studygroup.png', fit: BoxFit.contain, height: 90,),]
                    ),
                    userName,
                    SizedBox(height:10),
                    emailField,
                    SizedBox(height:10),
                    passwordField,
                    SizedBox(height:10),
                    confirmPasswordField,
                    SizedBox(height:10),
                    signUpButton,
                    SizedBox(height:30,),
                    Column(
                        children:[ Image.asset('assets/background.png', fit: BoxFit.contain, height: 180,),]
                    ),
                  ],
                ),
              ),

            ),
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if(_formKey.currentState!.validate()) {
      await _auth.createUserWithEmailAndPassword(email: email, password: password)
          .then((value) => {postDetailsToFirestore()})
          .catchError((e) {
        Fluttertoast.showToast(msg: e!.message);
        });
    }
  }

  postDetailsToFirestore() async {
    //on va appeller notre firestore
    //on va appeler aussi notre user model
    //envoyer ces values

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    UserModel userModel = UserModel();

    //on va ecrire tous les values
    userModel.email = user!.email;
    userModel.uid = user.uid;
    userModel.userName = userNameEditingController.text;
    
    await firebaseFirestore.collection('users').doc(user.uid).set(userModel.toMap());
    Fluttertoast.showToast(msg: 'Account created successfully ${userModel.userName}');

    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Predashboard()), (route) => false);


  }

}
