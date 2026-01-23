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
            : SizedBox(
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
      ),
    );
  }
}
