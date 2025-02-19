import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreatePostDialog extends StatefulWidget {
  final Function(String text, String? imagePath) onPostCreated;

  const CreatePostDialog({required this.onPostCreated});

  @override
  _CreatePostDialogState createState() => _CreatePostDialogState();
}

class _CreatePostDialogState extends State<CreatePostDialog> {
  final TextEditingController _textController = TextEditingController();
  String? _imagePath;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void _createPost() {
    final text = _textController.text.trim();
    if (text.isNotEmpty || _imagePath != null) {
      widget.onPostCreated(text, _imagePath); // Call the callback
      Navigator.pop(context); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text(
        "Create Post",
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _textController,
            decoration: InputDecoration(
              hintText: "What's on your mind?",
              hintStyle: TextStyle(color: Colors.grey),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white),
            maxLines: 3,
          ),
          SizedBox(height: 16),
          if (_imagePath != null)
            Image.file(
              File(_imagePath!),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 150,
            ),
          IconButton(
            icon: Icon(Icons.image, color: Colors.white),
            onPressed: _pickImage,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _createPost,
          child: Text(
            "Post",
            style: TextStyle(color: Colors.white),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}