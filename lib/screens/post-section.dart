import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/colors.dart';

class PostSection extends StatefulWidget {
  PostSection({Key? key}) : super(key: key);

  @override
  PostSectionState createState() => PostSectionState();
}

class PostSectionState extends State<PostSection> {
  List<Map<String, dynamic>> posts = [
    {
      "text": "What a hackathon! We won CODESEVA 🧑‍💻👾 #Hackathon #CodeSeva",
      "image": "assets/post1.jpg",
      "time": DateTime.now().subtract(Duration(hours: 2)),
      "isAsset": true,
    },
    {
      "text": "Just finished a 10k run! 🏃‍♂️💨 #Fitness #Running",
      "image": "assets/post2.png",
      "time": DateTime.now().subtract(Duration(days: 1)),
      "isAsset": true,
    },
    {
      "text": "Incredible goal by my favorite player! ⚽️🔥 #Football",
      "image": "assets/post3.webp",
      "time": DateTime.now().subtract(Duration(minutes: 45)),
      "isAsset": true,
    },
    {
      "text": "Amazing rally in today's tennis match! 🎾💪 #Tennis",
      "image": "assets/post4.avif",
      "time": DateTime.now().subtract(Duration(hours: 3)),
      "isAsset": true,
    },
  ];

  void addPost(String text, String? imagePath) {
    setState(() {
      posts.insert(0, {
        "text": text,
        "image": imagePath,
        "time": DateTime.now(), // Add current timestamp
        "isAsset": false, // Gallery images are not assets
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        final time = post["time"] as DateTime;
        final timeAgo = _getTimeAgo(time);

        return Container(
          margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: AppColors.darkGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post Header
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage("assets/logo.avif"),
                ),
                title: Text(
                  "SportsFan123",
                  style: TextStyle(
                      color: AppColors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  timeAgo,
                  style: TextStyle(color: AppColors.lightGrey),
                ),
                trailing: Icon(
                  Icons.more_vert,
                  color: AppColors.white,
                ),
              ),
              // Post Text
              if (post["text"] != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    post["text"],
                    style: TextStyle(color: AppColors.white),
                  ),
                ),
              // Post Image
              if (post["image"] != null)
                post["isAsset"]
                    ? Image.asset(
                        post["image"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      )
                    : Image.file(
                        File(post["image"]),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
              // Post Actions
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: AppColors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.comment, color: AppColors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: AppColors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getTimeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    } else if (difference.inMinutes > 0) {
      return "${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago";
    } else {
      return "Just now";
    }
  }
}