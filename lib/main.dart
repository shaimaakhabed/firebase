import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/firebaseauth/auth.dart';
import 'package:string_validator/string_validator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: App()));
}

class App extends StatefulWidget {
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // Set default `_initialized` and `_error` state to false
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  @override
  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    if (_error) {
      return Scaffold(
        backgroundColor: Colors.red,
        body: Center(
          child: Text('Exception occured'),
        ),
      );
    }

    // Show a loader until FlutterFire is initialized
    if (!_initialized) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return SplachScreen();
  }
}

class AuthPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Auth Page'),
          bottom: TabBar(tabs: [
            Tab(
              child: Text('Login'),
            ),
            Tab(
              child: Text('Register'),
            ),
          ]),
        ),
        body: TabBarView(
          children: [LoginForm(), RegisterForm()],
        ),
      ),
    );
  }
}

class LoginForm extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                validator: (v) {
                  if (!isEmail(v)) {
                    return 'InValid Email Syntax';
                  }
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                validator: (v) {
                  if (v.length <= 6) {
                    return 'the password must be larger than 6 symbols';
                  }
                },
                obscureText: true,
                controller: passwordController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            RaisedButton(onPressed: () {
             AuthHelper.authHelper.forgetPassword(emailController.text);
            }, child: Text('Forget Password')),
            SizedBox(
              height: 20,
            ),
            RaisedButton(
              onPressed: () async {
                if (formKey.currentState.validate()) {
                  await AuthHelper.authHelper.login(
                      emailController.text, passwordController.text, context);
                  if (FirebaseAuth.instance.currentUser.emailVerified) {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return HomePage();
                    }));
                  } else {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            content:
                                Text('you have to verify your email first'),
                            actions: [
                              RaisedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'))
                            ],
                          );
                        });
                  }
                }
              },
              child: Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatelessWidget {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                validator: (v) {
                  if (!isEmail(v)) {
                    return 'InValid Email Syntax';
                  }
                },
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              child: TextFormField(
                validator: (v) {
                  if (v.length <= 6) {
                    return 'the password must be larger than 6 symbols';
                  }
                },
                obscureText: true,
                controller: passwordController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10))),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState.validate()) {
                  AuthHelper.authHelper.register(
                      emailController.text, passwordController.text, context);
                }
              },
              child: Text('Register'),
            )
          ],
        ),
      ),
    );
  }
}

class SplachScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3)).then((value) {
      if (AuthHelper.authHelper.checkUser()) {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      } else {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) {
          return AuthPage();
        }));
      }
    });
    // TODO: implement build
    return Center(
      child: FlutterLogo(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                await AuthHelper.authHelper.logout();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return AuthPage();
                }));
              })
        ],
        title: Text('Home Page'),
      ),
    );
  }
}