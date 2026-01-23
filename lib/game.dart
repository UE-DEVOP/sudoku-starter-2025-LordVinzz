import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:sudoku_api/sudoku_api.dart';
import 'package:sudoku_starter/widgets/sudoku_block.dart';

class Game extends StatefulWidget {
  const Game({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
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
    } else {
      _showWrongValue();
    }
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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
