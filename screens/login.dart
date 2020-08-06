import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class LoginSignupScreen extends StatefulWidget {
  final Function callback;
  LoginSignupScreen({this.callback});
  @override
  State<StatefulWidget> createState() {
    return LoginSignupScreenState();
  }
}

class LoginSignupScreenState extends State<LoginSignupScreen> {
  Map loginFormValues = Map();
  Map signUpFormValues = Map();
  bool isLogin = true;
  bool _signupObscureText = true;
  bool _loginObscureText = true;
  bool _signupEmailInUse = false;
  bool _signupWeakPassword = false;
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: isLogin
              ? Form(
                  key: _loginFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email';
                          } else if (!EmailValidator.validate(value)) {
                            return 'Invalid email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide:
                                BorderSide(width: 0, style: BorderStyle.none),
                          ),
                          fillColor: Color.fromRGBO(245, 245, 245, 1),
                          filled: true,
                        ),
                        onSaved: (value) => loginFormValues["email"] = value,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autocorrect: false,
                          obscureText: _loginObscureText,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            fillColor: Color.fromRGBO(245, 245, 245, 1),
                            filled: true,
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _loginObscureText = !_loginObscureText;
                                });
                              },
                              child: Icon(
                                _loginObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onSaved: (value) =>
                              loginFormValues["password"] = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: AnimatedButton(
                          callback: () {},
                          child: Text(
                            "Forgotton Password?",
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: AnimatedButton(
                          callback: () {
                            FocusScope.of(context).unfocus();
                            if (_loginFormKey.currentState.validate()) {
                              _loginFormKey.currentState.save();
                              _loginUser();
                            }
                          },
                          child: SubmitButton(text: "Login"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: AnimatedButton(
                          callback: () {
                            setState(() {
                              isLogin = false;
                            });
                          },
                          child: Text(
                            "CREATE AN ACCOUNT",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Form(
                  key: _signupFormKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your first name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'First Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            fillColor: Color.fromRGBO(245, 245, 245, 1),
                            filled: true,
                          ),
                          onSaved: (value) =>
                              signUpFormValues["firstName"] = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Please enter your last name';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Last Name',
                            prefixIcon: Icon(Icons.people),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            fillColor: Color.fromRGBO(245, 245, 245, 1),
                            filled: true,
                          ),
                          onSaved: (value) =>
                              signUpFormValues["lastName"] = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          textCapitalization: TextCapitalization.none,
                          validator: (value) {
                            if (_signupEmailInUse) {
                              return "Email already in use";
                            }
                            if (value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                            ),
                            labelText: 'Email',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            fillColor: Color.fromRGBO(245, 245, 245, 1),
                            filled: true,
                          ),
                          onSaved: (value) => signUpFormValues["email"] = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextFormField(
                          autocorrect: false,
                          validator: (value) {
                            if (_signupWeakPassword) {
                              return "Password is too weak";
                            } else if (value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          obscureText: _signupObscureText,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide:
                                  BorderSide(width: 0, style: BorderStyle.none),
                            ),
                            fillColor: Color.fromRGBO(245, 245, 245, 1),
                            filled: true,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _signupObscureText = !_signupObscureText;
                                });
                              },
                              child: Icon(
                                _signupObscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onSaved: (value) =>
                              signUpFormValues["password"] = value,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                        child: AnimatedButton(
                          callback: () {
                            FocusScope.of(context).unfocus();
                            _signupWeakPassword = false;
                            _signupEmailInUse = false;
                            if (_signupFormKey.currentState.validate()) {
                              _signupFormKey.currentState.save();
                              _addNewUser();
                            }
                          },
                          child: SubmitButton(text: "Sign up"),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: AnimatedButton(
                          callback: () {
                            setState(() {
                              isLogin = true;
                            });
                          },
                          child: Text(
                            "LOG IN",
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  void _loginUser() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth
        .signInWithEmailAndPassword(
            email: loginFormValues["email"],
            password: loginFormValues["password"])
        .then((result) {
      isLoggedIn = true;
      currentUser["firstName"] = "Alice";
      currentUser["lastName"] = "Miller";
      // currentUser["profilePictureURL"] = "assets/images/alice.jpeg";
      widget.callback();
      Navigator.pop(context);
    });
  }

  Future<void> _addNewUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser user;
    _auth
        .createUserWithEmailAndPassword(
      email: signUpFormValues["email"],
      password: signUpFormValues["password"],
    )
        .then((u) async {
      Navigator.pop(context);
      showDialog(
          context: context,
          barrierColor: Color.fromRGBO(40, 40, 40, 0.2),
          builder: (BuildContext context) => SuccessDialog(
                description: "Nice one " +
                    signUpFormValues["firstName"] +
                    "! We've sent a verification link to " +
                    signUpFormValues["email"] +
                    "\nClick that link and log in!",
                title: "Hooray!",
              ));
      user = await _auth.currentUser();
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = signUpFormValues["firstName"];
      await user.updateProfile(updateInfo);

      user.sendEmailVerification();

      print(user.displayName);
    }).catchError((exception) {
      if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        print("Email in use");
        setState(() {
          _signupEmailInUse = true;
          _signupFormKey.currentState.validate();
        });
      } else if (exception.code == "ERROR_WEAK_PASSWORD") {
        print("Weak password");
        setState(() {
          _signupWeakPassword = true;
          _signupFormKey.currentState.validate();
        });
      } else {
        print(exception);
      }
    });
  }
}

class SubmitButton extends StatelessWidget {
  final String text;
  SubmitButton({this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).primaryColor.withOpacity(0.4),
            blurRadius: 10,
            spreadRadius: 0,
            // offset: Offset(2, 2),
          )
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context)
                .textTheme
                .button
                .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
