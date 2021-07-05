import 'package:flutter/material.dart';

class InstructionsList extends StatelessWidget {
  final List<String> _instructions;

  InstructionsList(this._instructions);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          itemCount: _instructions.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 50,
              child: Text('${_instructions[index]}'),
            );
          }),
    );
  }
}
