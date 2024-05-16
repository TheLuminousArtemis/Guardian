import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:guardian_traffic/resources/firestore_methods.dart';
import 'package:guardian_traffic/utils/colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guardian_traffic/utils/utils.dart';
import 'package:guardian_traffic/providers/user_provider.dart';
import 'package:guardian_traffic/models/user.dart' as model;
import 'package:provider/provider.dart';
import 'package:guardian_traffic/screens/location_screen.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  bool _isLoading = false;
  bool _isCityTextFieldVisible = false;

  void postImage(
      String uid,
      String username,
      String profileImage,
      ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profileImage,
        _cityController.text,
      );
      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(context, 'Posted!');
        clearImage();
      } else {
        setState(() {
          _isLoading = true;
        });
        showSnackBar(context, res);
      }
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Cancel'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                  }),
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _cityController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    model.User? user = Provider.of<UserProvider>(context).getUser;
    return _file == null
        ? Center(
      child: IconButton(
        onPressed: () => _selectImage(context),
        icon: const Icon(Icons.upload),
      ),
    )
        : Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: clearImage,
        ),
        title: const Text('Post'),
        actions: [
          TextButton(
            onPressed: () => postImage(
                user?.uid ?? 'user_id',
                user?.username ?? 'username',
                user?.photoUrl ?? 'https://i.stack.imgur.com/l60Hf.png'),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _isLoading
              ? const LinearProgressIndicator()
              : const Padding(
            padding: EdgeInsets.only(top: 0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user?.photoUrl ?? 'https://i.stack.imgur.com/l60Hf.png',
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    hintText: 'Caption',
                    border: InputBorder.none,
                  ),
                  maxLines: 8,
                ),
              ),
              SizedBox(
                height: 45,
                width: 45,
                child: AspectRatio(
                  aspectRatio: 487 / 451,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: MemoryImage(_file!),
                        fit: BoxFit.fill,
                        alignment: FractionalOffset.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              const Divider(),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _isCityTextFieldVisible
                ? TextField(
              controller: _cityController,
              decoration: const InputDecoration(
                labelText: 'City',
              ),
            )
                : TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationScreen(
                      onLocationSelected: (location) {
                        setState(() {
                          _cityController.text = location;
                        });
                      },
                    ),
                  ),
                );
              },
              child: Text(
                'Add Location',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
