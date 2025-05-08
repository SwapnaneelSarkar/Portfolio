import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ScrollEvent extends Equatable {
  const ScrollEvent();

  @override
  List<Object> get props => [];
}

class ScrollToSection extends ScrollEvent {
  final String sectionId;

  const ScrollToSection(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

class UpdateScrollPosition extends ScrollEvent {
  final double position;

  const UpdateScrollPosition(this.position);

  @override
  List<Object> get props => [position];
}

// States
abstract class ScrollState extends Equatable {
  const ScrollState();

  @override
  List<Object> get props => [];
}

class ScrollInitial extends ScrollState {}

class ScrollInProgress extends ScrollState {
  final String sectionId;

  const ScrollInProgress(this.sectionId);

  @override
  List<Object> get props => [sectionId];
}

class ScrollPositionUpdated extends ScrollState {
  final double position;
  final String? activeSection;

  const ScrollPositionUpdated(this.position, {this.activeSection});

  @override
  List<Object> get props => [position, activeSection ?? ''];
}

// BLoC
class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  ScrollBloc() : super(ScrollInitial()) {
    on<ScrollToSection>(_onScrollToSection);
    on<UpdateScrollPosition>(_onUpdateScrollPosition);
  }

  void _onScrollToSection(ScrollToSection event, Emitter<ScrollState> emit) {
    emit(ScrollInProgress(event.sectionId));
  }

  void _onUpdateScrollPosition(UpdateScrollPosition event, Emitter<ScrollState> emit) {
    // Determine active section based on scroll position
    String? activeSection;
    
    if (event.position < 500) {
      activeSection = 'hero';
    } else if (event.position < 1200) {
      activeSection = 'about';
    } else if (event.position < 2000) {
      activeSection = 'skills';
    } else if (event.position < 2800) {
      activeSection = 'experience';
    } else if (event.position < 3600) {
      activeSection = 'projects';
    } else {
      activeSection = 'contact';
    }
    
    emit(ScrollPositionUpdated(event.position, activeSection: activeSection));
  }
}
