import 'package:firebase_auth/firebase_auth.dart';
import 'package:firstproject/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:firstproject/utilis/routes.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;
  bool _obscureText = true; // Define _obscureText variable
  String? errorMessage = '';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signIn() async {
    print('Auth user: ${_controllerEmail.text}');
    print('Auth email ${_controllerPassword.text}');
    try {
      var cred = await _firebaseAuth.signInWithEmailAndPassword(
        email: _controllerEmail.text,
        password: _controllerPassword.text,
      );

      print('Auth cred $cred');
      if (cred.user != null) {
        //MOBILE USE KYN NHI KRTA APP KI TESTING K LIYE
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Authentication failed, display an error message
        setState(() {
          errorMessage = "Authentication failed";
        });
      }
    } on FirebaseAuthException catch (e) {
      print('auth exception $e');
      setState(() {
        errorMessage = e.message;
      });
    } catch (e) {
      print('auth exception error $e');
      // Handle other exceptions (if any)
      setState(() {
        errorMessage = "An unexpected error occurred";
      });
    }
  }

  // Function to navigate to the signup page
  void _goToSignUpPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpPage()),
    );
  }

  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(Duration(seconds: 1));
      await signIn();
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Wrap the Column with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Image.asset(
                "assets/images/login_image.png",
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20.0),
              Text(
                "Welcome, $name",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _controllerEmail, // Add controller for email
                      decoration: InputDecoration(
                        hintText: "Enter email",
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Email:)";
                        } else if (!value.contains('@')) {
                          return "Please Enter a valid Email Address:)";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller:
                          _controllerPassword, // Add controller for password
                      obscureText:
                          _obscureText, // Use _obscureText to toggle visibility
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        labelText: "Password",
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Password:)";
                        } else if (value.length < 6) {
                          return "Password Should contain at least 6 characters:) ";
                        } else {
                          return null;
                        }
                      },
                    ),
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Want to register? ",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, MyRoutes.signUpRoute);
                          },
                          child: Text(
                            "Sign up",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                    Material(
                      color: Colors.deepPurple,
                      borderRadius:
                          BorderRadius.circular(changeButton ? 50 : 8),
                      child: InkWell(
                        onTap: () => moveToHome(context),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: changeButton
                              ? 50
                              : MediaQuery.of(context).size.width * 0.5,
                          height: 50,
                          alignment: Alignment.center,
                          child: changeButton
                              ? Icon(
                                  Icons.done,
                                  color: Colors.white,
                                )
                              : Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    _errorMessage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorMessage() {
    return Text(errorMessage == '' ? '' : 'Try Again ! $errorMessage');
  }
}
