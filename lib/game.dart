import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:flutter_chessbot_ai/stockfish_manager.dart';

class MoveRequest {
  final String fen;
  final String gameId;
  final Completer<String> completer;

  MoveRequest(this.fen, this.gameId, this.completer);
}

class Game extends StatefulWidget {
  const Game({
    super.key,
    required this.title,
    required this.instanceId,
  });

  final String title;
  final String instanceId;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final controller = ChessBoardController();

  final stockfishManager = StockfishManager();

  @override
  void initState() {
    super.initState();
    stockfishManager.initialize();
  }

  // Stockfish? stockFish;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   initializeStockfish();
  // }
  //
  // Future<void> initializeStockfish() async {
  //   stockFish = await stockfishAsync();
  // }

  @override
  void dispose() {
    stockfishManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chess Board in ${widget.title}')),
      body: Center(
        child: ChessBoard(
          enableUserMoves: true,
          controller: controller,
          onMove: () {
            generateAIMove();
          },
          boardColor: BoardColor.brown,
          boardOrientation: PlayerColor.white,
        ),
      ),
    );
  }

  // Future<void> generateAIMove() async {
  //   final currentPosition = controller.getFen();
  //
  //   stockFish!.stdin = 'position fen $currentPosition';
  //   stockFish!.stdin = 'go movetime ${1 * 1000}';
  //
  //   stockFish!.stdout.listen((event) {
  //     if (event.contains('bestmove')) {
  //       final bestMove = event.split(' ')[1];
  //       final from = bestMove.substring(0, 2);
  //       final to = bestMove.substring(2, 4);
  //
  //       setState(() {
  //         controller.makeMove(from: from, to: to);
  //       });
  //     }
  //   });
  // }

  Future<void> generateAIMove() async {
    final currentPosition = controller.getFen();

    final bestMove = await stockfishManager.requestMove(
      currentPosition,
      widget.instanceId,
    );

    if (bestMove != null) {
      final from = bestMove.substring(0, 2);
      final to = bestMove.substring(2, 4);

      setState(() {
        controller.makeMove(from: from, to: to);
      });
    }
  }
}
