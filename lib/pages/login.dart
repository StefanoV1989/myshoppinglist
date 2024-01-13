import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/pages/home.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late AuthenticationBloc authBloc;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void initState() {
    super.initState();

    authBloc = BlocProvider.of<AuthenticationBloc>(context);

    authBloc.stream.listen((state) {
      if (state is Authorized) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Homepage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          ClipPath(
            clipper: LoginClipper(),
            child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.8,
                color: Colors.red[800],
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 200),
                      child: const Text(
                        "My Shopping List - Login",
                        style: TextStyle(fontSize: 30, color: Colors.white),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 50, right: 50, top: 50),
                      child: TextFormField(
                        controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      child: TextFormField(
                        controller: password,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          fillColor: Colors.white,
                          filled: true,
                          isDense: true,
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 10),
                      child: SizedBox(
                        width: 100,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                          ),
                          onPressed: () async {
                            authBloc.add(LoggedIn(username: email.text, password: password.text));
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 50),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[800],
              ),
              onPressed: () {},
              child: const Text("Register"),
            ),
          )
        ],
      ),
    ));
  }
}

class LoginClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 50);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height - 100, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
