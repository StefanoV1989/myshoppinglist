import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/bloc/category/category_bloc.dart';
import 'package:myshoppinglist/bloc/myitem/myitem_bloc.dart';
import 'package:myshoppinglist/components/menu.dart';
import 'package:myshoppinglist/components/myappbar.dart';
import 'package:myshoppinglist/models/myitem.dart';
import 'package:myshoppinglist/pages/additem.dart';

class Homepage extends StatelessWidget {
  Homepage({super.key});

  final myKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authorized) {
            return BlocConsumer<MyitemBloc, MyitemState>(
              listener: (context, state) {
                String categoryId = BlocProvider.of<CategoryBloc>(context).getSelectedCategory();

                if (state is MyitemSuccess) {
                  BlocProvider.of<MyitemBloc>(context).add(MyItemLoad(categoryID: categoryId));
                }
              },
              builder: (context, state) {
                String categoryId = BlocProvider.of<CategoryBloc>(context).getSelectedCategory();

                if (state is MyItemLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      BlocProvider.of<MyitemBloc>(context).add(MyItemReload(categoryID: categoryId));
                    },
                    child: ListView.builder(
                      itemCount: state.myItems.length,
                      itemBuilder: (context, index) {
                        if (state.myItems[index].isCompleted) {
                          return myListTile(state, index);
                        } else {
                          return Dismissible(
                            key: myKey,
                            onDismissed: (DismissDirection direction) {
                              if (direction == DismissDirection.endToStart) {
                                // delete
                                BlocProvider.of<MyitemBloc>(context).add(MyItemDel(myItem: state.myItems[index]));
                              } else if (direction == DismissDirection.startToEnd) {
                                // complete
                                MyItem oldItem = state.myItems[index];
                                MyItem myNewItem = oldItem.copyWith(isCompleted: true);
                                BlocProvider.of<MyitemBloc>(context).add(MyItemUpdate(myItem: myNewItem));
                              }
                            },
                            background: Container(color: Colors.green),
                            secondaryBackground: Container(color: Colors.red),
                            child: myListTile(state, index),
                          );
                        }
                      },
                    ),
                  );
                } else if (state is MyitemInitial) {
                  return const Center(
                    child: Text("Select a category to view items"),
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            );
          } else {
            return const Center(child: Text("Not logged in"));
          }
        },
      ),
      floatingActionButton: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Authorized) {
            return BlocBuilder<CategoryBloc, CategoryState>(
              builder: (context, state) {
                if (state is CategoryLoaded) {
                  String categoryId = BlocProvider.of<CategoryBloc>(context).getSelectedCategory();

                  if (categoryId != "") {
                    return FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddItem()));
                      },
                      child: const Icon(Icons.add),
                    );
                  } else {
                    return Container();
                  }
                } else {
                  return Container();
                }
              },
            );
          } else {
            return Container();
          }
        },
      ),
      drawer: const Menu(),
    );
  }

  Widget myListTile(MyItemLoaded state, int index) {
    return ListTile(
      selected: state.myItems[index].isCompleted,
      onTap: () {},
      leading: const Icon(
        Icons.list_sharp,
        size: 48,
      ),
      title: Text(state.myItems[index].name),
      subtitle: Text(state.myItems[index].note),
    );
  }
}
