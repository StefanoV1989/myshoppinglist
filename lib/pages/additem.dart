import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/category/category_bloc.dart';
import 'package:myshoppinglist/bloc/myitem/myitem_bloc.dart';
import 'package:myshoppinglist/components/myappbar.dart';
import 'package:myshoppinglist/globals/custom_theme.dart';
import 'package:myshoppinglist/globals/theme_globals.dart';
import 'package:myshoppinglist/models/myitem.dart';

class AddItem extends StatefulWidget {
  const AddItem({super.key});

  @override
  State<AddItem> createState() => _AddItemState();
}

class _AddItemState extends State<AddItem> {
  String? selectedCategory = "";
  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemNoteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: Text("Add an item to your shopping list:"),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: BlocBuilder<CategoryBloc, CategoryState>(
                          builder: (context, state) {
                            if (state is CategoryLoaded) {
                              List<DropdownMenuItem<String>> categoryList = [];

                              for (var cat in state.categories) {
                                categoryList.add(DropdownMenuItem(
                                  value: cat.categoryID,
                                  child: Text(cat.name),
                                ));
                              }

                              return DropdownButtonFormField<String>(
                                  hint: const Text("Select a list"),
                                  items: categoryList,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedCategory = value;
                                    });
                                  });
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Item Name",
                            border: OutlineInputBorder(),
                          ),
                          controller: itemNameController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Item Informations",
                            border: OutlineInputBorder(),
                          ),
                          controller: itemNoteController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Theme(
                              data: themeManager.themeMode == ThemeMode.dark ? customAmberButtonTheme : customRedButtonTheme,
                              child: ElevatedButton(
                                style: Theme.of(context).elevatedButtonTheme.style,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Cancel"),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (selectedCategory == null || selectedCategory == "") {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("You must select a list"),
                                    ),
                                  );
                                  return;
                                }

                                BlocProvider.of<MyitemBloc>(context).add(
                                  MyItemAdd(
                                    myItem: MyItem(
                                      categoryID: selectedCategory!,
                                      name: itemNameController.text,
                                      note: itemNoteController.text,
                                      isCompleted: false,
                                      id: "",
                                    ),
                                  ),
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text("Add element"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
