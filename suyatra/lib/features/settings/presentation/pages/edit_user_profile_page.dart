import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:suyatra/constants/app_colors.dart';
import 'package:suyatra/constants/font_sizes.dart';
import 'package:suyatra/core/app_status.dart';
import 'package:suyatra/core/service_locator.dart';
import 'package:suyatra/features/authentication/presentation/cubit/auth_cubit.dart';
import 'package:suyatra/services/firebase_service.dart';
import 'package:suyatra/services/navigation_service.dart';
import 'package:suyatra/widgets/cached_image_widget.dart';
import 'package:suyatra/widgets/custom_button.dart';
import 'package:suyatra/widgets/text_field_widget.dart';

class EditUserProfilePage extends StatefulWidget {
  const EditUserProfilePage({super.key});

  @override
  State<EditUserProfilePage> createState() => _EditUserProfilePageState();
}

class _EditUserProfilePageState extends State<EditUserProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  String? phoneNumber;
  String? photoUrl;
  XFile? photoFile;
  bool userEmailVerified = false;
  ImagePicker imagePicker = ImagePicker();
  bool _nameChanged = false;
  bool _emailChanged = false;


  @override
  void initState() {
    super.initState();
    User? user = locator<FirebaseService>().firebaseAuth.currentUser;
    nameController = TextEditingController(text: user?.displayName);
    emailController = TextEditingController(text: user?.email);
    phoneNumber = user?.phoneNumber;
    photoUrl = user?.photoURL;
    userEmailVerified = user?.emailVerified ?? false;
    setState(() {
      
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AuthCubit authCubit = context.watch<AuthCubit>();
    return Scaffold(
      appBar: _appBar(authCubit),
      backgroundColor: grey100,
      body: _body(authCubit),
    );
  }

  PreferredSizeWidget _appBar(AuthCubit authCubit) {
    return AppBar(
      title: const Text(
        "Edit Profile",
      ),
      actions: [
        IconButton(
          onPressed: () {
            authCubit.updateUserProfile(
              displayName: _nameChanged ? nameController.text : null,
              photoUrl: photoUrl,
              email: _emailChanged ? emailController.text : null,
            );
            setState(() {
              _emailChanged = false;            
              _nameChanged = false;
            });
          }, 
          icon: authCubit.state.authStatus == AppStatus.loading 
            ? const SizedBox(
              height: 24.0,
              width: 24.0,
              child: CircularProgressIndicator(),
            ) 
            : const Icon(Icons.check, size: 24.0,
          ),
        )
      ],
    );
  }

  Widget _body(AuthCubit authCubit) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        children: [
          if(kDebugMode)
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 104,
                width: 104,
                decoration: BoxDecoration(
                  color: grey100,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: grey300,
                    width: 2,
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  clipBehavior: Clip.antiAlias,
                  child: photoFile != null 
                    ? Image.file(File(photoFile!.path), fit: BoxFit.cover,)
                    : photoUrl != null 
                      ? CachedImageWidget(imageUrl: photoUrl!, fit: BoxFit.cover) 
                      : const Icon(
                          Icons.person_3,
                          size: 64,
                        ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    _onCameraClicked();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: whiteColor,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: blackColor.withOpacity(0.12),
                          blurRadius: 10,
                          offset: const Offset(0, 5)
                        )
                      ]
                    ),
                    padding: const EdgeInsets.all(4.0),
                    child: const Icon(
                      Icons.camera_alt,
                      color: blackColor,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 32.0),
          TextFieldWidget(
            hintText: nameController.text.isNotEmpty == true ? null : "Full name",
            labelText: nameController.text.isNotEmpty == true ? "FULL NAME" : null,
            controller: nameController,
            onChanged: (_) {
              if(!_nameChanged) {
                setState(() {
                  _nameChanged = true;
                });
              }
            },
          ),
          const SizedBox(height: 24.0),
          TextFieldWidget(
            hintText: emailController.text.isNotEmpty == true ? null : "Email",
            labelText: emailController.text.isNotEmpty == true ? "EMAIL" : null,
            controller: emailController,
            suffixIcon: userEmailVerified ? null : InkWell(
              onTap: () {
                // authCubit.verifyUserEmail(
                //   email: emailController.text
                // );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: himalayanBlue,
                  borderRadius: BorderRadius.circular(12.0)
                ),
                child: const Text(
                  "VERIFY",
                  style: TextStyle(
                    fontSize: h11,
                    fontWeight: FontWeight.w500,
                    color: whiteColor
                  ),
                ),
              ),
            ),
            onChanged: (_) {
              if(!_emailChanged) {
                setState(() {
                  _emailChanged = true;
                });
              }
            },
          ),
          const SizedBox(height: 24.0),
          if(kDebugMode)
            TextFieldWidget(
              hintText: phoneNumber?.isNotEmpty == true ? null : "Phone number",
              labelText: phoneNumber?.isNotEmpty == true ? "PHONE NUMBER" : null,
              textValue: phoneNumber,
              readOnly: true,
            )
        ],
      ),
    );
  }

  _onCameraClicked() {
    return showAdaptiveDialog(
      context: context, 
      builder: (context) {
        return AlertDialog.adaptive(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          title: const Text(
            "Select image from one of the options"
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                icon: const Icon(Icons.photo),
                buttonColor: Colors.transparent,
                borderColor: grey300,
                textColor: blackColor,
                label: "Gallery",
                onPressed: () {
                  _selectImageFromGallery();
                },
              ),
              const SizedBox(height: 16.0),
              CustomButton(
                icon: const Icon(Icons.camera_alt),
                buttonColor: Colors.transparent,
                borderColor: grey300,
                textColor: blackColor,
                label: "Camera",
                onPressed: () {
                  _selectImageFromCamera();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  _selectImageFromGallery() async {
    var image = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      photoFile = image ?? photoFile;
    });
    locator<NavigationService>().goBack();
  }

  _selectImageFromCamera() async {
    var image = await imagePicker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);
    setState(() {
      photoFile = image ?? photoFile;
    });
    locator<NavigationService>().goBack();
  }
}