import 'dart:async';

import 'package:stockfish/stockfish.dart';

import 'game.dart';

class StockfishManager {
  static final StockfishManager _instance = StockfishManager._internal();
  factory StockfishManager() => _instance;
  StockfishManager._internal();

  Stockfish? _stockfish;
  final _moveQueue = <MoveRequest>[];
  bool _isProcessing = false;

  Future<void> initialize() async {
    _stockfish ??= await stockfishAsync();
  }

  Future<String?> requestMove(String fen, String gameId) async {
    if (_stockfish == null) {
      await initialize();
    }

    final completer = Completer<String>();
    _moveQueue.add(MoveRequest(fen, gameId, completer));
    _processMoveQueue();
    return completer.future;
  }

  void _processMoveQueue() async {
    if (_isProcessing || _moveQueue.isEmpty || _stockfish == null) return;

    _isProcessing = true;
    while (_moveQueue.isNotEmpty) {
      final request = _moveQueue.removeAt(0);

      final moveCompleter = Completer<void>();
      late StreamSubscription subscription;

      subscription = _stockfish!.stdout.listen((event) {
        if (event.contains('bestmove')) {
          final bestMove = event.split(' ')[1];
          request.completer.complete(bestMove);
          subscription.cancel();
          moveCompleter.complete();
        }
      });

      _stockfish!.stdin = 'position fen ${request.fen}';
      _stockfish!.stdin = 'go movetime ${1 * 1000}';

      await moveCompleter.future;
    }
    _isProcessing = false;
  }

  void dispose() {
    _stockfish?.dispose();
    _stockfish = null;
  }
}
