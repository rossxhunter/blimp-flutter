import 'package:blimp/services/http.dart';
import 'package:blimp/services/suggestions.dart';
import 'package:blimp/services/user.dart';
import 'package:blimp/styles/colors.dart';
import 'package:blimp/widgets/alerts.dart';
import 'package:blimp/widgets/buttons.dart';
import 'package:blimp/widgets/fields.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:stripe_payment/stripe_payment.dart';

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
  ScrollController _loginController = ScrollController();
  final _loginFormKey = GlobalKey<FormState>();
  final _signupFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 80,
        iconTheme: IconThemeData(
          color: Theme.of(context).primaryColor,
        ),
        title: Stack(
          children: [
            IconButton(
              padding: EdgeInsets.only(bottom: 80),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                FontAwesomeIcons.times,
                color: Theme.of(context).primaryColor,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 80, left: 10),
              child: Text(
                isLogin ? "Log In" : "Sign Up",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ),
      body: KeyboardAvoider(
        duration: Duration(milliseconds: 900),
        autoScroll: true,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Padding(
            padding: EdgeInsets.all(30),
            child: isLogin
                ? Form(
                    key: _loginFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CustomTextFormField(
                              labelText: "Email",
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: FontAwesomeIcons.envelope,
                              onSaved: (value) =>
                                  loginFormValues["email"] = value,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!EmailValidator.validate(value)) {
                                  return 'Invalid email';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 20),
                              child: CustomTextFormField(
                                labelText: "Password",
                                prefixIcon: FontAwesomeIcons.lock,
                                obscureText: _loginObscureText,
                                onSaved: (value) =>
                                    loginFormValues["password"] = value,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
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
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 20),
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
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : Form(
                    key: _signupFormKey,
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomTextFormField(
                                labelText: "First Name",
                                prefixIcon: FontAwesomeIcons.user,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    signUpFormValues["firstName"] = value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomTextFormField(
                                labelText: "Last Name",
                                prefixIcon: FontAwesomeIcons.userFriends,
                                textCapitalization: TextCapitalization.words,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter your last name';
                                  }
                                  return null;
                                },
                                onSaved: (value) =>
                                    signUpFormValues["lastName"] = value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomTextFormField(
                                labelText: "Email",
                                prefixIcon: FontAwesomeIcons.envelope,
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
                                onSaved: (value) =>
                                    signUpFormValues["email"] = value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomTextFormField(
                                labelText: "Password",
                                obscureText: _signupObscureText,
                                prefixIcon: FontAwesomeIcons.lock,
                                validator: (value) {
                                  if (_signupWeakPassword) {
                                    return "Password is too weak";
                                  } else if (value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
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
                                onSaved: (value) =>
                                    signUpFormValues["password"] = value,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: CustomTypeAheadField(
                                field: "homeCity",
                                placeholder: "Home City",
                                offset: -30,
                                callback: (value) {},
                                controller: TextEditingController(),
                                suggestionsCallback: (pattern) {
                                  return suggestions
                                      .getCitySuggestions(pattern);
                                },
                                itemBuilder: (context, suggestion) {
                                  return Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          EmojiParser()
                                              .get("flag-" +
                                                  suggestion["countryCode"])
                                              .code,
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline4,
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  suggestion["cityName"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText1,
                                                  // overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  suggestion["countryName"],
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyText2,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 40),
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
                                child: SubmitButton(text: "Create Account"),
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
                                          color:
                                              Theme.of(context).primaryColor),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
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
        .then(
      (result) async {
        var user = result.user;
        if (user.emailVerified) {
          isLoggedIn = true;
          currentUser = await getUserDetails(user.uid);
          // currentUser["profilePictureURL"] = "assets/images/alice.jpeg";

          widget.callback();
          Navigator.pop(context);
        } else {
          showErrorToast(context, "Please verify your email before you login");
        }
      },
    );
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
      showSuccessToast(
          context,
          "Nice one " +
              signUpFormValues["firstName"] +
              "! We've sent a verification link to " +
              signUpFormValues["email"] +
              "\nClick that link and log in!");
      user = _auth.currentUser;
      await user.updateProfile(displayName: signUpFormValues["firstName"]);
      user.sendEmailVerification();

      print(user.displayName);

      await addNewUserDetails(user.uid, user.email,
          signUpFormValues["firstName"], signUpFormValues["lastName"]);
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
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.4),
            blurRadius: 10.0,
            offset: Offset(0, 5),
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
