import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:portfolio/core/theme/app_theme.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({Key? key}) : super(key: key);

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int GRID_SIZE = 20;
  static const double CELL_SIZE = 15.0;
  
  List<Offset> _snake = [];
  Offset? _food;
  Timer? _timer;
  Direction _direction = Direction.right;
  bool _isGameOver = false;
  int _score = 0;
  final Random _random = Random();
  
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    _startGame();
    _focusNode.requestFocus();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _focusNode.dispose();
    super.dispose();
  }
  
  void _startGame() {
    setState(() {
      _snake = [
        const Offset(5, 5),
        const Offset(4, 5),
        const Offset(3, 5),
      ];
      _direction = Direction.right;
      _isGameOver = false;
      _score = 0;
      _generateFood();
    });
    
    _timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      _updateGame();
    });
  }
  
  void _generateFood() {
    int x, y;
    do {
      x = _random.nextInt(GRID_SIZE);
      y = _random.nextInt(GRID_SIZE);
    } while (_snake.contains(Offset(x.toDouble(), y.toDouble())));
    
    setState(() {
      _food = Offset(x.toDouble(), y.toDouble());
    });
  }
  
  void _updateGame() {
    if (_isGameOver) return;
    
    setState(() {
      // Calculate new head position
      Offset head = _snake.first;
      Offset newHead;
      
      switch (_direction) {
        case Direction.up:
          newHead = Offset(head.dx, (head.dy - 1) % GRID_SIZE);
          break;
        case Direction.down:
          newHead = Offset(head.dx, (head.dy + 1) % GRID_SIZE);
          break;
        case Direction.left:
          newHead = Offset((head.dx - 1) % GRID_SIZE, head.dy);
          break;
        case Direction.right:
          newHead = Offset((head.dx + 1) % GRID_SIZE, head.dy);
          break;
      }
      
      // Handle negative wrap-around
      if (newHead.dx < 0) newHead = Offset(GRID_SIZE - 1, newHead.dy);
      if (newHead.dy < 0) newHead = Offset(newHead.dx, GRID_SIZE - 1);
      
      // Check if snake hit itself
      if (_snake.contains(newHead)) {
        _gameOver();
        return;
      }
      
      // Add new head
      _snake.insert(0, newHead);
      
      // Check if snake ate food
      if (newHead == _food) {
        _score++;
        _generateFood();
      } else {
        // Remove tail if no food was eaten
        _snake.removeLast();
      }
    });
  }
  
  void _gameOver() {
    setState(() {
      _isGameOver = true;
    });
    _timer?.cancel();
  }
  
  void _onKeyEvent(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (_isGameOver) {
        if (event.logicalKey == LogicalKeyboardKey.space) {
          _startGame();
        }
        return;
      }
      
      switch (event.logicalKey) {
        case LogicalKeyboardKey.arrowUp:
          if (_direction != Direction.down) {
            setState(() => _direction = Direction.up);
          }
          break;
        case LogicalKeyboardKey.arrowDown:
          if (_direction != Direction.up) {
            setState(() => _direction = Direction.down);
          }
          break;
        case LogicalKeyboardKey.arrowLeft:
          if (_direction != Direction.right) {
            setState(() => _direction = Direction.left);
          }
          break;
        case LogicalKeyboardKey.arrowRight:
          if (_direction != Direction.left) {
            setState(() => _direction = Direction.right);
          }
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Snake Game Easter Egg!'),
        backgroundColor: AppColors.accentPrimary,
      ),
      body: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: _onKeyEvent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Score: $_score',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: GRID_SIZE * CELL_SIZE,
                height: GRID_SIZE * CELL_SIZE,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.accentPrimary, width: 2),
                  color: AppColors.cardBackground,
                ),
                child: Stack(
                  children: [
                    // Draw food
                    if (_food != null)
                      Positioned(
                        left: _food!.dx * CELL_SIZE,
                        top: _food!.dy * CELL_SIZE,
                        child: Container(
                          width: CELL_SIZE,
                          height: CELL_SIZE,
                          decoration: const BoxDecoration(
                            color: AppColors.accentTertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    
                    // Draw snake
                    ..._snake.map((segment) {
                      final isHead = segment == _snake.first;
                      return Positioned(
                        left: segment.dx * CELL_SIZE,
                        top: segment.dy * CELL_SIZE,
                        child: Container(
                          width: CELL_SIZE,
                          height: CELL_SIZE,
                          decoration: BoxDecoration(
                            color: isHead ? AppColors.accentSecondary : AppColors.accentPrimary,
                            borderRadius: BorderRadius.circular(isHead ? 3 : 0),
                          ),
                        ),
                      );
                    }).toList(),
                    
                    // Game over overlay
                    if (_isGameOver)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Game Over!',
                                style: TextStyle(
                                  color: AppColors.accentTertiary,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Score: $_score',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _startGame,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.accentSecondary,
                                ),
                                child: const Text('Play Again'),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Use arrow keys to control the snake',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.arrow_upward, () {
                    if (_direction != Direction.down) {
                      setState(() => _direction = Direction.up);
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.arrow_back, () {
                    if (_direction != Direction.right) {
                      setState(() => _direction = Direction.left);
                    }
                  }),
                  const SizedBox(width: 50),
                  _buildControlButton(Icons.arrow_forward, () {
                    if (_direction != Direction.left) {
                      setState(() => _direction = Direction.right);
                    }
                  }),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildControlButton(Icons.arrow_downward, () {
                    if (_direction != Direction.up) {
                      setState(() => _direction = Direction.down);
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: _isGameOver ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Icon(icon),
      ),
    );
  }
}

enum Direction {
  up,
  down,
  left,
  right,
}
