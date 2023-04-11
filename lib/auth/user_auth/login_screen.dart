import 'package:box_office/auth/user_auth/register_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../common/common_textfield.dart';
import '../../home/home_page.dart';

class LoginUser extends StatefulWidget {


  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool showPass = true;
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
  }
  userLogin() async {
    isLoading = true;
    setState(() {});
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      UserCredential userCredential=await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: userName.text, password: password.text);
      await preferences.setBool('isLoggedIn', true);
      await preferences.setString('userName', userName.text.trim());
      // print(userCredential.user?.uid);
      //await storage.write(key: "uid", value: userCredential.user?.uid);
      isLoading = false;
      setState(() {});
      Fluttertoast.showToast(msg: 'Successfully logged in');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );


    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print("No User Found for that Email");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'No User Found for that Email');

      } else if (e.code == 'wrong-password') {
        print("Wrong Password Provided by User");
        isLoading = false;
        setState(() {});
        Fluttertoast.showToast(msg: 'Wrong Password Provided by User');

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                          image: AssetImage("images/background.png"),
                          // fit: BoxFit.fitHeight
                      ),

                    ),
                  ),const SizedBox(
                    height: 30,
                  ),

                  CommonTextFieldWithTitle(
                      'User email', 'Enter User email', userName, (val) {
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
                      const Text("Did not have an account?", style: TextStyle(fontSize: 16),),
                      const SizedBox(width: 5,),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegisterUser()),
                          );
                        },
                          child: const Text("Register" ,  style: TextStyle(fontSize: 16, color: Colors.blueAccent),)),
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
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50)
        ),
        onPressed: () async {
          if (formKey.currentState!.validate()) {
               userLogin();


          }
        },
        child: const Text(
          'Login',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ),
    );
  }
}
