import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sudoku'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Bienvenue sur Sudoku'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/game'),
              child: const Text('Lancer une partie'),
            ),
          ],
        ),
      ),
    );
  }
}
