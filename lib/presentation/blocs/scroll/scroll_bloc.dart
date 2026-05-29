import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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

class ScrollBloc extends Bloc<ScrollEvent, ScrollState> {
  ScrollBloc() : super(ScrollInitial()) {
    on<ScrollToSection>(_onScrollToSection);
    on<UpdateScrollPosition>(_onUpdateScrollPosition);
  }

  void _onScrollToSection(ScrollToSection event, Emitter<ScrollState> emit) {
    emit(ScrollInProgress(event.sectionId));
  }

  void _onUpdateScrollPosition(
      UpdateScrollPosition event, Emitter<ScrollState> emit) {
    final p = event.position;
    String? activeSection;

    if (p < 500) {
      activeSection = 'hero';
    } else if (p < 1100) {
      activeSection = 'about';
    } else if (p < 1700) {
      activeSection = 'skills';
    } else if (p < 2300) {
      activeSection = 'experience';
    } else if (p < 2900) {
      activeSection = 'projects';
    } else if (p < 3400) {
      activeSection = 'caseStudies';
    } else {
      activeSection = 'contact';
    }

    emit(ScrollPositionUpdated(p, activeSection: activeSection));
  }
}
