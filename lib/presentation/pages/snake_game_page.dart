import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class SnakeGamePage extends StatefulWidget {
  const SnakeGamePage({Key? key}) : super(key: key);

  @override
  State<SnakeGamePage> createState() => _SnakeGamePageState();
}

class _SnakeGamePageState extends State<SnakeGamePage> {
  static const int _gridSize = 20;
  static const double _cellSize = 15.0;
  
  List<Offset> _snake = [];
  Offset? _food;
  Direction _direction = Direction.right;
  Direction _nextDirection = Direction.right;
  Timer? _timer;
  int _score = 0;
  int _highScore = 0;
  bool _isGameOver = false;
  bool _isPaused = false;
  double _swipeStartX = 0;
  double _swipeStartY = 0;
  
  @override
  void initState() {
    super.initState();
    _loadHighScore();
    _initGame();
  }
  
  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _highScore = prefs.getInt('snake_high_score') ?? 0;
    });
  }
  
  Future<void> _saveHighScore() async {
    if (_score > _highScore) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('snake_high_score', _score);
      setState(() {
        _highScore = _score;
      });
    }
  }
  
  void _initGame() {
    // Initialize snake at the center of the grid
    final center = Offset(
      (_gridSize / 2).floor().toDouble(),
      (_gridSize / 2).floor().toDouble(),
    );
    
    _snake = [
      center,
      Offset(center.dx - 1, center.dy),
      Offset(center.dx - 2, center.dy),
    ];
    
    _direction = Direction.right;
    _nextDirection = Direction.right;
    _score = 0;
    _isGameOver = false;
    _isPaused = false;
    
    // Generate initial food
    _generateFood();
    
    // Start the game loop
    _startGameLoop();
  }
  
  void _startGameLoop() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (!_isPaused && !_isGameOver) {
        _updateGame();
      }
    });
  }
  
  void _generateFood() {
    final random = Random();
    Offset newFood;
    
    // Generate food at a random position that is not occupied by the snake
    do {
      newFood = Offset(
        random.nextInt(_gridSize).toDouble(),
        random.nextInt(_gridSize).toDouble(),
      );
    } while (_snake.contains(newFood));
    
    setState(() {
      _food = newFood;
    });
  }
  
  void _updateGame() {
    setState(() {
      // Update direction
      _direction = _nextDirection;
      
      // Calculate new head position
      final head = _snake.first;
      Offset newHead;
      
      switch (_direction) {
        case Direction.up:
          newHead = Offset(head.dx, head.dy - 1);
          break;
        case Direction.right:
          newHead = Offset(head.dx + 1, head.dy);
          break;
        case Direction.down:
          newHead = Offset(head.dx, head.dy + 1);
          break;
        case Direction.left:
          newHead = Offset(head.dx - 1, head.dy);
          break;
      }
      
      // Check for collisions with walls
      if (newHead.dx < 0 || newHead.dx >= _gridSize || newHead.dy < 0 || newHead.dy >= _gridSize) {
        _gameOver();
        return;
      }
      
      // Check for collisions with self
      if (_snake.contains(newHead)) {
        _gameOver();
        return;
      }
      
      // Move the snake
      _snake.insert(0, newHead);
      
      // Check if the snake ate the food
      if (newHead == _food) {
        _score++;
        _generateFood();
      } else {
        _snake.removeLast();
      }
    });
  }
  
  void _gameOver() {
    setState(() {
      _isGameOver = true;
    });
    _timer?.cancel();
    _saveHighScore();
  }
  
  void _onDirectionChange(Direction newDirection) {
    // Prevent 180-degree turns
    if ((_direction == Direction.up && newDirection == Direction.down) ||
        (_direction == Direction.down && newDirection == Direction.up) ||
        (_direction == Direction.left && newDirection == Direction.right) ||
        (_direction == Direction.right && newDirection == Direction.left)) {
      return;
    }
    
    setState(() {
      _nextDirection = newDirection;
    });
  }
  
  void _togglePause() {
    setState(() {
      _isPaused = !_isPaused;
    });
  }
  
  void _handleSwipeStart(DragStartDetails details) {
    _swipeStartX = details.globalPosition.dx;
    _swipeStartY = details.globalPosition.dy;
  }
  
  void _handleSwipeUpdate(DragUpdateDetails details) {
    final dx = details.globalPosition.dx - _swipeStartX;
    final dy = details.globalPosition.dy - _swipeStartY;
    
    // Determine the swipe direction based on the larger delta
    if (dx.abs() > dy.abs()) {
      // Horizontal swipe
      if (dx > 0) {
        _onDirectionChange(Direction.right);
      } else {
        _onDirectionChange(Direction.left);
      }
    } else {
      // Vertical swipe
      if (dy > 0) {
        _onDirectionChange(Direction.down);
      } else {
        _onDirectionChange(Direction.up);
      }
    }
    
    // Reset the start position for the next swipe
    _swipeStartX = details.globalPosition.dx;
    _swipeStartY = details.globalPosition.dy;
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Snake Game'),
        backgroundColor: AppColors.backgroundLight,
        actions: [
          IconButton(
            icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause),
            onPressed: _togglePause,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initGame,
          ),
        ],
      ),
      body: GestureDetector(
        onPanStart: _handleSwipeStart,
        onPanUpdate: _handleSwipeUpdate,
        child: Column(
          children: [
            // Game stats
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBackground,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.accentPrimary.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('Score', _score.toString(), Icons.star, AppColors.accentPrimary),
                  _buildStatItem('High Score', _highScore.toString(), Icons.emoji_events, AppColors.accentSecondary),
                ],
              ),
            ),
            
            // Game board
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBackground,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.accentSecondary,
                        width: 2,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CustomPaint(
                        painter: SnakeGamePainter(
                          snake: _snake,
                          food: _food,
                          gridSize: _gridSize,
                          cellSize: _cellSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            
            // Controls
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        Icons.arrow_upward,
                        () => _onDirectionChange(Direction.up),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        Icons.arrow_back,
                        () => _onDirectionChange(Direction.left),
                      ),
                      const SizedBox(width: 60),
                      _buildControlButton(
                        Icons.arrow_forward,
                        () => _onDirectionChange(Direction.right),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        Icons.arrow_downward,
                        () => _onDirectionChange(Direction.down),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Game over message
            if (_isGameOver)
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.accentTertiary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.accentTertiary,
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Game Over',
                      style: TextStyle(
                        color: AppColors.accentTertiary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your score: $_score',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _initGame,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentTertiary,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  Widget _buildControlButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentPrimary,
          shape: const CircleBorder(),
          padding: const EdgeInsets.all(16),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }
}

enum Direction {
  up,
  right,
  down,
  left,
}

class SnakeGamePainter extends CustomPainter {
  final List<Offset> snake;
  final Offset? food;
  final int gridSize;
  final double cellSize;
  
  SnakeGamePainter({
    required this.snake,
    required this.food,
    required this.gridSize,
    required this.cellSize,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / gridSize;
    final cellHeight = size.height / gridSize;
    
    // Draw grid lines
    final gridPaint = Paint()
      ..color = AppColors.backgroundLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    
    for (int i = 0; i <= gridSize; i++) {
      // Vertical lines
      canvas.drawLine(
        Offset(i * cellWidth, 0),
        Offset(i * cellWidth, size.height),
        gridPaint,
      );
      
      // Horizontal lines
      canvas.drawLine(
        Offset(0, i * cellHeight),
        Offset(size.width, i * cellHeight),
        gridPaint,
      );
    }
    
    // Draw food
    if (food != null) {
      final foodPaint = Paint()
        ..color = AppColors.accentTertiary
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        Offset(
          (food!.dx + 0.5) * cellWidth,
          (food!.dy + 0.5) * cellHeight,
        ),
        min(cellWidth, cellHeight) * 0.4,
        foodPaint,
      );
    }
    
    // Draw snake
    for (int i = 0; i < snake.length; i++) {
      final segment = snake[i];
      final isHead = i == 0;
      
      final snakePaint = Paint()
        ..style = PaintingStyle.fill;
      
      if (isHead) {
        snakePaint.color = AppColors.accentPrimary;
      } else {
        // Gradient from primary to secondary color
        final t = i / snake.length;
        snakePaint.color = Color.lerp(
          AppColors.accentPrimary,
          AppColors.accentSecondary,
          t,
        )!;
      }
      
      final rect = Rect.fromLTWH(
        segment.dx * cellWidth,
        segment.dy * cellHeight,
        cellWidth,
        cellHeight,
      );
      
      // Draw rounded rectangle for the snake segments
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(4)),
        snakePaint,
      );
      
      // Draw eyes for the head
      if (isHead) {
        final eyePaint = Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;
        
        final eyeSize = min(cellWidth, cellHeight) * 0.15;
        
        // Left eye
        canvas.drawCircle(
          Offset(
            (segment.dx + 0.3) * cellWidth,
            (segment.dy + 0.3) * cellHeight,
          ),
          eyeSize,
          eyePaint,
        );
        
        // Right eye
        canvas.drawCircle(
          Offset(
            (segment.dx + 0.7) * cellWidth,
            (segment.dy + 0.3) * cellHeight,
          ),
          eyeSize,
          eyePaint,
        );
      }
    }
  }
  
  @override
  bool shouldRepaint(covariant SnakeGamePainter oldDelegate) {
    return true;
  }
}
