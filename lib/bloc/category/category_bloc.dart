import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/models/category.dart';
import 'package:myshoppinglist/repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

  final CategoryRepository categoryRepository;
  String categoryID = "";

  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<CategoryLoad>((event, emit) async {
      emit(CategoryLoading());
      List<Category> categories = await categoryRepository.getCategories(event.userID, selectedCategoryID: categoryID);
      emit(CategoryLoaded(categories: categories));
    });

    on<CategoryAdd>((event, emit) async {
      emit(CategoryLoading());
      await categoryRepository.addCategory(event.category);
      emit(CategorySuccess());
    });

    on<CategoryDel>((event, emit) async {
      emit(CategoryLoading());
      await categoryRepository.delCategory(event.categoryID);
      emit(CategorySuccess());
    });

    on<CategorySelect>((event, emit) async {
      emit(CategoryLoading());
      categoryID = event.categoryID;
      emit(CategorySuccess());
    });
  }

  String getSelectedCategory() {
    return categoryID;
  }
}