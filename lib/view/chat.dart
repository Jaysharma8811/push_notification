import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("chat"),
      ),
      body: ListView.builder(
        itemCount: 3,
          itemBuilder: (context,index){
        return const ListTile(leading: Text("List Tile"),);
      }),
    );
  }
}
