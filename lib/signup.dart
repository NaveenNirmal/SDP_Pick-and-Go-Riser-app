import 'package:flutter/material.dart';
import 'package:pickngo/Presenter/mainPresenter.dart';
import 'package:pickngo/Styles/textStyles.dart';
import 'package:pickngo/animation/FadeAnimation.dart';
import 'package:pickngo/animation/Form.dart';
import 'package:pickngo/login.dart';

class SignupPage extends StatefulWidget {
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final email=TextEditingController();
  final fullName=TextEditingController();
  final userName=TextEditingController();
  final nicNumber=TextEditingController();
  final contactNumber=TextEditingController();
  final password=TextEditingController();


  Presenter _presenter=new Presenter();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50.0,top: 20.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 40),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                    1,
                    Text(
                      "Sign up",
                      style:
                      TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                    1.2,
                    Container(
                      child: Text(
                        "Join Easy Way as A Rider",
                        style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
              Column(
                children: <Widget>[

                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "Full Name",
                      controller: fullName,
                      capitalization: true,
                    ),
                  ),

                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "User Name",
                      controller: userName,
                      capitalization: true,
                    ),
                  ),

                  FadeAnimation(
                    1.2,
                    makeInput(
                      label: "Contact Number",
                      controller: contactNumber,
                      capitalization: true,
                    ),
                  ),
                  FadeAnimation(
                    1.3,
                    makeInput(
                      label: "Password",
                      obscureText: true,
                      controller: password,
                    ),
                  ),
                  FadeAnimation(
                    1.4,
                    makeInput(
                      label: "Confirm Password",
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              FadeAnimation(
                1.4,
                Container(
                  child: GestureDetector(
                    onTap: () {
                      _presenter.register(email.text, fullName.text, userName.text, nicNumber.text, contactNumber.text, password.text, context);
                    },
                    child: Container(
                      width: 280.0,
                      height: 50.0,
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.centerLeft,
                          colors: [
                            Color(0XFFFFCD00),
                            Color(0XFFFFC900),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(40.0),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Sign Up",
                        style: buttonText,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                1.6,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Already have an account?"),
                    Text(
                      " Login",
                      style:
                      TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
