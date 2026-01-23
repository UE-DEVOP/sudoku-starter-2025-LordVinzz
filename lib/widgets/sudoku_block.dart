import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';

class SudokuBlock extends StatelessWidget {
  const SudokuBlock({
    super.key,
    required this.boxSize,
    required this.blockIndex,
    required this.puzzle,
    required this.selectedBlock,
    required this.selectedCell,
    required this.onCellTap,
  });

  final double boxSize;
  final int blockIndex;
  final Puzzle puzzle;
  final int? selectedBlock;
  final int? selectedCell;
  final void Function(int blockIndex, int cellIndex) onCellTap;

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
          final isSelected =
              blockIndex == selectedBlock && cellIndex == selectedCell;
          return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 0.3),
              color: isSelected
                  ? Colors.blueAccent.shade100.withAlpha(100)
                  : Colors.transparent,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => onCellTap(blockIndex, cellIndex),
                child: Center(
                  child: Text(value == 0 ? '' : value.toString()),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
