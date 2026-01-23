import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/widgets/sudoku_block.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  Puzzle? _puzzle;
  bool _isLoading = true;
  int? _selectedBlock;
  int? _selectedCell;

  @override
  void initState() {
    super.initState();
    _generatePuzzle();
  }

  @override
  void dispose() {
    _puzzle?.dispose();
    super.dispose();
  }

  Future<void> _generatePuzzle() async {
    final puzzle = Puzzle(PuzzleOptions(name: 'Sudoku', clues: 30));
    await puzzle.generate();
    if (!mounted) {
      return;
    }
    setState(() {
      _puzzle = puzzle;
      _isLoading = false;
    });
  }

  void _selectCell(int blockIndex, int cellIndex) {
    setState(() {
      _selectedBlock = blockIndex;
      _selectedCell = cellIndex;
    });
  }

  void _enterValue(int value) {
    if (_puzzle == null || _selectedBlock == null || _selectedCell == null) {
      return;
    }
    final solvedValue = _puzzle
        ?.solvedBoard()
        ?.matrix()?[_selectedBlock!][_selectedCell!]
        .getValue();
    if (solvedValue == null) {
      return;
    }
    if (value == solvedValue) {
      setState(() {
        final pos = Position(row: _selectedBlock!, column: _selectedCell!);
        _puzzle!.board()!.cellAt(pos).setValue(value);
      });
      if (_isSolved()) {
        context.go('/end');
      }
    } else {
      _showWrongValue();
    }
  }

  bool _isSolved() {
    final board = _puzzle?.board()?.matrix();
    final solved = _puzzle?.solvedBoard()?.matrix();
    if (board == null || solved == null) {
      return false;
    }
    for (var row = 0; row < 9; row++) {
      for (var col = 0; col < 9; col++) {
        if (board[row][col].getValue() != solved[row][col].getValue()) {
          return false;
        }
      }
    }
    return true;
  }

  void _showWrongValue() {
    const snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Erreur',
        message: 'Cette valeur n\'est pas correcte.',
        contentType: ContentType.failure,
      ),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  Widget _buildNumberRow(List<int> values) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: values
          .map(
            (value) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ElevatedButton(
                onPressed: () => _enterValue(value),
                child: Text('$value'),
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height / 2;
    var width = MediaQuery.of(context).size.width;
    var maxSize = height > width ? width : height;
    var boxSize = (maxSize / 3).ceil().toDouble();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: boxSize * 3,
                    width: boxSize * 3,
                    child: GridView.count(
                      crossAxisCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: List.generate(9, (blockIndex) {
                        return SudokuBlock(
                          boxSize: boxSize,
                          blockIndex: blockIndex,
                          puzzle: _puzzle!,
                          selectedBlock: _selectedBlock,
                          selectedCell: _selectedCell,
                          onCellTap: _selectCell,
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildNumberRow(const [1, 2, 3, 4, 5]),
                  const SizedBox(height: 8),
                  _buildNumberRow(const [6, 7, 8, 9]),
                ],
              ),
      ),
    );
  }
}
