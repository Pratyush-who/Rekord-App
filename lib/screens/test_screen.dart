import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';

class Post {
  final String id;
  final Author author;
  final String content;
  final List<Media> media;
  final int likeCount;
  final int commentCount;
  final DateTime createdAt;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.author,
    required this.content,
    required this.media,
    required this.likeCount,
    required this.commentCount,
    required this.createdAt,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'] ?? '',
      author: Author.fromJson(json['author'] ?? {'_id': '', 'name': 'Unknown'}),
      content: json['content'] ?? '',
      media: (json['media'] as List?)
              ?.map((media) => Media.fromJson(media))
              .toList() ??
          [],
      likeCount: json['likeCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      comments: (json['comments'] as List?)
              ?.map((comment) => Comment.fromJson(comment))
              .toList() ??
          [],
    );
  }
}

class Author {
  final String id;
  final String name;
  final String? profileImage;

  Author({
    required this.id,
    required this.name,
    this.profileImage,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      profileImage: json['profileImage'],
    );
  }
}

class Media {
  final String url;
  final String type;

  Media({
    required this.url,
    required this.type,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      url: json['url'] ?? '',
      type: json['type'] ?? 'image',
    );
  }
}

class Comment {
  final String content;
  final DateTime createdAt;

  Comment({
    required this.content,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }
}

class AthletePost {
  final String id;
  final String name;
  final String? profileImage;
  final Map<String, dynamic> career;
  final DateTime createdAt;

  AthletePost({
    required this.id,
    required this.name,
    this.profileImage,
    required this.career,
    required this.createdAt,
  });

  factory AthletePost.fromJson(Map<String, dynamic> json) {
    return AthletePost(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown Athlete',
      profileImage: json['profileImage'],
      career: json['career'] ?? {},
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
    );
  }

  // Convert AthletePost to Post for UI display
  Post toPost() {
    // Create a simplified content string from career info
    String content = '';
    if (career.containsKey('activeYears')) {
      var activeYears = career['activeYears'];
      if (activeYears is Map && activeYears.containsKey('from')) {
        content += 'Active since: ${activeYears['from']}\n';
      }
    }
    
    if (career.containsKey('currentTeam')) {
      content += 'Current team: ${career['currentTeam']}\n';
    }
    
    if (career.containsKey('achievements')) {
      content += 'Achievements: ${career['achievements']}\n';
    }
    
    if (content.isEmpty) {
      content = 'Athlete profile pending verification';
    }

    return Post(
      id: id,
      author: Author(
        id: id,
        name: name,
        profileImage: profileImage,
      ),
      content: content,
      media: [],
      likeCount: 0,
      commentCount: 0,
      createdAt: createdAt,
      comments: [],
    );
  }
}

class PostsPage extends StatefulWidget {
  const PostsPage({Key? key}) : super(key: key);

  @override
  _PostsPageState createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  late Future<List<Post>> _postsFuture;

  @override
  void initState() {
    super.initState();
    _postsFuture = fetchAthletes();
  }

  Future<List<Post>> fetchAthletes() async {
    final apiUrl = 'http://192.168.1.61:3000/api/getUnverifiedAthlete';
    
    print('Fetching athletes from: $apiUrl');
    
    try {
      final response = await http.get(Uri.parse(apiUrl));
      
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body.substring(0, min(100, response.body.length))}...');
      
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        
        // For debugging
        print('Full response structure: ${jsonData.keys.join(', ')}');
        
        if (jsonData['unverifiedAthlete'] != null) {
          List<AthletePost> athletes = (jsonData['unverifiedAthlete'] as List)
              .map((athlete) => AthletePost.fromJson(athlete))
              .toList();
          
          // Convert athletes to posts for UI display
          return athletes.map((athlete) => athlete.toPost()).toList();
        } else {
          print('No unverifiedAthlete field found in response');
          return [];
        }
      } else {
        throw Exception('Failed to load athletes: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching athletes: $e');
      throw Exception('Network error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unverified Athletes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _postsFuture = fetchAthletes();
              });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _postsFuture = fetchAthletes();
          });
        },
        child: FutureBuilder<List<Post>>(
          future: _postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Error fetching athletes',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        '${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _postsFuture = fetchAthletes();
                        });
                      },
                      child: const Text('Try Again'),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No athletes available'));
            }

            final posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(post: post);
              },
            );
          },
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author info
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.author.profileImage != null
                  ? CachedNetworkImageProvider(post.author.profileImage!)
                  : null,
              child: post.author.profileImage == null
                  ? Text(post.author.name.isNotEmpty
                      ? post.author.name[0].toUpperCase()
                      : '?')
                  : null,
            ),
            title: Text(
              post.author.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              DateFormat.yMMMd().add_jm().format(post.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ),

          // Post content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(post.content),
          ),

          // Post media
          if (post.media.isNotEmpty) ...[
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: post.media.length,
                itemBuilder: (context, index) {
                  final media = post.media[index];
                  if (media.type == 'image') {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: CachedNetworkImage(
                        imageUrl: media.url,
                        fit: BoxFit.cover,
                        height: 200,
                        width: 300,
                        placeholder: (context, url) => Container(
                          height: 200,
                          width: 300,
                          color: Colors.grey[300],
                          child:
                              const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 200,
                          width: 300,
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        ),
                      ),
                    );
                  } else if (media.type == 'video') {
                    // For simplicity, just showing a placeholder for videos
                    return Container(
                      height: 200,
                      width: 300,
                      color: Colors.black,
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],

          // Action buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.check_circle_outline),
                label: const Text('Verify'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.info_outline),
                label: const Text('Details'),
              ),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.close),
                label: const Text('Reject'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Add this to your MaterialApp or main widget tree
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: PostsPage(),
    theme: ThemeData(
      useMaterial3: true,
      colorSchemeSeed: Colors.blue,
    ),
  ));
}