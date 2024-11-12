import 'package:flutter/material.dart';

import 'game.dart';

class ChessButton extends StatelessWidget {
  const ChessButton({
    super.key,
    required this.title,
    required this.instanceId,
  });

  final String title;
  final String instanceId;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.8,
      height: 52,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(40.0),
              side: const BorderSide(color: Colors.grey),
            ),
          ),
          backgroundColor: WidgetStateProperty.all<Color>(Colors.yellowAccent),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Game(
                title: title,
                instanceId: instanceId,
              ),
            ),
          );
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
