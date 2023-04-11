import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import '../../common/common_textfield.dart';
import 'login_screen.dart';

class RegisterUser extends StatefulWidget {


  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();


  bool showPass = true;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }
  registration() async {
    isLoading = true;
    setState(() {});
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: userName.text, password: password.text);
      print(userCredential);
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Registered Successfully. Please Login');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginUser(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print("Password Provided is too Weak");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Password Provided is too Weak');

      } else if (e.code == 'email-already-in-use') {
        print("Account Already exists");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Account Already exists');
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   automaticallyImplyLeading: false,
        //   title: const Text("My Physio Registration"),
        // ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(

              child: Column(
                children: [
                  const SizedBox(
                    height: 14,
                  ),

                  Container(
                    padding: const EdgeInsets.only(top: 100),
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("images/welcome.png"),
                        // fit: BoxFit.fitHeight
                      ),

                    ),
                  ),const SizedBox(
                    height: 30,
                  ),
                  CommonTextFieldWithTitle(
                      'Email', 'Enter User Email', userName, (val) {
                    if (val!.isEmpty) {
                      return 'This is required field';
                    }
                  }),
                  const SizedBox(
                    height: 14,
                  ),
                  CommonTextFieldWithTitle('Password', 'Enter Password', password,
                      suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              showPass = !showPass;
                            });
                          },
                          child: const Icon(Icons.remove_red_eye)),
                      obscure: showPass,
                          (val) {
                        if (val!.isEmpty) {
                          return 'This is required field';
                        }
                      }),
                  const SizedBox(
                    height: 14,
                  ),
                  Row(
                    children:  [
                      const Text("Already have an account?", style: TextStyle(fontSize: 16),),
                      const SizedBox(width: 5,),
                      GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginUser()),
                            );
                          },
                          child: const Text("Login" ,  style: TextStyle(fontSize: 16, color: Colors.blueAccent),)),
                    ],
                  ),
                  const SizedBox(
                    height: 22,
                  ),
                  isLoading
                      ? Center(
                    child: SizedBox(
                        width: 80,
                        child: LoadingIndicator(
                            indicatorType: Indicator.ballBeat,
                            colors: [
                              Theme.of(context).primaryColor,
                            ],
                            strokeWidth: 2,
                            pathBackgroundColor:
                            Theme.of(context).primaryColor)),
                  )
                  :
                  buttonWidget(),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buttonWidget() {
    return ButtonTheme(
      height: 60,
      minWidth: MediaQuery.of(context).size.width,
      child: MaterialButton(
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
              registration();
          }
        },
        child: const Text(
          'Register',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
