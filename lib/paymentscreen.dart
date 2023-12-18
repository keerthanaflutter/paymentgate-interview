import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:interview/payment_switch.dart';
//import 'package:payment/switch_widget.dart';

import 'payment_model.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  List<User> users = [];
  bool switchValue = false;

  final alphaName = [
    "A",
    "B",
    "C",
    "D",
    "E",
    "F",
    "G",
    "H",
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final response = await http
        .get(Uri.parse('https://randomuser.me/api/?results=100&gender=male'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      setState(() {
        users = results.map((user) => User.fromJson(user)).toList();
      });
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _updatePaymentMethod(User user, int paymentAmount, bool isCash) {
    setState(() {
      user.paymentAmount = paymentAmount;
      user.isCash = isCash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'TODO',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w300),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              color: const Color.fromARGB(255, 216, 235, 252),
              child: GridView.builder(
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index];
                  return InkWell(
                    onTap: () {
                      _showPaymentDialog(userData);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(userData.picture),
                            backgroundColor:
                                userData.isPaid ? Colors.green : null,
                          ),
                          const SizedBox(height: 10),
                          Text(userData.name),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // alphabet names
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 216, 235, 252),
              child: ListView.builder(
                itemCount: alphaName.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 20,
                      width: 55,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Center(
                        child: Text(
                          alphaName[index],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      // fab
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(top: 400),
        child: Column(
          children: [
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.paid),
            ),
            const SizedBox(height: 30),
            FloatingActionButton(
              onPressed: () {},
              child: const Icon(Icons.group_add_outlined),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaymentDialog(User user) async {
    int paymentAmount = user.paymentAmount;
    bool isCash = user.isCash;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(user.name)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                initialValue: paymentAmount.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.paid_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  paymentAmount = int.tryParse(value) ?? 0;
                },
              ),
              const SizedBox(height: 10),
              // Text('Payment Method:'),
              Column(
                children: [
                  PaymentSwitch(name: "UPI"),
                  PaymentSwitch(name: "CASH"),
                  PaymentSwitch(name: "LATER"),
                ],
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    _updatePaymentMethod(user, paymentAmount, isCash);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}