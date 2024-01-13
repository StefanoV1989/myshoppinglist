import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/bloc/category/category_bloc.dart';
import 'package:myshoppinglist/models/category.dart';

class AddList extends StatefulWidget {
  const AddList({super.key});

  @override
  State<AddList> createState() => _AddListState();
}

class _AddListState extends State<AddList> {
  TextEditingController nameCategory = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 200,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Text("Write a name for a new list"),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                height: 40,
                child: TextFormField(
                  controller: nameCategory,
                  decoration: const InputDecoration(
                    labelText: "List Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
                if (state is Authorized) {
                  return ElevatedButton(
                    onPressed: () {
                      Category category = Category(name: nameCategory.text, categoryID: '', userID: state.user.uuid ?? '', isSelected: false);
                      categoryBloc.add(CategoryAdd(category: category));
                      Navigator.of(context).pop();
                    },
                    child: const Text("Add element"),
                  );
                } else {
                  return const Text("You must be logged in to add a list");
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
