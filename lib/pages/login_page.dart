import 'package:flutter/material.dart';
import 'package:firstproject/utilis/routes.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String name = "";
  bool changeButton = false;

  final _formKey = GlobalKey<FormState>();

  moveToHome(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.homeRoute);
      setState(() {
        changeButton = false; // Corrected statement
      });
    }
  }

//
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "assets/images/login_image.png",
                fit: BoxFit.cover,
              ),
              SizedBox(
                height: 20.0,
              ),
              Text(
                "Welcome, $name",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Enter username",
                        labelText: "Username",
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please Enter Username:)";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) {
                        name = value;
                        setState(() {});
                      },
                    ),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: "Enter password",
                        labelText: "Password",
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
                    SizedBox(
                      height: 40.0,
                    ),
                    Material(
                      color: Colors.deepPurple,
                      borderRadius:
                          BorderRadius.circular(changeButton ? 50 : 8),
                      child: InkWell(
                        onTap: () => moveToHome(context),
                        child: AnimatedContainer(
                          duration: Duration(seconds: 1),
                          width: changeButton ? 50 : 150,
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
                                      fontSize: 18),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:firstproject/utilis/routes.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   String name = "";
//   bool changeButton = false;

//   final _formKey = GlobalKey<FormState>();

//   moveToHome(BuildContext context) async {
//     if (_formKey.currentState.validate()) {
//       setState(() {
//         changeButton = true;
//       });
//       await Future.delayed(Duration(seconds: 1));
//       await Navigator.pushNamed(context, MyRoutes.homeRoute);
//       setState(() {
//         ChangeButton:
//         false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//         color: Colors.white,
//         child: SingleChildScrollView(
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 Image.asset(
//                   "assets/images/login_image.png",
//                   fit: BoxFit.cover,
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Text(
//                   "Welcome, $name",
//                   style: TextStyle(
//                     fontSize: 28,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(
//                   height: 20.0,
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 16.0, horizontal: 32.0),
//                   child: Column(
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                           hintText: "Enter username",
//                           labelText: "Username",
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return "Please Enter Username and Password both:)";
//                           } else {
//                             return null;
//                           }
//                         },
//                         onChanged: (value) {
//                           name = value;
//                           setState(() {});
//                         },
//                       ),
//                       TextFormField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                           hintText: "Enter password",
//                           labelText: "Password",
//                         ),
//                         validator: (value) {
//                           if (value.isEmpty) {
//                             return "Please Enter Username and Password:)";
//                           } else if (value.length < 6) {
//                             return "Password Should contain atleast 6 characters:) ";
//                           } else {
//                             return null;
//                           }
//                         },
//                       ),
//                       SizedBox(
//                         height: 40.0,
//                       ),

//                       Material(
//                         color: Colors.deepPurple,
//                         borderRadius:
//                             BorderRadius.circular(changeButton ? 50 : 8),
//                         child: InkWell(
//                           onTap: () => moveToHome(context),
//                           child: AnimatedContainer(
//                             duration: Duration(seconds: 1),
//                             width: changeButton ? 50 : 150,
//                             height: 50,
//                             alignment: Alignment.center,
//                             child: changeButton
//                                 ? Icon(
//                                     Icons.done,
//                                     color: Colors.white,
//                                   )
//                                 : Text(
//                                     "Login",
//                                     style: TextStyle(
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 18),
//                                   ),
//                           ),
//                         ),
//                       ),

//                       // ElevatedButton(
//                       //   child: Text("Login"),
//                       //   style: TextButton.styleFrom(minimumSize: Size(150, 40)),
//                       //   onPressed: () {
//                       //     Navigator.pushNamed(context, MyRoutes.homeRoute);
//                       //   },
//                       // )
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ));
//   }
// }
