part of 'myitem_bloc.dart';

abstract class MyitemState extends Equatable {
  const MyitemState();

  @override
  List<Object> get props => [];
}

class MyitemInitial extends MyitemState {}

class MyitemLoading extends MyitemState {}

class MyItemLoaded extends MyitemState {
  final List<MyItem> myItems;

  const MyItemLoaded({required this.myItems});

  @override
  List<Object> get props => [myItems];
}

class MyitemSuccess extends MyitemState {}
class MyitemFail extends MyitemState {}
class MyItemReloaded extends MyitemState {}