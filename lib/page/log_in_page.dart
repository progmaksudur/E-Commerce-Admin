import 'package:e_commerce_app_admin/auth_service/auth_service.dart';
import 'package:e_commerce_app_admin/page/admin_dashboard.dart';
import 'package:e_commerce_app_admin/utlitis/utilit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogInPage extends StatefulWidget {
  static const String routeName="/loginpage";
  const LogInPage({Key? key}) : super(key: key);

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  bool isObscure=true;
  String errorMessage='';
  final fromKey=GlobalKey<FormState>();
  @override
  void dispose() {
    // TODO: implement dispose

    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: secondaryColors,
              width: 1.5,
            )
          ),
          child: Form(
            key: fromKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(height: 30,),
                  Center(child:
                  Text("Log In",style: headerFont,)),
                  SizedBox(height: 40,),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      style: fieldFont,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffe6e6e6),
                          contentPadding: EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          hintText: "Enter your email",
                          hintStyle: hintstyle,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        }else{
                            return null;
                          }
                        },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      style: fieldFont,
                      obscureText: isObscure,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xffe6e6e6),
                          contentPadding: EdgeInsets.only(left: 10),
                          focusColor: Colors.white,
                          prefixIcon: Icon(
                            Icons.password,
                          ),
                          hintText: "Enter your Password",
                          hintStyle: hintstyle,
                          border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(20))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field must not be empty';
                        } else {
                          if(passwordController.text.length<=6){
                            return 'Password must be above 6 words';
                          }
                          else{
                            return null;
                          }

                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Container(
                      height: 60,
                      width: 130,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                            onPressed: () {
                              authentication();
                            },
                            child: Text("Login")),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Forgot Password",style:text1Style,),
                      TextButton(onPressed: (){

                      },
                          child: Text("Click Here",style:fieldFont,))
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(child: Text(errorMessage,style:fieldFont1,)),
                  )



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void authentication() async{
    String email=emailController.text.trim();
    String password=passwordController.text;
    if(fromKey.currentState!.validate()){

      try{
        final status=await AuthService.login(email, password);
        if(status){
          Navigator.pushReplacementNamed(context, DashboardPage.routeName);
        }
        else{
          setState((){
            errorMessage="You are not admin";
          });
          AuthService.logout();
        }
      }on FirebaseAuthException catch(e){
        setState((){
          errorMessage=e.toString();
        });
      }

    }

  }
}
