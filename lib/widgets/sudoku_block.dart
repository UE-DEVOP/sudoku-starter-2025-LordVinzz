import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class SudokuBlock extends StatelessWidget {
  const SudokuBlock({
    super.key,
    required this.boxSize,
    required this.blockIndex,
    required this.puzzle,
  });

  final double boxSize;
  final int blockIndex;
  final Puzzle puzzle;

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
          final value =
              puzzle.board()?.matrix()?[blockIndex][cellIndex].getValue() ?? 0;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
            ),
            child: Center(
              child: Text(value == 0 ? '' : value.toString()),
            ),
          );
        }),
      ),
    );
  }
}
