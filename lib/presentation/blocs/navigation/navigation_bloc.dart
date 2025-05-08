import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class NavigateToPage extends NavigationEvent {
  final String route;

  const NavigateToPage(this.route);

  @override
  List<Object> get props => [route];
}

// States
abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class NavigationInitial extends NavigationState {}

class NavigationInProgress extends NavigationState {
  final String route;

  const NavigationInProgress(this.route);

  @override
  List<Object> get props => [route];
}

class NavigationSuccess extends NavigationState {
  final String currentRoute;

  const NavigationSuccess(this.currentRoute);

  @override
  List<Object> get props => [currentRoute];
}

// BLoC
class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(NavigationInitial()) {
    on<NavigateToPage>(_onNavigateToPage);
  }

  void _onNavigateToPage(NavigateToPage event, Emitter<NavigationState> emit) {
    emit(NavigationInProgress(event.route));
    emit(NavigationSuccess(event.route));
  }
}
