import 'package:flutter/material.dart';

import 'button.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select a City to play',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 100),
            ChessButton(title: 'Lagos', instanceId: '1',),
            SizedBox(height: 20),
            ChessButton(title: 'Kano', instanceId: '2',),
            SizedBox(height: 20),
            ChessButton(title: 'Port Harcourt', instanceId: '3',),
            SizedBox(height: 20),
            ChessButton(title: 'Warri', instanceId: '4',),
          ],
        ),
      ),
    );
  }
}
