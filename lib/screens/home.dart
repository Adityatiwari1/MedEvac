import 'dart:convert';
import 'package:project/screens/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _message = [];
  String? profilePicture;
  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _submitMessage(String value) async {
    Message message = Message(text: _messageController.text, isMe: true);
    _messageController.clear();
    setState(() {
      _message.insert(0, message);
    });
    String response = await fetchResponseFromPythonBackend(value);
    Message bot = Message(text: response, isMe: false);
    setState(() {
      _message.insert(0,bot);
    });

  }


Future<String> fetchResponseFromPythonBackend(String message) async {
  var url = 'http://127.0.0.1:8000/predict-drug/';
  var csrfToken = '5i6TW9RZD9EGMevqNPL6PI8EZ0tDJoxk'; // Replace with the actual CSRF token

  var response = await http.post(
    Uri.parse(url),
    headers: {'X-CSRFToken': csrfToken}, // Include the CSRF token in the request headers
    body: {'medical_condition': message},
  );

  if (response.statusCode == 200) {
    return response.body;
  } else {
    throw Exception('Failed to communicate with the Python backend.');
  }
}




@override
  void initState() {
    super.initState();
    fetchProfilePicture(); // Call the method to fetch the profile picture
  }

  Future<void> fetchProfilePicture() async {
    try { 
      var url = 'http://127.0.0.1:8000/fetch-profile-picture/';
      var response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        setState(() {
          profilePicture = response.body; // Store the profile picture in the state
        });
      } else {
        throw Exception('Failed to fetch the profile picture.');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }


  Widget _buildMessage(Message message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        crossAxisAlignment:
            message.isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            message.isMe ? 'You' : 'MedEvac',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(message.text),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C9BCF),
        title: const Text('MedEvac is here to help!!'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Loginscreen(),
                  ),
                );
              },
              icon: const Icon(Icons.logout),
              tooltip: 'Logout'),
        ],
      ),
      body: Column(
        children: [
          Align(
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(
                  height: 20,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: const Color(0xFF6c9BCF),
                      backgroundImage: profilePicture != null
                          ? MemoryImage(base64Decode(profilePicture!))
                          : null,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      width: 170,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Name: Adi'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Rank: General',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Blood Group: O+',
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text('Age: 22'),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            'Medical History: None',
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 300,
                  child: Expanded(
                      child: ListView.builder(
                    reverse: true,
                    itemCount: _message.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMessage(
                        _message[index],
                      );
                    },
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  onSubmitted: _submitMessage,
                  decoration: const InputDecoration(
                    hintText: 'Enter text',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  _submitMessage(_messageController.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C9BCF),
                  fixedSize: const Size(70, 50),
                ),
                child: const Text('Enter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Message {
  final String text;
  final bool isMe;

  Message({required this.text, required this.isMe});
}