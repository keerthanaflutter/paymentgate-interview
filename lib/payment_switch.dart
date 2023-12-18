import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class PaymentSwitch extends StatefulWidget {
  String name;
  PaymentSwitch({
    super.key,
    required this.name,
  });

  @override
  State<PaymentSwitch> createState() => _PaymentSwitchState();
}

class _PaymentSwitchState extends State<PaymentSwitch> {
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(widget.name),
        Switch(
          value: switchValue,
          onChanged: (value) {
            setState(() {
              switchValue = value;
            });
          },
        ),
      ],
    );
  }
}