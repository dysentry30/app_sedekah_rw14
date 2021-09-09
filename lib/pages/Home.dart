import 'dart:convert';

import 'package:app_sedekah_rw14/pages/Result.dart';
import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:encrypt/encrypt.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String text = "";
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
                          children: [
                            Text(text),
                            TextButton.icon(
                              onPressed: () async {
                                var result;
                                SharedPreferences session =
                                    await SharedPreferences.getInstance();
                                var user = jsonDecode(jsonDecode(session
                                        .getString("user")
                                        .toString())) ??
                                    null;
                                if (user == null) {
                                  Navigator.pushNamed(context, "/login");
                                  return;
                                }
                                PermissionStatus status =
                                    await Permission.camera.status;
                                if (status == PermissionStatus.denied) {
                                  status = await Permission.camera.request();
                                  result = await scanner.scan();
                                  result = Base64Decoder().convert(result);
                                } else if (status == PermissionStatus.granted) {
                                  result = await scanner.scan();
                                  result = utf8.decode(base64.decode(result));
                                }
                                if (result != null &&
                                    result.toString().contains("sedekah")) {
                                  result = result
                                      .toString()
                                      .trim()
                                      .replaceAll("sedekah", "");
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Result(
                                        value: result,
                                        user: user,
                                      ),
                                    ),
                                  );
                                } else {
                                  text = "QRCODE / BARCODE Tidak Sesuai";
                                  // print("QRCODE / BARCODE Tidak Sesuai");
                                  setState(() {});
                                }
                              },
                              icon: Icon(Icons.qr_code_scanner),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                fixedSize: Size(constraints.maxWidth, 30),
                              ),
                              label: Text("Scan"),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                SharedPreferences session =
                                    await SharedPreferences.getInstance();
                                await session.remove("user");
                                var snackBar = SnackBar(
                                  content: Text("Berhasil keluar dari sistem"),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              },
                              icon: Icon(Icons.logout),
                              style: TextButton.styleFrom(
                                primary: Colors.black,
                                backgroundColor: Colors.redAccent,
                                fixedSize: Size(constraints.maxWidth, 30),
                              ),
                              label: Text("Logout"),
                            ),
                          ],
                        ),
                      )),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
