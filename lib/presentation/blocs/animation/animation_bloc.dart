import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class AnimationEvent extends Equatable {
  const AnimationEvent();

  @override
  List<Object> get props => [];
}

class StartAnimation extends AnimationEvent {
  final String animationId;

  const StartAnimation(this.animationId);

  @override
  List<Object> get props => [animationId];
}

class StopAnimation extends AnimationEvent {
  final String animationId;

  const StopAnimation(this.animationId);

  @override
  List<Object> get props => [animationId];
}

class ResetAnimation extends AnimationEvent {
  final String animationId;

  const ResetAnimation(this.animationId);

  @override
  List<Object> get props => [animationId];
}

// States
abstract class AnimationState extends Equatable {
  const AnimationState();

  @override
  List<Object> get props => [];
}

class AnimationInitial extends AnimationState {}

class AnimationRunning extends AnimationState {
  final List<String> runningAnimations;

  const AnimationRunning(this.runningAnimations);

  @override
  List<Object> get props => [runningAnimations];
}

// BLoC
class AnimationBloc extends Bloc<AnimationEvent, AnimationState> {
  final List<String> _runningAnimations = [];

  AnimationBloc() : super(AnimationInitial()) {
    on<StartAnimation>(_onStartAnimation);
    on<StopAnimation>(_onStopAnimation);
    on<ResetAnimation>(_onResetAnimation);
  }

  void _onStartAnimation(StartAnimation event, Emitter<AnimationState> emit) {
    if (!_runningAnimations.contains(event.animationId)) {
      _runningAnimations.add(event.animationId);
    }
    emit(AnimationRunning(List.from(_runningAnimations)));
  }

  void _onStopAnimation(StopAnimation event, Emitter<AnimationState> emit) {
    _runningAnimations.remove(event.animationId);
    emit(AnimationRunning(List.from(_runningAnimations)));
  }

  void _onResetAnimation(ResetAnimation event, Emitter<AnimationState> emit) {
    _runningAnimations.remove(event.animationId);
    _runningAnimations.add(event.animationId);
    emit(AnimationRunning(List.from(_runningAnimations)));
  }
}
