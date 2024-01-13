import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/bloc/category/category_bloc.dart';
import 'package:myshoppinglist/bloc/myitem/myitem_bloc.dart';
import 'package:myshoppinglist/bloc/profile/profile_bloc.dart';
import 'package:myshoppinglist/pages/addlist.dart';
import 'package:myshoppinglist/pages/login.dart';
import 'package:myshoppinglist/pages/profile.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    AuthenticationBloc authBloc = BlocProvider.of<AuthenticationBloc>(context);
    CategoryBloc categoryBloc = BlocProvider.of<CategoryBloc>(context);

    return Drawer(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is Authorized) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundImage: (state.user.avatar != null && state.user.avatar!.isNotEmpty) ? Image.network(state.user.avatar!).image : const AssetImage("assets/no-avatar.jpg"),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Welcome ${state.user.name}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      BlocProvider.of<ProfileBloc>(context).add(ProfileLoadSettings(user: state.user));
                                      Navigator.of(context).pop();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => const Profile()),
                                      );
                                    },
                                    child: const Text("Profile"),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      authBloc.add(LoggedOut());
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )
                      ],
                    );
                  } else if(state is AuthLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                   else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Not logged id',
                              style: TextStyle(color: Colors.white),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                                },
                                child: const Text("Log IN"))
                          ],
                        )
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(1),
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, stateAuth) {
                  if (stateAuth is Authorized) {
                    categoryBloc.add(CategoryLoad(userID: stateAuth.user.uuid ?? ''));
                    return BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is CategoryLoaded) {
                          return Column(
                            children: [
                              Expanded(
                                child: ListView.builder(
                                  itemCount: state.categories.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      selected: state.categories[index].isSelected,
                                      title: Text(state.categories[index].name),
                                      leading: const Icon(Icons.list_alt_outlined),
                                      onTap: () {
                                        categoryBloc.add(CategorySelect(categoryID: state.categories[index].categoryID));
                                        BlocProvider.of<MyitemBloc>(context).add(MyItemLoad(categoryID: state.categories[index].categoryID));
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          );
                        } else if (state is CategorySuccess) {
                          categoryBloc.add(CategoryLoad(userID: stateAuth.user.uuid ?? ''));
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is CategoryLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else {
                          return const Center(child: Text("No categories found"));
                        }
                      },
                    );
                  } else {
                    return const Center(child: Text("Not logged in"));
                  }
                },
              ),
            ),
          ),
          Flexible(
              flex: 1,
              child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
                builder: (context, state) {
                  if (state is Authorized) {
                    return ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return const AddList();
                              });
                        },
                        child: const Text("Add new list"));
                  } else {
                    return Container();
                  }
                },
              ))
        ],
      ),
    );
  }
}
