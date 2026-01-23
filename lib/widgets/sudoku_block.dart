import 'package:flutter/material.dart';

class SudokuBlock extends StatelessWidget {
  const SudokuBlock({super.key, required this.boxSize});

  final double boxSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize,
      height: boxSize,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueAccent),
      ),
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: List.generate(9, (cellIndex) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
            ),
          );
        }),
      ),
    );
  }
}
