part of 'category_bloc.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class CategoryLoad extends CategoryEvent {
  final String userID;

  const CategoryLoad({required this.userID});

  @override
  List<Object> get props => [userID];
}

class CategoryAdd extends CategoryEvent {
  final Category category;

  const CategoryAdd({required this.category});

  @override
  List<Object> get props => [category];
}

class CategoryDel extends CategoryEvent {
  final String categoryID;

  const CategoryDel({required this.categoryID});

  @override
  List<Object> get props => [categoryID];
}

class CategorySelect extends CategoryEvent {
  final String categoryID;

  const CategorySelect({required this.categoryID});

  @override
  List<Object> get props => [categoryID];
}