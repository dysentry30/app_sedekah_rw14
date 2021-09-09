import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            children: [
              Text("Sedekah RW 14"),
              Text(
                "Mekarsari, Cimanggis, Depok",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w200),
              ),
            ],
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: constraints.maxHeight,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Masuk ke Sistem Sedekah RW 14 Cimanggis Depok",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Username"),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.people,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Kata Sandi"),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.lock,
                                  size: 15,
                                  color: Colors.green,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Column(
                              children: [
                                TextButton.icon(
                                  onPressed: () async {
                                    SharedPreferences session =
                                        await SharedPreferences.getInstance();
                                    Uri url = Uri.parse(
                                        "http://192.168.100.100:3000/masuk");
                                    var response = await http.post(
                                      url,
                                      headers: <String, String>{
                                        'Content-Type':
                                            'application/json; charset=UTF-8',
                                      },
                                      body: jsonEncode({
                                        "username":
                                            _usernameController.text.trim(),
                                        "password":
                                            _passwordController.text.trim(),
                                      }),
                                    );
                                    if (response.statusCode == 200) {
                                      Map<String, dynamic> result =
                                          jsonDecode(response.body)
                                              as Map<String, dynamic>;
                                      if (result["status"].toString() ==
                                          "Failed") {
                                        var alertDialog = AlertDialog(
                                          title: Text(result["title"]),
                                          content: Text(result["message"]),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Mengerti")),
                                          ],
                                        );
                                        showDialog(
                                            context: context,
                                            builder: (_) => alertDialog);
                                      } else {
                                        Map<String, dynamic> user =
                                            jsonDecode(response.body);
                                        var jsonUser =
                                            jsonEncode(jsonEncode(user));
                                        await session.setString(
                                            "user", jsonUser);
                                        const snackBar = SnackBar(
                                          content: Text("Berhasil masuk"),
                                          duration: Duration(seconds: 2),
                                        );
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        Navigator.pop(context);
                                      }
                                    }
                                  },
                                  icon: Icon(
                                    Icons.login,
                                    size: 20,
                                  ),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green[500],
                                    fixedSize: Size(constraints.maxWidth, 30),
                                  ),
                                  label: Text("Masuk"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
