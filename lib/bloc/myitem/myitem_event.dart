part of 'myitem_bloc.dart';

abstract class MyitemEvent extends Equatable {
  const MyitemEvent();

  @override
  List<Object> get props => [];
}

class MyItemLoad extends MyitemEvent {
  final String categoryID;

  const MyItemLoad({required this.categoryID});

  @override
  List<Object> get props => [categoryID];
}

class MyItemAdd extends MyitemEvent {
  final MyItem myItem;

  const MyItemAdd({required this.myItem});

  @override
  List<Object> get props => [myItem];
}

class MyItemUpdate extends MyitemEvent {
  final MyItem myItem;

  const MyItemUpdate({required this.myItem});

  @override
  List<Object> get props => [myItem];
}

class MyItemDel extends MyitemEvent {
  final MyItem myItem;

  const MyItemDel({required this.myItem});

  @override
  List<Object> get props => [myItem];
}

class MyItemReload extends MyitemEvent {
  final String categoryID;

  const MyItemReload({required this.categoryID});

  @override
  List<Object> get props => [categoryID];
}