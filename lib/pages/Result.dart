import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Result extends StatefulWidget {
  late String value;
  late Map<String, dynamic> user;
  Result({Key? key, required this.value, required this.user}) : super(key: key);

  @override
  _ResultState createState() => _ResultState(value: value, user: user);
}

class _ResultState extends State<Result> {
  late String value;
  late int amount;
  late Map<String, dynamic> user;
  TextEditingController _idFamilyController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  _ResultState({required this.value, required this.user});

  @override
  void dispose() {
    _idFamilyController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if ((value == null || value == "") && user == null) {
      Navigator.pop(context);
    } else {
      _idFamilyController.text = value;
    }
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
                          Text("Nomor Kartu Keluarga"),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            readOnly: true,
                            enabled: false,
                            controller: _idFamilyController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("Jumlah Sedekah"),
                          SizedBox(
                            height: 5,
                          ),
                          TextField(
                            onChanged: (String newAmount) {
                              if (newAmount != "") {
                                newAmount = newAmount.replaceAll(".", "");
                                String result = NumberFormat.currency(
                                        decimalDigits: 0,
                                        symbol: "",
                                        locale: "id")
                                    .format(int.parse(newAmount));
                                _amountController.value = TextEditingValue(
                                  text: result,
                                  selection: TextSelection.fromPosition(
                                    TextPosition(offset: result.length),
                                  ),
                                );
                              }
                            },
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefix: Text("Rp. "),
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
                                    if (_amountController.text == "") {
                                      var snackBar = SnackBar(
                                        content:
                                            Text("Silahkan isi Jumlah Sedekah"),
                                        duration: Duration(seconds: 2),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                      return;
                                    }
                                    amount = int.parse(_amountController.text
                                        .trim()
                                        .replaceAll(".", ""));
                                    // print(amount);
                                    // print(user);
                                    Uri url = Uri.parse(
                                        "http://192.168.100.100:3000/buat-data-sedekah");
                                    var response = await http.post(url,
                                        headers: <String, String>{
                                          'Content-Type':
                                              'application/json; charset=UTF-8',
                                        },
                                        body: jsonEncode({
                                          "dataCharity": {
                                            "idFamily": int.parse(
                                                _idFamilyController.text
                                                    .trim()
                                                    .toString()),
                                            "amount": amount,
                                          },
                                          "user": user,
                                        }));

                                    if (response.statusCode == 200) {
                                      var result = jsonDecode(response.body);
                                      var snackBar;
                                      if (result.status == "Success") {
                                        snackBar = SnackBar(
                                          content: Text(
                                              "Data Sedekah Berhasil Ditambah"),
                                          duration: Duration(seconds: 2),
                                        );
                                      } else {
                                        snackBar = SnackBar(
                                          content: Column(
                                            children: [
                                              Text(
                                                result.title,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(result.message),
                                            ],
                                          ),
                                          duration: Duration(seconds: 2),
                                        );
                                      }
                                    }
                                  },
                                  icon: Icon(Icons.create),
                                  style: TextButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: Colors.green[500],
                                    fixedSize: Size(constraints.maxWidth, 30),
                                  ),
                                  label: Text("Buat Data"),
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
