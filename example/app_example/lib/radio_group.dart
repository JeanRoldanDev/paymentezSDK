import 'package:flutter/material.dart';

class RadioGroup extends StatefulWidget {
  const RadioGroup({required this.onChanged, super.key});

  final void Function(int) onChanged;

  @override
  State<RadioGroup> createState() => _RadioGroupState();
}

class _RadioGroupState extends State<RadioGroup> {
  int _selectedOption = 1;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xffe6cc01),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: RadioListTile(
              title: const Text(
                'InappWebview',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              contentPadding: EdgeInsets.zero,
              value: 1,
              selected: true,
              groupValue: _selectedOption,
              onChanged: (int? value) {
                setState(() {
                  _selectedOption = value!;
                  widget.onChanged(value);
                });
              },
            ),
          ),
          Expanded(
            child: RadioListTile(
              title: const Text(
                'webview',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              value: 2,
              groupValue: _selectedOption,
              contentPadding: EdgeInsets.zero,
              onChanged: (int? value) {
                setState(() {
                  _selectedOption = value!;
                  widget.onChanged(value);
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
