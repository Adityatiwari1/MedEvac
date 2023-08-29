// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import '../reusable_widget/reusable_widget.dart';
import '../database/mongo_service.dart';
import 'home.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({Key? key}) : super(key: key);

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {
  final TextEditingController _passwordTextController = TextEditingController();
  final TextEditingController _idTextController = TextEditingController();

  Future<void> handlelogin(String username, String password) async {
    final username = _idTextController.text;
    final password = _passwordTextController.text;

    final user = await MongoService.userCollection.findOne(
      mongo.where.eq('username', username),
    );

    if (user != null &&
        user.containsKey('password') &&
        user['password'] == password) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Homescreen()),
      );
    } else {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: const Text('Invalid Id or Password'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Ok'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90.0),
        child: Align(
          alignment: Alignment.center,
          child: AppBar(
            toolbarHeight: 140,
            backgroundColor: const Color(0xFF6C9BCF),
            title: const Column(
              children: [
                Text(
                  'Welcome to MedEvac',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7E1717),
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "Your Trusted Medical Health Companion",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF4E3636),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            centerTitle: true,
          ),
        ),
      ),
      body: Stack(
        children: [
          const Opacity(
            opacity: 0.5,
            child: BackgroundImage(),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xFFDDE6ED),
                  ),
                  height: 400.0,
                  width: 400.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.add,
                        color: Colors.red,
                        size: 90,
                      ),
                      const Text(
                        "Sign In Here!",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      reusableTextField(
                        "Enter Login ID",
                        false,
                        _idTextController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      reusableTextField(
                        "Enter Password",
                        true,
                        _passwordTextController,
                        onSubmitEnabled: true,
                        onSubmit: handlelogin,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          sosButton(context, () {}),
                          loginButton(context, () {
                            final username = _idTextController.text;
                            final password = _passwordTextController.text;
                            handlelogin(username,password);
                          },(){
                            final username = _idTextController.text;
                            final password = _passwordTextController.text;
                            handlelogin(username,password);
                          }),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
