import 'package:flutter/material.dart';
import 'package:portfolio/core/theme/app_theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:portfolio/presentation/blocs/scroll/scroll_bloc.dart';

class ScrollIndicator extends StatelessWidget {
  const ScrollIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScrollBloc, ScrollState>(
      builder: (context, state) {
        if (state is ScrollPositionUpdated) {
          final activeSection = state.activeSection;
          
          return Positioned(
            right: 20,
            top: 0,
            bottom: 0,
            child: Center(
              child: Container(
                width: 20,
                height: 200,
                decoration: BoxDecoration(
                  color: AppColors.backgroundLight.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildDot('hero', activeSection),
                    _buildDot('about', activeSection),
                    _buildDot('skills', activeSection),
                    _buildDot('experience', activeSection),
                    _buildDot('projects', activeSection),
                    _buildDot('contact', activeSection),
                  ],
                ),
              ),
            ),
          );
        }
        
        return const SizedBox.shrink();
      },
    );
  }
  
  Widget _buildDot(String section, String? activeSection) {
    final isActive = section == activeSection;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.accentPrimary : AppColors.textSecondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
