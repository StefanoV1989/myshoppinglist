import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/models/myitem.dart';
import 'package:myshoppinglist/repository/item_repository.dart';

part 'myitem_event.dart';
part 'myitem_state.dart';


class MyitemBloc extends Bloc<MyitemEvent, MyitemState> {

  final ItemRepository itemRepository;

  MyitemBloc(this.itemRepository) : super(MyitemInitial()) {
    on<MyItemLoad>((event, emit) async {
      emit(MyitemLoading());
      List<MyItem> myItems = await itemRepository.getItems(event.categoryID);
      emit(MyItemLoaded(myItems: myItems));
    });

    on<MyItemAdd>((event, emit) async {
      emit(MyitemLoading());
      await itemRepository.addItem(event.myItem);
      emit(MyitemSuccess());
    });

    on<MyItemUpdate>((event, emit) async {
      emit(MyitemLoading());
      await itemRepository.updateItem(event.myItem);
      emit(MyitemSuccess());
    });

    on<MyItemDel>((event, emit) async {
      emit(MyitemLoading());
      await itemRepository.delItem(event.myItem);
      emit(MyitemSuccess());
    });

    on<MyItemReload>((event, emit) async {
      emit(MyitemLoading());
      emit(MyItemReloaded());
      List<MyItem> myItems = await itemRepository.getItems(event.categoryID);
      emit(MyItemLoaded(myItems: myItems));
    });
  }
}