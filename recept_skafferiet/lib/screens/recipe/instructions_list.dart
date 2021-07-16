import 'package:flutter/material.dart';

class InstructionsList extends StatelessWidget {
  final List<String> _instructions;

  InstructionsList(this._instructions);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(), // MAKES NOT SCROLLABLE
          padding: const EdgeInsets.all(8),
          itemCount: _instructions.length,
          separatorBuilder: (context, index) {
            return Divider(color: Colors.grey);
          },
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 30,
              child: Text('${_instructions[index]}'),
            );
          }),
    );
  }
}
