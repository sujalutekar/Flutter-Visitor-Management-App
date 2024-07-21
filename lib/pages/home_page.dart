import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:adypkc/widgets/app_drawer.dart';
import 'package:adypkc/widgets/custom_button.dart';
import 'package:adypkc/widgets/custom_textfield.dart';
import 'package:adypkc/widgets/date_time_picker.dart';
import 'package:adypkc/services/upload_image.dart';
// import 'package:adypkc/services/auto_delete_data.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController reasonController = TextEditingController();

  File? _selectedImage;
  Uint8List? image;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // deleteAfterThreeMonths();

    DateTime dateTime = DateTime.now();
    Timestamp timestamp = Timestamp.fromDate(dateTime);

    print('Timestamp: ${timestamp}');
    getUserData();
  }

  Future<String> getUserData() async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('users');

    DocumentSnapshot<Object?> querySnapshot =
        await collectionRef.doc(FirebaseAuth.instance.currentUser!.uid).get();

    final String username = querySnapshot['name'] ?? 'Unknown';
    print('USERNAME: ${username}');

    return username;
  }

  Future _pickImageFromCamera() async {
    XFile? returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);

    if (returnedImage == null) return;

    Uint8List img = await returnedImage.readAsBytes();

    setState(() {
      image = img;
    });

    setState(() {
      _selectedImage = File(returnedImage.path);
    });

    // print('Image Path : ${_selectedImage!.path}');
  }

  void submit() async {
    try {
      if (_selectedImage == null ||
          nameController.text.isEmpty ||
          addressController.text.isEmpty ||
          reasonController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Please fill all fields'),
            );
          },
        );

        return;
      }

      if (phoneNoController.text.length != 10) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              title: Text('Invalid phone number'),
            );
          },
        );

        return;
      }

      setState(() {
        _isLoading = true;
      });

      // adding data to firestore

      String currentUsername = await getUserData();

      String docId = DateTime.now().toIso8601String();

      String imageId = '${nameController.text} $docId';

      String imageUrl =
          await StoreData().uploadImageToStorage('userImage', image!, imageId);

      String currentDate = DateFormat('yMMMMd').format(DateTime.now());

      String currentTime =
          // ignore: use_build_context_synchronously
          TimeOfDay(hour: TimeOfDay.now().hour, minute: TimeOfDay.now().minute)
              .format(context);

      // Adding date to "entries" collection
      await FirebaseFirestore.instance
          .collection('entries')
          .doc(currentDate)
          .set({
        'date': currentDate,
        // timestatmp
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      await FirebaseFirestore.instance
          .collection('entries')
          .doc(currentDate)
          .collection('singleDayEntries')
          .doc(docId)
          .set({
        'image': imageUrl,
        'name': nameController.text,
        'phoneNumber': phoneNoController.text,
        'address': addressController.text,
        'reason': reasonController.text,
        'date': currentDate,
        'time': currentTime,
        'entryCreatedBy': currentUsername,
        'outTime': '',
      });

      setState(() {
        _isLoading = false;
      });

      AnimatedSnackBar.removeAll();
      // ignore: use_build_context_synchronously
      AnimatedSnackBar.material(
        'Entry added successfully',
        type: AnimatedSnackBarType.success,
      ).show(context);

      setState(() {
        _selectedImage = null;
        nameController.clear();
        phoneNoController.clear();
        addressController.clear();
        reasonController.clear();
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // print(e.toString());
    }
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    phoneNoController.dispose();
    addressController.dispose();
    reasonController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1F2FF),
      appBar: AppBar(
        title: const Text('ADYPG'),
        centerTitle: true,
        backgroundColor: const Color(0xffF1F2FF),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/dypatil.png'),
              ),
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          const Text(
                            'Enter a new entry',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 16),

                          // display image from camera
                          _selectedImage != null
                              ? Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: _selectedImage != null
                                      ? Image.file(_selectedImage!)
                                      : null,
                                )
                              : const SizedBox.shrink(),

                          _selectedImage != null
                              ? const SizedBox(height: 20)
                              : SizedBox.fromSize(),

                          // Camera
                          Align(
                            alignment: Alignment.center,
                            child: InkWell(
                              onTap: () => _pickImageFromCamera(),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.camera,
                                        color: Colors.white),
                                    const SizedBox(width: 4),
                                    _selectedImage == null
                                        ? const Text(
                                            'Camera',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          )
                                        : const Text(
                                            'Change Image',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          // Name
                          CustomTextField(
                            controller: nameController,
                            title: 'Name',
                            hintText: 'Eg: Sujal',
                            keyboardType: TextInputType.name,
                          ),

                          // Phone Number
                          CustomTextField(
                            controller: phoneNoController,
                            title: 'Phone Number',
                            hintText: 'Eg: 1234567899',
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                          ),

                          // Address
                          CustomTextField(
                            controller: addressController,
                            title: 'Address',
                            hintText: 'Eg: Dhanori',
                            keyboardType: TextInputType.streetAddress,
                          ),

                          // Reason
                          CustomTextField(
                            controller: reasonController,
                            title: 'Reason',
                            hintText: 'Eg: To meet a friend',
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                          ),

                          // Date and Time
                          const Row(
                            children: [
                              Expanded(
                                child: DatePicker(),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: TimePicker(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Submit Button
                  CustomButton(
                    onPressed: () {
                      submit();
                    },
                    title: 'Submit',
                  ),
                ],
              ),
            ),
    );
  }
}
