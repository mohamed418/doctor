import 'dart:io';
import 'package:doctor/constants/transitions.dart';
import 'package:doctor/view/bottom_nav/bottom_nav_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../constants/colors.dart';
import '../../../constants/components.dart';
import '../../logic/bloc/cubit.dart';
import '../../logic/bloc/states.dart';
import '../../network/local/cache_helper.dart';

class LoginScreen extends StatefulWidget {
  final dynamic phoneNumber;

  const LoginScreen({super.key, this.phoneNumber});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var LoginFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final dateController = TextEditingController();
  final monthController = TextEditingController();
  final yearController = TextEditingController();

  File? image;
  File? myFile;

  Future pickImage(ImageSource source, BuildContext context) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = await saveImage(image.path);
      setState(() {
        this.image = imageTemporary;
        myFile = File(image.path);
        CacheHelper.saveData(key: 'image', value: myFile);
      });
    } on PlatformException catch (e) {}
  }

  Future<File> saveImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }

  void buildCameraDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Lottie.asset('assets/lotties/image.json'),
        backgroundColor: white,
        actions: [
          Center(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickImage(ImageSource.camera, context);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Camera',
                    style: mainTextStyle(context),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickImage(ImageSource.gallery, context);
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Gallery',
                    style: mainTextStyle(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        surfaceTintColor: white,
        centerTitle: true,
        backgroundColor: white,
        title: Text(
          'Login Screen',
          style: mainTextStyle(context),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: black,
          ),
        ),
      ),
      body: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          // var cubit = AuthCubit.get(context);
          return SingleChildScrollView(
            child: Container(
              color: white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: LoginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: image != null
                            ? SizedBox(
                                width: 184,
                                height: 184,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.2),
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipOval(
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(
                                width: 184,
                                height: 184,
                                child: Padding(
                                  padding: const EdgeInsets.all(2.2),
                                  child: Container(
                                    height: 184,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color.fromRGBO(0, 0, 0, 0.2),
                                    ),
                                    // child: SvgPicture.asset('assets/svg/person.svg'),
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: () {
                            buildCameraDialog(context);
                          },
                          child: Text(
                            'add photo',
                            style: mainTextStyle(
                              context,
                              color: black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'first name',
                        style: midTextStyle(context, black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      TFF(
                        isOutLineBorder: true,
                        isEnabledBorder: true,
                        borderColor: const Color.fromRGBO(217, 217, 217, 1),
                        isPrefix: false,
                        controller: nameController,
                        action: TextInputAction.next,
                        type: TextInputType.name,
                        hint: 'name',
                        filled: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          } else {
                            return null;
                          }
                        },
                        underlineBorder: false,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'last name',
                        style: midTextStyle(context, black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      TFF(
                        isOutLineBorder: true,
                        underlineBorder: false,
                        isEnabledBorder: true,
                        borderColor: const Color.fromRGBO(217, 217, 217, 1),
                        isPrefix: false,
                        controller: lastnameController,
                        action: TextInputAction.next,
                        type: TextInputType.name,
                        hint: 'last_name',
                        // borderColor: white,
                        filled: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'email address',
                        style: midTextStyle(context, black),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 3),
                      TFF(
                        isOutLineBorder: true,
                        underlineBorder: false,
                        isEnabledBorder: true,
                        borderColor: const Color.fromRGBO(217, 217, 217, 1),
                        isPrefix: false,
                        controller: emailController,
                        action: TextInputAction.next,
                        type: TextInputType.emailAddress,
                        hint: 'email',
                        filled: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return '';
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 60, bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            if (image == null) {
                              buildSnackBar(
                                'please add image',
                                context,
                                2,
                              );
                            } else if (LoginFormKey.currentState!.validate()) {
                              FocusScope.of(context).unfocus();
                              Navigator.push(
                                context,
                                CustomPageRoute(child: const AppLayout()),
                              );
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: defaultColor,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            minimumSize: Size(
                              double.infinity,
                              screenHeight(context, .053),
                            ),
                          ),
                          child: const Text(
                            'save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
