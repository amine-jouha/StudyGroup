import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:studygroup/src/screens/dashboard.dart';
import 'package:studygroup/src/screens/home.dart';
import 'package:studygroup/src/screens/predashboard.dart';
import 'package:studygroup/src/screens/registration.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:studygroup/src/screens/dashboard.dart';
// import 'package:studygroup/src/screens/verify.dart';

class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //form key
  final _formKey = GlobalKey<FormState>();

  //modifier les controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // late String _email, _password;
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {


    //email field
    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
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
        emailController.text = value!;
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
      obscureText: true,
      controller: passwordController,
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
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon:Icon(Icons.vpn_key),
          hintText: 'Password',
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10)
          )
      ),
    );

    //login boutton
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.blueAccent,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        },
        child: Text(
          'Login',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeWelcome()));
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
                    Text('Login To', textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, letterSpacing: 2.0, color: Colors.blueAccent),),
                    SizedBox(height:120,
                      child: Image.asset('assets/studygroup.png',fit: BoxFit.contain, height: 170,),),

                    SizedBox(height:10),
                    emailField,
                  SizedBox(height:10),
                    passwordField,
                    SizedBox(height:10),
                    loginButton,
                    SizedBox(height:30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have an account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => RegistrationScreen()));
                          },
                          child : Text(
                            "SignUp",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          )


                        )
                      ],

                    ),
                    SizedBox(height:40,),
                    Column(
                        children:[ Image.asset('assets/background.png', fit: BoxFit.contain, height: 200,),]
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
  //login function
void signIn(String email, String password) async{
    if(_formKey.currentState!.validate())
      {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                Fluttertoast.showToast(msg: 'Login Successful'),
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Predashboard()), (route) => false)
        }).catchError((e)
        {
          Fluttertoast.showToast(msg: e!.message);
        },
        );
      }
}

}
