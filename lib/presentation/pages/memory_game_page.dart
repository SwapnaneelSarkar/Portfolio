import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'dart:math';
import 'dart:async';

class MemoryGamePage extends StatefulWidget {
  const MemoryGamePage({Key? key}) : super(key: key);

  @override
  State<MemoryGamePage> createState() => _MemoryGamePageState();
}

class _MemoryGamePageState extends State<MemoryGamePage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _gridSize = 4;
  final List<String> _emojis = ['🚀', '🌟', '🎮', '🎯', '🎨', '🎭', '🎪', '🎢'];
  late List<String> _cards;
  List<bool> _flipped = [];
  List<bool> _matched = [];
  int? _firstFlippedIndex;
  int? _secondFlippedIndex;
  bool _isProcessing = false;
  int _moves = 0;
  int _matches = 0;
  late Stopwatch _stopwatch;
  late Timer _timer;
  String _timeElapsed = '00:00';
  bool _gameCompleted = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _initGame();
  }
  
  void _initGame() {
    // Create pairs of emojis
    _cards = [..._emojis, ..._emojis];
    
    // Shuffle the cards
    _cards.shuffle(Random());
    
    // Initialize flipped and matched states
    _flipped = List.generate(_cards.length, (_) => false);
    _matched = List.generate(_cards.length, (_) => false);
    
    // Reset game state
    _firstFlippedIndex = null;
    _secondFlippedIndex = null;
    _isProcessing = false;
    _moves = 0;
    _matches = 0;
    _gameCompleted = false;
    
    // Start the timer
    _stopwatch = Stopwatch()..start();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        final minutes = (_stopwatch.elapsedMilliseconds ~/ 60000).toString().padLeft(2, '0');
        final seconds = ((_stopwatch.elapsedMilliseconds % 60000) ~/ 1000).toString().padLeft(2, '0');
        _timeElapsed = '$minutes:$seconds';
      });
    });
  }
  
  void _flipCard(int index) {
    if (_isProcessing || _flipped[index] || _matched[index] || _gameCompleted) {
      return;
    }
    
    setState(() {
      _flipped[index] = true;
      
      if (_firstFlippedIndex == null) {
        _firstFlippedIndex = index;
      } else {
        _secondFlippedIndex = index;
        _moves++;
        _isProcessing = true;
        
        // Check if the cards match
        if (_cards[_firstFlippedIndex!] == _cards[_secondFlippedIndex!]) {
          _matched[_firstFlippedIndex!] = true;
          _matched[_secondFlippedIndex!] = true;
          _matches++;
          
          // Check if all cards are matched
          if (_matches == _emojis.length) {
            _gameCompleted = true;
            _stopwatch.stop();
            _timer.cancel();
          }
          
          _firstFlippedIndex = null;
          _secondFlippedIndex = null;
          _isProcessing = false;
        } else {
          // If cards don't match, flip them back after a delay
          Future.delayed(const Duration(milliseconds: 1000), () {
            setState(() {
              _flipped[_firstFlippedIndex!] = false;
              _flipped[_secondFlippedIndex!] = false;
              _firstFlippedIndex = null;
              _secondFlippedIndex = null;
              _isProcessing = false;
            });
          });
        }
      }
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Memory Card Game'),
        backgroundColor: AppColors.backgroundLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _stopwatch.stop();
                _timer.cancel();
                _initGame();
              });
            },
          ),
        ],
      ),
      body: Column(
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
                _buildStatItem('Time', _timeElapsed, Icons.timer, AppColors.accentPrimary),
                _buildStatItem('Moves', _moves.toString(), Icons.touch_app, AppColors.accentSecondary),
                _buildStatItem('Matches', '$_matches/${_emojis.length}', Icons.check_circle, AppColors.accentTertiary),
              ],
            ),
          ),
          
          // Game grid
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _gridSize,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: _cards.length,
                itemBuilder: (context, index) {
                  return _buildCard(index);
                },
              ),
            ),
          ),
          
          // Game completed message
          if (_gameCompleted)
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentPrimary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.accentPrimary,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    '🎉 Congratulations! 🎉',
                    style: TextStyle(
                      color: AppColors.accentPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You completed the game in $_timeElapsed with $_moves moves!',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _stopwatch.stop();
                        _timer.cancel();
                        _initGame();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentPrimary,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Play Again'),
                  ),
                ],
              ),
            ),
        ],
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
  
  Widget _buildCard(int index) {
    return GestureDetector(
      onTap: () => _flipCard(index),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: _flipped[index] ? 180 : 0),
        duration: const Duration(milliseconds: 300),
        builder: (context, double value, child) {
          // Determine if the card is showing the front or back
          final showFront = value < 90;
          
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY((value * pi) / 180),
            child: showFront
                ? _buildCardBack(index)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(pi),
                    child: _buildCardFront(index),
                  ),
          );
        },
      ),
    );
  }
  
  Widget _buildCardFront(int index) {
    return Container(
      decoration: BoxDecoration(
        color: _matched[index] ? AppColors.accentPrimary.withOpacity(0.2) : AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _matched[index] ? AppColors.accentPrimary : AppColors.accentSecondary,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          _cards[index],
          style: const TextStyle(
            fontSize: 40,
          ),
        ),
      ),
    );
  }
  
  Widget _buildCardBack(int index) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentSecondary,
          width: 2,
        ),
        gradient: LinearGradient(
          colors: [
            AppColors.accentPrimary.withOpacity(0.5),
            AppColors.accentSecondary.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Text(
          '?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
