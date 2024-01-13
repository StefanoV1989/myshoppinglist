import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myshoppinglist/bloc/authentication/authentication_bloc.dart';
import 'package:myshoppinglist/bloc/profile/profile_bloc.dart';
import 'package:myshoppinglist/components/myappbar.dart';
import 'package:myshoppinglist/models/user_model.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    ProfileBloc profileBloc = BlocProvider.of<ProfileBloc>(context);

    return Scaffold(
      appBar: MyAppBar(),
      body: SingleChildScrollView(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, stateAuth) {
            if (stateAuth is Authorized) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: BlocConsumer<ProfileBloc, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Profile saved"),
                        ),
                      );
                      BlocProvider.of<AuthenticationBloc>(context).add(LoggedInRefresh(user: state.user));
                      BlocProvider.of<ProfileBloc>(context).add(ProfileLoadSettings(user: state.user));
                    } else if (state is ProfileChangedAvatar) {
                      BlocProvider.of<AuthenticationBloc>(context).add(LoggedInRefresh(user: state.user));
                    }
                  },
                  builder: (context, stateProfile) {
                    if (stateProfile is ProfileLoaded) {
                      _nameController.text = stateProfile.user.name ?? '';
                      _surnameController.text = stateProfile.user.surname ?? '';

                      
                      return Column(
                        children: [
                          Row(
                            children: [
                              InkWell(
                                borderRadius: BorderRadius.circular(60),
                                onTap: () async {
                                  final ImagePicker imagePicker = ImagePicker();

                                  final XFile? newAvatar = await imagePicker.pickImage(source: ImageSource.gallery);

                                  if(newAvatar != null || newAvatar!.name.isNotEmpty) {
                                    File newFileAvatar = File.fromUri(Uri.parse(newAvatar.path));

                                    profileBloc.add(ProfileChangeAvatar(user: stateAuth.user, avatar: newFileAvatar));
                                  }
                                },
                                child: CircleAvatar(
                                  radius: 60,
                                  backgroundImage: (stateProfile.user.avatar != null && stateProfile.user.avatar!.isNotEmpty) ? Image.network(stateProfile.user.avatar!).image : const AssetImage("assets/no-avatar.jpg"),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(5.0),
                                    margin: const EdgeInsets.only(top: 80, left: 70),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 16,
                                    ),
                                  )
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: "ID",
                                        ),
                                        readOnly: true,
                                        initialValue: stateAuth.user.uuid,
                                      ),
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          labelText: "Username",
                                        ),
                                        readOnly: true,
                                        initialValue: stateAuth.user.email,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 30,
                          ),
                          const Text("Personal Information"),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Name",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  controller: _nameController,
                                ),
                                TextFormField(
                                  decoration: const InputDecoration(
                                    labelText: "Surname",
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter your surname';
                                    }
                                    return null;
                                  },
                                  controller: _surnameController,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                child: const Text(
                                  "Back",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    UserModel user = stateAuth.user.copyWith(
                                      uuid: stateAuth.user.uuid,
                                      email: stateAuth.user.email,
                                      name: _nameController.text,
                                      surname: _surnameController.text,
                                    );

                                    BlocProvider.of<ProfileBloc>(context).add(ProfileSaveSettings(user: user));
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                child: const Text(
                                  "Save",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          )
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
